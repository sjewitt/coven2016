#!/usr/bin/perl
# you might need to modify the line above
#########################################
#   This script and others like it can be downloaded 			@              @   @@@
#             from:http://newdev.com   					  @           @  @         
#              copywrite the wickedone 					    @  @  @     @@@
#              email:wicked@newdev.com					      @@@                @
#	This Software Is Copywrited By Me Larry Lipke 			       @  @       @@@	
#               Alias "The wickedone" 						                    
#	USA						                   	
#	Domains newdev.com,4sure-access			                 	
#	Company Name New Development Associates
#	If you like this program please register it.
#	to get to my site
#	http://newdev.com
#	thank you for you interest in my scripts.
#########################################
# this is a new feature, when available 
# just uncomment then tell were your
# quicksetup.pl is and your done no editing the script
# you might have to comment the rest of the variables
# require "quicksetup.pl";
#############################################
# unix and nt usable
#  product = Guest Book
#  version = 1.32
#############################################
# Add your BODY tag information, like background graphic, color, etc.
$bodyspec = ' background=""  bgcolor="#8000ff" text="#ffffff" link="#ffffff" alink="#0000FF" vlink="#ffffff" ';


# path to your header and footer files
$pathto="/guest/data";

# Add your own graphics, text, links, etc., to the top of your pages.
$header = "header.txt";

# Add your own graphics, text, links, etc., to the bottom of your pages.
$footer = "footer.txt";

# Type the name of your organization, group, or company
$orgname = "Wickedone`s Scripts";

# your mail program 
$mail_prog = '/usr/sbin/sendmail' ;

# your email ---- leave the " \ "
$youremail="wicked\@newdev.com";

# your autorespond comments
$yourcomments="Thank You For Signing My Guest Book";

# the path to the guest file 
$pathtoguestdatabase="/guest/data/";

# the actual guest file you can name it any thing ou want
$guestfile="guest.txt";

#####
##################### | Thats It | ############
sub header {
open (FILE,"<$pathto/$header"); #### Full path name from root.
if ($LOCK_EX){ 
      flock(FILE, $LOCK_EX); #Locks the file
	} 
 @footerfile = <FILE>;
 close(FILE);
print '<HTML>'."\n";
print '<BODY '.$bodyspec.'>';
foreach $line(@footerfile) {
print "$line";
}
print "";
}

sub footer {
open (FILE,"<$pathto/$footer"); #### Full path name from root.
if ($LOCK_EX){ 
      flock(FILE, $LOCK_EX); #Locks the file
	} 
 @footerfile = <FILE>;
 close(FILE);
foreach $line(@footerfile) {
print "$line";

}
print "</BODY></HTML>";
}

sub error{
print "Content-type:text/html\n\n";
print <<'end_tag'; 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<TITLE>error</TITLE>
</HEAD>
<DIV align="center">
no link page has been created!
<br>
</BODY>
</HTML>
end_tag
exit;
}






