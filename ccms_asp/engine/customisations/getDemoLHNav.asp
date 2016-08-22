<%
function getDemoTopNav(startNode,currentNode)
{
  
  try
  {
    var out = "<ul class=\"box\">";
    var childs    = startNode.getChildren();

    childs.reverse();
    childs.push(startNode);
    childs.reverse();
    var _class = "";

    for(var a=0;a<childs.length;a++)
    {
      var page = new Page(childs[a].pageId);
      // class="nav-active"
       //reset
       _class = "";
      if(childs[a].id == currentNode.id)
      {
        _class = " class=\"nav-active\"";
      }
      out += "<li" + _class + "><a href='/ccms.asp?nodeid=" + childs[a].id + "'>"+page.linkText+"</a>";
      out += "</li>\n";
      
    }
    out += "</ul>"
    return out;
  }
  catch(e)
  {
    Response.Write("error in getDemoTopNav(): " + e.message);
    return "";
  }
}
%>
