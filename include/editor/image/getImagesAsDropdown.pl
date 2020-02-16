##############################################################
#### EDITOR METHOD - 
#### get list of gif/jpg in /images/ folder and generate 
#### dropdown when the content tag is of type IMAGE.
#### Will accept a sub-path parameter to allow obtaining 
#### images from a subfolder.
#### (this and getImagesForInsert should ideally be subclasses
#### of a generic listImages method...)
####
#### INPUT:         string currentimage, string sub path.
#### OUTPUT:        string HTML dropdown.
#### DEPENDANCIES:  getRoot
##############################################################

sub getImagesAsDropdown
{
  my $current_image = $_[0];
  my $sub_path      = $_[1];
  
  if(length(scalar $sub_path) ne 0)
  {
    $sub_path = "$sub_path/"
  }
  
  my $path          = "/images/$sub_path";
  my $root          = getRoot();
  my $extn          = "";
  my $selected      = "";
  opendir IMAGES, $root . $path;
  
  #an array:
  my @contents = readdir IMAGES;
  #loop over list:
  foreach $image ( @contents )
  {
    if ( -d $image ) {}  
    else
    {
      $extn = substr( $image,index($image,".")+1,length($image));
      if(lc($extn) eq "jpg" or lc($extn) eq "gif")
      {
        $selected = "";
        if($image eq $current_image)
        {
          $selected = "selected=\"selected\"";
        }
        $output .= "<option value=\"" . $image . "\" " . $selected . ">" . $image . "</option>";
      }
    }
  }

  close IMAGES;
  return $output;
}
1;  #must always return 1.
