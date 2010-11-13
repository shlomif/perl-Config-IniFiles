#!/usr/bin/perl

# This script attempts to reproduce:
# https://rt.cpan.org/Ticket/Display.html?id=36584

# Written by Shlomi Fish.
# This file is licensed under the MIT/X11 License.

use strict;
use warnings;

use Test::More;

use Config::IniFiles;

eval "use IO::Scalar 2.109";

plan skip_all => "IO::Scalar 2.109 required for testing POD coverage" if $@;

plan tests => 6;

{
    my $data = join "", <DATA>;
    my $ini = Config::IniFiles->new(-file => \$data);

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

    $ini = Config::IniFiles->new(-file => \$data, -fallback => 'GENERAL');

    # TEST
    ok(defined($ini), "(-fallback) Ini was initialised");

    # TEST
    ok($ini->SectionExists('GENERAL'), "(-fallback) Fallback section exists");

    # TEST
    ok($ini->exists('GENERAL', 'wrong'),
       "(-fallback) Fallback section catches parameter");
}

__DATA__

; This is a malformed ini file with a key/value outside a scrtion

wrong = wronger

[section]

right = more right

