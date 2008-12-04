
use strict;
use warnings;

use File::Spec;
use lib File::Spec->catdir(File::Spec->curdir(), "inc");

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    'module_name' => "Config::IniFiles",
    'build_requires' =>
    {
        'File::Spec' => 0,
    },
    'requires' =>
    {
        'strict' => 0,
        'Carp' => 0,
        'Symbol' => 0,
        'warnings' => 0,
    },
    'license' => "perl",
);
$builder->create_build_script;
