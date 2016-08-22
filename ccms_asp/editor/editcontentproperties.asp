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
  var msg         = "";
  var refresher   = "";
  var editme      = "";
  var addToPage = false;
  
  //vars to pre-populate the page and slot hidden fields:
  var contentId     = parseInt(Request.QueryString("contentid"));
  
  if(new String(Request.Form("execute")) == "ok"){
    msg = "Updating content properties."
    try{
      //TODO: ABSTRACT TO editUtils!
      //THIS SHOULD BE SQL TRANSACTIONS AS WELL AS THERE ARE SEVERAL THINGS GOING ON...
      //I need to ensure that each sql statement correctly executes BEFORE the next occurs - mainly for the ID
      
      var dateFrom = null;
      var dateTo = null;
      if(Request.Form('validfrom')!= null && (new String(Request.Form('validfrom'))) != "")
      {
        dateFrom = new String(Request.Form('validfrom'));
      }
      if(Request.Form('validto')!= null && (new String(Request.Form('validto'))) != "")
      {
        dateTo = new String(Request.Form('validto'));
      }
      
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
    
      //TODO: REMOVE!! the updated_user field from content - it is tracked in content_instance
      //var sql = "update content set name='" + Request.Form('name') + "', description='" + Request.Form('description') + "',updated_user=" + currentUser.id + ",updated_date=GETDATE(),auth_group=1,content_type="+Request.Form("type") + " where id=" + contentId;
      var sql = "update content set name=?, description=?,updated_user=?,updated_date=GETDATE(),auth_group=1,content_type=?,start_date=?,end_date=? where id=?";

      var cmd           = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                   //adCmdText - sql query
      cmd.Name              = "content_update";    //note naming convention...
      cmd.CommandText       = sql;                 //Parameterised SQL
      cmd.ActiveConnection  = connection;          //set the active connection
      cmd.Prepared          = true;                //set the statement to prepared.
      //see http://www.w3schools.com/ado/met_comm_createparameter.asp#datatypeenum
      cmd.Parameters.Append(cmd.CreateParameter("contentName",  8,1,0,Request.Form('name')));  //name
      cmd.Parameters.Append(cmd.CreateParameter("contentDescr", 8,1,0,Request.Form('description')));  //description
      cmd.Parameters.Append(cmd.CreateParameter("userid",       3,1,0,currentUser.id));  //updated user id
      //cmd.Parameters.Append(cmd.CreateParameter("userid",       3,1,0,currentUser.id));  //user id
      cmd.Parameters.Append(cmd.CreateParameter("type",         3,1,0,Request.Form("type")));  //type
      cmd.Parameters.Append(cmd.CreateParameter("dateFrom",     135,1,0,dateFrom));  //date_from - may be null
      cmd.Parameters.Append(cmd.CreateParameter("dateTo",       135,1,0,dateTo));  //date_to - may be null
      cmd.Parameters.Append(cmd.CreateParameter("contentId",    3,1,0,contentId));  //user id
      cmd.execute();


      //connection.execute(sql);
      connection.close();
      connection = null;
    }
    catch(e){
      Response.Write("error updating properties: " + e.message +" (" + sql + ")");
    }
    
    refresher = editUtils.getOpenerReloadJavascript();
  }
  
  var item = new Content(contentId);
  var contentName = item.name;
  var contentDescription = item.description;
  var instance = item.getActiveInstance();
  var createdUser = new User(item.createdUser);
  var createdDate = dateUtils.getShortDateTime(item.createdDate);
  var validFrom = dateUtils.getPropUIDateTime(item.validFrom);
  var validTo = dateUtils.getPropUIDateTime(item.validTo);
 
  var contentTypeOptions = editUtils.getContentTypeOptions(item.contentType); //retrieve the <option> list
  
%><!DOCTYPE html>
<html>
  <head>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>

  <link rel='stylesheet' type='text/css' href='/ccms_asp/editor/datepicker/calendar.css' />
  <script type='text/javascript' src='/ccms_asp/editor/datepicker/calendar.js'></script>

  <script type="text/javascript">
  window.onload = function()
  {
    //date picker
	   calendar.set("validfrom");
	   calendar.set("validto");
  }
  </script>  
  <title>Update content properties</title>
  </head>
  <body>
 <%=refresher%>
 <div id="container">
  <div id="editor_content">
    <div style="height:130px;">
      <h1>Update content properties</h1>
      <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/contentprops100x130.jpg" alt="Update content properties" />
      
      <p>
        Options for updating content name and content type.
      </p>
      <p><%=msg%></p>
    </div>
    <form name="updatecontentproperties" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?contentid=<%=contentId%>">
      <input type="hidden" name="contentid" value="<%=contentId%>" />
      <input type="hidden" name="execute" value="ok" />
      <table>
        <tr>
          <td>Created Date:</td>
          <td><%=createdDate%></td>
        </tr>
        <tr>
          <td>Created By:</td>
          <td><%=createdUser.fullName%></td>
        </tr>
        <tr>
          <td>Name:</td>
          <td><input type="text" name="name" value="<%=contentName%>" style="width:320px;"/></td>
        </tr>
        <tr>
          <td>Description:</td>
          <td><input type="text" name="description" value="<%=contentDescription%>" style="width:320px;" /></td>
        </tr>
        <tr>
          <td>Subtype:</td>
          <td>
            <select name="type">

              <%=contentTypeOptions%>
              
            </select>
          </td>
        </tr>
        <tr>
          <td>Valid from:</td>
          <td>
          <input type="text" name="validfrom" id="validfrom" value="<%=validFrom%>" /></td>
        </tr>
        <tr>
          <td>Valid to:</td>
          <td><input type="text" name="validto" id="validto" value="<%=validTo%>" /></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td><input type="submit" value="update" /></td>
        </tr>
      </table>    
      <!-- div style="padding-bottom:10px;"><div style="float:left;width:120px;"></div></div>
      <div style="padding-bottom:10px;"><div style="float:left;width:120px;"></div></div>
      <div style="padding-bottom:10px;"><div style="float:left;width:120px;"></div></div>
      <div style="padding-bottom:10px;"><div style="float:left;width:120px;"></div></div>
      <div style="padding-bottom:10px;"><div style="float:left;width:120px;"></div>
      </div>
      <div style="padding-bottom:10px;"><div style="float:left;width:120px;"></div>      
      </div -->
    </form>
    <p>&nbsp;
      <%=editme%>
    </p>
        <p>
        [<a href="/ccms_asp/editor/managecontent.asp">List all content</a>]&nbsp;
        [<a href="/ccms_asp/editor/editcontent.asp?contentid=<%=contentId%>">Edit this content</a>]&nbsp;
        [<a href="#" onclick="javascript:window.close();">close</a>]&nbsp;
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
