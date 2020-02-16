##############################################################
#### UTIL METHOD - 
#### Log stuff.
####
#### INPUT:         string message to log.
#### OUTPUT:        none
#### DEPENDANCIES:  getRoot,
#### (TODO: modify this to use a config file to determine 
#### logging level, logfile name etc)
##############################################################

sub logger
{
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $datestamp = sprintf("%02d-%02d-%04d %02d:%02d:%02D",$mday,$mon+1,$year+1900,$hour,$min,$sec);
    my $logstring = $_[0];
    my $root      = getRoot();
    my $file      = "logfile.log";
    if($_[1])
    {
        $file = $_[1];
    }
    
    open (LOGFILE, ">>" .$root . $file || die "Cannot open logfile...");
    print LOGFILE $datestamp . " - " . $logstring . "\n";
    close LOGFILE;
}

1;  #must always return 1.
