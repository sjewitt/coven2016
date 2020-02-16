#!/usr/bin/perl
print "Content-type: text/html\r\n\r\n";
$document_root = $ENV{'DOCUMENT_ROOT'};
require $document_root . "include/config/includes.pl";

$image = getRequest("image");
$field = getRequest("field");

print <<END_HTML;
<html>
<head>
<link rel="stylesheet" href="/styles/style.css" type="text/css">
<title>Image preview</title>
<script language="JavaScript" src="/script/edit.js"></script>
</head>
<body>
<img src="$image">
<br>

<a href="#" onClick="insertAtCursor(opener.document.newpage.$field,'$image',true)">Add this image</a><br />
<a href="#" onClick="window.close();">Done</p>
</body>
</html>
END_HTML
