<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
var currentUser = userFactory.getCurrentUser();
//only render edit form if user has rights:
if(currentUser.permissions & Permissions.ADMINISTRATOR){
  var output = "";
  var msg;
  //Handle submission of action:
  if((Request.QueryString("layout") && parseInt(Request.QueryString("layout"))>0))
  {
    try
    {
      var action = parseInt(Request.QueryString("doaction"));  
      //load the layout:
      var currLayout = new Layout(parseInt(Request.QueryString("layout")));
      //showObject(currLayout)
      currLayout.parse();
      
      var layoutManager = new LayoutManager();
      //what action is passed?
      switch(action)
      {
        case 1:
          msg = "Edit source";
          
          /*
          Handle source save:
          */
          if(new String(Request.Form("update")) == "true")
          {
            Response.Write("UPDATE = TRUE");
            //write the file back to FS:
            var fs = Server.CreateObject("Scripting.FileSystemObject");
            if(fs)
            {
              //Response.Write(fs);
              var absolutePath = Server.MapPath("/ccms_asp/templates/" + currLayout.fileName);
              Response.Write(absolutePath);
              Response.Write(Request.Form("layoutsrc"));
              var fContents = "";
              //var objF;
              var ts;
              //open text stream:
              //ts = fs.OpenTextFile(absolutePath,8,true);
              ts = fs.CreateTextFile(absolutePath,true);

              var res = ts.write(new String(Request.Form("layoutsrc")));
              Response.Write(res); 
 
              //ensure textstream is closed:
              ts.close();
              f = null;
              fs = null;
              
              //and redirect:
              Response.Redirect( Request.ServerVariables("SCRIPT_NAME") + "?layout=" + Request.QueryString('layout') + "&doaction=" + Request.QueryString('doaction'));
            }
            else
            {
              throw new Error("cannot open template file for writing.");
            }
          }
          
          output = "<h2>Edit template source</h2>";
          output += "<form name='updatetemplate' action='" + Request.ServerVariables("SCRIPT_NAME") + "?layout=" + Request.QueryString('layout') + "&amp;doaction=" + Request.QueryString('doaction') + "' method='post'>";
          output += "<input type='hidden' name='update' value='true' />";
          output += "<div><textarea rows='30' cols='80' name='layoutsrc'>" + currLayout.source + "</textarea></div>";
          output += "<input type='submit' name='submit' value='Update' /></form>"; 
        break;
        case 2:
          msg = "Set availability";

          if(new String(Request.QueryString("update")) == "true")
          {
            //determine the passed flag:
            var isVisible = false;
            if(new String(Request.QueryString("active")) == "true")
            {
              isVisible = true;
            }
            var res = layoutManager.setAvailability(currLayout,isVisible);
            Response.Write("res: " + res);
            if(res)
            {
              output = "<p>Availability of template '" + currLayout.fileName + "'' set to '" + currLayout.active + "'</p>";
            }
            else
            {
              output = "ERROR";
            }
          }
          else
          {
            var chk = "";
            if(currLayout.active)
            {
              chk = "checked='checked'";
            }
            output = "<script type='text/javascript'>\n";
            output += "function setActive(){\n";
            output += "if(confirm('Change visibility status of template " + currLayout.fileName + "')){\n";
            output += "document.setactive.submit();\n";
            output += "}\n";
            output += "}\n";
            output += "</script>\n";
            output += "<p>Choose whether template '" + currLayout.fileName + "' is available for editors:</p>";
            output += "<form name='setactive' action='" + Request.ServerVariables("SCRIPT_NAME") + "'>";
            output += "<input type='checkbox' name='active' value='true' " + chk + "/> Available<br />";
            output += "<input type='hidden' name='layout' value='" + currLayout.id + "' />";
            output += "<input type='hidden' name='doaction' value='" + Request.QueryString("doaction") + "' />";
            output += "<input type='hidden' name='update' value='true' />";
            output += "<input type='button' name='go' value='update' onclick='setActive();return false;'>"
            output += "</form>";            
          }
        break;
        case 3:
          msg = "Delete template";
        break;
        case 4:
          msg = "Add new template";
        break;
      } 
    }
    catch(e)
    {
      
    }
  }
  else
  {
    //get current layouts:
    var lm = new LayoutManager();
    var layouts = lm.getAllLayouts(true);
  }


%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  <link rel="stylesheet" href="/ccms_asp/editor/styles/editstyles.css" type="text/css" />
  <title>Manage Layouts</title>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>

<%
if(action == 1)
{
%>
<script type="text/javascript">

</script> 
<%
}
%>  
  </head>
  <body>
    <div id="container">
      <div id="editor_content">
        <h1>CCMS Administration: Manage Layouts</h1>      
         <%=output%>
<%
if(Request.QueryString("layout") && parseInt(Request.QueryString("layout"))>0)
{
%>
        <p>
        [<a href="<%=Request.ServerVariables('SCRIPT_NAME')%>">Show all layouts</a>]
        </p>
<%
}
else
{
%>
<p>
Select a template and choose an action:
</p>
<form name="layoutaction">
<select name="layout">
<%
  var inactive = "";
  for(var a=0;a<layouts.length;a++)
  {
    inactive = "";
    if(!layouts[a].active) inactive = " [HIDDEN]"
%>
<option value="<%=layouts[a].id%>"><%=layouts[a].fileName%><%=inactive%></option>
<%
  }
%>
</select>
[<a href="#" onclick="editScripts.layoutAction(1);return false;">edit source</a>] 
[<a href="#" onclick="editScripts.layoutAction(2);return false;">set availability</a>] 
[<a href="#" onclick="editScripts.layoutAction(3);return false;">delete</a>]
<p>
Or, enter the name to create a new, empty template:
</p>
<p>
<input type="text" name="newname"> <input type="button" value="Add Template" onclick="layoutAction(4);return false;">
</p>
<input type="hidden" name="doaction" value="">
</form>
<%  
}
%>

      <p>
        [<a href="#" onclick="popup('admin.asp',<%=SIZE_ADMIN_HOME%>)">Admin functions</a>]&nbsp;[<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
      </div>
    </div>
  </body>
</html>
<%
}
//otherwise, error:
else{
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN");
}

%>
