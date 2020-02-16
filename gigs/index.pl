#!/usr/bin/perl
print "Content-type: text/html\r\n\r\n";
$document_root = $ENV{'DOCUMENT_ROOT'};
require $document_root . "include/config/includes.pl";
print core("/gigs/", "index");
