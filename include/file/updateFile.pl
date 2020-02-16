##############################################################
#### FILE METHOD - 
#### Get file name without extension or path:
####
#### INPUT:         string relative filepath/name.
#### OUTPUT:        string statusmessage
#### DEPENDANCIES:  getRoot,
##############################################################

sub updateFile
{
  my $root          = getRoot();
  my $file          = $_[0];
  my $filecontents  = $_[1];
  my $result        = "";

  $result           = "";
  $fullpath         = $root . $file;

  if(-e $fullpath)  #if exists
  {
    $result         = "<div class=\"system_message\">Updating file " . $fullpath . "</div>";
    open UPDATEFILE, ">" . $fullpath;
    
    #set execute permissions as it's a .pl file...:
    chmod 0755, $fullpath;
    
    print UPDATEFILE $filecontents;
    close UPDATEFILE;
  }
  return $result;
}

1;  #must always return 1.
