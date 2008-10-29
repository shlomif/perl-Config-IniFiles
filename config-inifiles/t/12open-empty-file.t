#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;
use File::Spec;

use Config::IniFiles;

my $filename = File::Spec->catfile("t", "empty.ini");

{
    my $cfg=Config::IniFiles->new;
    $cfg->WriteConfig($filename);
}

{
    my $cfg=Config::IniFiles->new(-file => $filename, -allowempty => 1);

    # TEST
    isa_ok ($cfg, "Config::IniFiles", '$cfg');
}

unlink($filename);
