##############################################################
#### CUSTOMISATION -                                                
#### generate homepage navs for The Coven        
#### 
#### (TODO: work out best way to incorporate these 
#### custom methods into the rendered output. probably
#### a replacement of a {CMS_CONTENT} tag with the method 
#### call return value.)
####                                                         
#### DEPENDANCIES:  none (may depend on the specific 
#### implementation).                                    
##############################################################

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

1;  #must always return 1.

