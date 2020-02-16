##############################################################
#### FILE METHOD - 
#### Get file name without extension or path:
####
#### INPUT:         string relative filepath/name.
#### OUTPUT:        string filename
#### DEPENDANCIES:  none
#### (TODO: allow for multiple '.')
##############################################################

sub getPureFileName
{
  my $src               = $_[0];
  my @path_no_extension = split(/\./,$src);
  my @path_sections     = split(/\//,@path_no_extension[0]);
  
  #funky length syntax - a scalar cannot hold an array, so it determines length instead:
  $length = @path_sections;
  
  #now we want the last element of the array:
  return @path_sections[$length - 1];
}

1;  #must always return 1.
