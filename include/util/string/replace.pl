##############################################################
#### STRING METHOD - 
#### replace globally a substring in a string. NOTE care with
#### '[nn]' as input string as this defines a character class.
####
#### INPUT:         string source string, regexp string to 
####                replace, string replacement
#### OUTPUT:        string modified string.
#### DEPENDANCIES:  none
##############################################################

sub replace
{
  my $src_string  = $_[0];
  my $src_word    = $_[1];    #actually a regexp string.
  my $target_word = $_[2];
  my $result_string;
  $result_string = $src_string;
  $result_string =~ s/$src_word/$target_word/g;
  return $result_string;
}

1;  #must always return 1.
