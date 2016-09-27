<%
var adminUtils = new Object();



/*
Build an abstract User object from submitted form data
*/
adminUtils.buildUser = function(formObject){
  Response.Write("<br>.-> Building user for update:<br>")
  var usr = new User()
  var isActive = false;
  usr.login = formObject("login");
  usr.password = formObject("password")
  usr.fullName = formObject("fullname")
  usr.email = formObject("email")
  usr.permissions = parseInt(formObject("permissions"))
  if(formObject("enabled") == "true"){ 
    Response.Write("ACTIVE!<br>");
    isActive = true;
  } 
  usr.active = isActive
  
  Response.Write("-> Returning this user object:<br>");
  showObject(usr);
  
  return(usr);
}

/*
TODO: Passin a User object instead
*/
adminUtils.addUser = function(login,password,fullname,email,permissions,active,user){
  try{
    if(
      login.length > 0 
      && password.length>0
      && fullname.length>0
      && email.length>0
      ){
    var activeVal = "0";
    if(active) activeVal = "1";
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var updateSQL = "insert into users(login,password,fullname,email,permissions,active) values ('" + login + "', '" + password + "', '" + fullname + "', '" + email + "'," + permissions + "," + activeVal + ");";
    //var updateSQL = "insert into users(login,password,fullname,email,permissions,active) values ('" + user.login + "', '" + user.password + "', '" + user.fullName + "', '" + user.email + "'," + user.permissions + "," + activeVal + ");";

    connection.execute(updateSQL);
    connection.close(); 
    connection = null;
    return true;
    }
    else{
      return false;
    }
  }
  catch(e){
    Response.Write("error in adminUtils.addUser(): "+e.message);
    recordset = null;
    connection = null;
    return false;
  }
}

/*
Update a user record:
*/
adminUtils.updateUser = function(user)
{
  Response.Write("begin update<br />");
  try
  {
    //if(login.length > 0 && password.length>0 && fullname.length>0 && email.length>0){
      var activeVal = "0";
      if(user.active) activeVal = "1";
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var updateSQL = "update users set login='" + this.sqlEscape(user.login) 
          + "',password='" + this.sqlEscape(user.password) 
          + "',fullname='" + this.sqlEscape(user.fullName) 
          + "',email='" + this.sqlEscape(user.email) 
          + "',permissions=" + user.permissions 
          + ", active=" + activeVal 
          + " where id=" + user.id + ";";
          
          Response.Write("<xmp>SQL: "+updateSQL+"</xmp>");
      connection.execute(updateSQL);
      connection.close(); 
      connection = null;
      return true;
    //}
    //else{
    //  return false;
    //}
  }
  catch(e){
    Response.Write("error in adminUtils.updateUser(): "+e.message);
    recordset = null;
    connection = null;
    return false;
  }
}

/*
return an array of all User objects
*/
adminUtils.getAllUsers = function(){
  var query = new Query();
  try{
    query.setQuery("select id from users order by login;");
    query.execute();
    var userList = query.resultObject; 
    var out = new Array();
    for(var a=0;a<userList.length;a++){
      out.push(new User(userList[a].id));  
    }
    query.closeRecordset();
    query.close();
    return out; 
  }
  catch(e){
    query.closeRecordset();
    query.close();
      var err = "";
      for(p in e){
        err += p +"="+e[p]+"<br>"; 
      }
    Response.Write(err);
    return false;
  }
}

/*
Admin User editing functions:
*/

adminUtils.isSet = function(usr,perm){
  var out = '';
  if(usr){
    if(usr.permissions & perm){
       out = ' checked="checked"';
    }
  }
    return(out);
}

adminUtils.getPermsCheckboxes = function(){
  var out = "";
  for(p in Permissions){
    out += '<input type="checkbox" name="permission" value="' + Permissions[p] + '"' + this.isSet(usr,Permissions[p]) + ' onclick="setPerms();" />' + p + '<br />\n';
  }
  return out;
}

adminUtils.getCurrentUsersDropdown = function(){
  
  var userlist = adminUtils.getAllUsers();
  var out = '<option value="">[  Add new user  ]</option>\n';
  var selected = '';
  for(var a=0;a<userlist.length;a++){
    selected = '';
    if(userlist[a].id == parseInt(Request.QueryString("userid"))) selected = ' selected="selected"';
    out += '<option value="' + userlist[a].id + '"' + selected + '>'+userlist[a].fullName+'</option>\n';
  }
  
  return out;
}



/*
return an array of ContentType objects
*/
adminUtils.getCurrentContentTypes = function(){
  var query = new Query();
  try{
    query.setQuery("select id,name,description from content_types;");
    query.execute();
    return query.resultObject;
  }
  catch(e){
    query.closeRecordset();
    query.close();
      var err = "";
      for(p in e){
        err += p +"="+e[p]+"<br>"; 
      }
    Response.Write(err);
    return false;
  }
}


adminUtils.getCurrentContentTypesDropdown = function(cTypeList){
  var out = '<option value="">[Add new content type  ]</option>\n';  
  try{
    //var contentTypes = adminUtils.getCurrentContentTypes();
    
    var selected = '';
    for(var a=0;a<cTypeList.length;a++){
      selected = '';
      if(cTypeList[a].id == parseInt(Request.QueryString("contenttypeid"))) selected = ' selected="selected"';
      out += '<option value="' + cTypeList[a].id + '"' + selected + '>'+cTypeList[a].name+'</option>\n';
    }
    
    return out;
    }
    catch(e){
      out = e.message;
      return out;
    }
}


/*
retrieve a Content Type:
*/
adminUtils.getContentType = function(contentTypeId){
  var query = new Query();
  try{
    if(parseInt(contentTypeId)){
      var out = new Object();
      query.setQuery(" select id,name,description from content_types where id=" + contentTypeId);
      query.execute();
      out = query.resultObject;

      query.closeRecordset();
      query.close();
      
      return out[0];  //there should be only one
    }
    else{
      throw new Error("Supplied content type ID parameter (" + contentTypeId + ") is not an integer.");
    }
  }
  catch(e){
    query.closeRecordset();
    query.close();
      var err = "";
      for(p in e){
        err += p +"="+e[p]+"<br>"; 
      }
    Response.Write(err);
    return false;
  }
}

/*
insert a new Content Type:
*/
adminUtils.addContentType = function(contentType){
  try{
    var query = new Query();
    var queryString = "insert into content_types(name, description) values('" + contentType.name + "','" + contentType.description + "')";
    query.insert(queryString);
  }
  catch(e){
    
  }
}

/*
update a Content Type:
*/
adminUtils.updateContentType = function(contentType){
  try{
    var query = new Query();
    var queryString = "update content_types set name='" + contentType.name + "', description='" + contentType.description + "' where id=" + contentType.id;
    query.insert(queryString);
  }
  catch(e){
    
  }
}

/*
delete a new Content Type:
*/
adminUtils.deleteContentType = function(contentType){
  try{
    var query = new Query();  
    var queryString = "delete from content_types where id = " + contentType.id;
    query.del(queryString);
    
  }
  catch(e){
    
  }
}


adminUtils.sqlEscape = function(str){
  //ensure the incoming object is in fact at String:
  str = str + "";
  Response.Write("I AM A: "+typeof(str));
  str = str.replace(/'/g,"''");
  
  return str;
}



%>
