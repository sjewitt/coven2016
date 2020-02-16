##############################
#PAGE RENDERING###############
##############################

#get the components of each page and assemble them:
sub getPage
{
    print "FISH!!!!!!!";
    logger("getPage(): starting for $_[1]...");
  my $LOGGED_IN_USER = getAuth();
  
  logger("getPage(): user is authorised: $LOGGED_IN_USER");
  my $path = $_[0];
  my $file = $_[1];
  logger("getPage(): PATH: $path; FILE: $file");
  #vars holding default values:
  my $default_page;
  my $default_section = ""; #root
  
  #output:
  my $output = "";
  
  #get layout template file:
  my $layout = getFile("template/layout.tmpl");

  #get XML data file for page:
  my $data = getFile($path . "/" . $file . ".xml");
  
  #test:
  $navorder = getXMLData("navorder",$data); #need to check for tag in this method
  
  #my $homenav = "HOMENAV";
  #also, check for and use layout page defined in the page if present - eg index page.
  if(length(getXMLData("layoutpage",$data)) ne 0)
  {
    $layout = getFile("template/" . getXMLData("layoutpage",$data));
    #determine what else to get - eg for this I need to get a particular nav for the Home page:
    #could do if(getXMLData() == "index") etc...
    $homenav = getFolderNavData(); #this is a function specific to this site.
    #print "using alternative layout: <xmp>$layout</xmp>";
  }
  #print $homenav;
  
  #now check for a 'defaults.cfg' in the current directory:    
  #if a defaults.cfg exists, use values stored here
  #rather than stored as local defaults - ie initialised
  #when a new page is created:
  my $default_page;
  if(fileExists($path . "defaults.cfg"))
  {
    $default_data       = getFile($path . "defaults.cfg");
    $default_page       = getXMLData("defaultpage",$default_data);
    $default_section    = getXMLData("currentdirectory",$default_data);
    #print "global default: ".$default_page;
  }
  else
  {
    #get defaults from the page:
    $default_page = getXMLData("defaultpage",$data);
  }
  
  ###################################################################
  # nav stuff: These are dependant on the site build                #
  ###################################################################
  
  #my $rhnav = getTopNav($default_section,$default_page,$path);
  #my $rhnav_title = "Check out...";
  #my $homelink = "<a href=\"/\">Home</a>";
  my $atRoot = "false";
  if($path eq "/" || !$path)
  {
    $atRoot = "true";
  }
  #if((getPureFileName($ENV{"SCRIPT_NAME"}) eq $default_page) && ($atRoot eq "true"))
  #{
  #  $homelink = "<b>Home</b>";
  #}
  #my $lhnav = format_nav_right(nav($path,$default_page));
  ##### I want to generate some functions to do this.
  #my $lhnav_title = "More...";
  
  #get editlink if session cookie is set:
  my $editlink = "";

  #GENERATE AN Editlink if logged in:
  #if(getAuth() eq true)
  if($LOGGED_IN_USER eq true)
  {
    $editlink =     "<div class=\"editpanel\">";
    $editlink .=    "<span class=\"editlink\">";
    $editlink .=    "<a href=\"#\" onClick=\"editPage('/edit/editor_newfile2.pl')\">";
    $editlink .=    "<strong>Create</strong></a> new page.</span>";
    
    #we don't want to delete the default page, otherwise going to directory will throw a 404 error.
    if(getPureFileName($ENV{"SCRIPT_NAME"}) ne $default_page)
    {
        $editlink .=    "<span class=\"editlink\">";
        $editlink .=    "<a onclick=\"javascript:return(confirm('Really delete this page?'));\" href=\"/edit/editor_deletefile.pl?page=" . substr($ENV{"SCRIPT_NAME"},0,index($ENV{"SCRIPT_NAME"},".")) . "\">";
        $editlink .=    "<strong>Delete</strong></a> this page.</span>";
    }
    $editlink .=    "<span class=\"editlink\">";
    $editlink .=    "<strong>[<a href=\"/logout.pl?return=" . $ENV{"SCRIPT_NAME"} . "\">Logout</a>]</strong>";
    $editlink .=    "</span></div>";
  }
  ###################################################################################################################
  #replace CMS placeholders in layout template:
  #loop over global config array defining tags to render from XML file:
  #we also want icons by each editable element if logged in. These
  #will pass the element and what type of content it is to the edit content page.
  #the edit content page will then allow editing of this particular element.
  my $editicon = "";
  my $alttext = "";
  my $contenttype = "";
  
  #iterative replacement of content tags. These don't require any format, so a simple replace will do.
  #The navs are different - see below - and all require additional logic.
  #TODO: 13.05.07: Need to add 'title' attributes to the tags
  for(my $i = 0; $i < scalar(@TAGS_TO_RENDER); $i++)
  {
    $editicon = "";
    $alttext = "";
    $img_start_tag = "";
    $img_end_tag = "";
    
    #modify this to accept a path param for image subfolder...
    $contenttype = getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"datatype");
    
    #generate edit link for elements that have a datatype of text - ie editable:
    if($LOGGED_IN_USER eq true && ($contenttype eq "text" || $contenttype eq "string"))
    {
      $alttext = getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"friendlyname");
      $editicon = "<a href=\"#\" onClick=\"editPage('/edit/editor_editfile.pl?fname=".$path.$file.".xml&amp;contentid=" . $TAGS_TO_RENDER[$i]{'tag'} . "')\">";
      $editicon .= "<img src=\"/images/edit/edit.gif\" alt=\"Edit " . $alttext . "\" style=\"border:none;\" /></a>&nbsp;";
    }
    
    #generate edit link for elements that have a datatype of image - ie editable: GET DIFFERENT ICON!
    if($LOGGED_IN_USER eq true && $contenttype eq "image")
    {
      $alttext = getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"friendlyname");
      $editicon = "<a href=\"#\" onClick=\"editPage('/edit/editor_editfile.pl?fname=".$path.$file.".xml&amp;contentid=" . $TAGS_TO_RENDER[$i]{'tag'} . "')\">";
      $editicon .= "<img src=\"/images/edit/edit.gif\" alt=\"Edit " . $alttext . "\" style=\"border:none;\" /></a>&nbsp;";
    }
    
    #if $contenttype is 'image', then we need to wrap image tags around the content - ONLY if there is content!
    if($contenttype eq "image")# && length(replaceNewline(getXMLData($TAGS_TO_RENDER[$i]{'tag'}) eq 0)
    {
      $img_start_tag = "<img src=\"/images/";
      $img_end_tag = "\" />";
    }
    $layout = replace($layout,$TAGS_TO_RENDER[$i]{'placeholder'},$editicon . $img_start_tag . replaceNewline(getXMLData($TAGS_TO_RENDER[$i]{'tag'},$data).$img_end_tag));
  }
 
  #replace the nav:
  #$layout     = replace($layout,"{CMS_TOPNAV}",       nav_top($topnav));
  $layout     = replace($layout,"{CMS_JSNAVARRAY}",       getCovenNavs());
  $layout     = replace($layout,"{CMS_CURRPATH}",         getPath()); #get the current path to drop into the JS call
  $layout     = replace($layout,"{ENV_SCRIPT_NAME}",      $ENV{'SCRIPT_NAME'});

  #replace the edit link:
  $layout     = replace($layout,"{CMS_EDITLINK}",     $editlink);
  
  #return processed string:
  $output .= $layout;
  
  #$output .= $navorder; #test
  
   logger("getPage(): ending for $_[1]...");
  
  return $output;
}

#generic function to return paths to folders defined in config sub:
sub getFolderNavData
{
    logger("getFolderNavData(): ");
  my $result = "";
  #print scalar(@SITE_SECTIONS);
  for(my $a=0;$a<scalar(@SITE_SECTIONS);$a++)
  {
    $result .= "<div class=\"homepagethumbs\"><div class=\"thumbheader\">" . $SITE_SECTIONS[$a]{path} . "</div><a href=\"/" . $SITE_SECTIONS[$a]{path} . "\"><img src=\"/images/" . $SITE_SECTIONS[$a]{path} . ".jpg\" width=\"90\" height=\"90\" border=\"0\"></a></div>";
  }
  return $result;
}

##############################
#END PAGE RENDERING###########
##############################

1;  #must always return 1.
