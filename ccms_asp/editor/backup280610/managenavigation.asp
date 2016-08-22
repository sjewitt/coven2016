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


/*
function getLayoutOptions(layout){
  try{
    var out = "";
    for(var a=0;a<templates.length;a++){
      out += '\t<option value="' + templates[a].id + '" ';
          if(layout.id == templates[a].id ){
            out += ' selected="selected"';
          }
          out += '>' + templates[a].fileName + '</option>\n';
    }
    return(out);
  }
  catch(e){
    
    return("");
  }
}


function walkVT(node,spacer,currNode, alternator){
  try{
    var currLine        = "";
    var currStart       = "";
    var currEnd         = "";
    var layoutOptions   = "";
    
    
    if(node.id == currNode.id){ 
      currStart   = "<strong>";
      currEnd     = "</strong>";
      layoutOptions = '<select style="width:160px;" name="layoutid">\n'
          + '\t<option> - None - </option>\n'
          + getLayoutOptions(new Layout(node.getLayoutId()))  //retrieve the layout dropdown options
          + '</select>\n<input type=\"button\" value=\"OK\" onclick=\"javascript:if(confirm(\'You are about to modify the layout for this node.\\nAre you sure? \')){document.updatelayout.submit();}\" />';
    }
    else{
      layoutOptions = (new Layout(node.getLayoutId())).fileName;
    }
    currLine = spacer + "<img src=\"/ccms_asp/editor/images/node.gif\" alt=\"#\" />"; //sort this.
    currLine += "<a href=\"" + Request.ServerVariables("SCRIPT_NAME") + "?nodeid=" + node.id + "\">";
    currLine += currStart + new Page(node.pageId).linkText + currEnd + "</a>";
    
    Response.Write("<tr style=\"background-color:" + alternator + ";\"><td>" + currLine + "</td><td style=\"padding-left:10px;\">" + layoutOptions + "</td></tr>\n");
    
    if(node.hasChildren){
      var childs = node.getChildren();
      for(var a=0;a<childs.length;a++){
        if(alternator=="#ddd;") alternator="#eee;";
        else alternator="#ddd;";
        walkVT(childs[a],(spacer + " &nbsp;"),currNode,alternator);
      }
    }
  }
  catch(e){
    Response.Write("Error in walkVT(): " + e.message+"<br>")
  }
}
*/
//evaluate user session:
var currentUser = userFactory.getCurrentUser();

/*
This jump-off page should be visible to all. The options will become unavailable if 
insuffcient rights.
*/
//if(currentUser){

  /*
  RETRIEVE START NODE:
   - assume root, and check for a nodeID on the URL:
  */
  var node = (new Viewtree()).getRoot(); 
  //if((new String(Request("nodeid"))) != 'undefined'){
  //  node = new Node(parseInt(new String(Request("nodeid"))));
  //}

/*
COLLAPSING VIEWTREE TEST:
*/
//build html list from nodetree (based on showObject):  
var out = "";

var page;

/*
Original: */
function walkVT(node,spacer, alternator){
  try{
    var currLine        = "";
    currLine += spacer + new Page(node.pageId).linkText;
    
    Response.Write(currLine + "<br />\n");
    
    if(node.hasChildren){
      var childs = node.getChildren();
      for(var a=0;a<childs.length;a++){
        if(alternator=="#ddd;") alternator="#eee;";
        else alternator="#ddd;";
        walkVT(childs[a],(spacer + " &nbsp;"),alternator);
      }
    }
  }
  catch(e){
    Response.Write("Error in walkVT(): " + e.message+"<br>")
  }
}


function walkVT(node,spacer){
  try{
    var currLine        = "";
    var currStart       = "";
    var currEnd         = "";
    var layoutOptions   = "";
    
    
    currLine = spacer + "<a href=\"" + Request.ServerVariables("SCRIPT_NAME") + "?nodeid=" + node.id + "\">";
    currLine += currStart + new Page(node.pageId).linkText + currEnd + "</a>";
    
    Response.Write("<tr style=\"background-color:" + alternator + ";\"><td>" + currLine + "</td><td style=\"padding-left:10px;\">" + layoutOptions + "</td></tr>\n");
    
    if(node.hasChildren){
      var childs = node.getChildren();
      for(var a=0;a<childs.length;a++){

        walkVT(childs[a],(spacer + " &nbsp;"));
      }
    }
  }
  catch(e){
    Response.Write("Error in walkVT(): " + e.message+"<br>")
  }
}


function buildTree(node,spacer){
	try{
    if(!spacer){
  		spacer = "";
  	}
  	
  	//out += "<li>"
  	
  	//render the node:
  	page = new Page(node.pageId);
  	out += "\n" + spacer + "\t<li id=\"node_" + node.id + "\" title=\"" + page.linkText + "\">\n";
  	
  	
  	if(node.childArray.length>0){
  	  
  	  out += spacer + "\t\t<ul><!-- childs -->\n";
    
    	for(var a=0;a<node.childArray.length;a++){
    	
//  	     page = new Page(node.childArray[a].pageId);
//  	     out += spacer + "\t\t\t<li id=\"node_" + node.childArray[a].id + "\" title=\"" + page.linkText + "\">\n";
    
    
//         if(node.childArray[a].hasChildren){
//          out += "childs";

          
//    			 //out += "\n" + spacer + "<ul>\n"
    			 buildTree(node.childArray[a], spacer + "  ");
//    			// out += spacer + "</ul>\n";

//        }     		  
//         out += "\t\t\t</li>\n";
        
  	   }
    
  	   out += spacer + "\t\t</ul>\n";
       spacer += "\t\t\t";
  	}
  	
  	out += spacer + "\t</li>\n"
  }
  catch(e){
    showObject(e);
  }
}
var nodeTree = new Node(node.id,true);  //load childs
//showObject(inNode);
buildTree(nodeTree,"");
out = "<ul>" + out + "</ul>"  

%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <script type="text/javascript" src="/script/dom.asp"></script>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
    
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

        <%
        //vt = new Viewtree();
        //walkVT(vt.getRoot(),"   ",node,"#ddd;");
        %>
        <xmp>
        <div id="treeXX">
          <!-- render dynamic viewtree and options -->
<%=out%>          
        </div> 
        </xmp>
        
        <div id="tree">
          <!-- render dynamic viewtree and options -->
<%=out%>          
        </div> 
        <div>

        <%
        //vt = new Viewtree();
        //walkVT(vt.getRoot(),"   ","#ddd;");
        %>
        
        
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
//}
//else{
//  Response.Write("INSUFFICIENT PRIVILEGES OR NOT LOGGED IN.<br />PLEASE CLOSE THIS WINDOW AND LOG IN AGAIN.");
//}
%>



