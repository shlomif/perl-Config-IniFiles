#!/usr/bin/perl
use Config::IniFiles;
use strict;
use CGI;
my ($cgi, $VERSION, $prog,
    $cfg, $inifile, $form,
    $section, $param, $value, $name, $length,
	$row, @rows, $input,
    );

$VERSION = qw($Revision)[1];

$cgi = new CGI;
$inifile = "configuration.ini"; # Hardcoded for security
$prog = "iniedit.cgi"; # The name of this file
$cfg = Config::IniFiles->new(-file => $inifile);

#  Has the user already filled in some values?
if ($cgi->param('action') eq "change")	{
	MakeChanges($cgi, $cfg);
}

# Display the HTML page
print $cgi->header;
print $cgi->start_html();

print "<table>";
print $cgi->start_form(-method=>'POST',
                       -action=>$prog);
print $cgi->hidden(-name=>'action',
                   -value=>'change');

for $section ($cfg->Sections)	{
	$row = $cgi->th({-colspan=>'2'}, $section);
	print $cgi->Tr($row);
 	for $param	($cfg->Parameters($section))	{
 		$value = $cfg->val($section, $param);
 		$name = $section . "___" . $param;
 		$length = length($value) + 5;
		$input = $cgi->textfield(-name=>$name,
						-value=>$value,
						-size=>$length);
		$row = $cgi->td({-align=>'RIGHT'},$param) . 
		       $cgi->td({-align=>'LEFT'},$input);
 		print $cgi->Tr($row);
	} # End for param
} #  End for sections

$row = $cgi->td({-colspan=>'2'}, $cgi->submit('Make changes'));
print $cgi->Tr($row);
print "</form></table>";
print $cgi->end_html();

sub MakeChanges	{
	my ($cgi, $cfg) = @_;
	my ($key, $section, $param, @fields, $field);
	
	@fields = $cgi->param;
	for $field (@fields)	{
		if ($field =~ /___/)	{
			($section, $param) = split /___/, $field;
			$cfg->setval($section, $param, $cgi->param($field));
		}
	}  #  End keys

	$cfg->RewriteConfig;
	$cfg->ReadConfig;
}  #  End sub MakeChanges

=head1 NAME

iniedit.cgi - Interface for editing a generic ini configuration
file from the web.

=head1 DESCRIPTION

Generates a HTML form containing the sections and values from a
.ini-style configuration file, and lets you modify them.

=head1 README

Generates a HTML form containing the sections and values from a
.ini-style configuration file, and lets you modify them.

=head1 PREREQUISITES

	C<Config::IniFiles>, C<CGI.pm>

=pod OSNAMES

Any

=pod SCRIPT CATEGORIES

CGI

=cut
