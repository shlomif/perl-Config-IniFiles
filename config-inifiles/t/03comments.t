use Config::IniFiles;
print "1..$t\n";

my $ors = $\ || "\n";

#
# Comment preservation, -default and -nocase tests added by JW/WADG
#

# test 1

$t = 1;
$value = 0;
if( open FILE, "<t/test.ini" ) {
	$_ = join( '', <FILE> );
	$value = /\# This is a section comment[$ors]\[test1\]/;
	close FILE;
}
# print "Section comments preserved ....... ";
if ($value) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 2
$t++;
$value = /\# This is a parm comment[$ors]five=value5/;
# print "Parameter comments preserved ..... ";
if ($value) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 3 
$t++;
$ini = new Config::IniFiles( -file => "t/test.ini", -default => 'test1', -nocase => 1 );
# print "-default option .................. ";
if( (defined $ini) && 
    ($ini->val('test2', 'three') eq 'value3') ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 4
$t++;
# print "Case insensitivity ............... ";
if( (defined $ini) && 
    ($ini->val('TEST2', 'THREE') eq 'value3') ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

my $ini = new Config::IniFiles ( -file => "t/test.ini" );
$ini->setval("foo","bar","qux");

# test 5
$t++;
# print "Setting Section Comment........... ";
if ($ini->SetSectionComment("foo", "This is a section comment", "This comment takes two lines!")) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 6
$t++;
# print "Getting Section Comment........... ";
my @comment = $ini->GetSectionComment("foo");
if ( join("", @comment) eq "# This is a section comment# This comment takes two lines!") {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

#test 7
$t++;
# print "Deleting Section Comment.......... ";
$ini->DeleteSectionComment("foo");
# Should not exist!
if (not defined $ini->GetSectionComment("foo")) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 8
$t++;
# print "Setting Parameter Comment......... ";
if ($ini->SetParameterComment("foo", "bar", "This is a parameter comment", "This comment takes two lines!")) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 9
$t++;
# print "Getting Parameter Comment......... ";
@comment = $ini->GetParameterComment("foo", "bar");
if (join("", @comment) eq "# This is a parameter comment# This comment takes two lines!") {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 10
$t++;
# print "Deleting Parameter Comment........ ";
$ini->DeleteParameterComment("foo", "bar");
# Should not exist!
if (not defined $ini->GetSectionComment("foo", "bar")) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

BEGIN {$t = 10}
