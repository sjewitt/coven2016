######################################
#EDITING - PAGE CREATE FUNCTIONS######
######################################
#accepts a filename, a relative path, string file contents and an extension.
##############################################################
#### FILE METHOD - 
#### create a new file, checking that it doesn't exist first:
####
#### INPUT:         string filename, string relative path,
####                string filecontents, string extension
#### OUTPUT:        string statusmessage
#### DEPENDANCIES:  getRoot,
##############################################################

sub createFile
{
  my $root            = getRoot();
  my $filename        = $_[0];
  my $relativepath    = $_[1];
  my $filecontents    = $_[2];
  my $fileextension   = $_[3];
  my $result          = "";
  my $fullpath        = "";
  
  $fullpath = $root . $relativepath . "/" . $filename;
  
  if(!(-e $fullpath))   #does not exist - doit:
  {
    open NEWFILE, ">" . $fullpath;
    
    #set execute permissions as it's a .pl file...:
    chmod 0755, $fullpath;
    
    print NEWFILE $filecontents;
    close NEWFILE;
    $result = "File $fullpath successfully created.";
  }
  else
  {
    $result = "File $fullpath exists already. Cannot continue."
  }

  return $result;
}

1;  #must always return 1.

