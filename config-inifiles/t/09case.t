#!/usr/bin/perl
use strict;
use Test;
use Config::IniFiles;
# $Id: 09case.t,v 1.3 2002-08-15 21:34:00 wadg Exp $

BEGIN { plan tests => 10 }

my $ini;
my @members;
my $string;

# Get files from the 't' directory, portably
chdir('t') if ( -d 't' );

# CASE SENSITIVE CHECKS

# Test 1
# newval and val - Check that correct case brings back the correct value
$ini = Config::IniFiles->new;
$ini->newval("Section", "PaRaMeTeR", "Mixed Case");
$ini->newval("Section", "Parameter", "Title Case");
my $mixed_case = $ini->val("Section", "PaRaMeTeR");
my $title_case = $ini->val("Section", "Parameter");
ok(($mixed_case eq "Mixed Case") and ($title_case eq "Title Case"));

# Test 2
# Sections
# Set up a controlled environment
$ini = Config::IniFiles->new;
$ini->newval("Section", "Parameter", "Value");
$ini->newval("section", "parameter", "value");
my $section_case_check_pass = 1;
$section_case_check_pass = 0 unless (scalar($ini->Sections()) == 2);
ok($section_case_check_pass);

# Test 3
# Deleting values
# Set up a controlled environment
$ini = Config::IniFiles->new;
$ini->newval("Section", "Parameter", "Title Case");
$ini->newval("Section", "parameter", "lower case");
$ini->newval("Section", "PARAMETER", "UPPER CASE");
my $delete_case_check_pass = 1;
@members = $ini->Parameters("Section");
$delete_case_check_pass = 0 unless (scalar(@members) == 3);
$ini->delval("Section", "PARAMETER");
@members = $ini->Parameters("Section");
$delete_case_check_pass = 0 unless (scalar(@members) == 2);
$delete_case_check_pass = 0 unless (grep {/Parameter/} @members);
$delete_case_check_pass = 0 unless (grep {/parameter/} @members);
ok($delete_case_check_pass);

# Test 4
# Parameters
$ini = Config::IniFiles->new;
$ini->newval("Section", "PaRaMeTeR", "Mixed Case");
$ini->newval("Section", "Parameter", "Title Case");
$ini->newval("SECTION", "Parameter", "N/A");
my @parameter_list = $ini->Parameters("SECTION");
my $parameters_case_check_pass = 1;
$parameters_case_check_pass = 0 unless scalar(@parameter_list) == 1;
$parameters_case_check_pass = 0 unless $parameter_list[0] eq "Parameter";
@parameter_list = $ini->Parameters("Section");
$parameters_case_check_pass = 0 unless scalar(@parameter_list) == 2;
my $parameters = join " ", @parameter_list;
$parameters_case_check_pass = 0 unless ($parameters =~ /PaRaMeTeR/);
$parameters_case_check_pass = 0 unless ($parameters =~ /Parameter/);
ok($parameters_case_check_pass);

# Test 5
# Case sensitive handling of groups
# Set up a controlled environment
$ini = Config::IniFiles->new;
$ini->newval("interface foo", "parameter", "foo");
$ini->newval("interface bar", "parameter", "bar");
$ini->newval("INTERFACE blurgle", "parameter", "flurgle");
my $group_case_check_pass = 1;
# We should have two groups - "interface" and "Interface"
my $group_case_count = $ini->Groups();
$group_case_check_pass = 0 unless ($group_case_count == 2);
# We don't want to get the "interface" entries when we use the wrong case
@members = $ini->GroupMembers("Interface");
$group_case_check_pass = 0 unless (scalar(@members) == 0);
# We *do* want to get the "interface" entries when we use the right case
@members = $ini->GroupMembers("interface");
$group_case_check_pass = 0 unless (scalar(@members) == 2);
$group_case_check_pass = 0 unless (grep {/interface foo/} @members);
$group_case_check_pass = 0 unless (grep {/interface bar/} @members);
ok($group_case_check_pass);



# CASE INSENSITIVE CHECKS

# Test 6
# newval - Check that case-insensitive version returns one value
$ini = Config::IniFiles->new( -nocase => "1" );
$ini->newval("Section", "PaRaMeTeR", "Mixed Case");
$ini->newval("Section", "Parameter", "Title Case");
my @values = $ini->val("Section", "parameter");
ok((scalar(@values) == 1) and ($values[0] eq "Title Case"));

# Test 7
# Case insensitive handling of groups
$ini = Config::IniFiles->new( -file =>'test.ini', -nocase => 1 );
$string = join " ", $ini->GroupMembers("GrOuP");
ok($string eq "group member one group member two group member three");

$ini = Config::IniFiles->new( -file => "test.ini", -default => 'test1', -nocase => 1 );
$ini->SetFileName("test09.ini");

# test 8
# Case insensitivity in parameters
ok( (defined $ini) && ($ini->val('test2', 'FOUR') eq 'value4') );

# test 9
# Case insensitivity in sections
ok( (defined $ini) && ($ini->val('TEST2', 'four') eq 'value4') );
my $v;

# test 10
ok( (defined $ini) && ($v = $ini->val('mixedcasesect', 'mixedcaseparam')) && ($v eq 'MixedCaseVal'));



