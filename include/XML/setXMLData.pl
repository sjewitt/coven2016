##############################################################
#### XML METHOD - 
#### write the data between passed XML tags:
####
#### INPUT:         string tag name, string XML containing 
####                required tag, string new tag contnts
#### OUTPUT:        string tag with updated contents
#### DEPENDANCIES:  none.
#### (TODO: handle tag or attribute not found)
##############################################################

sub setXMLData
{
  #logger("in setXMLData()...");
  my $tag         = $_[0];    #tag to which to write data
  my $str         = $_[1];    #The XML file contents
  my $new         = $_[2];    #The new data to write
  
  my $regexp_start = "<" . $tag . ".*?>"; #non-greedy match
  $str =~ m/($regexp_start)/i;
  # $1 is the scalar value returned from first bracket above. There is only one here...

  my $startTag    = $1;
  my $endTag      = "</" . $tag . ">";
  my $output_start= substr($str,0,index($str,$startTag) + length($startTag));   #because of bracket
  my $output_end  = substr($str,index($str,$endTag),length($str));
  #build return string:
  $output = $output_start . $new . $output_end;
  return $output;
}

1;  #must always return 1.
