<%
var userFactory = new Object();

//return a user, or false;
userFactory.login = function(login,password){
  try{
    var user = false;
    //login a user:
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var recordset     = Server.CreateObject("ADODB.Recordset");
    
    var count = 0;
    var countSql = "select count (*) as count from users where active=" + State.ACTIVE + " and login='" + login + "' and password='" + password + "'";
    recordset = connection.execute(countSql);
    count         = parseInt(recordset("count"));

    if(count == 1){
      var sql = "select id from users where active=" + State.ACTIVE + " and login='" + login + "' and password='" + password + "'"; 
      var recordset = connection.execute(sql);

      user = new User(parseInt(recordset("id")));
      
      if(SESSIONTYPE == "asp"){
        var src = this.getSerialisedUserData(parseInt(recordset("id")));
        Session("currentUser")  = src;
      }
      else if(SESSIONTYPE == "internal"){
        var sessionMgr = new SessionManager();
        var guid = sessionMgr.createSession(parseInt(recordset("id")));
      }
    }
    recordset.close();
    recordset = null;
    connection.close();
    connection = null;
    
    return user;
    
  }
  catch(e){
    if(connection) connection.close();
    connection = null;
    //error trap
    Response.Write("error in userFactory.login(): "+e.message);
    return false;
  }
}

//returns a User representing the currently logged-in user, or false.
userFactory.getCurrentUser = function(){
  try{
    //evaluate user session:
    var currentUser = false;
    
    if(SESSIONTYPE == "asp"){
      if(Session("currentUser") != null){
        currentUser = eval(Session("currentUser"));
      }
    }
    else if(SESSIONTYPE == "internal"){
      var sessionMgr = new SessionManager();
      currentUser = sessionMgr.getUserData(Request.Cookies("CCMSSESSIONGUID"));
    }
    
    else{
      throw new error("cannot determine SESSIONTYPE.");
    }
    
    return currentUser;
  }
  catch(e){
    Response.Write("error in userFactory.getCurrentUser(): " + e.message);
    return false;
  }
}

//get a user:
userFactory.getUser = function(userId){
  try{
    var user = new User(userId);
    if(user.exists){
      return user;
    }
    else{
      return false;
    }
  }
  catch(e){
  
  }
}

userFactory.getSerialisedUserData = function(userId){
    try{
      user = new User(userId);

      var src = "({";
      src += "id:"           + user.id         + ",";
      src += "login:'"       + user.login      + "',";
      src += "email:'"       + user.email      + "',";
      src += "fullName:'"    + user.fullName   + "',";
      src += "permissions:"  + user.permissions;
      src += "})";
      
      return src;
    }
    catch(e){
    
    }
  }
 
%>
