<%
function getShaldonL3Nav(nodelist){
  try{
    var out = '';
    if(nodelist){ //nodelist may be false if the current page is at/near root
      for(var a=0;a<nodelist.length;a++){
        page = new Page(nodelist[a].pageId);
        
        if(nodelist[a].isCurrentNode){
          out += '<span>' + page.linkText + "</span>";
        }
        else{
          out += '<a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodelist[a].id + '" class="subnav">' + page.linkText + "</a>";
        }
      }
    }
    return out;
  }
  catch(e){
    Response.Write("error in getShaldonL3Nav(): " + e.message);
    return "";
  }
}
%>
