<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
//var lm = new LayoutManager();
//var inNode = (new Viewtree()).getRoot();
//if(parseInt(Request.QueryString("nodeid"))){
//  inNode = new Node(parseInt(Request.QueryString("nodeid")));
//}
//var templates = lm.getAllLayouts();  //return an array of Layout() objects.
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
   - assume root, and check for a nodeID on the URL:
  */
  var node = (new Viewtree()).getRoot(); 

  /*
  //build html list from nodetree (based on showObject):  
  var out = "";

  var page;


  function buildTree(node){
  	try{
    	
    	//render the node:
    	page = new Page(node.pageId);
    	out += "\n\t<li id=\"node_" + node.id + "\" title=\"" + page.linkText + "\">\n";

    	if(node.childArray.length>0){
    	  
        out += "\t\t<!-- childs --><ul>\n";
        for(var a=0;a<node.childArray.length;a++){
      		buildTree(node.childArray[a]);
    	  }
    	  out += "\n\t\t</ul><!-- end childs -->\n";
        
    	}
    	out += "\t</li>\n" 
    }
    catch(e){
      showObject(e);
    }
  }
  */
  
  var nodeTree = new Node(node.id,true);  //load childs
  out = editUtils.buildTree(nodeTree);
  //out = "<ul>" + out + "</ul>"  

%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <script type="text/javascript" src="/script/dom.asp"></script>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  <%=EDITOR_DOM%>
    
  <title>Manage Navigation</title>
  </head>
  
  <body>
  
  <!-- TODO: Add parent refresher when clicking on a link... -->
    <%=refresher%>
    <div id="container">
      <div id="editor_content">
      
       <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/viewtree100x130.jpg" alt="Create page" />

      
          <h1>Manage Navigation</h1>
          <p>
         ordering of siblings etc. <br />
         -> opens siblingorder.asp
          </p>
        </div>
      <div id="vt">
      
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



