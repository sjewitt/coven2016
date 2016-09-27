<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
var refresher = "";
if(Request.Form("action") == "update"){
  var res = editUtils.updateLayoutMap( new Node(parseInt(Request.Form("nodeid")  )), new Layout( parseInt( Request.Form("layoutid") ) )   );
  refresher = editUtils.getOpenerReloadJavascript();
}

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

Response.Write("TODO: ADD IE HANDLERS FOR setAttribute('name','value')");
if(currentUser){

    /*
  RETRIEVE START NODE:
  */
  var node = (new Viewtree()).getRoot(); 
  if((new String(Request("nodeid"))) != 'undefined'){
    node = new Node(parseInt(new String(Request("nodeid"))));
  }
  if(new String(Request("action")) == "update"){
    try{
      var sibNode;
      var currData;
      //get each item:
      for(var a=0;a<parseInt(Request("numitems"));a++){
        
        currData = new String(Request("item" + a));
        sibNode = new Node(parseInt(currData.split(";")[0].split(":")[1]));
        //set the ordering poperty:
        sibNode.ordering = parseInt(currData.split(";")[1].split(":")[1])
        //update:
        sibNode.update();
      }
    }
    catch(e){
      Response.Write("error: " + e.description);
    }
  } 
 
  var out = "";

  //get childs of passed nodeid:
  var nodeTree = new Node(node.id);  //load childs
  var childArray =  nodeTree.getChildren();

  /*
  build ui/form with sibling node data. Add some CSJS to
  manipulate the form values for submission:
  */
  function getSiblingReorderingUI(childArray,parentNode){
    try{
      var out = ""; //parent: " + (new Page(parentNode.id)).linkText + "<br/>";
      //out += "var data = new Object();\n";
      out += "data.parentId = " + parentNode.id + ";\n";
      out += "data.childs = new Array();\n";
    
      var page;
      for(var a=0;a<childArray.length;a++){
        page = new Page(childArray[a].pageId);
        out += "data.childs.push({linkText:'" + page.linkText + "',nodeId:" + childArray[a].id + "});\n";
      }
      return(out);
    }
    catch(e){
      Response.Write(e.message);
      return(false);
    }
  }

  out = getSiblingReorderingUI(childArray,node);

%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
  
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
<script type="text/javascript">
var data = new Object();
//dynamic JS array of CURRENT ordering state (object='data'):
<%=out%>

var orig = new Array();
//orig = data.childs; //this seems to be BY REF - so FAILS! Explicitly build a copy of the object:
for(var a=0;a<data.childs.length;a++){
  orig.push(data.childs[a]);
}

//assemble the DOM structure for initial display:
function buildReorderingUI(data){
  try{
    var container = document.getElementById("reorder_ui");
    
    //alert(container.innerHTML)
    
    //remove current content:
    while (container.hasChildNodes()) {
      container.removeChild(container.lastChild);
    }
    var outerTable = document.createElement("table");
    var row;
    var cell1;
    var cell2;
    //var currItem;
    var currText;
    var up;
    var down;
    var upText;
    var downText;
    var frmElem;
    //var itemDiv;
    //var actionsDiv;

    //determine if IE or not:    
    var isOpera = false;
    var isIE    = false;
    if(typeof(window.opera) != 'undefined'){
      isOpera = true;
    }
    if((!isOpera) && navigator.userAgent.indexOf('MSIE') != -1){
      isIE = true;
    }
  
    for(var a=0;a<data.childs.length;a++){
      
      //create the current row:
      row = document.createElement("tr");
      
      //create the first cell, to hold the item name:
      cell1 = document.createElement("td");
      
      //create the second cell, to hold the movement controls:
      cell2 = document.createElement("td");
      
      //currItem = document.createElement("div");
      //currItem.setAttribute("id","node" + data.childs[a].nodeId);
      currText = document.createTextNode(data.childs[a].linkText + " (node " + data.childs[a].nodeId + ")");
      
      //conditionally add element differently depending on useragent (IE is crap...)
      //see http://webbugtrack.blogspot.com/2007/10/bug-235-createelement-is-broken-in-ie.html
      /* */
      try{
        
        //var isOpera = false;
        //var isIE = false;
        //if(typeof(window.opera) != 'undefined'){
        //  isOpera = true;
        //}
        //if(!isOpera && navigator.userAgent.indexOf('Internet Explorer')){
        //  isIE = true;
        //}
    
        //var myNewField = null;
        if(!isIE){
          frmElem = document.createElement('input');
          frmElem.setAttribute("name","item" + a);
        } 
        else {
          frmElem = document.createElement('<input name="item' + a + '"/>');
        }
      }
      catch(e){
        alert("eror in siblingorder.browsercheck: "+e.message)
      }
        
      
      //set any other attributes...
      //add to the DOM
      
      //end
      
      //frmElem = document.createElement("input");
      frmElem.setAttribute("type","text");
      //frmElem.setAttribute("name","item" + a);
      frmElem.setAttribute("id","item" + a);   //for IE
      frmElem.setAttribute("value","id:"+data.childs[a].nodeId+";pos:"+a);
      
      upText = document.createTextNode("[up]"); //I can't declare outside because it is a SINGLE node, and thus it is moved to the last one... 
      if(a > 0){
        up = document.createElement("a");
        up.setAttribute("href","#");
        up.setAttribute("title","Move item '" + data.childs[a].linkText + "' up one position.");
        up.setAttribute("onclick","reOrder(" + a + ",'up');return false;");
      }
      else{
        up = document.createElement("span");
      }
      up.appendChild(upText);  
      
      downText = document.createTextNode("[down]");  
      if(a < (data.childs.length-1)){
        down = document.createElement("a");
        down.setAttribute("href","#");
        down.setAttribute("title","Move item '" + data.childs[a].linkText + "' down one position.");
        down.setAttribute("onclick","reOrder(" + a + ",'down');return false;");
      }
      else{
        down = document.createElement("span");
      }
      down.appendChild(downText);
      
      //currItem.appendChild(currText);
      
      //currItem.appendChild(up);
      //currItem.appendChild(down);
      //currItem.appendChild(frmElem);
  
      //finally, append the table
      //container.appendChild(currItem);
      
      //add the table:
      cell1.appendChild(currText);
      cell2.appendChild(up);
      cell2.appendChild(down);
      cell2.appendChild(frmElem);
      row.appendChild(cell1);
      row.appendChild(cell2);
      outerTable.appendChild(row);
      
      container.appendChild(outerTable);
      
      //alert(container.innerHTML);  
    }
    //alert(container.innerHTML);
    //populate the hidden parent and length fields:
    document.reordersibs.numitems.value = data.childs.length;
    document.reordersibs.parentid.value = data.parentId;
    
    //?
    container.innerHTML = container.innerHTML;
  }
  catch(e){
    alert("error in siblingorder.buildReorderingUI(): "+e.message)
  }
  
}

//manipulate the DOM (and the hidden formfield data) when the user clicks the re-ordering buttons:
function reOrder(itemIndex,direction){
  var swapItemIndex;    //this depends on the direction:
  if(direction == "up") swapItemIndex = itemIndex - 1;  
  else swapItemIndex = itemIndex + 1;
  var item = data.childs[itemIndex];
  var swapItem = data.childs[swapItemIndex];
  data.childs[swapItemIndex] = item;
  data.childs[itemIndex] = swapItem;
  buildReorderingUI(data);
}

function resetOrdering(){
  var x="";
  for(var a=0;a<data.childs.length;a++){
    x+= "curr: "+data.childs[a].nodeId + " orig: " + orig[a].nodeId + "\n";
  }
  data.childs = orig;
  buildReorderingUI(data);
}

</script>  
  
  <title>Reorder sibling items</title>
  </head>
  
  <body onload="buildReorderingUI(data);">
    <%=refresher%>
    <div id="container">
      <div id="editor_content">
      
       <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/layouts100x130.jpg" alt="Re-order siblings" />
          <h1>Re-order siblings</h1>
          <p>
          Re-order siblings...
          </p>
        </div>
      <div id="vt">
      
      <form name="reordersibs" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?nodeid=<%=node.id%>" method="post">
      
      <div id="previewpanel">
         <input type="text" name="action" value="update" />
         <input type="text" name="numitems" value="" />
         <input type="text" name="parentid" value="" />
        
        <span id="reorder_ui">
        <!-- dynamically generated table -->
        </span>
         
        <input type="button" value="Update order" name="apply" onclick="javascript:if(confirm('Save these changes?')){document.reordersibs.submit();}">
      </div>
      </form>
      </div>
        <p>
          [<a href="#" onclick="resetOrdering();return false;" title="Cancel any changes made to sibling order since your last save.">Reset</a>]
          [<a href="#" onclick="javascript:window.close();" title="Close this window">close</a>]
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



