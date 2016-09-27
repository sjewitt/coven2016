<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
var lm = new LayoutManager();
var inNode = (new Viewtree()).getRoot();
if(parseInt(Request.QueryString("nodeid"))){
  inNode = new Node(parseInt(Request.QueryString("nodeid")));
}
var templates = lm.getAllLayouts();  //return an array of Layout() objects.
var refresher = "";
if(Request.Form("action") == "update"){
  var res = editUtils.updateLayoutMap( new Node(parseInt(Request.Form("nodeid")  )), new Layout( parseInt( Request.Form("layoutid") ) )   );
  refresher = editUtils.getOpenerReloadJavascript();
}

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

//evaluate user session:
var currentUser = userFactory.getCurrentUser();
if(currentUser){

  /*
  RETRIEVE START NODE:
   - assume root, and check for a nodeID on the URL:
  */
  var node = (new Viewtree()).getRoot(); 
  if((new String(Request("nodeid"))) != 'undefined'){
    node = new Node(parseInt(new String(Request("nodeid"))));
  }

%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <script type="text/javascript" src="/script/dom.js"></script>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
    
  <title>Assign Layouts</title>
  </head>
  
  <body>
  <!-- TODO: Add parent refresher when clicking on a link... -->
    <%=refresher%>
    <div id="container">
      <div id="editor_content">
      
       <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/layouts100x130.jpg" alt="Create page" />

      
          <h1>Assign Layouts</h1>
          <p>
          Select a page in the Node Tree. One of the available layouts may be assigned. Note that the selected layout will be applied to 
          all direct children (unless you assign another layout further down the tree).
          </p>
        </div>
      <div id="vt">
      
      <form name="updatelayout" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?nodeid=<%=Request.QueryString("nodeid")%>" method="post">
      <input type="hidden" name="nodeid" value="<%=inNode.id%>" />
      <input type="hidden" name="action" value="update" />
      <div id="previewpanel">
        <table>
          <tr style="font-weight:bold;background-color:#bbb;">
            <td style="padding-left:10px;width:200px;">Node Tree</td>
            <td style="padding-left:10px;width:250px;">Manage layout</td>
          </tr>
        <%
        vt = new Viewtree();
        walkVT(vt.getRoot(),"   ",node,"#ddd;");
        %>
        </table>

      </div>
      </form>
      </div>
              <p>
        [<a href="#" onclick="javascript:history.go(-1);return false;">back</a>]
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



