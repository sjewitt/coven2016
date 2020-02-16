##############################################################
#### EDITOR METHOD - 
#### generate links on update page when logged in for editing
#### session. UNUSED???
####
#### INPUT:         string path, string display indent, string 
####                navheading.
#### OUTPUT:        string HTML navlinks.
#### DEPENDANCIES: getRoot, getXMLData
#### TODO: configure edit pages as globals
##############################################################

sub getEditLinks
{
  my $UPDATE_PAGE     = "editor_editfile.pl";
  my $path            = $_[0];
  my $indent          = $_[1];
  my $navheading      = $_[2];
  #get directory listing:
  my $output;
  my $root = getRoot();
  my $currpage;
  my $FILES_TO_INCLUDE = ".xml";
  
  opendir NAV, $root . $path;
  
  #an array:
  my @contents = readdir NAV;
  
  #loop over list:
  my $nav = "";
  my $currLinkText;
  
  #add navheading:
  $nav .= "<div class=\"editor_editlist\"><div class=\"editor_editlisttitle\">" . $_[2] . "</div>";
  foreach $listitem ( @contents )
  {
    $currpage   = $listitem;
    $output     .= $listitem;
    #check whether its a file or a directory, ignore directories:
    if ( -d $listitem ) {}  
    else
    {
      if(substr($currpage,(index($currpage,".")),length($currpage)) eq $FILES_TO_INCLUDE)
      {
        #check for double // if path is zero-length:
        if(length($path) > 0)
        {
          $currpage = "/" . $listitem;
        }
        #get the current page linktext:
        $currLinkText = getXMLData("linktext",getFile($path . $currpage));
        if(length($currLinkText) eq 0)
        {
          $currLinkText = $currpage;
        }
        $nav .= $indent . "<div class=\"editor_editlistlink\"><a href=\"" . $UPDATE_PAGE . "\?fname=" . $path . $listitem . "\">" . $currLinkText . "</a></div>\n";
      }
    }
    $output .= "</div>";
  }
  close NAV;
  return $nav;
}

1;  #must always return 1.
