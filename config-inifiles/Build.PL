
use strict;
use warnings;

use File::Spec;
use lib File::Spec->catdir(File::Spec->curdir(), "inc");

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    'module_name' => "Config::IniFiles",
    'license' => "perl",
    dist_author => 'Shlomi Fish <shlomif@iglu.org.il>',
    'configure_requires' =>
    {
        'Module::Build' => '0.36',
    },
    'build_requires' =>
    {
        'base' => 0,
        'File::Spec' => 0,
        'List::Util' => 0,
        'Scalar::Util' => 0,
        'strict' => 0,
        'Test::More' => 0,
        'warnings' => 0,
    },
    'requires' =>
    {
        'strict' => 0,
        'Carp' => 0,
        'Symbol' => 0,
        'warnings' => 0,
    },
    create_makefile_pl => 'small',
    meta_merge =>
    {
        resources =>
        {
            repository => "http://config-inifiles.svn.sourceforge.net/svnroot/config-inifiles/",
            homepage => "https://sourceforge.net/projects/config-inifiles/",
        },
        keywords =>
        [
            "ini",
            "files",
            "config",
            "configuration",
            "ini files",
            "windows",
            "tie",
            "pure-perl",
            "tested",
        ],
    },
);

$builder->create_build_script;
