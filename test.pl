#!/usr/bin/perl
$document_root = $ENV{'DOCUMENT_ROOT'};
require $document_root . "include/config/includes.pl";



logger("************************** beginning test...");
$a = getFile("template/index.tmpl");
print $a;
print "filetest";
