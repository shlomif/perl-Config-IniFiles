use Config::IniFiles;
print "1..$t\n";

# test 1
$t = 1;
# print "Empty list when no groups ........ ";
$en = new Config::IniFiles( -file => 't/en.ini' );
if( scalar($en->Groups) == 0 ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 2
$t++;
# print "Creating new object, no file ..... ";
if ($ini = new Config::IniFiles) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 3
$t++;
# print "Setting new file name .............";
if ($ini->SetFileName("t/newfile.ini")) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 4
$t++;
# print "Saving under new file name ........";
if ($ini->RewriteConfig()) {
	if ( -f "t/newfile.ini" ) {
		print "ok $t\n";
	} else {
		print "not ok $t\n";
	}
} else {
	print "not ok $t\n";
}

# test 5
$t++;
# print "SetSectionComment .................";
$ini->newval("Section1", "Parameter1", "Value1");
my @section_comment = ("Line 1 of section comment.", "Line 2 of section comment", "Line 3 of section comment");
if ($ini->SetSectionComment("Section1", @section_comment)) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 6
$t++;
# print "GetSectionComment .................";
my @comment;
if (@comment = $ini->GetSectionComment("Section1")) {
	if ((join "\n", @comment) eq ("# Line 1 of section comment.\n# Line 2 of section comment\n# Line 3 of section comment")) {
		print "ok $t\n";
	} else {
		print "not ok $t\n";
	}
} else {
	print "not ok $t\n";
}

# test 7
$t++;
# print "DeleteSectionComment ..............";
$ini->DeleteSectionComment("Section1");
if (defined $ini->GetSectionComment("Section1")) {
	print "not ok $t\n";
} else {
	print "ok $t\n";
}

BEGIN { $t = 7 }
