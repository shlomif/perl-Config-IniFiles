use strict;
use Test;
use Config::IniFiles;
# $Id: 09case.t,v 1.1 2001-06-07 02:51:24 grail Exp $

BEGIN { plan tests => 7 }

my $ini;
my @members;
my $string;

# CASE SENSITIVE CHECKS

# Test 1
# newval and val - Check that correct case brings back the correct value
$ini = new Config::IniFiles;
$ini->newval("Section", "PaRaMeTeR", "Mixed Case");
$ini->newval("Section", "Parameter", "Title Case");
my $mixed_case = $ini->val("Section", "PaRaMeTeR");
my $title_case = $ini->val("Section", "Parameter");
ok(($mixed_case eq "Mixed Case") and ($title_case eq "Title Case"));

# Test 2
# Sections
# Set up a controlled environment
$ini = new Config::IniFiles;
$ini->newval("Section", "Parameter", "Value");
$ini->newval("section", "parameter", "value");
my $section_case_check_pass = 1;
$section_case_check_pass = 0 unless (scalar($ini->Sections()) == 2);
ok($section_case_check_pass);

# Test 3
# Deleting values
# Set up a controlled environment
$ini = new Config::IniFiles;
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
$ini = new Config::IniFiles;
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
$ini = new Config::IniFiles;
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
$ini = new Config::IniFiles( -nocase => "1" );
$ini->newval("Section", "PaRaMeTeR", "Mixed Case");
$ini->newval("Section", "Parameter", "Title Case");
my @values = $ini->val("Section", "parameter");
ok((scalar(@values) == 1) and ($values[0] eq "Title Case"));

# Test 7
# Case insensitive handling of groups
$ini = new Config::IniFiles( -file =>'t/test.ini', -nocase => 1 );
$string = join " ", $ini->GroupMembers("GrOuP");
ok($string eq "group member one group member two group member three");

