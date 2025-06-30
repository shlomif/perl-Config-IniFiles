#! /usr/bin/env perl
#
# Short description for perl-based-cat.pl
#
# Version 0.0.1
# Copyright (C) 2025 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

while ( my $l = <ARGV> )
{
    print $l;
}
