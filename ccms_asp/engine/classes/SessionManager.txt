  <%
/*
Class encapsulating bespoke session management. Use if deployed in a shared 
hosting environment, or the ASP Session object cannot be relied upon.

Description:
*/
function SessionManager(){
  //this.logger                = log4CCMS.init();
  this.id                    = null;                //a GUID
  //this.userData              = "";               //hydrated user data string
  this.active                = false;
  this.sessionGUID           = "";

  //input parameters come from userFactory:
  SessionManager.prototype.createSession = function(userId){
    try{
      if(userId && userFactory.getUser(userId)) { //perhaps some better checking?
        //get user data (load the user)
        //this.userData = userData
        this.sessionGUID = this.getGUID();
        //serialise it
      
        //drop a row into the database with parsed time as GUID, the user ID and an 'active' flag
        var connection    = Server.CreateObject("ADODB.Connection");
        connection.open(renderUtils.getConnectionString());
        var recordset     = Server.CreateObject("ADODB.Recordset");
        
        var SQL = "insert into session_data(session_id,user_id,user_data,active,session_opened) values ('" 
          + this.sessionGUID + "',"
          + userId +",'"
          + userFactory.getSerialisedUserData(userId).replace(/'/g,"''") +"',1,GETDATE());";
        //Response.Write(SQL);
        connection.execute(SQL);
        connection.close(); 
        connection  = null;  
        
        //set the cookie:
        Response.Cookies("CCMSSESSIONGUID") = this.sessionGUID;
        
      }
      else{
        throw new Error("cannot instantiate a session without a valid user ID.");
      }
      return this.sessionGUID;   //this is used to populate the cookie for this session
    }
    catch(e){
      Response.Write("error in SessionManager.createSession(): " + e.message);
      return false;
    }
  }

  /*
  Retrieve the serialised string from the database
  and return a user data object as per other method.
  */
  SessionManager.prototype.getUserData = function(sessionGUID){ //from cookie
    try{
      var userData = new Object();
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");

      var SQL = "select user_data from session_data where session_id = '" + sessionGUID + "' and active=1;";
      recordset = connection.execute(SQL);
      
      var userDataString = recordset("user_data")+"";
      userData = eval(userDataString);
      
      recordset.close();
      recordset   = null;
      connection.close(); 
      connection  = null;
      
      if(userData == undefined){
        //Response.Write("XXXXXXXXXXXXXXXXXX")
        userData = false;
      }

      return userData;
    }
    catch(e){
      Response.Write("error in SessionManager.getUserData(): " + e.message);
      recordset   = null;
      connection  = null;
      return null;
    }
  }
  /*
  Expire the session. Set flag to inactive and insert a session close datetime
  and kill the cookie
  */
  SessionManager.prototype.expireSession = function(sessionGUID){  //from cookie
    try{
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      
      var SQL = "update session_data set active = 0 where session_id='" + sessionGUID +"';";
      connection.execute(SQL);

      //END
      connection.close(); 
      connection  = null;
      
    }
    catch(e){
      Response.Write("error in SessionManager.expireSession(): " + e.message);
      connection  = null;
      return null;
    }
  }
    /*
  SessionManager.prototype.getSerialisedUserData = function(userId){
    try{
      user = new User(userId);
      
      //toSource() does not work for SSJS!
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
  */
  SessionManager.prototype.getGUID = function(){
    var guid = CreateGUID(32);
    // + "-" +
    //CreateGUID(4) + "-" +
    //CreateGUID(4) + "-" +
    //CreateGUID(4) + "-" +
    //CreateGUID(12);
    
    return guid;
  }
}

//static utility method:
function CreateGUID(tmpLength){
  var tmpCounter;
  var tmpGUID = "";
  var strValid = "0123456789ABCDEF";
  
  var index = 0;
  
  for(tmpCounter = 0;tmpCounter < tmpLength; tmpCounter++){ 
    index = parseInt(Math.random() * (strValid.length - 1))
    tmpGUID += strValid.charAt(index);
  }
  return tmpGUID;
}  
  
%>

