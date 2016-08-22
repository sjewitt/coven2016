<%
function getShaldonNews(){
   try{
    var out = "";
    
    if(Request.QueryString("newsid") && (new String(Request.QueryString("newsid"))) != "undefined"){
      var newsItem = new Content(Request.QueryString("newsid"));
      out = "<h2>" + newsItem.description + "</h2>";
      out += newsItem.getActiveInstance().content;
      out += "<p>[<a href=\"/ccms.asp?nodeid=" + Request.QueryString("nodeid") + "\" title=\"Back\">All News</a>]</p>"
    }
    
    else{
      /*
      get the list TODO: paginate etc...
      */
      out = "<ul>";
      var a = 0;
      var query = new Query();
      query.setQuery("select id,name,description,start_date,created_user,updated_date,updated_user,auth_group from content where content_type=2 order by start_date desc;");
      query.execute();
      for(a=0;a<query.resultObject.length;a++){
        out += "<li><a href=\"/ccms.asp?nodeid=" + Request.QueryString("nodeid") + "&amp;newsid=" + query.resultObject[a].id + "\" title=\"" + query.resultObject[a].description + "\">" + query.resultObject[a].description + "</a>\n";// ("+dateUtils.getShortDate(query.resultObject[a].start_date)+")</li>\n";
      }
      out += "</ul>";
    }
    
    return out;
  }
  catch(e){
    Response.Write("error in getCovenNews(): " + e.message);
    return "";
  }
}
%>
