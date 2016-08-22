<%
/*
render this:
<div class="thumbheader">Indi</div><img src="../images/indi_lge.jpg">
pass in PATH array?
*/
function getSectionImage(currNode,currPath){
  try{
    var out = '';
    var nav = new Navigation();
    var node = (new Viewtree()).getRoot();
    if(Request.QueryString("nodeid") && (new String(Request.QueryString("nodeid"))) != "undefined"){
      node = new Node(Request.QueryString("nodeid"));
    }

    var page;
    var path = nav.getBreadcrumb(node);
    var linkStart = "";
    var linkEnd = "";
    
    if(path && path.length>1){  //path may be false if the current page is at/near root
      for(var a=0;a<path.length;a++){
        if(path[a].level == 1){
          page = new Page(path[a].pageId);
          if(node.level >= 2){
            linkStart = "\n<a href=\"/ccms.asp?nodeid=" + path[a].id + "\" title=\"" + page.linkText + "\">\n\t";
            linkEnd = "</a>";
          }
          
          out = "<div class=\"thumbheader\">\n\t" + page.linkText;
          out += linkStart + "<img src='/images/" + page.name + "_lge.jpg' alt='" + page.linkText + "' width='110' height='120' />\n";
          out += linkEnd + "</div>\n";
        }
      }
    }
    return out;
  }
  catch(e){
    Response.Write("error in getSectionHeading(): " + e.message);
    return "";
  }
}
%>
