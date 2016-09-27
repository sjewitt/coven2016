<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
//evaluate user session:
var currentUser = userFactory.getCurrentUser();

if(currentUser){
  var lm = new LayoutManager();
  var inNode = (new Viewtree()).getRoot();
  if(parseInt(Request.QueryString("nodeid"))){
    inNode = new Node(parseInt(Request.QueryString("nodeid")));
  }
  
  var refresher = "";
  if(Request.QueryString("action") == "removenode"){
    
    var res = editUtils.removeViewtreeNode(inNode);
    if(res){
      refresher = editUtils.getOpenerParentReloadJavascript(inNode.getParent());
    }
  }
%>
<!DOCTYPE html>
<html>
  <head>

  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>

  <title>Manage Viewtree</title>
  </head>
  <body>
    <%=refresher%>
    <div id="container">
      <div id="editor_content">
      
       <div style="height:130px;">
          <h1>Remove viewtree node</h1>
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/viewtreeremove100x130.jpg" alt="Remove navigation item" />      
          
            
            <p>Remove Viewtree navigation item '<%=(new Page(inNode.pageId)).linkText%>' from the Viewtree. This action only removes the 
          reference to the page from the Viewtree and does not delete the page itself. The referenced page can be re-attached if desired.</p>
        </div>
        <div id="content">
        
<%
//if node has childs, do not remove.
if(inNode.hasChildren){
%>
        <p>
        Navigation item '<%=(new Page(inNode.pageId)).linkText%>' has children. A navigation item cannot be deleted if it has children.
        Please remove child items first or choose another action.
        </p>
        <p>
        [<a href="#" onclick="javascript:window.close();">close</a>]
        </p>
<%
}
//otherwise, trigger the removal form:
else{
  if(Request.QueryString("action") == "removenode"){
%>
  <p>
  Node removed
  </p>
  <p>
  [<a href="#" onclick="javascript:window.close();">close</a>]
  </p>
<%
  }
  else{
%>
        <script type="text/javascript">
        function submitFrm(){
          if(confirm('You are about to remove this node.\nAre you sure?')){
            document.removenode.submit();
          }
        }
        </script>
        <form name="removenode" action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method="get">
        <input type="hidden" name="nodeid" value="<%=inNode.id%>">
        <input type="hidden" name="action" value="removenode">
        <input type="button" value="Remove node" onclick="submitFrm();" />
        </form>
        
  <p>
  [<a href="#" onclick="javascript:window.close();">cancel</a>]
  </p>
<%
  }
}
%>
        </div>
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



