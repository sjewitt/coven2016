<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

//only render edit form if user has rights:
if(currentUser){
  var currpage = new Page(Request.QueryString("pageid"));
  
  //handle requests from a NODEID:
  if(parseInt(Request.QueryString("nodeid"))){
    currpage = new Page((new Node(parseInt(Request.QueryString("nodeid")))).pageId);
  }
  
  //update the properties:
  if(Request.Form("action") == "updatepage"){
    currpage              = new Page(Request.Form("pageid"));
    currpage.name         = Request.Form("name");
    currpage.linkText     = Request.Form("linktext");
    currpage.description  = Request.Form("description");
    currpage.keywords     = Request.Form("keywords");
    currpage.title        = Request.Form("title");
    currpage.update();
    Response.Redirect(Request.ServerVariables("HTTP_REFERER") + "&reload=true");
  }
  var refresher = "";
  if(new String(Request.QueryString("reload")) == "true"){
    refresher = editUtils.getOpenerReloadJavascript();
  }
%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <title>Edit Page Properties</title>
</head>
<body>
<%=refresher%>
  <div id="container">
    <div id="editor_content">
  <h1>Edit page properties</h1>
    
  <p>
  Currently managing page '<strong><%=currpage.name%></strong>':
  </p>
  <form name="page" action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method="post">
  <input type="hidden" name="pageid" value="<%=currpage.id%>" />
  <input type="hidden" name="action" value="updatepage" />
  <table>
    <tr>
      <td>Name</td>
      <td><input type="text" name="name" value="<%=currpage.name%>" /></td>
    </tr>
    <tr>
      <td>Page Title</td>
      <td><input type="text" name="title" value="<%=currpage.title%>" /></td>
    </tr>
    <tr>
      <td>Link text</td>
      <td><input type="text" name="linktext" value="<%=currpage.linkText%>" /></td>
    </tr>
    <tr>
      <td>Description</td>
      <td><input type="text" name="description" value="<%=currpage.description%>" /></td>
    </tr>
    <tr>
      <td>Keywords</td>
      <td><input type="text" name="keywords" value="<%=currpage.keywords%>" /></td>
    </tr>
    <tr>
      <td></td>
      <td><input type="submit" value="Update" /></td>
    </tr>
  </table>
  </form>
        <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        [<a href="#" onclick="javascript:document.location='/ccms_asp/editor/managepages.asp';">manage pages</a>]
        [<a href="#" onclick="javascript:history.go(-1);return false;">back</a>]
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
