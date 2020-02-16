#!/usr/bin/perl
print "Content-type: text/html\n\n";
$document_root = $ENV{'DOCUMENT_ROOT'};

require "setup.pl";

#get the 
&GetFormInput;
#($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
#print scalar localtime();

$name = $field{'name'} ;	 
$comments = $field{'comments'} ;	

$message = "" ;
$found_err = "" ;

$errmsg = "<p>name must be filled in.</p>\n" ;

if ($name eq "")    {$message=$message.$errmsg;	    $found_err = 1;}
if ($found_err)     {&PrintError;}

#open current file:
open oldguest,"<$document_root$pathtoguestdatabase/$guestfile" or "&error";
$currentdata = "";
while (<oldguest>) {
#chomp;
#print "$_\n";

$currentdata.=$_;

}
close (oldguest);

print ($currentdata);

$newdata = scalar localtime()."@";
$newdata .= $name . "@";
$newdata .= $comments;
$newdata .= "\n";
open guest,">$document_root$pathtoguestdatabase$guestfile" or "&error"; #use '>' to over-write, '>>' to append

#add new data:
print guest $newdata;

##add exisiting data:
print guest $currentdata;

#print guest scalar localtime()."@";
#print guest $name,"@";
#print guest $comments, "@";
#print guest "\n";
close guest;

#################################

#

print '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">'."\n" ;
&header;
print "<html>\n" ;
print "\n" ;
print "<head>\n" ;
print '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'."\n" ;
print '<meta name="Author" content>'."\n" ;
print '<meta name="GENERATOR" content="Microsoft FrontPage 3.0">'."\n" ;
print "<title>Thank you</title>\n" ;
print "</head>\n" ;
print "\n" ;
print "<BODY $bodyspec>\n";
print "\n" ;
print '<p align="center"><font color="#FFFFFF" face="Arial"><big><strong>Thank You, '.$name.'!</strong></big></font></p>'."\n" ;
print "\n" ;
print '<p align="center">&nbsp;</p>'."\n" ;
print "\n" ;
print "<hr>\n" ;
print "\n" ;
print '<p align="center"><font face="Arial"><big>You entered the following:</big></font></p>'."\n" ;
print "\n" ;
print '<p align="center"><font face="Arial"><big>Name: '.$name.'</big></font></p>'."\n" ;
print '<p align="center"><font face="Arial"><big>Comments: '.$comments.' </big></font></p>'."\n" ;
print '<center><A HREF="guest_read.pl">Read The Guest Book</A></center>'."\n" ;
print "</body>\n" ;
print "</html>\n" ;
&footer;

sub PrintError { 
print "Content-type: text/html\n\n";
print '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">'."\n" ;
&header;
print "<html>\n" ;
print "\n" ;
print "<head>\n" ;
print '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'."\n" ;
print '<meta name="Author" content>'."\n" ;
print '<meta name="GENERATOR" content="Microsoft FrontPage 3.0">'."\n" ;
print "<title>Error</title>\n" ;
print "</head>\n" ;
print "\n" ;
print "<BODY $bodyspec>\n";
print "\n" ;
print '<p align="center"><font color="#000080" face="Arial"><big><strong>Processing Error</strong></big></font></p>'."\n" ;
print "\n" ;
print '<p align="center"><font face="Arial" color="#000080"><strong>You forgot to enter one or more'."\n" ;
print "values:</strong></font></p>\n" ;
print "\n" ;
print '<center><font color="#000080" face="Arial"><strong>'.$message.'</strong></font></center>'."\n" ;
print "\n" ;
print '<p align="center"><font face="Arial" color="#000080"><strong>Please click your browser\'s'."\n" ;
print "Back button and try again.</strong></font></p>\n" ;
print "</body>\n" ;
print "</html>\n" ;
&footer;
exit 0 ;
return 1 ; 
}

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
			}
		   }
		}
return 1;
}


