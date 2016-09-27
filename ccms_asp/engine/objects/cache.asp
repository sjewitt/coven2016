<%
var cache = new Object();

/*
These methods use the ASP Application.Contents collection.
Each cached datum is actually using two Application vars:
 - the data, and
 - the UTC timestamp of the time of storage
This object also contains a private method that compares NOW with this time
to determine if the cached object has expired.

The default time to cache is in the config file.
*/

/*
boolean. does the cache contain an entry under key:
*/
cache.contains = function(key){
  try{
    var now = Date.parse(new Date());
    if(Application(key) && (Application(key + "_time")-now) > 0){
      return true;
    }
    else{
      Application(key) = false;
      return false;
    }
  }
  catch(e){
    return false;
  }
}

//retrieve data stored under key
cache.get = function(key){
  try{
    //Response.Write("retrieving data for " + key + ":<br>");
    return Application(key);
  }
  catch(e){
    return false;
  }
}

//store data 'data' under key 'key'. optional cachetime over-rides the default
cache.store = function(key,data,cachetime){
  try{
    //Response.Write("storing data under key " + key + ":<br>");
    Application(key) = data;
    Application(key+"_time") = (Date.parse(new Date()) + (CACHETIMEOUT * 1000));
    return true;
  }
  catch(e){
    return false;
  }
}

//returns a boolean
function hasExpired(key){

}

%>
