use strict;
use Test;

BEGIN { $| = 1; plan tests => 8 }
use Config::IniFiles;
my $loaded = 1;
ok($loaded);

my $ini;

# Get files from the 't' directory, portably
chdir('t') if ( -d 't' );

# a simple filehandle, such as STDIN
#** If anyone can come up with a test for STDIN that would be great
#   The following could be run in a separate file with data piped
#   in. e.g. ok( !system( "$^X stdin.pl < test.ini" ) );
#   But it's only good on platforms that support redirection.
#	use strict;
#	use Config::IniFiles;
#	my $ini = new Config::IniFiles -file => STDIN;
#	exit $ini ? 0; 1

local *CONFIG;
# Test 2
# a filehandle glob, such as *CONFIG
if( open( CONFIG, "test.ini" ) ) {
  $ini = new Config::IniFiles -file => *CONFIG;
  ok($ini);
  close CONFIG;
} else {
 ok( 0 );
}
	
# Test 3
# a reference to a glob, such as \*CONFIG
if( open( CONFIG, "test.ini" ) ) {
  $ini = new Config::IniFiles -file => \*CONFIG;
  ok($ini);
  close CONFIG;
} else {
  ok( 0 );
}

# Test 4
# an IO::File object
if( eval( "require IO::File" ) && (my $fh = new IO::File( "test.ini" )) ) {
  $ini = new Config::IniFiles -file => $fh;
  ok($ini);
  $fh->close;
} else {
  ok( 0 );
}

# Test 5
# the pathname of a file
$ini = new Config::IniFiles -file => "test.ini";
ok($ini);

# Test 6
# A non-INI file should fail, but not throw warnings
local $@ = '';
my $ERRORS = '';
local $SIG{__WARN__} = sub { $ERRORS .= $_[0] };
eval { $ini = new Config::IniFiles -file => "00load.t" };
ok(!$@ && !$ERRORS && !defined($ini));


# Test 7
# Read in the DATA file without errors
$@ = '';
$ERRORS = '';
eval { $ini = new Config::IniFiles -file => \*DATA };
ok(!$@ && !$ERRORS && defined($ini));

# Test 8
# Try a file with utf-8 encoding (has a Byte-Order-Mark at the start)
$ini = new Config::IniFiles -file => "en.ini";
ok($ini);



__END__
; File that has comments in the first line
; Comments are marked with ';'. 
; This should not fail when checking if the file is valid
[section]
parameter=value


