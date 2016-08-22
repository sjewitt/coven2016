<%
//in: child array of current node:
function getHomeNav(childs){
  try{
    var out = "";
  /*
  Generate this:
  <div class="homepagethumbs"><div class="thumbheader">Indi</div><a href="indi/indi.htm"><img src="../images/indi.jpg" width="90" height="90" border="0"></a></div>
  */

    var currPage;
    var prefix = "<div class=\"homepagethumbs\"><div class=\"thumbheader\">";
    var suffix = "</a></div>\n";
    for(var a=0;a<childs.length;a++){
      currPage = new Page(childs[a].pageId);
      out += "<div class=\"homepagethumbs\"><div class=\"thumbheader\">" 
          + currPage.linkText 
          + "</div><a href=\"\ccms.asp?nodeid=" 
          + childs[a].id 
          + "\" title=\"" 
          + currPage.linkText 
          + "\"><img src=\"/images/" 
          + currPage.name
          + "_home.jpg\" alt=\"" + currPage.linkText + "\" />" 
          + suffix;
    }
    return out;
  }
  catch(e){
    Response.Write("Error in getHomeNav(): " + e.message);
    return out;
  }
}
%>
