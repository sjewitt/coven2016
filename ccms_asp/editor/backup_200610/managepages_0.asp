<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
//var lm = new LayoutManager();
var inNode = (new Viewtree()).getRoot();
if(parseInt(Request.QueryString("nodeid"))){
  inNode = new Node(parseInt(Request.QueryString("nodeid")));
}

var refresher = "";

//evaluate user session:
var currentUser = userFactory.getCurrentUser();

//perhaps abstract this to a generic function?
/*
function getNodeLinks(nodeArray){
  try{
    var out = new Array();
    for(var a=0;a<nodeArray.length;a++){
      //TODO: GET PATH HERE.
      out.push('<a href="#" onclick="reloadOpener(\'/ccms.asp?nodeid=' + nodeArray[a].id + '\');">ref ' + eval(a+1) + '</a>');
    }
    return out.join(", ");
  }
  catch(e){
    
  }
}
*/

if(currentUser){
  var node = (new Viewtree()).getRoot(); 
  if((new String(Request("nodeid"))) != 'undefined'){
    node = new Node(parseInt(new String(Request("nodeid"))));
  }
  var pageId = 0;
  var pageName = "";
  var page = new Object();
  page.name = "";
  if(parseInt(Request.QueryString("pageid"))){
    pageId = parseInt(Request.QueryString("pageid"));
    page = new Page(pageId);
    pageName = page.name;
  }
  
  var vt = new Viewtree();
  
  //return an array of pages (filter by auth?)
  var pageList = renderUtils.getAllPages();
  var pageListOptions = "";
  var refCount = 0;
  var alternator = "#ddd;";
  for(var a=0;a<pageList.length;a++){
    pageListOptions += "\t<tr style='background-color:" + alternator + "'>\n\t\t"
          + "<td style=\"padding-left:10px;\"><a href=\"/ccms_asp/editor/managepages.asp?pageid=" + pageList[a].id + "\">" + pageList[a].name + "</a></td>\n\t\t\n\t\t"
          + "<td style=\"padding-left:10px;\">" + editUtils.getNodeLinks(vt.getVTRefs(pageList[a])) + "</td>"
          + "<td>";
    
    //call editUtils to get dropdown of options based on user's rights - moved the condition there.:
    if(pageId == pageList[a].id){
      refCount = vt.getVTRefCount(pageList[a]);
      pageListOptions += editUtils.getPageEditOptions(currentUser,refCount);
    }
    pageListOptions += "</td>\n\t</tr>\n";
    if(alternator=="#ddd;") alternator="#eee;";
    else alternator="#ddd;";
  }
  
%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
 
  <%=EDITOR_CSS%>
  <%=EDITOR_JAVASCRIPTS%>
  
  <script type="text/javascript">
  <!--
  /* 
  Open the selected viewtree ref in the parent window: 
  */
  function reloadOpener(newloc){
    window.opener.location = newloc;
  }
  
  
  function popup(url,width,height){
	 var win = window.open(url,'popup','width=' + width + ',height=' + height + ',toolbar=0,resizable=1,scrollbars=1');
	 win.resizeTo(width,height);
	 win.focus();
  }
  
  function doAction(form){
    try{
      
      switch(form.action.value){
        case "add":
          if(confirm("you are about to ADD page '<%=pageName%>' to the viewtree. Are you sure?")){
            //<a href="#" onclick="popup('/ccms_asp/editor/addtoviewtree.asp?pageid=< %  =newPageId %  >',700,600);">ADD</a>
            //document.location = "/ccms_asp/editor/addtoviewtree.asp?pageid=" + form.pageid.value;
            popup("/ccms_asp/editor/addtoviewtree.asp?pageid=" + form.pageid.value, <%=SIZE_ADD_TO_VT%>);
          }
        break;
        case "managevt":
          if(confirm("you are about to perform action ACTION on page '<%=page.name%>' (msg TODO)")){
            //document.location = "/ccms_asp/editor/manageviewtree.asp?pageid=" + form.pageid.value;
          }
        break;
        case "delete":
          if(confirm("you are about to perform action ACTION on page '<%=page.name%>' (TODO)")){
          
          }
        break;
        
        case "properties":
          if(confirm("Modify page '<%=page.name%>' properties?")){
            //document.location = "/ccms_asp/editor/pageproperties.asp?pageid=" + form.pageid.value;
            popup("/ccms_asp/editor/pageproperties.asp?pageid=" + form.pageid.value, <%=SIZE_PROPS_PAGE%>);
          }
        break;
        
        case "xx":
        
        break;
      
      }
    }
    catch(e){
    
    }
  }
  //-->
  </script>
  <title>Manage All Pages</title>
  </head>
  <body>
    <%=refresher%>
    <div id="container">
      <div id="editor_content">
      
       <div style="height:130px;">
          <img style="float:left;padding-right:20px;" src="/ccms_asp/editor/images/pages100x130.jpg" alt="Create page" />
          <h1>Manage All Pages</h1>
          <p>
            This option shows all pages in the system, and indicates the occurrence(s) in the navigation hierarchy (the Viewtree). You can
            
          </p>
        </div>
        <div id="vt">
          
          <form name="updatelayout" action="<%=Request.ServerVariables("SCRIPT_NAME")%>?nodeid=<%=Request.QueryString("nodeid")%>" method="post">
            <input type="hidden" name="pageid" value="<%=pageId%>" />
              <div id="previewpanel"><!-- style="border:1px solid black;padding:5px;width:600px;height:300px;overflow:auto;" TODO: MOVE TO CSS -->
                <table>
                  <tr style="font-weight:bold;background-color:#bbb;">
                    <td style="padding-left:10px;width:150px;">Page</td>
                    <td style="padding-left:10px;width:150px;">Viewtree References</td>
                    <td style="padding-left:10px;width:250px;">Available 'Page' actions</td>
                  </tr>
                
                <%=pageListOptions%>
                
                      </table>
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



