#!/usr/bin/perl
use strict;
use Test;
use Config::IniFiles;
# $Id: 08group.t,v 1.4 2002-08-15 21:34:00 wadg Exp $

BEGIN { plan tests => 1 }

# Get files from the 't' directory, portably
chdir('t') if ( -d 't' );

my $ini = Config::IniFiles->new( -file => 'test.ini' );
my $members;

# Test 1
# Group members with spaces

$members = join " ", $ini->GroupMembers("group");
ok($members eq "group member one group member two group member three");

# Test 2
# Adding a new section - updating groups list

# Test 3
# Deleting a section - updating groups list
