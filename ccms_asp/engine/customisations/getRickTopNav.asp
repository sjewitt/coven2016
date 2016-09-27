<%
function getRickTopNav(root){
  try{
    var childs = root.getChildren();
    var grandchilds;
    var out = "<ul>\n";
    for(var a=0;a<childs.length;a++){
      out += "\t<li><a href=ccms.asp?nodeid=" +childs[a].id + ">" + childs[a].getPage().linkText + "</a>\n";
      if(childs[a].hasChildren){
         out += "\t\t<ul>\r\n";
        grandchilds = childs[a].getChildren();
        for(var b=0;b<grandchilds.length;b++){
          out += "\t\t\t<li><a href=\"ccms.asp?nodeid=" + grandchilds[b].id + "\">" + grandchilds[b].getPage().linkText + "</a></li>\r\n";
        }
        out += "\t\t</ul>\r\n";
      }
      out += "\t</li>\r\n";
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
