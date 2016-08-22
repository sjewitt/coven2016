<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
try{
  //Response.Write(Request.Form);
  //var lm = new LayoutManager();
  var page = false;
  var out = "";
  var submitted = false;
  if(parseInt(Request.QueryString("pageid"))){
    page = new Page(parseInt(Request.QueryString("pageid")));
  }
  else{
    throw new Error("No page ID.");
  }
  var viewtree = new Viewtree();

  var refresher = "";
  if(Request.Form("action") == "add"){
    var newNode = new Node();
    newNode.pageId = page.id;
    var res = viewtree.addNode( new Node(parseInt(Request.Form("nodeid")  )), newNode);
    //refresher = editUtils.getOpenerReloadJavascript();      //because the opener is always the popup.
    //Response.Write(res);
    submitted = true;
    if(res){
      out = "Page added to viewtree OK.<br>";
    }
    else{
      out = "There was a problem adding the page to the viewtree.<br />";
    }
  }
}
catch(e){
  Response.Write("error in addtoviewtree.asp: " + e.message);
}

//recursive walk:
function walkVT(node,spacer){
  try{
    var currLine        = "";
    currLine = spacer;
    currLine  += "<input type=\"radio\" name=\"nodeid\" value=\"" + node.id + "\" / >" 
              + "<a href=\"#\" onclick=\"javascript:return false;\" title=\"node ID=" + node.id+", page ID="+node.pageId + "\">" + new Page(node.pageId).linkText + "</a>";
    
    Response.Write("<tr><td>" + currLine + "</td></tr>\n");
    
    if(node.hasChildren){
      var childs = node.getChildren();
      for(var a=0;a<childs.length;a++){
        walkVT(childs[a],(spacer + "&nbsp;&nbsp;&nbsp;&nbsp;"));
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
%>

<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  <meta http-equiv="content-type" content="text/html; charset=windows-1250">
  <meta name="generator" content="PSPad editor, www.pspad.com">
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <script type="text/javascript">
  function dosubmit(){  
    var submit = false;
    var msg = "";
    
    //get list of radiobuttons, check that one is selected:
    var radiobuttons = document.updatelayout.nodeid;
    
    /*
    If there is only one item (ie root) then we do not have an
    ARRAY, so create one:
    */
    if(radiobuttons.length == undefined){
      var elem = radiobuttons;
      radiobuttons = new Array();
      radiobuttons.push(elem);
    }
    
    //var x = "";
    for(var a=0;a<radiobuttons.length;a++){
      //x+=radiobuttons[a].checked+"\n"
      if(radiobuttons[a].checked == true){
        submit = true;  
      }
      msg = "Please select a parent to proceed."
    }
    
    if(submit){
      if(confirm("Add this page to viewtree?")){
        //submit the form:
        document.updatelayout.submit();
      }
    }
    else{
      alert(msg);
    }
  }
  </script>
  
  <title>Add page to viewtree</title>
  </head>
  <body>
    <%=refresher%>

    <div id="container">
      <div id="editor_content">
       <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/viewtree100x130.jpg" alt="Create page" />
          <h1>Add page to viewtree</h1>
          <p>
<%
if(submitted){
%>
      <%=out%>
<%
}
else{
%>
      <p>Place page '<%=page.name%>' (id <%=page.id%>) in the viewtree.</p>
      <p>Select parent for this page and click 'add'. You can further manage the viewtree 
      <a href="managenavigation.asp" title="Manage Viewtree">here</a>. 
<%
}
%>
          </p>
        </div>
    
        <form name="updatelayout" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?pageid=<%=Request.QueryString("pageid")%>" method="post">
          <input type="hidden" name="pageid" value="<%=page.id%>" />
          <input type="hidden" name="action" value="add" />
          <div id="previewpanel">
          <table>
<%
vt = new Viewtree();
walkVT(vt.getRoot(),"&nbsp;");
%>
          </table>
      </div>
<%
if(submitted){
%>
      <input type="button" value="Close" onclick="window.close();" />
<%
}
else{
%>
      <input type="button" name="add" value="Add" onclick="dosubmit();" />
<%
}
%>
      </form>
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



