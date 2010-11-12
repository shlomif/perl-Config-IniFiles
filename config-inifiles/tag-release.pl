#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my ($version) = 
    (map { m{\$VERSION *= *'([^']+)'} ? ($1) : () } 
    io->file('lib/Config/IniFiles.pm')->getlines()
    )
    ;

if (!defined ($version))
{
    die "Version is undefined!";
}

my $mini_repos_base = 'https://config-inifiles.svn.sourceforge.net/svnroot/config-inifiles';

my @cmd = (
    "svn", "copy", "-m",
    "Tagging the Config-IniFiles release as $version",
    "$mini_repos_base/trunk",
    "$mini_repos_base/tags/releases/$version",
);

print join(" ", map { /\s/ ? qq{"$_"} : $_ } @cmd), "\n";
exec(@cmd);

