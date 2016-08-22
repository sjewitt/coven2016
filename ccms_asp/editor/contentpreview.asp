<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

if(currentUser){
  if(Request.QueryString("contentid") && parseInt(new String(Request.QueryString("contentid"))) > 0){
    var content = new Content(parseInt(new String(Request.QueryString("contentid"))));

    
  }

  
%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <title>Content preview</title>
  </head>
  <body>

    <div id="container">

    <%=content.getActiveInstance().content%>

        <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        </p>

    </div>
  </body>
</html>
<%
}
else{
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN.<br />PLEASE CLOSE THIS WINDOW AND LOG IN AGAIN.");
}
%>
