use strict;
use Test;

BEGIN { $| = 1; plan tests => 5 }
use Config::IniFiles;
my $loaded = 1;
ok($loaded);

my $ini;

# a simple filehandle, such as STDIN
#** If anyone can come up with a test for STDIN that would be great
#   The following could be run in a separate file with data piped
#   in. e.g. ok( !system( "$^X t/stdin.pl < t/test.ini" ) );
#   But it's only good on platforms that support redirection.
#	use strict;
#	use Config::IniFiles;
#	my $ini = new Config::IniFiles -file => STDIN;
#	exit $ini ? 0; 1

local *CONFIG;
# a filehandle glob, such as *CONFIG
if( open( CONFIG, "t/test.ini" ) ) {
  $ini = new Config::IniFiles -file => *CONFIG;
  ok($ini);
  close CONFIG;
} else {
 ok( 0 );
}
	
# a reference to a glob, such as \*CONFIG
if( open( CONFIG, "t/test.ini" ) ) {
  $ini = new Config::IniFiles -file => \*CONFIG;
  ok($ini);
  close CONFIG;
} else {
  ok( 0 );
}

# an IO::File object
if( eval( "require IO::File" ) && (my $fh = new IO::File( "t/test.ini" )) ) {
  $ini = new Config::IniFiles -file => $fh;
  ok($ini);
  $fh->close;
} else {
  ok( 0 );
}

# the pathname of a file
$ini = new Config::IniFiles -file => "t/test.ini";
ok($ini);


