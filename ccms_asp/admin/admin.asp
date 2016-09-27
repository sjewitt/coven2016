<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
//evaluate user session:
var currentUser = userFactory.getCurrentUser();

if(currentUser && (currentUser.permissions == Permissions.ADMINISTRATOR)){
  var refresher = "";
%><!DOCTYPE html>
<html>
  <head>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <title>CCMS Administration</title>
  
  </head>
  <body>
    <div id="container">
      <div id="editor_content">
        <h1>CCMS Administration</h1>
        <p>Administration options for managing the system</p>
        <ul>
          <li><a href="#" onclick="popup('/ccms_asp/admin/manageusers.asp');" title="Manage Users">Manage Users</a>: Manage CCMS users and their permissions.</li>
          <li><a href="#" onclick="popup('/ccms_asp/admin/managecontenttypes.asp')" title="Manage Content Types">Manage Content Types</a>: Manage CCMS classification types for, e.g. news items.</li>
          <li><a href="#" onclick="popup('/ccms_asp/admin/managelayouts.asp')" title="Manage Content Types">Manage Templates</a>: Manage available layout templates.</li>
          <li>Manage Roles (TODO)</li>
        </ul>
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
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN");
}
%>
