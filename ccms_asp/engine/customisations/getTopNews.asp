<%
function getTopNews(numToGet){
  try{
    //var newsNodeId=4;  //interrogate for the news page?
    var newsNodeId=10; 
    var out = "";
    var a = 0;
    var query = new Query();
    
    //TODO: Do as prepared statement
    
    query.setQuery("select top " + numToGet + " id,description,start_date,GETDATE() as now from content where content_type=2 and start_date <= GETDATE() order by start_date desc");
    query.execute();
    
    if(query.resultObject.length > 0){
      out += "<span class=\"date\">" + formatDate(query.resultObject[a].start_date) + "</span><br />";
      out += "<a href=\"/ccms.asp?nodeid=" + newsNodeId + "&amp;newsid=" + query.resultObject[a].id + "\" title=\"" + query.resultObject[a].description + "\">" + query.resultObject[a].description + "</a>\n";
    }
    else{
      out = "No data."
    }
    return(out);
  }
  catch(e){
    Response.Write("error in customised layout getTopNews(): "+e.message+"<br />")
    return "";
  }
}

function formatDate(dateStr){
  var date = new Date(dateStr);
  var months = ["01","02","03","04","05","06","07","08","09","10","11","12"];
  var dstr = date.getDate().toString();
  return((dstr.length==2?dstr:"0"+dstr) + "." + months[date.getMonth()] + "." + date.getFullYear());
}
%>
