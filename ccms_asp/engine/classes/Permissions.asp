<%
/*
Permission constants
*/
var Permissions = new Object();

Permissions.ADMINISTRATOR = 1;    //all rights
Permissions.CHANGESTATE   = 2;    //set content to active right
Permissions.CREATEPAGE    = 4;    //
Permissions.CREATECONTENT = 8;    //
Permissions.EDITPAGE      = 16;   //add/remove from slots, page core props
Permissions.EDITCONTENT   = 32;   //
Permissions.DELETEPAGE    = 64;   //
Permissions.DELETECONTENT = 128;  //
Permissions.BROWSEONLY 	  = 256;  //no edit rights, just logged in
Permissions.EDITVIEWTREE  = 512;  //edit node position in viewtree
Permissions.UPLOADBINARY  = 1024; //upload images/documents
Permissions.MANAGELAYOUT  = 2048; //modify layout assignment
%>
