use strict;
use Test;
use Config::IniFiles;

BEGIN { plan tests => 6 }

sub slurp {
    my ($filename)=@_;
    open(SLURP, "<$filename") || die "Cannot open $filename: $!";
    my $retval=join("", <SLURP>);
    close(SLURP);
    return $retval;
}

my $ors = $\ || "\n";
my ($ini,$value);

# Get files from the 't' directory, portably
chdir('t') if ( -d 't' );

#
# Delta tests added by D/DO/DOMQ
#

# test 1
# print "Import a file .................... ";
my $en = new Config::IniFiles( -file => 'en.ini' );
ok( $en );

# test 2
my $es;
ok( $es = new Config::IniFiles( -file => 'es.ini', -import => $en ) );
my $estext=slurp("es.ini"); $estext =~ s/\s*//g;

# test 3
## Delta without any update should result in exact same file (ignoring
## distinctions about leading whitespace)
unlink('delta.ini');
$es->WriteConfig('delta.ini', -delta=>1);
my $deltatext=slurp('delta.ini'); $deltatext =~ s/\s*//g;
ok($deltatext eq $estext);
unlink('delta.ini');

# test 4
## Delta with updates
$es->newval("something", "completely", "different");
$es->WriteConfig('delta.ini', -delta=>1);
$deltatext=slurp('delta.ini');
ok($deltatext =~ m/^[something].*completely=different/sm) || warn($deltatext);
unlink('delta.ini');

# test 5
## Delta with deletion marks
$es->delval("x", "LongName");
$es->DeleteSection("m");
$es->WriteConfig('delta.ini', -delta=>1);
$deltatext=slurp('delta.ini');
ok(($deltatext =~ m/^. \[m\] is deleted/m) &&
   ($deltatext =~ m/^. LongName is deleted/m)) || warn $deltatext;

# test 6
## Parsing back deletion marks

$es=new Config::IniFiles( -file => 'delta.ini', -import => $en );
ok((!defined $es->val("x", "LongName")) &&
   (! $es->SectionExists("m")));
unlink("delta.ini");
