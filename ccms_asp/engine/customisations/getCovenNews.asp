<%
function getCovenNews(){
   try{
    var out = "";
    
    if(Request.QueryString("newsid") && (new String(Request.QueryString("newsid"))) != "undefined"){
      out = (new Content(Request.QueryString("newsid"))).getActiveInstance().content;
      out += "<p>[<a href=\"/ccms.asp?nodeid=" + Request.QueryString("nodeid") + "\" title=\"Back\">All News</a>]</p>"
    }
    
    else{
      /*
      get the list TODO: paginate etc...
      */
      out = "<ul>";
      var a = 0;
      var query = new Query();
      query.setQuery("select id,name,created_date,created_user,updated_date,updated_user,auth_group from content where content_type=2 order by created_date desc;");
      query.execute();
      for(a=0;a<query.resultObject.length;a++){
        out += "<li><a href=\"/ccms.asp?nodeid=" + Request.QueryString("nodeid") + "&amp;newsid=" + query.resultObject[a].id + "\" title=\"" + query.resultObject[a].name + "\">" + query.resultObject[a].name + "</a></li>\n";
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
