<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
var refresher = "";


if(Request.Form("action") == "update"){
}

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

/*
This jump-off page should be visible to all. The options will become unavailable if 
insuffcient rights.
*/
if(currentUser){

  /*
  RETRIEVE START NODE:
  */
  var node = (new Viewtree()).getRoot(); 
  var nodeTree = new Node(node.id,true);  //load childs
  out = editUtils.buildTree(nodeTree);

%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <script type="text/javascript" src="/script/dom.asp"></script>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  <%=EDITOR_DOM_MANAGENAV%>
    
  <title>Manage Navigation</title>
  </head>
  
  <body>
  
  <!-- TODO: Add parent refresher when clicking on a link... -->
    <%=refresher%>
    <div id="container">
      <div id="editor_content">
      
       <div style="height:230px;">
          

      
          <h1>Manage Navigation</h1>
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/viewtree100x130.jpg" alt="Create page" />
          <p>
         This option allows the manipulation and viewing of various aspects of the navigation hierarchy. These include:</p>
         <ul style="margin-left:100px;">
            <li>View Node properties</li>
            <li>Move a Node to a new viewtree location</li>
            <li>Assign a layout to a Node</li>
            <li>Re-order the children of a Node</li>
            <li>View Page properties</li>
         </ul>
          <p>
          Use the '+' to expand the viewtree and click on a node for the available actions.
          </p>
          <h2>Viewtree</h2>
        </div>
      <div id="vt" style="border:1px solid grey;">
      
      <form name="viewtreeactions" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?nodeid=<%=Request.QueryString("nodeid")%>" method="post">
      <input type="hidden" name="nodeid" value="<%=node.id%>" />
      <input type="hidden" name="action" value="update" />
      <div id="previewpanel">

        <div id="tree">
          <!-- render dynamic viewtree and options -->
<%=out%>          
        </div>

                         
      </div>
      </form>
      </div>
              <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
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



