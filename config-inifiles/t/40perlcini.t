#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 38;
use File::Copy qw{copy};
use File::Temp qw(tempdir);

my $test    = $0;
my $inifile = "$0.ini";
my $exec    = 'perl -Mlib=lib scripts/perlcini';

#perlcini get        inifile section parameter default
{
    my $get  = qx{$exec get $inifile my_section_1 my_parameter_1};
    my $code = $?;
    chomp $get;
    is( $get, 'my_value_1', 'my_section_1 my_parameter_1' );
    ok( !$code );
}
{
    my $get  = qx{cat $inifile | $exec get - my_section_1 my_parameter_1};
    my $code = $?;
    chomp $get;
    is( $get, 'my_value_1', 'my_section_1 my_parameter_1' );
    ok( !$code );
}
{
    my $get  = qx{$exec get $inifile my_section_1 not_my_parameter not_found};
    my $code = $?;
    chomp $get;
    is( $get, 'not_found', 'my_section_1 my_parameter_1' );
    ok( !$code );
}
{
    my $get =
        qx{cat $inifile | $exec get - my_section_1 not_my_parameter not_found};
    my $code = $?;
    chomp $get;
    is( $get, 'not_found', 'my_section_1 my_parameter_1' );
    ok( !$code );
}

#perlcini exists     inifile section parameter
{
    my $exists = qx{$exec exists $inifile my_section_1 my_parameter_1};
    my $code   = $?;
    chomp $exists;
    is( $exists, '1', 'my_section_1 my_parameter_1' );
    ok( !$code );
}
{
    my $exists = qx{cat $inifile | $exec exists - my_section_1 my_parameter_1};
    my $code   = $?;
    chomp $exists;
    is( $exists, '1', 'my_section_1 my_parameter_1' );
    ok( !$code );
}
{
    my $exists = qx{$exec exists $inifile my_section_1 not_my_parameter};
    my $code   = $?;
    chomp $exists;
    is( $exists, '', 'my_section_1 my_parameter_1' );
    ok($code);
}
{
    my $exists =
        qx{cat $inifile | $exec exists - my_section_1 not_my_parameter};
    my $code = $?;
    chomp $exists;
    is( $exists, '', 'my_section_1 my_parameter_1' );
    ok($code);
}

#perlcini parameters inifile section
{
    my @parameters = qx{$exec parameters $inifile "my section 2"};
    my $code       = $?;
    chomp @parameters;
    is( scalar(@parameters), 2, 'my_section_1' );
    ok( !$code );
    is( $parameters[0], 'my parameter 2' );
    is( $parameters[1], 'my parameter 2 whitespace' );
}
{
    my @parameters = qx{cat $inifile | $exec parameters - "my section 2"};
    my $code       = $?;
    chomp @parameters;
    is( scalar(@parameters), 2, 'my_section_1' );
    ok( !$code );
    is( $parameters[0], 'my parameter 2' );
    is( $parameters[1], 'my parameter 2 whitespace' );
}
{
    diag("Expect warning on next test");    #TODO: trap warn and test it.
    my @parameters = qx{$exec parameters $inifile not_my_section};
    my $code       = $?;
    chomp @parameters;
    is( scalar(@parameters), 0, 'my_section_1' );
    ok($code);
}

#perlcini sections   inifile
{
    my @sections = qx{$exec sections $inifile};
    my $code     = $?;
    chomp @sections;
    is( scalar(@sections), 2, 'my_section_1' );
    ok( !$code );
    is( $sections[0], 'my_section_1' );
    is( $sections[1], 'my section 2' );
}

{
    my $tempdir = tempdir( CLEANUP => 1 );
    my $copy    = "$tempdir/copy.ini";
    copy( $inifile, $copy );
    undef($inifile);

    #perlcini set        inifile section parameter value [value] [value]
    {
        #   diag('### ls ###');
        #   diag(`ls -l $copy`);
        #   diag('### cat ###');
        #   diag(`cat $copy`);
        #   diag('### set ###');
        my $return = qx{$exec set $copy my_section_1 my_parameter_1 new_value};

        #   diag('### ls ###');
        #   diag(`ls -l $copy`);
        #   diag('### cat ###');
        #   diag(`cat $copy`);
        my $code = $?;
        chomp $return;
        is( $return, '' );
        ok( !$code );
    }
    {
        my $return = qx{$exec get $copy my_section_1 my_parameter_1 error};
        my $code   = $?;
        chomp $return;
        is( $return, 'new_value' );
        ok( !$code );
    }

    #perlcini delete     inifile section parameter
    {
        #   diag('### ls ###');
        #   diag(`ls -l $copy`);
        #   diag('### cat ###');
        #   diag(`cat $copy`);
        #   diag('### delete ###');
        my $return = qx{$exec delete $copy my_section_1 my_parameter_1};

        #   diag('### ls ###');
        #   diag(`ls -l $copy`);
        #   diag('### cat ###');
        #   diag(`cat $copy`);
        my $code = $?;
        chomp $return;
        is( $return, '' );
        ok( !$code );
    }
    {
        my $return = qx{$exec exists $copy my_section_1 my_parameter_1};
        my $code   = $?;
        chomp $return;
        is( $return, '' );
        ok($code);
    }
}
