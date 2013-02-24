# NAME

Log::Any::Adapter::Syslog - Send Log::Any logs to syslog

# VERSION

version 1.5

# SYNOPSIS

    use Log::Any::Adapter;
    Log::Any::Adapter->set('Syslog');

    # You can override defaults:
    use Unix::Syslog qw{:macros};
    Log::Any::Adapter->set(
        'Syslog',
        # name defaults to basename($0)
        name     => 'my-name',
        # options default to LOG_PID
        options  => LOG_PID|LOG_PERROR,
        # facility defaults to LOG_LOCAL7
        facility => LOG_LOCAL7
    );

# DESCRIPTION

[Log::Any](http://search.cpan.org/perldoc?Log::Any) is a generic adapter for writing logging into Perl modules; this
adapter use the [Unix::Syslog](http://search.cpan.org/perldoc?Unix::Syslog) module to direct that output into the standard
Unix syslog system.

# CONFIGURATION

`Log::Any::Adapter::Syslog` is designed to work out of the box with no
configuration required; the defaults should be reasonably sensible.

You can override the default configuration by passing extra arguments to the
`Log::Any::Adapter` method:

- name

The _name_ argument defaults to the basename of `$0` if not supplied, and is
inserted into each line sent to syslog to identify the source.

- options

The _options_ configure the behaviour of syslog; see [Unix::Syslog](http://search.cpan.org/perldoc?Unix::Syslog) for
details.

The default is `LOG_PID`, which includes the PID of the current process after
the process name:

    example-process[2345]: something amazing!

The most likely addition to that is `LOG_PERROR` which causes syslog to also
send a copy of all log messages to the controlling terminal of the process.

__WARNING:__ If you pass a defined value you are setting, not augmenting, the
options.  So, if you want `LOG_PID` as well as other flags, pass them all.

- facility

The _facility_ determines where syslog sends your messages.  The default is
`LOCAL7`, which is not the most useful value ever, but is less bad than
assuming the fixed facilities.

See [Unix::Syslog](http://search.cpan.org/perldoc?Unix::Syslog) and [syslog(3)](http://man.he.net/man3/syslog) for details on the available facilities.

# AUTHORS

- Daniel Pittman <daniel@rimspace.net>
- Stephen Thirlwall <sdt@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
