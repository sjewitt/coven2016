##############################################################
#### generate an edit icon link for supplied tag 
#### 
#### INPUT          string CMS tag to append edit icon, string 
####                path to file                                                
#### DEPENDANCIES:  none (may depend on the specific 
#### implementation).                                    
##############################################################
sub getContentEditLink
{
    my $xmlTag      = $_[0];
    my $fullPath    = $_[1];
    my $output      = "";
    my $alttext     = "";
    
    # generate edit link for elements that have a datatype of text (body copy) 
    # or string (a label/title)- ie editable:
    if($contenttype eq "text" || $contenttype eq "string")
    {
        $alttext = getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"friendlyname");
        $output = "<a href=\"#\" onclick=\"editPage('/edit/editor_editfile.pl?fname=".$path.$file.".xml&amp;contentid=" . $TAGS_TO_RENDER[$i]{'tag'} . "')\">";
        $output .= "<img src=\"/images/edit/edit.gif\" alt=\"Edit " . $alttext . "\" style=\"border:none;\" /></a>&nbsp;";
    }
    
    #generate edit link for elements that have a datatype of image - ie editable: GET DIFFERENT ICON!
    if($contenttype eq "image")
    {
        $alttext = getXMLTagParameter($TAGS_TO_RENDER[$i]{'tag'},$data,"friendlyname");
        $output = "<a href=\"#\" onclick=\"editPage('/edit/editor_editfile.pl?fname=".$path.$file.".xml&amp;contentid=" . $TAGS_TO_RENDER[$i]{'tag'} . "')\">";
        $output .= "<img src=\"/images/edit/edit.gif\" alt=\"Edit " . $alttext . "\" style=\"border:none;\" /></a>&nbsp;";
    }
    return $output;
}

1;  #must return 1
