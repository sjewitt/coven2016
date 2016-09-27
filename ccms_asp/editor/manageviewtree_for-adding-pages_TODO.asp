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
    
  }
}

function walkVT(node,spacer,currNode){
  try{
    var currLine        = "";
    var currStart       = "";
    var currEnd         = "";
    var layoutOptions   = "";
    if(node.id == currNode.id){ 
      currStart   = "<strong>";
      currEnd     = "</strong>";
      layoutOptions = '<select name="layoutid">\n'
          + '\t<option> - Select layout page - </option>\n'
          + getLayoutOptions(new Layout(node.getLayoutId()))  //retrieve the layout dropdown options
          + '</select>\n';
    }
    else{
      layoutOptions = (new Layout(node.getLayoutId())).fileName;
    }
    currLine = spacer;
    currLine += "<a href=\"" + Request.ServerVariables("SCRIPT_NAME") + "?nodeid=" + node.id + "\">";
    currLine += currStart + new Page(node.pageId).linkText + currEnd + "</a>";
    
    Response.Write("<tr><td><input type=\"radio\" name=\"vtnode\" value=\"" + node.pageId + "\" / >" + currLine + "</td><td>" + layoutOptions + "</td></tr>\n");
    
    if(node.hasChildren){
      var childs = node.getChildren();
      for(var a=0;a<childs.length;a++){
        walkVT(childs[a],(spacer + "-"),currNode);
      }
    }
  }
  catch(e){
    Response.Write("Error in walkVT(): " + e.message+"<br>")
  }
}

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

//showObject(currentUser);

if(currentUser){

  var node = (new Viewtree()).getRoot(); 
  if((new String(Request("nodeid"))) != 'undefined'){
    node = new Node(parseInt(new String(Request("nodeid"))));
  }
  
    /*
  RETRIEVE START NODE:
   - assume root, and check for a nodeID on the URL:
  */
  var node = (new Viewtree()).getRoot(); 
  if((new String(Request("nodeid"))) != 'undefined'){
    node = new Node(parseInt(new String(Request("nodeid"))));
  }
  
%>

<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  <meta http-equiv="content-type" content="text/html; charset=windows-1250">
  <meta name="generator" content="PSPad editor, www.pspad.com">
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <title>Manage Viewtree</title>
  </head>
  <body>
    <%=refresher%>
    <div id="container">
      <h1>
      Manage Viewtree<br />
      </h1>
      <div id="vt">
      [list layout page next to each node if present. if the node is SELECTED, render a dropdown with available 
      layout pages. submit will assign selected layout]
      <form name="updatelayout" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?nodeid=<%=Request.QueryString("nodeid")%>" method="post">
      <input type="hidden" name="nodeid" value="<%=inNode.id%>">
      <input type="hidden" name="action" value="update">
      <div id="previewpanel" style="border:1px solid black;padding:5px;width:600px;height:300px;overflow:auto;">
        <table>
          <tr>
            <td>Node Tree</td>
            <td>Manage layout</td>
          </tr>
        <%
        vt = new Viewtree();
        walkVT(vt.getRoot(),"  ",node);
        %>
        </table>
      </div>
      <input type="submit" value="Update" />
      </form>
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



