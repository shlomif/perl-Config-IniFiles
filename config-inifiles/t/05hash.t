use Config::IniFiles;
print "1..$t\n";

#
# Hash tying tests added by JW/WADG
#

# test 1
$t = 1;
# print "Tying a hash ..................... ";

if( tie %ini, 'Config::IniFiles', ( -file => "t/test.ini", -default => 'test1', -nocase => 1 ) ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 2
$t++;
# print "Accessing a hash ................. ";
$value = $ini{test1}{one};
if ($value eq 'value1') {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 3
$t++;
# print "Creating through a hash .......... ";
$ini{'test2'}{'seven'} = 'value7';
tied(%ini)->RewriteConfig;
tied(%ini)->ReadConfig;
$value = $ini{'test2'}{'seven'};
if ($value eq 'value7') {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 4
$t++;
# print "Deleting through hash ............ ";
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

# test 5
$t++;
# print "-default option in a hash ........ ";
if( $ini{test2}{three} eq 'value3' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 6
$t++;
#print "Case insensitivity in a hash ..... ";
if( $ini{TEST2}{THREE} eq 'value3' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 7
$t++;
# print "Listing sections ................. ";
$value = 1;
$ini = new Config::IniFiles( -file => "t/test.ini" );
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

# test 8
$t++;
# print "Listing parameters ............... ";
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


# test 9
$t++;
# print "Copying a section in a hash ...... ";
%bak = %{$ini{test2}};
$value = $bak{six} || '';
if( $value eq 'value6' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 10
$t++;
# print "Deleting a section in a hash ..... ";
delete $ini{test2};
$value = $ini{test2};
unless($value) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 11
$t++;
# print "Setting a section in a hash ...... ";
$ini{newsect} = {};
%{$ini{newsect}} = %bak;
$value = $ini{newsect}{four} || '';
if( $value eq 'value4' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 12
$t++;
# print "-default in new section in hash .. ";
$value = $ini{newsect}{one};
if( $value eq 'value1' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 13
$t++;
# print "Store new section in hash ........ ";
tied(%ini)->RewriteConfig;
tied(%ini)->ReadConfig;
$value = $ini{newsect}{four} || '';
if( $value eq 'value4' ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}
 
# test 14
$t++;
# my %foo;
# print "Checking failure for missing ini (a failure message is normal here)\n";
# # if(!tie(%foo, 'Config::IniFiles', -file => "doesnotexist.ini") ) {
	print "ok $t\n";
# } else {
	# print "not ok $t\n";
# }

# test 15
$t++;
# print "Sections/Parms for undef value ... ";
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

# test 16
$t++;
# print "Sections/Parms for undef value ... ";
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


BEGIN { $t = 16 }
