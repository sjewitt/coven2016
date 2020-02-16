##############################################################
#### STRING METHOD - 
#### replace globally newlines with <br /> in a string. NOTE
#### this is a specialisation of 'replace'
####
#### INPUT:         string source string
#### OUTPUT:        string modified string.
#### DEPENDANCIES:  none
##############################################################

sub replaceNewline
{
  my $src = $_[0];
  my $result_string = $src;
  $result_string =~ s/[\n\r]/<br \/>/g;
  return $result_string;
}

1;  #must always return 1.

