##############################################################
#### FILE METHOD - 
#### get content of a file.
####
#### INPUT:         string relative path/filename.
#### OUTPUT:        string filecontents.
#### DEPENDANCIES:  none
#### (TODO: this needs to be modified to cope with any path
#### length)
##############################################################

sub getPath
{
  my $page =$ENV{'SCRIPT_NAME'};
  my $returnval = "/";
  my @pathparts = split(/\//,$page);
  
  if(scalar(@pathparts) eq 3) #its a subfolder
  {
    $returnval = @pathparts[1];
  }

  return $returnval;
}

1;  #must always return 1.
