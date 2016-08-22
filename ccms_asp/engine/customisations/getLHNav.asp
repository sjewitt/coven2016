<%
/*
demo nav function:
Left nav
*/
function getLHNav(root){
  try{
    //var vt = new Viewtree();
    //var root = vt.getRoot();
    var childs = root.getChildren();
    var out = "<ul>\n";
    for(var a=0;a<childs.length;a++){
      if(childs[a].id != parseInt(Request.QueryString("nodeid"))){
        out+="<li><a href=ccms.asp?nodeid=" +childs[a].id + ">" + childs[a].getPage().linkText + "</a></li>\n";
      }
      else{
        out+="<li>" + childs[a].getPage().linkText + "</li>\n";
      }
    }
    out += "</ul>\n";
    return out;
  }
  catch(e){
    Response.Write(e.message);
    return out;
  }
}
%>
