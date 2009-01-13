#!/usr/bin/perl

# This script attempts to reproduce:
# https://rt.cpan.org/Ticket/Display.html?id=36584

# Written by Shlomi Fish.
# This file is licensed under the MIT/X11 License.

use strict;
use warnings;

use Test::More tests => 3;

use Config::IniFiles;

{
    my $ini = Config::IniFiles->new(-file => *DATA);

    # TEST
    ok(!defined($ini), "Ini was not initialised");

    # TEST
    is (scalar(@Config::IniFiles::errors), 1,
        "There is one error."
    );

    # TEST
    like ($Config::IniFiles::errors[0],
        qr/parameter found outside a section/,
        "Error was correct - 'parameter found outside a section'",
    );
}

__DATA__

; This is a malformed ini file with a key/value outside a scrtion

wrong = wronger

[section]

right = more right

