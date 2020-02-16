#get a data struture holding navigation data:
sub getNavData
{
  $path       = $_[0];    #nav root
  $default    = $_[1];    #directory default page - ie current 'home' - WITHOUT extension
  
  my $root = getRoot();
  my $currpage;                     #the current page in iteration
  my $currUrl;                      #placeholder for item URL
  my $currLinktext;                 #placeholder for item linktext
  my $currStatus;                   #placeholder for whether link or just linktext
  my $FILES_TO_INCLUDE = ".xml";    #regexp? or array?
  my $comparator;
  my @result;                       #an array of hashmaps
  my $leading = "";
  
  #determine if we are at the root. bugger about with the path if not:
  my $atRoot = true;
  if(length($path) > 0)
  {
    #if we are NOT at root, add a leading slash:
    $atRoot = false;
    $leading = "/";
  }
  #get self:
  my $self = $ENV{"SCRIPT_NAME"};
  
  opendir NAV, $root . $path;
  
  #an array:
  my @contents = readdir NAV;

  foreach $listitem ( @contents )
  {
    #check for double // if path is zero-length:
    $currpage = $leading . $listitem;  #listitem is the current item in the folder. NO slashes
    
    #check whether its a file or a directory, ignore directories:
    if ( -d $listitem ) {}  
    else
    {
      #check the current file is of correct type and NOT the default directory page:
      if((substr($currpage,(index($currpage,".")),length($currpage)) eq $FILES_TO_INCLUDE) && !($listitem eq $default . $FILES_TO_INCLUDE))
      {
        #get the current page linktext:
        $currLinktext = getXMLData("linktext",getFile($path . "/" . substr($listitem,0,index($listitem,".")) . ".xml"));
        
        #if no linktext defined, use the page url (no extension) instead:
        if(length($currLinktext) eq 0)
        {
          $currLinktext = $currpage;
        }
        
        #as we pulled out the XML data files only, we need to generate .pl files instead for the URLs: 
        $currUrl = substr($listitem,0,index($listitem,".")) . ".pl";
  
        if($atRoot eq false)
        {
          $comparator = $path . substr($currpage,1,index($currpage,".")) . "pl";
        }
        else
        {
          $comparator = "/" . $path . substr($currpage,0,index($currpage,".")) . ".pl";
        }

        if($self eq $comparator)
        {
          $currStatus = "SELF";
        }
        else
        {
          $currStatus = "LINK";
        }
        
        #push the data onto the result array:
        push(@result,{url=>$currUrl,linktext=>$currLinktext,status=>$currStatus});
      }
    }
  }
  close NAV;
  return @result;         #an array of nav items
}
#site specific formatted nav - javascript arrays in this case:
sub getCovenNavs
{
  my $result = "";
  my $secondarynav_JS = "var nav=new Object();\n";
  my @curr_secondarynav_data;
  my $primarynav_JS = "var primarynav = new Array();\nvar homenav = new Array();";
  for($counter=0;$counter<scalar(@SITE_SECTIONS);$counter++)
  {
    #make sure the image actually exists:
    $primarynav_JS .= "primarynav[$counter] = {url: \"" . $SITE_SECTIONS[$counter]{path} . "\", linktext: \"" . $SITE_SECTIONS[$counter]{linktext} . "\", image: \"/images/navicons/" . $SITE_SECTIONS[$counter]{path} . "_sml.jpg\"};\n";
    $primarynav_JS .= "homenav[$counter] = {url: \"" . $SITE_SECTIONS[$counter]{path} . "\", linktext: \"" . $SITE_SECTIONS[$counter]{linktext} . "\", image: \"/images/navicons/" . $SITE_SECTIONS[$counter]{path} . ".jpg\"};\n";
    
    @curr_secondarynav_data = getNavData($SITE_SECTIONS[$counter]{path});
    $secondarynav_JS .= "nav." . $SITE_SECTIONS[$counter]{path} . "nav=new Array();\n";
    for($counter2=0;$counter2<scalar(@curr_secondarynav_data);$counter2++)
    {
      $secondarynav_JS .= "nav." . $SITE_SECTIONS[$counter]{path} . "nav[$counter2]=new Object();\n";
      $secondarynav_JS .= "nav." . $SITE_SECTIONS[$counter]{path} . "nav[$counter2].page={url: \"/" . $SITE_SECTIONS[$counter]{path} . "/" . $curr_secondarynav_data[$counter2]{url} . "\", linktext: \"" . $curr_secondarynav_data[$counter2]{linktext} . "\"};\n";
    }
  }
  $result = $primarynav_JS . $secondarynav_JS;
  return $result;
}

1;  #must always return 1.
