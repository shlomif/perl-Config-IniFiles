package Config::IniFiles::TestPaths;

use strict;
use warnings;

use File::Spec;

use base 'Exporter';

use vars (qw(@EXPORT));

@EXPORT = (qw(t_file));

=head2 my $t_filename = t_file($filename)

Returns a portable filename under "./t" for $filename.

=cut

sub t_file
{
    my $filename = shift;

    return File::Spec->catfile(File::Spec->curdir(), "t", $filename);
}

1;

