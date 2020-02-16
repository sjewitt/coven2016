##############################################################
#### INCLUDE -                                                
#### list of perl files that are to be required. One file
#### per function is the model. This file is then included
#### in the perl stub file.
#### 
#### DEPENDANCIES:  none.                                    
##############################################################

print "Content-type: text/html\r\n\r\n";
my $document_root = $ENV{'DOCUMENT_ROOT'};

require $document_root . "include/OLD_SUBS/subs.pl";
require $document_root . "include/OLD_SUBS/subs_file.pl";
require $document_root . "include/OLD_SUBS/subs_xml.pl";
require $document_root . "include/OLD_SUBS/subs_string.pl";
require $document_root . "include/OLD_SUBS/subs_render.pl";
require $document_root . "include/OLD_SUBS/subs_config.pl";

#auth
require $document_root . "include/editor/auth/authenticate.pl";
require $document_root . "include/editor/auth/getAuth.pl";

#logging
require $document_root . "include/util/logging/logger.pl";

1;
