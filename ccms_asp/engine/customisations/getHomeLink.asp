<%
/*
demo nav function:
home link
*/
function getHomeLink(root){
  try{
    var out = "<a href=ccms.asp?nodeid=" + root.id + ">" + root.getPage().linkText + "</a>";
    if(root.id == parseInt(Request.QueryString("nodeid")))
      out = root.getPage().linkText;
    return out;
  }
  catch(e){
    Response.Write("error in getHomeLink(): "+e.message);
    return "";
  }
}
%>
