<%
/*
a singleton object that formats dates
*/
var dateUtils = new Object();

dateUtils.shortMonthFormat = new Array("01","02","03","04","05","06","07","08","09","10","11","12");

dateUtils.getShortDateTime = function(dateStr){
  try{
    var date = new Date(dateStr);
    var out = "";
    out = zeroPrefix(date.getDate()) 
    + "." 
    + this.shortMonthFormat[date.getMonth()] 
    + "." 
    + date.getYear() 
    + " " 
    + zeroPrefix(date.getHours()) 
    + ":" 
    + zeroPrefix(date.getMinutes())
    return out;
  }
  catch(e){
    return("error in dateUtils.getShortDateTime():" + e.message);
  }
},


dateUtils.getShortDate = function(dateStr){
  try{
    var date = new Date(dateStr);
    var out = "";
    out = zeroPrefix(date.getDate()) 
    + "." 
    + this.shortMonthFormat[date.getMonth()] 
    + "." 
    + date.getYear(); 
    return(out);
  }
  catch(e){
    return("error in dateUtils.getShortDate():" + e.message);
  }
},

//receive date string from DB, return date string in editor UI format (YYYY-MM-DD); or null:
dateUtils.getPropUIDateTime = function(dateStr){
  try{
    var out = null;
    if(dateStr !== null)
    {
      var date = new Date(dateStr);
      out = "";
      out = date.getYear()
      + "-" 
      + zeroPrefix(date.getMonth() + 1) 
      + "-" 
      + zeroPrefix(date.getDate());  
    }
    return out;
  }
  catch(e){
    return("error in dateUtils.getShortDateTime():" + e.message);
  }
},

//receive date string from DB, return date string in editor UI format (YYYY-MM-DD); or null:
dateUtils.getXMLDateTime = function(dateStr){
  try{
    var out = null;
    if(dateStr !== null)
    {
      var date = new Date(dateStr);
      out = "";
      out = date.getYear()
      + "-" 
      + zeroPrefix(date.getMonth() + 1) 
      + "-" 
      + zeroPrefix(date.getDate())
      + "T" + zeroPrefix(date.getHours())
      + ":" 
      + zeroPrefix(date.getMinutes())
      + ":" 
      + zeroPrefix(date.getSeconds())
      + "."
      + date.getMilliseconds()
    }
    return out;
  }
  catch(e){
    return("error in dateUtils.getShortDateTime():" + e.message);
  }
}

function zeroPrefix(inStr){
  var out = "";
  out += inStr;
  if(out.length === 1){
    out = "0" + out;
  }
  return(out);
}
%>
