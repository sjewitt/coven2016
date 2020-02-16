##############################################################
#### XML METHOD - 
#### get the specified tag parameter value:
####
#### INPUT:         string tag name, string XML containing 
####                required tag, string tag attribute whose
####                value we want
#### OUTPUT:        string tag attribute value
####                just a string, or an XML fragment.
#### DEPENDANCIES:  none.
#### (TODO: handle tag or attribute not found)
##############################################################

sub getXMLTagParameter
{
  my $tag         = $_[0];    #tag from which to get data
  my $str         = $_[1];    #The XML file contents
  my $attr        = $_[2];    #the tag attribute whose value we want
  my $regexp_start = "<" . $tag . ".*?>"; #non-greedy match
  
  $str =~ m/($regexp_start)/i;
  # $1 is the scalar value returned from first bracket above. There is only one here...
  my $tag    = $1;
  my $output      = substr($tag,index($tag,$attr)+length($attr)+2); #strip everything before the attribute value
  $output         = substr($output,0,index($output,"\""));          #now strip everything after the attribute value
  return $output;
}

1;  #must always return 1.
