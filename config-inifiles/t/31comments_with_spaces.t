#!/usr/bin/perl

# This test attempts to reproduce
# https://sourceforge.net/tracker/?func=detail&aid=3388382&group_id=6926&atid=106926

use strict;
use warnings;

use Test::More tests => 4;
use File::Spec;

use Config::IniFiles;
my $content = <<'EOT';
[section]
value1 = xxx ; My Comment
value2 = xxx ; My_Comment
EOT

my $ini = Config::IniFiles->new( -file => \$content,
-handle_trailing_comment => 1,
-commentchar => ';',
-allowedcommentchars => ';#');

is( $ini->val('section','value1'), 'xxx' );
is( $ini->GetParameterTrailingComment('section','value1'), 'My Comment');
is( $ini->val('section','value2'), 'xxx' );
is( $ini->GetParameterTrailingComment('section','value2'), 'My_Comment'); 
