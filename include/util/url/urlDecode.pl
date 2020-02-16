##############################################################
#### UTIL METHOD - 
#### decode a URL parameter string:
####
#### INPUT:         string url parameter to decode.
#### OUTPUT:        string the decoded parameter.
#### DEPENDANCIES:  none.
##############################################################

sub urlDecode
{
  $input = $_[0];
  $output = $input;
  $output =~ s/\+/ /g;
  $output =~ s/%([\dA-Fa-f]{2})/pack("C", hex($1))/eg;
  return $output;
}

1;  #must always return 1.
