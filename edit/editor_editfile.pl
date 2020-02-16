#!/usr/bin/perl
$document_root = $ENV{'DOCUMENT_ROOT'};
require $document_root . "include/config/includes.pl";

#get the element that is to be edited:
$ELEMENT_TO_EDIT            = getRequest("contentid");
$ELEMENT_TO_EDIT_CAPTION    = "";  #set this from the friendlyname attribute of the element, below:
$IMAGE_ELEMENT_FILTER       = "";

if(getAuth() eq false)
{
    print "HTTP/1.1 302 Object moved\r\n";
    print "Location: " . $SITE_BASE_URL . "\r\n";
}
print "Content-type: text/html\r\n";
print "Expires: 0\r\n\r\n";

#result message:
$result             = "";

#form enabled/disabled:
$FIELD_IS_ENABLED   = "disabled=\"disabled\"";
$formvalue          = "";  #reset this

#handle a submitted update:
if($ENV{'REQUEST_METHOD'} eq 'POST')
{
    #get form vars if posted:
    read(STDIN, $postdata,$ENV{'CONTENT_LENGTH'});
    @pairs = split(/&/, $postdata);
    foreach $pair (@pairs) 
    {
        ($name, $value) = split(/=/, $pair);
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $FORM{$name} = $value;
    }
    
    #set hidden field passing the field being edited:
    $ELEMENT_TO_EDIT    = $FORM{"contentid"};
    $datatype           = $FORM{'datatype'};
    $fname              = $FORM{'fname'};
    $formvalue          = replace($FORM{$ELEMENT_TO_EDIT},"\n","");  #odd stuff with spurous newlines
}
#otherwise, just set the current page name:
else
{
    $fname              = urlDecode(getRequest("fname"));
}
 
#load the XML file to edit if a filename is passed:
if(length($FORM{"fname"}) > 0 || length($fname) > 0)
{
    #continue if passed file exists:
    if(fileExists($path . $fname) == 1)
    {
        #set flag to enable form:
        $FIELD_IS_ENABLED = "";
        
        #get the data for the submitted file:
        $src_xml = getFile($path . "/" . $fname);
        
        #we have $fname at this point, from either the initial url param, or from the POSTed value:
        #we can therefore set the friendlyname property:
        $ELEMENT_TO_EDIT_CAPTION    = getXMLTagParameter($ELEMENT_TO_EDIT,$src_xml,friendlyname);
        
        #set vars from XML. we want to get the content of the passed XML content tag:
        $linktext                   = getXMLData("linktext",    $src_xml);
        $pagetitle                  = getXMLData("pagetitle",   $src_xml);
        $description                = getXMLData("description", $src_xml);
        $keywords                   = getXMLData("keywords",    $src_xml);
        
        #if $formvalue has not been set - ie the form has not yet been submitted - set it from the XML:
        if(length($formvalue) eq 0)
        {
          $formvalue        = getXMLData($ELEMENT_TO_EDIT,        $src_xml);
        }

        $content            = getXMLData($ELEMENT_TO_EDIT,        $src_xml);

        #get the datatype of the passed content tag, and render an appropriate HTML form element.
        #this call is only made if the value has not been passed on form submission:
        if(length($datatype) eq 0)
        {
          $datatype = getXMLTagParameter($ELEMENT_TO_EDIT,$src_xml,"datatype");
        }
        ################################################################
        # GENERATE EDIT ELEMENTS BY CONTENT TYPE 
        # datatypes are "property", "text", "string", "image" or "core".
        ################################################################
        
        $CONTENT_ELEMENT    = "";
        if($datatype eq "text")
        {
          $CONTENT_ELEMENT  = "<textarea style=\"font-family:arial;font-size:9pt;\" name=\"$ELEMENT_TO_EDIT\" cols=\"108\" rows=\"12\">$formvalue</textarea>";
        }
        
        if($datatype eq "string")
        {
          $CONTENT_ELEMENT  = "<input type=\"text\" name=\"$ELEMENT_TO_EDIT\" value=\"$formvalue\">";
        }
        
        if($datatype eq "image")
        {
          $CONTENT_ELEMENT = "<select name=\"$ELEMENT_TO_EDIT\">";
          $IMAGE_ELEMENT_FILTER = getXMLTagParameter($ELEMENT_TO_EDIT,$src_xml,"imagepath");
          $CONTENT_ELEMENT .= getImagesAsDropdown($content, $IMAGE_ELEMENT_FILTER);
          print($IMAGE_ELEMENT_FILTER);
        }

        if($FORM{"update"} eq "go")
        {
            $linktext       = $FORM{"linktext"};
            $pagetitle      = $FORM{"pagetitle"};
            $description    = $FORM{"description"};
            $keywords       = $FORM{"keywords"};
            $content        = $FORM{$ELEMENT_TO_EDIT};
            $fname          = $FORM{"fname"};
            $src_xml        = getFile($path . "/" . $fname);
            $src_xml        = setXMLData("pagetitle",       $src_xml,   $pagetitle);
            $src_xml        = setXMLData("linktext",        $src_xml,   $linktext);
            $src_xml        = setXMLData("description",     $src_xml,   $description);
            $src_xml        = setXMLData("keywords",        $src_xml,   $keywords);
            $src_xml        = replace(setXMLData($ELEMENT_TO_EDIT,  $src_xml,   $content),"\n",""); #more funky stuf with newlines
            updateFile($fname,$src_xml);
        }
    }
    else
    {
        $result = "File does not exist. Cannot continue.";
    }
    #pass the name of the element - which is also the name of the form field:
    #note - we dont want to add an image to a string - such as a heading.
    if($datatype eq "text")
    {
      $imagelinks = getImagesForInsert($ELEMENT_TO_EDIT);
    }
}

print <<END_HTML;
<html>
<head>
<script language="JavaScript" src="/script/edit.js"></script>
<link rel="stylesheet" href="/styles/editstyle.css" type="text/css">
<title>EDITOR: edit existing page</title>

</head>
<body>
<form name="newpage" method="post" action="$ENV{"SCRIPT_NAME"}">
<input type="hidden" name="fname" value="$fname" $FIELD_IS_ENABLED>
<input type="hidden" name="update" value="go" $FIELD_IS_ENABLED>
<input type="hidden" name="contentid" value="$ELEMENT_TO_EDIT">
<input type="hidden" name="datatype" value="$datatype">

<table border="1" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" class="content" width="600" colspan="4">
            <b>Standard page properties:</b></td>
        </td>
    <tr>
        <td><span style="color:#d00;">Linktext:</span></td>
        <td><input style="font-family:arial;font-size:9pt;" type="text" name="linktext" value="$linktext" $FIELD_IS_ENABLED></td>
        <td><span style="color:#d00;">Title:</span></td>
        <td><input style="font-family:arial;font-size:9pt;" type="text" name="pagetitle" value="$pagetitle" $FIELD_IS_ENABLED></td>
    </tr>
    <tr>
        <td><span style="color:#d00;">Description:</span></td>
        <td><input style="font-family:arial;font-size:9pt;" type="text" name="description" value="$description" $FIELD_IS_ENABLED></td>
        <td><span style="color:#d00;">Keywords:</td>
        <td><input style="font-family:arial;font-size:9pt;" type="text" name="keywords" value="$keywords" $FIELD_IS_ENABLED></td>
    </tr>
    <tr>
        <td colspan="4">
            <span style="color:#d00;">$ELEMENT_TO_EDIT_CAPTION content:</span><br />
            $CONTENT_ELEMENT
            <!-- textarea style="font-family:arial;font-size:9pt;" name="$ELEMENT_TO_EDIT" cols="108" rows="12">$content</textarea -->
        </td>
    </tr>
    <tr>
        <td colspan="4">
            <input type="button" value="Update" onClick="submitAndRefresh()" $FIELD_IS_ENABLED>
            <input type="reset" value="Clear" $FIELD_IS_ENABLED>
        </td>
    </tr>
    <tr>      
        <td colspan="2" valign="top"> 
            $result
            <p>Add a new page <a href="/edit/editor_newfile2.pl">here</a>.</p>
            <p>or <a href="#" onClick="window.close();">Close</a> the window</p>
        </td>
        <td colspan="2" valign="top" class="content">
            <p><b>Add images:</b></p>
            <div style="border:1px solid black; padding : 4px; width : 400px; height : 200px; overflow : auto; ">
            <p>Choose from the available images here. Click on the '+' to add.</p>
            $imagelinks
            </div>
        </td>
    </tr>
</table>
</form>
</body>
<html>
END_HTML
