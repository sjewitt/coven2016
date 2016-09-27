<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
var refresher = "";
/*
TODO: Do a JS conditional check for teh elem.getElementById - this throws an error in IE when the 
page reloads without the viewtree...

This jump-off page should be visible to all. The options will become unavailable if 
insuffcient rights.
*/
//evaluate user session:
var currentUser = userFactory.getCurrentUser();
if(currentUser){

  var showForm = false;

  //process the update request:
  if(Request.Form("action") == "movenode"){
     //call viewtree.moveNode(nodeToMove,newParentNode);
     
     //load the two nodes:
     var nodeToMove = new Node(parseInt(Request.Form("nodeid")));
     var newParentNode = new Node(parseInt(Request.Form("targetid")));
     //var newParentNode = new Node(19);
     var movedOK = (new Viewtree()).moveNode(nodeToMove,newParentNode);
     if(movedOK){
       msg = "Page '" + (new Page(nodeToMove.pageId)).linkText + "' moved OK."; 
     }
     else{
       msg = "There was an error moving the page.";
     }
     
     
  }
  
  //show the viewtree and options:
  else{
    showForm = true;
    var nodeToMove = false;
    if(parseInt(Request.QueryString("nodeid"))){
      nodeToMove = new Node(parseInt(Request.QueryString("nodeid")));
      var page;
      var msg = "";
      if(nodeToMove.exists){
        page = new Page(nodeToMove.pageId);
        msg = "Select new parent for page '" + page.linkText + "'' (node " + nodeToMove.id + ").";
      
        //build the tree:
        var node = (new Viewtree()).getRoot(); 
        var nodeTree = new Node(node.id,true);  //load childs
        out = editUtils.buildTree(nodeTree);    
  
      }
      else{
        msg = "supplied node ID does not correspond to a node.";  
      }
    }
    else{
      msg = "supplied node ID is not an integer, or no nodeid parameter.";  
    }
  }


%>
<!DOCTYPE html>
<html>
  <head>

  <script type="text/javascript">
<%
if(showForm && nodeToMove && nodeToMove.exists){
%>  
    var nodeToMove =  "node_<%=nodeToMove.id%>";
<%
}
else{
%>
  var nodeToMove = false; 

<%
}
%>
    //disableRecursiveMoveLocations();
  </script>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  <%=EDITOR_DOM_MOVENODE%>
 
  <title>Manage Navigation</title>
  </head>
  <body onload="buildTree(nodeToMove);">
  
  <!-- TODO: Add parent refresher when clicking on a link... -->
    <%=refresher%>
    <div id="container">
      <div id="editor_content">
      <h1>Move node</h1>
       <div style="height:130px;border:1px solid lightgrey;">
          
          
            <div><img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/viewtree100x130.jpg" alt="Move node" /></div>
          <p id="msg"><%=msg%></p>
        </div>
      <div id="vt">
<%
if(showForm && nodeToMove && nodeToMove.exists){
%>      
      <form name="movenode" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?nodeid=<%=Request.QueryString("nodeid")%>" method="post">
      <input type="hidden" name="nodeid" value="<%=nodeToMove.id%>" />
      <input type="hidden" id="targetid" name="targetid" value="" />
      <input type="hidden" name="action" value="movenode" />
      <!-- input type="button" name="submit" value="OK" onclick="javascript:confirm('Move page \'<%=page.linkText%>\' to selected location')" / -->
      
      <div id="previewpanel">
        <div id="tree">
          <!-- render dynamic viewtree and options -->
<%=out%>
       </div>
<%
}
%>       
                  
      </div>
      </form>
      </div>
              <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        [<a href="#" onclick="javascript:history.go(-1);return false;">back</a>]
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



