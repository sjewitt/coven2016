<%
/*
demo nav function:
home link
*/
function getBreadcrumb(node){
  try{
    var nav = new Navigation();
    var bc = nav.getBreadcrumb(node);
    var out = "";
    
    for(var a=0;a<bc.length;a++){
      if(bc[a].id != node.id){
        out += "<a href=\"/ccms.asp?nodeid=" + bc[a].id + "\">" + bc[a].getPage().linkText + "</a>&nbsp;&gt;&gt;&nbsp;";
        }
        else{
          out += "<b>" + bc[a].getPage().linkText + "</b>";
        }
    }
    
    return out;
  }
  catch(e){
    Response.Write("error in getBreadcrumb(): "+e.message);
    return "";
  }
}
%>
