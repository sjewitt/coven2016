<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
var currentUser = userFactory.getCurrentUser();
//only render edit form if user has admin rights:
if(currentUser.permissions & Permissions.ADMINISTRATOR){
  var contentTypes    = null;
  var currContentType = new Object();
  var contentTypeId   = 0;
  var name            = "";
  var description     = "";
  var action          = "add";
  var output          = new Object();
  output.text         = "Add a new Content Type";
  output.status       = 0;
  var delBtnDisabled  = 'disabled="disabled"';
  var res             = false;

  //collect submitted user data:
  if(parseInt(Request.QueryString("contenttypeid"))){
    contentTypeId = parseInt(Request.QueryString("contenttypeid"));
    currContentType = adminUtils.getContentType(contentTypeId);
    

    if(currContentType){   //
      output.text         = "Managing Content Type '" + currContentType.name + "'";
      
      if(Request.Form("action") == "update"){
        currContentType.name = Request.Form("name");
        currContentType.description = Request.Form("description");
        adminUtils.updateContentType(currContentType);  
      }
  
      if(Request.Form("action") == "deletect"){
        adminUtils.deleteContentType(currContentType);
        currContentType.name = "";
        currContentType.description = "";  
      }
      
      action          = "update";
      delBtnDisabled  = "";
    }
  }
  //TODO: add the reload
  if(Request.Form("action") == "add"){
    currContentType.id = 0;
    currContentType.name = Request.Form("name");
    currContentType.description = Request.Form("description");
    if(currContentType.name == null || currContentType.name == "" || currContentType.name.length == 0){
      output.text         = "Content Type name cannot be empty.";
      output.status       = 1;
    }
    else{
      adminUtils.addContentType(currContentType);
    }
  }
  
  //finally, retrieve the data:
  contentTypes    = adminUtils.getCurrentContentTypes();
  name            = currContentType.name;
  description     = currContentType.description;
  //showObject(currContentType);
  
%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <title>Manage Content Types</title>
  
  </head>
  <body>
    <div id="container">
      <div id="editor_content">
        <h1>CCMS Administration: Manage Content Types</h1>      
        <p>
        Add, delete or modify the available content types. CARE when removing, as there may be functionality that is
        dependant on particular content types (for example, news lists).
        </p>
        <p>
          <strong>Current action:</strong> <%=output.text%>:
        </p>

        <form name="contenttypelist" action="" method="get">
          <select name="contenttypeid" onchange="document.contenttypelist.submit();">
            <%=adminUtils.getCurrentContentTypesDropdown(contentTypes)%>
          </select>
        </form>
        
        <h2 id="actiontitle">Add/Modify</h2>

      <form name="contenttype" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?contenttypeid=<%=contentTypeId%>" method="post">
        <table>
          <tr>
            <td style="vertical-align:top;">

            </td>
            <td style="vertical-align:top;">
                <div style="float:left;width:120px;">Name</div>         <input type="text" name="name" value="<%=name%>" /><br />
                <div style="float:left;width:120px;">Description</div>  <input type="text" name="description" value="<%=description%>" /><br />

                <input type="hidden"    name="action"       value="<%=action%>" />
                <input type="button" value="<%=action%>" onclick="doCTAction('<%=action%>');" />
                <input type="button" value="delete" onclick="deleteCT();" <%=delBtnDisabled%> >
            </td>
          </tr>
        </table>
      </form>
      
      <p>
        [<a href="#" onclick="popup('admin.asp',<%=SIZE_ADMIN_HOME%>)">Admin functions</a>]&nbsp;[<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
      </div>
    </div>
    
    <form name="delete" method="post">
      <input type="hidden" name="action" value="delete" />
          <input type="hidden" name="contenttypeid" value="<%=contentTypeId%>" />
    </form>
  </body>
</html>
<%
}
//otherwise, error:
else{
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN");
}
%>
