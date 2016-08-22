<%
/*
demo nav function:
top nav
*/
function getTopNav(node){
  //showObject(node);
  var out = "";
  try{
    //Response.Write("topnav: "+node.hasChildren)
    if(node.hasChildren){
      var childs = node.getChildren();
      
      for(var a=0;a<childs.length;a++){
        if(childs[a].id != parseInt(Request.QueryString("nodeid"))){
          out+="<a href=ccms.asp?nodeid=" +childs[a].id + ">" + childs[a].getPage().linkText + "</a>";
        }
        else{
          out += childs[a].getPage().linkText;
        }
        if(a<childs.length-1){
          out += "&nbsp;|&nbsp;";
        }
      }
    }
    return out;
  }
  catch(e){
    Response.Write(e.message);
    return out;
  }
}
%>
