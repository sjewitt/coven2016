##############################################################
#### CONFIGURATION -                                         #
#### core and site specific configuration parameters.        #
####                                                         #
#### DEPENDANCIES:  none.                                    #
##############################################################


##############################################################
#### Site base URL for redirects when not logged in:         #
####                                                         #
#### THIS MUST BE CHANGED TO                                 #
#### MATCH THE UPLOADED SITE                                 #
#### BASE URL!! (IS THIS NECESSARY IF DOCUMENT_ROOT IS SET?) #            
##############################################################
$SITE_BASE_URL = "http://laptop3/";


##############################################################
#### array of XML tags to render.                            #
#### These must match the XML data file:                     #
####                                                         #
#### The edit forms have the same core element names. The    #
#### render function loops over this when performing the     #
#### placeholder replacement.                                #
##############################################################
@TAGS_TO_RENDER =
(
  {placeholder=>'{CMS_PAGETITLE}',  tag=>'pagetitle',   createeditlink=>false},  	#COMMON TO ALL FILES
  {placeholder=>'{CMS_LINKTEXT}',   tag=>'linktext',    createeditlink=>false},  	#COMMON TO ALL FILES
  {placeholder=>'{CMS_KEYWORDS}',   tag=>'keywords',    createeditlink=>false},  	#COMMON TO ALL FILES
  {placeholder=>'{CMS_AUTHOR}',     tag=>'author',      createeditlink=>false},  	#COMMON TO ALL FILES
  {placeholder=>'{CMS_DESCRIPTION}',tag=>'description', createeditlink=>false},  	#COMMON TO ALL FILES
  {placeholder=>'{CMS_OWNER}',      tag=>'owner',       createeditlink=>false},     #COMMON TO ALL FILES
  {placeholder=>'{CMS_CONTENT1}',   tag=>'content1',    createeditlink=>true},
  {placeholder=>'{CMS_CONTENT2}',   tag=>'content2',    createeditlink=>true}, 
);


##############################################################
#### array of second level directories, for use in nav       #
#### generation. These must map to directories on the        #
#### webserver filesystem:                                   #
####                                                         #
#### This array is used to generate both the second level    #
#### nav and the create form path-selection radio buttons.   #
##############################################################
@SITE_SECTIONS = 
(
  {path=>'us',          linktext=>'The&nbsp;Coven'},
  {path=>'food',        linktext=>'My food'},
  {path=>'gigs',        linktext=>'Gigs'},
  {path=>'gizmo',       linktext=>'Gizmo'},
  {path=>'scot2004',    linktext=>'Scotland 2004'},
);

##############################################################
#### array of user hashes. Each hash contains username, user #
#### full name and password. The login page uses this array  #
#### to check that the login attempt is valid:               #
##############################################################
{
    $ADMIN              = 100;
    $CREATE_DIRECTORY   = 50;
    $CREATE_PAGE        = 40;
    $BROWSE             = 1;
    @USERS =
    (
      {user=>'clare', password=>'clareix',  fullname=>'Clare Midgley',  email=>'clare@thecoven.co.uk',  accesslevel=>60},
      {user=>'silas', password=>'h154lon',  fullname=>'Silas Jewitt',   email=>'silas@thecoven.co.uk',  accesslevel=>100}
    );
}

##############################################################
#### the default layout template. It may be over-ridden      #
#### by an entry in either the folder defaults or in the     #
#### individual page XML file.                               #
##############################################################
$DEFAULT_TEMPLATE = "template/layout.tmpl";

1;  #must always return 1.
