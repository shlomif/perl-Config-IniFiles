#!/usr/bin/perl

use Test::More;

use strict;
use warnings;

use Config::IniFiles;
use File::Spec;

eval "use File::Temp qw(tempdir)";

plan skip_all => "File::Temp required for testing" if $@;

plan tests => 2;

{
    my $dir_name = tempdir(CLEANUP => 1);
    my $filename = File::Spec->catfile($dir_name, "foo.ini");
    my $data = join "", <DATA>;
    open F, ">$filename";
    print F $data;
    close F;

    my $ini = Config::IniFiles->new(-file => $filename, -nomultiline => 1);

    # TEST
    ok(defined($ini), "Ini was initialised");

    $ini->RewriteConfig;
    my $content;
    {
        local $/;
        open F, $filename;
        $content = <F>;
    }
    ok($content !~ /EOT/ && $content =~ /^a=1/m && $content =~ /^a=2/m,
       "No multiline is output");
}

__DATA__
[section]
a = 1
a = 2

