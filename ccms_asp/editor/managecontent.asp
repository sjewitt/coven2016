<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
//evaluate user session:
var currentUser = userFactory.getCurrentUser();

//if(currentUser.permissions & Permissions.EDITCONTENT || currentUser.permissions & Permissions.ADMINISTRATOR){

//list all content for logged in user:
if(currentUser){
  var contentTypeOptions  = editUtils.getContentTypeOptions();
  var refresher           = "";
  var msg                 = "";
  var out                 = "";

  /*
  handle search filter request:
  */
  if(Request.Form("action") == "listcontent"){
    out += "getting content";
    try{
      var query = new Query();
      var filter = "";
      if(Request.Form("q") && Request.Form("q")!= undefined){
        filter = Request.Form("q") + "";
      }
      query.setQuery("select id, name, created_date from content where name like '" + filter + "%' and content_type=" + Request.Form("type") + " order by created_date desc;");
      query.execute();
      
      var rowClass = "even";
      var flag = false;
      var actionArray = new Array();
      out += "<table id=\"list-content\" class=\"stripe order-column\"><thead><tr><th>Content name</th><th class=\"header\">ID</th><th class=\"header\">Created date</th><th class=\"header\">Actions</th></tr>\n</thead><tfoot><tr><th>Content name</th><th class=\"header\">ID</th><th class=\"header\">Created date</th><th class=\"header\">Actions</th></tr></tfoot><tbody>";
      
      var name = "";
      
      for(var a=0;a<query.resultObject.length;a++){
        name = query.resultObject[a].name;
        if(!(name && name.length > 1)){
          name = "[Name not set]";  //not specified
        }
        actionArray = new Array();
        out += "<tr class=\"" + rowClass + "\">";
        out += "<td>" + name + "</td>";
        out += "<td>" + query.resultObject[a].id + "</td>";
        out += "<td>" + dateUtils.getShortDateTime(query.resultObject[a].created_date) + "</td>";
        out += "<td>";
        //edit if perms:
        if(currentUser.permissions & Permissions.EDITCONTENT || currentUser.permissions & Permissions.ADMINISTRATOR){
          actionArray.push("<a href='*' onclick='popup(\"editcontent.asp?contentid=" + query.resultObject[a].id + "\"," + SIZE_EDIT_CONTENT + ");return false;'>edit</a>&nbsp;");
        }
        
        if(currentUser.permissions & Permissions.CREATECONTENT || currentUser.permissions & Permissions.ADMINISTRATOR){
          actionArray.push("<a href=\"editcontentproperties.asp?contentid=" + query.resultObject[a].id + "\">properties</a>&nbsp;");
        }
        
        if(currentUser.permissions & Permissions.DELETECONTENT || currentUser.permissions & Permissions.ADMINISTRATOR){
          actionArray.push("<a onclick=\"javascript:alert('Not yet implemented.');return false;\" href=\"deletecontent.asp?contentid=" + query.resultObject[a].id + "\">delete</a>&nbsp;"); 
        }
        out += actionArray.join("/ ")
        out += "</td></tr>\n"
        
        if(flag){
          rowClass="even";
          flag=false;
        } 
        else{
          rowClass = "odd";
          flag=true;
        }
      }
      out += "</tbody></table>\n";
    }
    catch(e){
      out = "error: " + e.message;
    }
  }
%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  <title>Manage content</title>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  </head>
  <body>
 <%=refresher%>
 <div id="container">
  <div id="editor_content">
    <h1>Manage existing content</h1>
    <p>
    Manage existing content items. The options available will depend on the logged-in user rights.
    </p>
    <p><%=msg%></p>
    <form name="managecontent" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
      <input type="hidden" name="action" value="listcontent" />
      <div style="float:left;width:120px;">Search:</div><input type="text" name="q" value="<%=Request.Form("q")%>" /><br />
      <div style="float:left;width:120px;">Subtype:</div><select name="type">
        
        <%=contentTypeOptions%>
              
      </select>
      <br />
      <div style="float:left;width:120px;">&nbsp;</div>      <input type="submit" value="find content" />
    </form>
    <p>
      <%=out%>
    </p>
        <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
    </div>
    </div>
      <script>
//          $(function () {
//              $("#list-content").DataTable();
//          });
    </script>
  </body>

</html>
<%
}
else{
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN.<br />PLEASE CLOSE THIS WINDOW AND LOG IN AGAIN.");
}
%>
