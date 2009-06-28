use strict;
use Test;
use Config::IniFiles;
use lib "./t/lib";
use Config::IniFiles::Debug;

BEGIN { plan tests => 6 }

my ($ini, $value);

# Get files from the 't' directory, portably
chdir('t') if ( -d 't' );

$ini = Config::IniFiles->new(-file => "test.ini");
$ini->_assert_invariants();
$ini->SetFileName("test02.ini");
$ini->SetWriteMode("0666");

# Test 1
# print "Weird characters in section name . ";
$value = $ini->val('[w]eird characters', 'multiline');
$ini->_assert_invariants();
ok($value eq "This$/is a multi-line$/value");

# Test 2
$ini->newval("test7|anything", "exists", "yes");
$ini->_assert_invariants();
$ini->RewriteConfig;
$ini->ReadConfig;
$ini->_assert_invariants();
$value = $ini->val("test7|anything", "exists");
ok($value eq "yes");

# Test 3/4
# Make sure whitespace after parameter name is not included in name
ok( $ini->val( 'test7', 'criterion' ) eq 'price <= maximum' );
ok( ! defined $ini->val( 'test7', 'criterion ' ) );

# Test 5
# Build a file from scratch with tied interface for testing
my %test;
ok( tie %test, 'Config::IniFiles' ); 
tied(%test)->SetFileName('test02.ini'); 

# Test 6
# Also with pipes when using tied interface using vlaue of 0
$test{'2'}={}; 
tied(%test)->_assert_invariants();
$test{'2'}{'test'}="sleep"; 
tied(%test)->_assert_invariants();
my $sectionheader="0|2"; 
$test{$sectionheader}={}; 
tied(%test)->_assert_invariants();
$test{$sectionheader}{'vacation'}=0;
tied(%test)->_assert_invariants();
tied(%test)->RewriteConfig(); 
tied(%test)->ReadConfig;
ok($test{$sectionheader}{'vacation'} == 0);


# Clean up when we're done
unlink "test02.ini";

