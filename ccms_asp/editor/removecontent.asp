<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
//evaluate user session:
var currentUser = userFactory.getCurrentUser();
/*
TODO: Modify to display title based on doaction:
*/
//only render edit form if user has rights:
if(currentUser){

  var msg = "";
  var refresher = "";
  
  //process the request:
  if(Request.QueryString("action") == "remove"){
    //Response.Write(Request.QueryString("pageid")+" - "+Request.QueryString("slotid")+" - "+Request.QueryString("contentid"))
    var ok = editUtils.removeContentMapping(Request.QueryString("pageid"),Request.QueryString("slotid"),Request.QueryString("contentid"));
    msg = "Mapping removal failed!"
    if(ok){ 
      msg = "Mapping removed successfully.";
      refresher = editUtils.getOpenerReloadJavascript();
    }
  }

%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <title>Remove content</title>
  </head>
  <body>
    <%=refresher%>
    <div id="container">
      <div id="editor_content">
       <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/contentremove100x130.jpg" alt="Create page" />
          <h1>Remove content</h1>
          Remove the current content from the current slot. The content item is not deleted, the association between it and this content slot
          is removed. The content is still available for use.
        </div>
      <p><%=msg%></p>
        <form name="replacecontent" method="get" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
          <input type="hidden" name="slotid" value="<%=Request.QueryString("slotid")%>" />
          <input type="hidden" name="pageid" value="<%=Request.QueryString("pageid")%>" />
          <input type="hidden" name="action" value="<%=Request.QueryString("doaction")%>" />
          <p><input type="submit" name="submit" value="Remove" />&nbsp;<input type="button" name="cancel" value="Cancel" onclick="javascript:window.close();" /></p>
        </form>
        
        <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
        
      </div>
      </div>
  </body>
</html>
<%
}
//otherwise, error:
else{
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN.<br />PLEASE CLOSE THIS WINDOW AND LOG IN AGAIN.");
}
%>
