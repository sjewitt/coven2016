<%
function getLatestNews(){
  try{
    var out = "";
    var a = 0;
    var query = new Query();
    //if no contentid
    query.setQuery("select id,name from content where content_type=1");
    query.execute();
    for(a=0;a<query.resultObject.length;a++){
      out += "<a href=\"/ccms.asp?nodeid=" + Request.QueryString("nodeid") + "&amp;contentid=\"" + query.resultObj[a].id + "\" title=\"" + query.resultObj[a].name + "\>" + query.resultObj[a].name + "</a>\n";
    }
    //else
    return "TODO!";
  }
  catch(e){
    
  }
  
}
%>
