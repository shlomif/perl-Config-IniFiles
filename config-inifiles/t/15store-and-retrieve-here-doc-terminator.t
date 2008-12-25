#!/usr/bin/perl

# This script attempts to reproduce:
# https://sourceforge.net/tracker/index.php?func=detail&aid=1230339&group_id=6926&atid=106926

use strict;
use warnings;

use Test::More tests => 1;
use File::Spec;

use Config::IniFiles;

my $filename = File::Spec->catfile(
    File::Spec->curdir(), "t", "store-and-retrieve-here-doc-terminator.ini"
);

# Prepare the offending file.
{
    # Delete the stray file - we want to over-write it.
    unlink($filename);
    my $cfg=Config::IniFiles->new();

    $cfg->newval ("MySection", "MyParam", "Hello\nEOT\n");

    $cfg->WriteConfig($filename);
}

{
    my $cfg=Config::IniFiles->new(-file => $filename);

    # TEST
    is (scalar($cfg->val ("MySection", "MyParam")),
        "Hello\nEOT\n",
        "Default here-doc terminator was stored and retrieved correctly",
    );
}

