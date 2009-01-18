#!/usr/bin/perl

# This script attempts to reproduce:
# https://rt.cpan.org/Ticket/Display.html?id=34067
#
# #34067: Multiline values returned as ARRAYs in tied hash interface

use Test::More tests => 1;

use strict;
use warnings;

use File::Spec;

use Config::IniFiles;

{
    tie my %ini, 'Config::IniFiles',
        (-file => File::Spec->catfile(File::Spec->curdir(), 't', 'array.ini'))
        ;

    # TEST
    is_deeply(
        scalar($ini{Sect}{Par}),
        ("1" . $/ . "2" . $/. "3"),
        "Multiline values accesed through hash returned as a single value",
    );
}
