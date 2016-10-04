<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

if(currentUser){
  var msg         = "Create new content.";
  var refresher   = "";
  var editme      = "";
  var addToPage = false;

  var contentTypeOptions = editUtils.getContentTypeOptions(null); //retrieve the option list

  if(new String(Request.Form("execute")) == "ok"){
    msg = "Creating new content."
    
    //build a date from passed to/from fields. Expects yyyy-mm-dd:
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
    
    
    //create new Content row:
    

    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var recordset     = Server.CreateObject("ADODB.Recordset");
    var newContentId  = 0;
    var sql = "insert into content (name,description,created_user,created_date,updated_date,updated_user,auth_group,content_type,start_date, end_date) values(?,?,?,GETDATE(),GETDATE(),?,1,?,?,?)";
    var cmd           = Server.CreateObject("ADODB.Command");
    cmd.CommandType       = 1;                    //adCmdText - sql query
    cmd.Name              = "content_create";    //note naming convention...
    cmd.CommandText       = sql;                 //Parameterised SQL
    cmd.ActiveConnection  = connection;           //set the active connection
    cmd.Prepared          = true;                 //set the statement to prepared.
    //see http://www.w3schools.com/ado/met_comm_createparameter.asp#datatypeenum
    cmd.Parameters.Append(cmd.CreateParameter("contentName",  8,1,0,Request.Form('name')));  //name
    cmd.Parameters.Append(cmd.CreateParameter("contentDescr", 8,1,0,Request.Form('description')));  //description
    cmd.Parameters.Append(cmd.CreateParameter("userid",       3,1,0,currentUser.id));  //user id
    cmd.Parameters.Append(cmd.CreateParameter("userid",       3,1,0,currentUser.id));  //user id
    cmd.Parameters.Append(cmd.CreateParameter("type",         3,1,0,Request.Form("type")));  //type
    cmd.Parameters.Append(cmd.CreateParameter("dateFrom",     135,1,0,dateFrom));  //date_from - may be null
    cmd.Parameters.Append(cmd.CreateParameter("dateTo",       135,1,0,dateTo));  //date_to - may be null
    cmd.execute();

    //if ok:
    sql = "select max (id) as id from content";
    recordset = connection.execute(sql);
    //if ok:
    /*do I actuallty need to do this? - er yes...*/
    newContentId = recordset("id");
    sql = "insert into content_version(content_id,version_id,state_id,edit_user,updated_date) values (" + newContentId + ",1,1," + currentUser.id + ",GETDATE())"; 
    connection.execute(sql);
    
    //test - edit new content link:
    editme = "<a href=\"#\" onclick=\"popup('/ccms_asp/editor/editcontent.asp?contentid=" + newContentId + "')\">Edit new content '" + Request.Form('name') + "'</a>";
    
    /*
    if page/slot IDs are also submitted (see below) additionally do 
    an insert into the mapping table: (Note that these are now POSTed)
    */
  //if((Request.Form("pageid") && parseInt(Request.Form("pageid"))>0) && (Request.Form("slotid") && parseInt(Request.Form("slotid"))>0)){
  //  addToPage = true;   
  //}
    try{
      if((Request.Form("pageid") && parseInt(Request.Form("pageid"))>0) && (Request.Form("slotid") && parseInt(Request.Form("slotid"))>0)){
        msg + " and adding to page [load page], slot [slotnum]";
        sql = "insert into page_content_ref (content_id,page_id,slot_num) values (" + newContentId + ", " + Request.Form("pageid") + ", " + Request.Form("slotid") + ")";
        connection.execute(sql);
      }
    }
    catch(e){
      Response.Write(e.message + " - insert into page_content_ref (content_id,page_id,slot_num) values (" + newContentId + ", " + Request.Form("pageid") + ", " + Request.Form("slotid"));
    }
    contentTypeOptions = editUtils.getContentTypeOptions(newContentId);
    recordset.close();
    recordset = null;   
    connection.close();
    connection = null;
    refresher = editUtils.getOpenerReloadJavascript();
  }
  
  //vars to pre-populate the page and slot hidden fields:
  var pageId = "";
  var slotId = "";
  
  //if we have come from a SLOT, additionally pre-populate the hidden slot and page ID fields: (NOTE these are GET vars:)
    if((Request.QueryString("pageid") && parseInt(Request.QueryString("pageid"))>0) && (Request.QueryString("slotid") && parseInt(Request.QueryString("slotid"))>0)){
      //Response.Write("PAGE: " + Request.QueryString("pageid"));
      pageId = new String(Request.QueryString("pageid"));
      slotId = new String(Request.QueryString("slotid"));
      msg = "Create new content and assign to page '" + (new Page(pageId)).name + "', slot " + slotId + "." 
    }
    
    //expects a date string of the form yyyy-mm-dd, returns SQLServer insertable string, or null:
    function getDateFromInput(dateStr)
    {
      try
      {
         var dateBits = dateStr.split("-");
         var date = new Date();
         
         if(dateBits[1].charAt(0) == "0") dateBits[1] = dateBits[1].substring(1,2);
         if(dateBits[2].charAt(0) == "0") dateBits[2] = dateBits[2].substring(1,2); 
         date.setFullYear(parseInt(dateBits[0]));
         date.setMonth(parseInt(dateBits[1]) - 1);  //zero-indexed
         date.setDate(parseInt(dateBits[2]));
         return date;
      }
      catch(e)
      {
         //log error 
         return null;
      }
    }
%><!DOCTYPE html>
<html>
  <head>

  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <link rel='stylesheet' type='text/css' href='/ccms_asp/editor/datepicker/calendar.css' />
  <script type='text/javascript' src='/ccms_asp/editor/datepicker/calendar.js'></script>

  <script type="text/javascript">
//  function popup(url,width,height){
//	 var win = window.open(url,'popup','width=' + width + ',height=' + height + ',toolbar=0,resizable=1,scrollbars=1');
//	 win.resizeTo(width,height);
//	 win.focus();
//  }
//  
////  window.onload = function(){
////  //date picker
////  	calendar.set("validfrom");
////  	calendar.set("validto");
////  }
$(function(){
  //date picker
  	calendar.set("validfrom");
  	calendar.set("validto");
});

//TODO: Add handlers for activating the button if name/description are filled
  </script>
  <title>Create new content</title>


  </head>
  <body>
 <%=refresher%>
 <div id="container">
  <div id="editor_content">
  
    
         <div style="height:130px;">
          
  
    <h1>Create new content</h1>
    <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/contentnew100x130.jpg" alt="Create new content" />
    <ul>
    <li>Provide a name</li>
    <li>Select subtype</li>
    <li>Edit the new content</li>
    </ul>
    </div>
    <p><%=msg%></p>
    <form id="createcontent" name="createcontent" method="post" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
      <input type="hidden" name="pageid" value="<%=pageId%>" />
      <input type="hidden" name="slotid" value="<%=slotId%>" />
      <input type="hidden" name="execute" value="ok" />
      
      <table>
        <tr>
          <td>Name:</td>
          <td><input type="text" id="new_content_name" name="name" value="" style="width:320px;"/></td>
        </tr>
        <tr>
          <td>Description:</td>
          <td><input type="text" id="new_content_description" name="description" value="" style="width:320px;" /></td>
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

          <input type="text" name="validfrom" id="validfrom" value="" /></td>
        </tr>
        <tr>
          <td>Valid to:</td>
          <td><input type="text" name="validto" id="validto" value="" /></td>
        </tr>      
        <tr>
          <td>&nbsp;</td>
          <td><input id="content_create_submit" disabled="disabled" type="submit" value="create" /></td>
        </tr>      
      </table>

    </form>
    <p>&nbsp;
      <%=editme%>
    </p>
        <p>
        [<a href="#" onclick="javascript:window.close();">close</a>][Calendar from <a href="http://www.openjs.com/scripts/ui/calendar/" target="_blank" title="Open JS Calendar">Open JS</a>]
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
