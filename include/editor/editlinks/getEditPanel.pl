##############################################################
#### EDITOR METHOD - 
#### generate edit links panel on page being edited.
####
#### INPUT:         string current page, string default page
#### OUTPUT:        string HTML edit links panel.
#### DEPENDANCIES:  getPureFileName
##############################################################
sub getEditPanel
{
    my $page           = $_[0];
    my $defaultpage    = $_[1];
    my $output =     "<div class=\"editpanel\">";
    $output .=    "<span class=\"editlink\">";
    $output .=    "<a href=\"#\" onclick=\"editPage('/edit/editor_newfile2.pl')\">";
    $output .=    "<strong>Create</strong></a> new page.</span>";
    
    #we don't want to delete the default page, otherwise going to directory will throw a 404 error.
    if(getPureFileName($page) ne $defaultpage)
    {
        $output .=    "<span class=\"editlink\">";
        $output .=    "<a onclick=\"javascript:return(confirm('Really delete this page?'));\" href=\"/edit/editor_deletefile.pl?page=" . substr($page,0,index($page,".")) . "\">";
        $output .=    "<strong>Delete</strong></a> this page.</span>";
    }
    $output .=    "<span class=\"editlink\">";
    $output .=    "<strong>[<a href=\"/logout.pl?return=" . $page . "\">Logout</a>]</strong>";
    $output .=    "</span></div>";
    return $output;
}

1;  #must return 1            
            
