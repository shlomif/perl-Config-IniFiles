#
# Comment preservation
#

use strict;
use Test;
use Config::IniFiles;

BEGIN { plan tests => 12 }

my $ors = $\ || "\n";
my ($ini, $value);

# test 1
# Load ini file and write as new file
$ini = new Config::IniFiles -file => "t/test.ini";
$ini->SetFileName("t/test03.ini");
$ini->RewriteConfig;
$ini->ReadConfig;
ok($ini);

# test 2
# Section comments preserved
$value = 0;
if( open FILE, "<t/test03.ini" ) {
	$_ = join( '', <FILE> );
	$value = /\# This is a section comment[$ors]\[test1\]/;
	close FILE;
}
ok($value);


# test 3
# Parameter comments preserved
$value = /\# This is a parm comment[$ors]five=value5/;
ok($value);


# test 4
# Setting Section Comment
$ini->setval('foo','bar','qux');
ok($ini->SetSectionComment('foo', 'This is a section comment', 'This comment takes two lines!'));

# test 5
# Getting Section Comment
my @comment = $ini->GetSectionComment('foo');
ok( join('', @comment) eq '# This is a section comment# This comment takes two lines!');

#test 6
# Deleting Section Comment
$ini->DeleteSectionComment('foo');
# Should not exist!
ok(not defined $ini->GetSectionComment('foo'));

# test 7
# Setting Parameter Comment
ok($ini->SetParameterComment('foo', 'bar', 'This is a parameter comment', 'This comment takes two lines!'));

# test 8
# Getting Parameter Comment
@comment = $ini->GetParameterComment('foo', 'bar');
ok(join('', @comment) eq '# This is a parameter comment# This comment takes two lines!');

# test 9
# Deleting Parameter Comment
$ini->DeleteParameterComment('foo', 'bar');
# Should not exist!
ok(not defined $ini->GetSectionComment('foo', 'bar'));


# test 10
# Reading a section comment from the file
@comment = $ini->GetSectionComment('test1');
ok(join('', @comment) eq '# This is a section comment');

# test 11
# Reading a parameter comment from the file
@comment = $ini->GetParameterComment('test2', 'five');
ok(join('', @comment) eq '# This is a parm comment');

# test 12
# Reading a comment that starts with ';'
@comment = $ini->GetSectionComment('MixedCaseSect');
ok(join('', @comment) eq '; This is a semi-colon comment');


