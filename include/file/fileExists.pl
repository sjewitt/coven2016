##############################################################
#### FILE METHOD - 
#### get filesystem root path.
####
#### INPUT:         string relative filepath/name to check.
#### OUTPUT:        integer (0/1) indicating existance of
####                file.
#### DEPENDANCIES:  getRoot
##############################################################

sub fileExists
{

  my $path            = $_[0];    #relative path to file
  my $root            = getRoot();
  my $fullpath        = $root . $path;
  if(-e $fullpath)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}

1;  #must always return 1.
