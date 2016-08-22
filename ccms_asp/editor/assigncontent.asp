<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
//evaluate user session:
var currentUser = userFactory.getCurrentUser();
/*
TODO: Modify to display title based on doaction:
*/
if(currentUser){
  Response.Write(Request.QueryString("action"))
  var msg = "Nothing done yet...";
  var refresher = "";
  var title = "";
  //process the request:
  if(Request.QueryString("update") == "true"){
    if(Request.QueryString("doaction") == "replace"){
      var ok = editUtils.updateContentMapping(Request.QueryString("pageid"),Request.QueryString("slotid"),Request.QueryString("contentid"));
      msg = "Mapping update failed!"
      if(ok){ 
        msg = "Mapping updated successfully.";
        //refresher = "<script type=\"text/javascript\">window.opener.location.reload(true);</script>"
        refresher = editUtils.getOpenerReloadJavascript();
      }
    }
    if(Request.QueryString("doaction") == "add"){
      var ok = editUtils.addContentMapping(Request.QueryString("pageid"),Request.QueryString("slotid"),Request.QueryString("contentid"));
      msg = "Mapping update failed!"
      if(ok){ 
        msg = "Mapping added successfully.";
        refresher = editUtils.getOpenerReloadJavascript();
      }
    }
  }
  //get content items:
  var contentList = editUtils.getContentItems();

%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
 
  <title>Replace content</title>
  </head>
  <body>
    <%=refresher%>
      <div id="container">
        <div id="editor_content">
        
       <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/contentswap100x130.jpg" alt="Create page" />

      <h1>Add/Replace content</h1>      
        <p>Select a content item to assign to the selected slot. Click a title to show a preview.</p>
        <p>[Action: <%=msg%>]</p>
        </div>

        <form name="replacecontent" method="get" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
          <input type="hidden" name="update" value="true" />
          <input type="hidden" name="slotid" value="<%=Request.QueryString("slotid")%>" />
          <input type="hidden" name="pageid" value="<%=Request.QueryString("pageid")%>" />
          <input type="hidden" name="doaction" value="<%=Request.QueryString("doaction")%>" />
        <table>
          <tr>
            <td>
              <div id="contentlist" style="margin-top:0px;">
              <ul>
<% for(var a=0;a<contentList.length;a++){ %>
                  <li>
                  <input type="radio" name="contentid" value="<%=contentList[a].id%>" >&nbsp;<a href="#" onclick="showPreview(<%=contentList[a].id%>);return false;"/><%=contentList[a].name%></a>
                  </li>
<% }%>
              </ul>
              </div>
            </td>
            <td style="vertical-align:top;">

              <p><input type="button" name="submitfrm" value="Assign this content" onclick="submitUpdateContentForm();" /></p>
              </td>
          </tr>
        </table>

                
        </form>
        
        </div>
              <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
      </div>
        
        </div> 
      </div>
      
  <script type="text/javascript"> 
  
  function showPreview(contentId)
  {
    var width = 640;
    var height = 480;
    var target = 'contentpreview.asp?contentid=' + contentId;
    var win = window.open(target,'previewpopup','width=' + width + ',height=' + height + ',toolbar=0,resizable=1,scrollbars=1');
    win.focus();
  }
  
  function submitUpdateContentForm(){

    if(confirm("Assign selected content to page?")){
      
      //get the radio buttons and check for one being selected:
      var selectedList = document.replacecontent.contentid;
      var submitOK = false;
      for(var a=0;a<selectedList.length;a++){
        if(selectedList[a].checked){
          submitOK = true;  
        }    
      }
      if(submitOK){
        document.replacecontent.submit();
      }
      else{
        alert("No content item selected!")
      }
    }
  }
  
  </script>       
      
  </body>
</html>
<%
}

//otherwise, error:
else{
  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN.<br />PLEASE CLOSE THIS WINDOW AND LOG IN AGAIN.");
}
%>
