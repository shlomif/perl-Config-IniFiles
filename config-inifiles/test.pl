# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..35\n"; }
END {print "not ok 1\n" unless $loaded;}
use Config::IniFiles;
$loaded = 1;
print "Loaded ........................... ok 1\n";

######################### End of black magic.
$t = 1;		# test number incremented at each test

# Okay, $\ may well be unset, and this seems to be the case at least
# with 5.005 under Linux so set our ors to this and fallback to \n if
# its not set
my $ors = $\ || "\n";

# test 2
$t++;
print "Opening ini file ................. ";
if ($ini = new Config::IniFiles -file => "test.ini") {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 3
$t++;
print "Reading a value .................. ";
$value = $ini->val('test2', 'five');
if ($value eq 'value5') {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 4
$t++;
print "Creating a new value ............. ";
$ini->newval('test2', 'seven', 'value7');
$ini->RewriteConfig;
$ini->ReadConfig;
$value='';
$value = $ini->val('test2', 'seven');
if ($value eq 'value7') {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 5
$t++;
print "Deleting a value ................. ";
$ini->delval('test2', 'seven');
$ini->RewriteConfig;
$ini->ReadConfig;
$value='';
$value = $ini->val('test2', 'seven');
if (! defined ($value)) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 6
$t++;
print "Weird characters in section name . ";
$value = $ini->val('[w]eird characters', 'multiline');
if ($value eq "This\nis a multi-line\nvalue") {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


#
# Comment preservation, -default and -nocase tests added by JW/WADG
#

# test 7
$t++;
$value = 0;
if( open FILE, "<test.ini" ) {
	$_ = join( '', <FILE> );
	$value = /\# This is a section comment[$ors]\[test1\]/;
	close FILE;
}
print "Section comments preserved ....... ";
if ($value) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 8
$t++;
$value = /\# This is a parm comment[$ors]five=value5/;
print "Parameter comments preserved ..... ";
if ($value) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 9 
$t++;
$ini = new Config::IniFiles( -file => "test.ini", -default => 'test1', -nocase => 1 );
print "-default option .................. ";
if( (defined $ini) && 
    ($ini->val('test2', 'three') eq 'value3') ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 10
$t++;
print "Case insensitivity ............... ";
if( (defined $ini) && 
    ($ini->val('TEST2', 'THREE') eq 'value3') ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


#
# Import tests added by JW/WADG
#

# test 11
$t++;
print "Import a file .................... ";
$en = new Config::IniFiles( -file => 'en.ini' );
if( $es = new Config::IniFiles( -file => 'es.ini', -import => $en ) ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 12
$t++;
print "Imported values are good ......... ";
$en_sn = $en->val( 'x', 'ShortName' );
$es_sn = $es->val( 'x', 'ShortName' );
$en_ln = $en->val( 'x', 'LongName' );
$es_ln = $es->val( 'x', 'LongName' );
$en_dn = $en->val( 'm', 'DataName' );
$es_dn = $es->val( 'm', 'DataName' );
if( 
	($en_sn eq $es_sn) &&
	($en_ln ne $es_ln) &&
	($en_dn ne $es_dn) &&
	1#
  ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 13
$t++;
print "Import another level ............. ";
$ca = new Config::IniFiles( -file => 'ca.ini', -import => $es );
if( 
	($en_sn eq $ca->val( 'x', 'ShortName' )) &&
	($en_sn eq $ca->val( 'x', 'ShortName' )) &&

	($en_ln ne $ca->val( 'x', 'LongName' )) &&
	($en_ln ne $ca->val( 'x', 'LongName' )) &&

	($en_dn ne $ca->val( 'm', 'DataName' )) &&
	($es_dn eq $ca->val( 'm', 'DataName' )) &&

	1#
  ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


#
# Hash tying tests added by JW/WADG
#

# test 14
$t++;
print "Tying a hash ..................... ";

if( tie %ini, 'Config::IniFiles', ( -file => "test.ini", -default => 'test1', -nocase => 1 ) ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 15
$t++;
print "Accessing a hash ................. ";
$value = $ini{test1}{one};
if ($value eq 'value1') {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 16
$t++;
print "Creating through a hash .......... ";
$ini{'test2'}{'seven'} = 'value7';
tied(%ini)->RewriteConfig;
tied(%ini)->ReadConfig;
$value = $ini{'test2'}{'seven'};
if ($value eq 'value7') {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 17
$t++;
print "Deleting through hash ............ ";
delete $ini{test2}{seven};
tied(%ini)->RewriteConfig;
tied(%ini)->ReadConfig;
$value='';
$value = $ini{test2}{seven};
if (! defined ($value)) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 18
$t++;
print "-default option in a hash ........ ";
if( $ini{test2}{three} eq 'value3' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 19
$t++;
print "Case insensitivity in a hash ..... ";
if( $ini{TEST2}{THREE} eq 'value3' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 20
$t++;
print "Listing sections ................. ";
$value = 1;
@S1 = $ini->Sections;
@S2 = keys %ini;
foreach (@S1) {
	unless( (grep "$_", @S2) &&
	        (grep "$_", qw( test1 test2 [w]eird characters ) ) ) {
		$value = 0;
		last;
	}
}
if( $value ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 21
$t++;
print "Listing parameters ............... ";
$value = 1;
@S1 = $ini->Parameters('test1');
@S2 = keys %{$ini{test1}};
foreach (@S1) {
	unless( (grep "$_", @S2) &&
	        (grep "$_", qw( three two one ) ) ) {
		$value = 0;
		last;
	}
}
if($value) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 22
$t++;
print "Copying a section in a hash ...... ";
%bak = %{$ini{test2}};
$value = $bak{six};
if( $value eq 'value6' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 23
$t++;
print "Deleting a section in a hash ..... ";
delete $ini{test2};
$value = $ini{test2};
unless($value) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 24
$t++;
print "Setting a section in a hash ...... ";
$ini{newsect} = {};
%{$ini{newsect}} = %bak;
$value = $ini{newsect}{four};
if( $value eq 'value4' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 25
$t++;
print "-default in new section in hash .. ";
$value = $ini{newsect}{one};
if( $value eq 'value1' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 26
$t++;
print "Store new section in hash ........ ";
tied(%ini)->RewriteConfig;
tied(%ini)->ReadConfig;
$value = $ini{newsect}{four};
if( $value eq 'value4' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}
 
# test 27
$t++;
print "Checking failure for missing ini (a failure message is normal here)\n";
if(!tie(%foo, 'Config::IniFiles', -file => "doesnotexist.ini") ) {
	print "                               ... ok $t\n";
} else {
	print "                               ... not ok $t\n";
}

# test 28
$t++;
print "Sections/Parms for undef value ... ";
$n1 = tied(%ini)->Parameters( 'newsect' );
$ini{newsect}{four} = undef;
$n2 = tied(%ini)->Parameters( 'newsect' );
$ini{newsect}{four} = 'value4';
$n3 = tied(%ini)->Parameters( 'newsect' );
if( $n1 == $n1 && $n2 == $n3 ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 29
$t++;
print "Empty list when no groups ........ ";
if( $en->Groups == () ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 30
$t++;
print "Creating new object, no file ..... ";
if ($ini = new Config::IniFiles) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 31
$t++;
print "Setting new file name .............";
if ($ini->SetFileName("newfile.ini")) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 32
$t++;
print "Saving under new file name ........";
if ($ini->RewriteConfig()) {
	if ( -f "newfile.ini" ) {
		print "ok $t\n";
	} else {
		print "not ok $t\n";
	}
} else {
	print "not ok $t\n";
}

# test 33
$t++;
print "SetSectionComment .................";
$ini->newval("Section1", "Parameter1", "Value1");
my @section_comment = ("Line 1 of section comment.", "Line 2 of section comment", "Line 3 of section comment");
if ($ini->SetSectionComment("Section1", @section_comment)) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 34
$t++;
print "GetSectionComment .................";
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

# test 35
$t++;
print "DeleteSectionComment ..............";
$ini->DeleteSectionComment("Section1");
if (defined $ini->GetSectionComment("Section1")) {
	print "not ok $t\n";
} else {
	print "ok $t\n";
}
