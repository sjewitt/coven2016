##############################################################
#### CUSTOMISATION -                                                
#### generate navs for The Coven. these return a javascript 
#### array for the primary nav generation 
#### 
#### (TODO: work out best way to incorporate these 
#### custom methods into the rendered output. probably
#### a replacement of a {CMS_CONTENT} tag with the method 
#### call return value.)
####                                                         
#### DEPENDANCIES:  none (may depend on the specific 
#### implementation).                                    
##############################################################
sub getCovenNavs
{
  my $result                    = "";
  my $secondarynav_JS           = "var nav=new Object();\n";
  my @curr_secondarynav_data;
  my $primarynav_JS             = "var primarynav = new Array();\nvar homenav = new Array();\n";
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
