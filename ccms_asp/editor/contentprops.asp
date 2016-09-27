<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
/*
TODO: PERMISSIONS!
A user can only create content if:
 - they are logged in (doh!)
 - they have Permissions.CREATECONTENT (only in ATWORK state)
 - they have Permissions.CHANGESTATE (can optionally set to ACTIVE)
*/

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

if(currentUser){
  if(Request.QueryString("contentid") && parseInt(new String(Request.QueryString("contentid"))) > 0){
    var msg         = "Content properties.";
    var refresher   = "";
    var editme      = "";
    
    /*
    Retrieve the core props of the passed content ID:
    */
    var query = new Query();
    var sql = "select name,created_user,created_date,updated_user,auth_group,content_type from content where id=" + new String(Request.QueryString("contentid"));
    query.setQuery(sql);
    query.execute();
    showObject(query.resultObject);
    
  }
  /*
  if(new String(Request.Form("execute")) == "ok"){

    }
    refresher = editUtils.getOpenerReloadJavascript();
  }
  */
  //vars to pre-populate the page and slot hidden fields:
  var pageId = "";
  var slotId = "";
  
  var contentTypeOptions = editUtils.getContentTypeOptions(); //retrieve the <option> list
  
%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <title>Create new content</title>
  </head>
  <body>
 <%=refresher%>
 <div id="container">
  <div id="editor_content">
  
         <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/content100x130.jpg" alt="Content properties" />
  
    <h1>Content properties</h1>
    <p>
    properties
    </p>
    </div>
    <p><%=msg%></p>
    <form name="contentprops" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
      <input type="hidden" name="execute" value="ok" />
      <div style="float:left;width:120px;">Name:</div><input type="text" name="name" value="" /><br />
      <div style="float:left;width:120px;">Subtype:</div><select name="type">
        
        <%=contentTypeOptions%>
              
      </select>
      <br />
      <div style="float:left;width:120px;">&nbsp;</div>      <input type="submit" value="create" />
    </form>
    <p>&nbsp;
      <%=editme%>
    </p>
        <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
    </div>
    </div>
  </body>
</html>
<%
}
else{
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN.<br />PLEASE CLOSE THIS WINDOW AND LOG IN AGAIN.");
}
%>
