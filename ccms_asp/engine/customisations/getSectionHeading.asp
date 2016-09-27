<%
function getSectionHeading(node,path){
  try{
    var out = '';
    var nav = new Navigation();
    //var bc = nav.getBreadcrumb(node)
    //showObject(path)
    
    var page;
    if(path){  //path may be false if the current page is at/near root
      for(var a=0;a<path.length;a++){
        page = new Page(path[a].pageId);
        //if(path[a].isCurrentNode){
        //  out += page.linkText;
        //}
        //else{
        //  out += "<a href='/ccms.asp?nodeid='" + path[a].id + "' title='" + page.linkText + "'>" + page.linkText + "</a>&nbsp:&nbsp;";
        //}
        
        if(path[a].level == 1){
          page = new Page(path[a].pageId);
          out = page.linkText;
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
