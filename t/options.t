use strict;
use warnings;

use Test::More tests => 17;
use Test::Exception;
use Test::MockModule;

use Log::Any qw{$log};
use Log::Any::Adapter;
use Unix::Syslog qw{:macros};

use vars qw{@openlog @syslog};

# Mock the Unix::Syslog classes to behave as we desire.
my $mock = Test::MockModule->new('Unix::Syslog');
$mock->mock('openlog', sub { @openlog = @_; });
$mock->mock('syslog',  sub ($$@) { @syslog  = @_; });

# Do nothing on closelog, since some libc implementations might abort if we
# didn't really call openlog, and I don't want that pain.
$mock->mock('closelog', sub {});

# Verify that we get the right options passed to the instance.
lives_ok { Log::Any::Adapter->set('Syslog') }
    "No exception setting the adapter to syslog without arguments";

is $openlog[0], 'options.t', "the right syslog name was inferred";
is $openlog[1], LOG_PID, "the default LOG_PID options were used";
is $openlog[2], LOG_LOCAL7, "the default LOG_LOCAL7 facility was used";


# Now, can we set a custom name?
lives_ok {
    Log::Any::Adapter->set('Syslog', name => 'example-name');
} "No exception setting the adapter to syslog with a name override";

is $openlog[0], 'example-name', "the custom name was preserved";
is $openlog[1], LOG_PID, "the default options were used";
is $openlog[2], LOG_LOCAL7, "the default facility was used";

# Custom options
lives_ok { Log::Any::Adapter->set('Syslog', options => LOG_PERROR) }
    "No exception setting the adapter to syslog with options";

is $openlog[0], 'options.t', "the right syslog name was inferred";
is $openlog[1], LOG_PERROR, "the custom options were used";
is $openlog[1] & LOG_PID, 0, "the default LOG_PID option was not merged";
is $openlog[2], LOG_LOCAL7, "the default LOG_LOCAL7 facility was used";

# Custom facility
lives_ok { Log::Any::Adapter->set('Syslog', facility => LOG_USER) }
    "No exception setting the adapter to syslog with a custom facility";

is $openlog[0], 'options.t', "the right syslog name was inferred";
is $openlog[1], LOG_PID, "the default LOG_PID options were used";
is $openlog[2], LOG_USER, "the custom LOG_USER facility was used";
