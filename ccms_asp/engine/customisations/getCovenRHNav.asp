<%
function getCovenRHNav(currNode){ //nodelist,color
  /*
  LOGIC:
  Get L2 ancestor node
  Get all L2 sibs
  Get L3 im current path if present
  
  */
  
  try{
    var out = "";
    var a = 0;
    var l2Sibs;
    
    //get the direct children if current page is a main section page (L1):
    if(currNode.level == 1){  //render direct children as RH nav:
      out = getHTMLList(node.getChildren(),currNode);
    }
    
    //get siblings:
    if(currNode.level == 2){
      l2Sibs = (new Navigation()).getSiblings(currNode);
      out = "<ul>";
      for(a=0;a<l2Sibs.length;a++){
        currPage = new Page(l2Sibs[a].pageId);
        
        //get child list (if any) of SELF node:
        if(l2Sibs[a].isCurrentNode){
          out += "<li><span class='current_link'>" + currPage.linkText + "</span>\n";
          out += getHTMLList(l2Sibs[a].getChildren(),currNode);
          out += "</li>";
        }
        
        //otherwise, just render siblings:
        else{
          out += "<li><a href='/ccms.asp?nodeid=" + l2Sibs[a].id + "'title='" + currPage.linkText + "'>"+currPage.linkText + "</a></li>\n"
        }
      }
      out += "</ul>"
    }
    
    //get parent and sibs, get sibs:
    if(currNode.level == 3){
      var nav = new Navigation();
      l2Sibs = nav.getSiblings(currNode.getParent());
      
      var l2Parent = nav.getBreadcrumb(currNode)[2];  //index is equal to level
      
      out = "<ul>";
      for(a=0;a<l2Sibs.length;a++){
        currPage = new Page(l2Sibs[a].pageId);
        out += "<li>";
        out += "<a href=\"/ccms.asp?nodeid=" + l2Sibs[a].id + "\" title=\"" + currPage.linkText + "\">" + currPage.linkText + "</a>"
        
        //parent:
        if(l2Parent.id == l2Sibs[a].id){
          out += getHTMLList(l2Sibs[a].getChildren(),currNode);
        }
        out += "</li>";
      }
      out += "</ul>"
    }
    return out;
  }
  catch(e){
    Response.Write("error in getCovenRHNav(): " + e.message);
    return "";
  }
}

//utility function to return list of childs of current node as HTML list
function getHTMLList(nodeList,self){
  var out = "";
  if(nodeList.length > 0){
    var page;
    out += "<ul>";
    for(var x=0;x<nodeList.length;x++){
      page = new Page(nodeList[x].pageId);
      
      out += "<li>";
      if(nodeList[x].id == self.id){
        out += "<span class='current_link'>" + page.linkText + "</span>";
      }
      else{
        out += "<a href=\"/ccms.asp?nodeid=" + nodeList[x].id + "\" title=\"" + page.linkText + "\">" + page.linkText + "</a>"
      }
      out += "</li>";
    }
    out += "</ul>";
  }
  return out;
}
%>
