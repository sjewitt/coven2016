<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
var currentUser = userFactory.getCurrentUser();
//only render edit form if user has rights:
if(currentUser.permissions & Permissions.ADMINISTRATOR){

  var usr = false;
  var fullname  = "";
  var login     = "";
  var password  = "";
  var email     = "";
  var perms     = 0;
  var userid    = 0;
  var isActive  = false;
  var isActiveChk = "";    
  var action    = "add";
  var output    = "";
  var res       = false;
  
  //collect submitted user data:
  if(parseInt(Request.QueryString("userid"))){
    usr = new User(parseInt(Request.QueryString("userid")));
    if(usr.exists){
      action = "update";
      fullname = usr.fullName;
      login = usr.login;
      password = usr.password
      email = usr.email;
      perms = usr.permissions;
      userid = usr.id;
      if(usr.active) isActiveChk = "checked=\"checked\"" 
      //showObject(usr);
      
    }
  }
  //TODO: add the reload
  if(Request.Form("action") == "add"){
    if(Request.Form("enabled") == "true") isActive = true;
    res = adminUtils.addUser(Request.Form("login")+"",Request.Form("password")+"",Request.Form("fullname")+"",Request.Form("email")+"",Request.Form("permissions"),isActive);
    if(res){
      output = " User '" + Request.Form("login") + "' added successfully.";
    }
    else{
      output = "<span style=\"color:red;\">Some user data was missing! Please add all fields.</span>";
    }
  }
  /*
  Handle an UPDATE request:
  */
  if(Request.Form("action") == "update"){
    var updateuser = adminUtils.buildUser(Request.Form);
    updateuser.id = usr.id;
    res = adminUtils.updateUser(updateuser);
    if(res){
      Response.Redirect(Request.ServerVariables("SCRIPT_NAME")+"?userid="+userid);
    }
    else{
      output += "<span style=\"color:red;\">User not updated! Check all fields are filled.</span>";
    }
  }
  
%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  <link rel="stylesheet" href="/ccms_asp/editor/styles/editstyles.css" type="text/css" />
  <title>Manage Users</title>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  </head>
  <body>
    <div id="container">
      <div id="editor_content">
        <h1>CCMS Administration: Manage Users</h1>      
        <p>
          Message: <%=output%>
        </p>
        <p>
        Select a user to modify from the dropdown, or create a new user by filling in new details:
        </p>
        <form name="userlist" action="" method="get">
          <select name="userid" onchange="document.userlist.submit();">
            <%=adminUtils.getCurrentUsersDropdown()%>
          </select>
        </form>
        <h2>User details</h2>
          <p>
<% if(usr && usr.exists){ %>
              Currently managing '<%=usr.fullName%>':
<% }
else{
 %>
              Add a new user:
<% } %>
      </p>
      <form name="user" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?userid=<%=userid%>" method="post">
        <table>
          <tr>
            <td style="vertical-align:top;">
                <%=adminUtils.getPermsCheckboxes()%>
            </td>
            <td style="vertical-align:top;">
                <div style="float:left;width:120px;">Login name</div><input type="text"    name="login"        value="<%=login%>" /><br />
                <div style="float:left;width:120px;">password</div><input type="text"    name="password"     value="<%=password%>" /><br /><!-- TODO: Sort out password here! -->
                <div style="float:left;width:120px;">Full Name</div><input type="text"    name="fullname"     value="<%=fullname%>" /><br />
                <div style="float:left;width:120px;">Email</div><input type="text"    name="email"        value="<%=email%>" /><br />
                <div style="float:left;width:120px;">Enabled</div><input type="checkbox" name="enabled" value="true" <%=isActiveChk%>><br />
                <input type="hidden"  name="permissions"  value="<%=perms%>" />
                <input type="hidden"  name="action"       value="<%=action%>" />
                <input type="button"       value="<%=action%> user" onclick="doUserAction('<%=action%>')" />
            </td>
          </tr>
        </table>
      </form>
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

/*
function isSet(usr,perm){
  var out = '';
  if(usr){
    if(usr.permissions & perm){
       out = ' checked="checked"';
    }
  }
    return(out);
}

function getPermsCheckboxes(){
  var out = "";
  for(p in Permissions){
    out += '<input type="checkbox" name="permission" value="' + Permissions[p] + '"' + isSet(usr,Permissions[p]) + ' onclick="setPerms();" />' + p + '<br />\n';
  }
  return out;
}

function getCurrentUsersDropdown(){
  
  var userlist = adminUtils.getAllUsers();
  var out = '<option value="">[  Add new user  ]</option>\n';
  var selected = '';
  for(var a=0;a<userlist.length;a++){
    selected = '';
    if(userlist[a].id == parseInt(Request.QueryString("userid"))) selected = ' selected="selected"';
    out += '<option value="' + userlist[a].id + '"' + selected + '>'+userlist[a].fullName+'</option>\n';
  }
  
  return out;
}
*/
%>
