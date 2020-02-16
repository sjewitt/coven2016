##############################################################
#### ENGINE -                                                
#### generates the page to render from - ultimately - the 
#### XML data file.        
#### 
#### CALL HIERARCHY:
#### HTTP request for stub perl file
#### -> calls getPage() with stub file nane
#### 
#### The initial HTTP call is to the perl stub file
####                                                         
#### DEPENDANCIES:  none.                                    
##############################################################

sub core
{
    my $LOGGED_IN_USER  = getAuth();
    my $path            = $_[0];
    my $file            = $_[1];
    
    # get XML data file for supplied page:
    my $data            = getFile($path . "/" . $file . ".xml");
    
    # get layout template file. also, check for and use layout page defined 
    # in the page if present - eg index page.:
    my $layout          = "";
    
    # default to the global layout page:
    my $layoutSrc       = $DEFAULT_TEMPLATE;

    # over-ride with the folder cfg layout if found:
    if(fileExists($path . "defaults.cfg"))
    {
        $default_data       = getFile($path . "defaults.cfg");
        if(getXMLData("layoutpage",$default_data) ne "")
        {
            logger("over-riding with folder alternate layout 'template/" . getXMLData("layoutpage",$default_data) . "' for page '$path'");
            $layoutSrc = "template/" . getXMLData("layoutpage",$default_data);
        }
    }
    
    # and over-ride with the PAGE layout if found:
    if(length(getXMLData("layoutpage",$data)) ne 0)
    {
        $layoutSrc = "template/" . getXMLData("layoutpage",$data);
        logger("over-riding with page alternate layout 'template/" . getXMLData("layoutpage",$data) . "' for page '$path'");
        ################################################################################
        $homenav = getFolderNavData(); #TODO: this is a function specific to this site.
        ################################################################################
    }
    
    #load the layout once it has been determined:
    $layout          = getFile($layoutSrc);
    
    # vars holding default values.
    # the page that is displayed when a FOLDER is rendered. correlates with 
    # that set in .htaccess. Also, indicates the page that cannot be deleted
    # during an editing session. It is used to suppress rendering of the 
    # 'delete page' link: (TODO: I may not actually need this in anything other
    # than the global defaults)
    my $default_page;           
    my $default_section = "";   # root
    my $output          = "";   # string returned to render the page

    # now check for a 'defaults.cfg' in the current directory:    
    # if a defaults.cfg exists, use values stored here
    # rather than stored as local defaults - ie initialised
    # when a new page is created:
    # much of this is stll to develop...
    my $default_page;
    if(fileExists($path . "defaults.cfg"))
    {
        $default_data       = getFile($path . "defaults.cfg");
        $default_page       = getXMLData("defaultpage",$default_data);
        $default_section    = getXMLData("currentdirectory",$default_data); #for later use?
        logger("Defaults config file 'defaults.cfg' found: Using default values from this.");
        logger(" --> defaultpage: $default_page");
        logger(" --> currentdirectory: $default_section");
    }
    else
    {
        $default_page = getXMLData("defaultpage",$data);
    }

    ###################################################################
    # nav stuff: These are dependant on the site build                #
    ###################################################################
    my $atRoot  = "false";
    if($path eq "/" || !$path)
    {
        $atRoot = "true";
    }
    ###################################################################
    # END nav stuff:                                                  #
    ###################################################################
    
    #get editlink if session cookie is set:
    my $editlink = "";

    #GENERATE AN Editlink if logged in: (call function in /include/edit part)
    if($LOGGED_IN_USER eq true)
    {
        $editlink = getEditPanel($ENV{"SCRIPT_NAME"}, $default_page);
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

    # Iterative replacement of content tags. These don't require any format, so a simple replace will do.
    # The navs are different - see below - and all require additional logic.
    # The array @TAGS_TO_RENDER is defined in the 'configs.pl' configuration file.
    # TODO: 13.05.07: Need to add 'title' attributes to the tags
    for(my $i = 0; $i < scalar(@TAGS_TO_RENDER); $i++)
    {
        $img_start_tag  = "";
        $img_end_tag    = "";
        $contenttype    = getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"datatype");
        
        
        # if there is an editing session, generate the edit links for each content tag.
        # Edit links are rendered only for tags whose TYPE is 
        if($LOGGED_IN_USER eq true)
        {
            
            $editicon       = "";
            $alttext        = "";
            $editicon       = getContentEditLink($TAGS_TO_RENDER[$i]{'tag'},$path.$file);
            # generate edit link for elements that have a datatype of text (body copy) 
            # or string (a label/title)- ie editable:
            if($contenttype eq "text" || $contenttype eq "string")
            {
                $alttext = getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"friendlyname");
                $editicon = "<a href=\"#\" onclick=\"editPage('/edit/editor_editfile.pl?fname=".$path.$file.".xml&amp;contentid=" . $TAGS_TO_RENDER[$i]{'tag'} . "')\">";
                $editicon .= "<img src=\"/images/edit/edit.gif\" alt=\"Edit " . $alttext . "\" style=\"border:none;\" /></a>&nbsp;";
            }
            
            #generate edit link for elements that have a datatype of image - ie editable: GET DIFFERENT ICON!
            if($contenttype eq "image")
            {
                $alttext = getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"friendlyname");
                $editicon = "<a href=\"#\" onclick=\"editPage('/edit/editor_editfile.pl?fname=".$path.$file.".xml&amp;contentid=" . $TAGS_TO_RENDER[$i]{'tag'} . "')\">";
                $editicon .= "<img src=\"/images/edit/edit.gif\" alt=\"Edit " . $alttext . "\" style=\"border:none;\" /></a>&nbsp;";
            }
        }    
        #if $contenttype is 'image', then we need to wrap image tags around the content - ONLY if there is content!
        if($contenttype eq "image")# && length(replaceNewline(getXMLData($TAGS_TO_RENDER[$i]{'tag'}) eq 0)
        {
            $img_start_tag = "<img src=\"/images/" . getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"imagepath") . "/";
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
    
    return $output;

}

1; #must return 1
