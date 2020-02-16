#!/usr/bin/perl
$document_root = $ENV{'DOCUMENT_ROOT'};
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
require "setup.pl";
&GetFormInput;


open guest,"<$document_root$pathtoguestdatabase/$guestfile" or "&error";
print "Content-type: text/html\n\n";
&header;
print '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">'."\n" ;

print "<html>\n" ;
print "\n" ;
print "<head>\n" ;
print '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'."\n" ;
print '<meta name="Author" content>'."\n" ;
print '<meta name="GENERATOR" content="Microsoft FrontPage 3.0">'."\n" ;
print "<title>Guest Book</title>\n" ;
print "</head>\n" ;
print "\n" ;
print "<BODY $bodyspec>\n";
print "\n" ;
print '<p align="center"><big><font color="#FFFFFF" face="Arial"><strong>' .$orgname.' Guest Book <font face="Arial" color="#ff0000"></big></font></strong></font></big></p><hr>'."\n" ;
print "\n" ;
print '<TABLE width=100% cellpadding=10 BORDER=0>'."\n" ;
print "	<TR>\n" ;
print "<TD>\n" ;
#print "\n" ;

#print "<hr>";
while (<guest>){
#($name,$email,$sitename,$siteurl,$subject,$comments,$datestamp)= split /:/;  
($date,$name,$comments)= split /\@/;  
print ' <center> '
.$date.'<br />'
.$name.'<br /> '
.$comments.'<hr />
';
}
#print "<hr>\n";
print "\n" ;
print "		</TD>\n" ;
print "	</TR>\n" ;
print "</TABLE>\n" ;
print "<hr>";
print "\n" ;
print "</body>\n" ;
print "</html>\n" ;
&footer;

sub GetFormInput {

	(*fval) = @_ if @_ ;

	local ($buf);
	if ($ENV{'REQUEST_METHOD'} eq 'POST') {
		read(STDIN,$buf,$ENV{'CONTENT_LENGTH'});
	}
	else {
		$buf=$ENV{'QUERY_STRING'};
	}
	if ($buf eq "") {
			return 0 ;
		}
	else {
 		@fval=split(/&/,$buf);
		foreach $i (0 .. $#fval){
			($name,$val)=split (/=/,$fval[$i],2);
			$val=~tr/+/ /;
			$val=~ s/%(..)/pack("c",hex($1))/ge;
			$name=~tr/+/ /;
			$name=~ s/%(..)/pack("c",hex($1))/ge;

			if (!defined($field{$name})) {
				$field{$name}=$val;
			}
			else {
				$field{$name} .= ",$val";
				
				#if you want multi-selects to goto into an array change to:
				#$field{$name} .= "\0$val";
			}


		   }
		}
return 1;
}

