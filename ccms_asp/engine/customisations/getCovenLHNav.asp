<%
function getCovenLHNav(node,path,root){//nodelist,color
  /*
  LOGIC:
  Get L1 ancestor node
  Get all L1 sibs
  Compare L1 sibs and DONT output ancestor
  
  code:
  
  <div class='thumbnav'>Andi</div>
  <a href='/andi/andi.htm'>
    <img src='/images/andi_sml.jpg'>
  </a>
  */
  
  try{
    var out = "";
    if(node.level > root.level){
      var childs    = root.getChildren();
      var sectionNode;
      
      //determine section:
      for(var a=0;a<path.length;a++){
        if(path[a].level == 1){
          sectionNode = path[a];
        }
      }
  
      var page;
      for(a=0;a<childs.length;a++){
        if(childs[a].id != sectionNode.id){
          page = new Page(childs[a].pageId);
          out += "<div class='thumbnav'>" + page.linkText + "</div><a href='/ccms.asp?nodeid=" + childs[a].id + "'><img src='/images/" + page.name + "_sml.jpg' alt='" + page.linkText + "' /></a>\n";
        }
      }
    }
    return out;
  }
  catch(e){
    Response.Write("error in getCovenLHNav(): " + e.message);
    return "";
  }
}
%>
