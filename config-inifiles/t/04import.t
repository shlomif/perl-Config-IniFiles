use Config::IniFiles;
print "1..$t\n";

my $ors = $\ || "\n";

#
# Import tests added by JW/WADG
#

# test 1
$t = 1;
# print "Import a file .................... ";
$en = new Config::IniFiles( -file => 't/en.ini' );
if( $es = new Config::IniFiles( -file => 't/es.ini', -import => $en ) ) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}


# test 2
$t++;
# print "Imported values are good ......... ";
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

# test 3
$t++;
# print "Import another level ............. ";
$ca = new Config::IniFiles( -file => 't/ca.ini', -import => $es );
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

BEGIN { $t = 3 }

