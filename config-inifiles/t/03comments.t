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

BEGIN {$t = 4}
