<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

//only render edit form if user has rights:
if(currentUser){

%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html>
<html>
  <head>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <title>Upload an image or document</title>
  <script type="text/javascript">
  function submitfrm(frm){
    try{
      if(frm.file.value !== ""){
    
        //if(confirm("Upload this file?")){
          frm.submit();  
        //}
      }
      else{
        alert("Please select a file to upload.")
      }
    }
    catch(e){
      alert(e)
    }
  }
  
  function checkfrm(frm){
    alert(frm.file.value);
  }
  </script>
  </head>
  <body>
    <div id="container">
      <div id="editor_content">
        <div style="height:625px;">
        <div style="height:580px;">
          <h1>Upload an image or document</h1>
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/bin100x130.jpg" alt="Upload a binary" />
          
          <p>
            Select a file from your desktop.
          </p>
  
        <form name="upload" action="/ccms_asp/editor/upload_handler.asp" method="post" enctype="multipart/form-data">

                <div><input type="file" name="file" value="" id="file_upload_selector"/></div>

            <!--Select type:
                <select name="filetype">
                  <option value="image">Image</option>
                  <option value="document">Document</option>
                </select>-->

          <div style="margin-top:20px"><input id="file_upload_submit" disabled="disabled" type="button" value="Upload file" onclick="submitfrm(document.upload);return false;" /></div>
        </form>  
</div>
<div>
        <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
</div>
        </div>
        


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
