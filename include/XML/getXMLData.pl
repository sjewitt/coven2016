##############################################################
#### XML METHOD - 
#### get the data between passed XML tags:
####
#### INPUT:         string root tag.
#### OUTPUT:        string child tree of tag contents. may be
####                just a string, or an XML fragment.
#### DEPENDANCIES:  none.
##############################################################

sub getXMLData
{
  my $tag         = $_[0];    #tag from which to get data
  my $str         = $_[1];    #The XML file contents
  
  my $regexp_start = "<" . $tag . ".*?>"; #non-greedy match
  $str =~ m/($regexp_start)/i;
  # $1 is the scalar value returned from first bracket above. There is only one here...

  my $startTag    = $1;
  my $endTag      = "</" . $tag . ">";
  my $output      = substr($str,index($str,$startTag) + length($startTag));
  $output         = substr($output,0,index($output,$endTag));
  return $output;
}

1;  #must always return 1.
