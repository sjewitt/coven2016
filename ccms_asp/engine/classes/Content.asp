  <%
/*
Class representing a content object.
It is a wrapper for common properties (linktext, ID etc.)
and is the FK to the array of ContentVersion objects.

DB core fields for Content:
id            int, PK
linktext      varchar
authGroup     int, FK GROUPS
createdDate   date
updatedDate  date

Other properties are mapped from the associated objects:
*/
function Content(id){
  //this.logger                = log4CCMS.init();
  this.name                  = null;
  this.description           = "";
  this.id                    = null;
  this.authGroup             = 0;
  this.createdUser           = 0;
  this.createdDate           = new Date();
  this.updatedUser           = 0;
  this.updatedDate           = new Date();
  this.validFrom             = null;
  this.validTo               = null;
  //this.contentInstanceArray  = new Array();

  /*
  'constructor'.
  If an ID is passed, set the property and retrieve the instancelist:
  */
  if(id){ 
    try{ 
      this.id           = parseInt(id);
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      
      //populate the CORE content properties (Name, ID, authGroup, createdDate,updatedDate)
      //(TODO: Check for multiple items/zero items.)
      var contentSql = "select name,description,created_date,created_user,updated_date,updated_user,auth_group,content_type,start_date,end_date from content where id=" + this.id;
   
      recordset = connection.execute(contentSql);

      //populate the values:
    this.name         = new String(recordset("name"));
    //if(new String(recordset("description")) != "null") 
    this.description  = new String(recordset("description"));
    this.createdDate  = new Date(recordset("created_date"));
    this.createdUser  = parseInt(recordset("created_user"));
    this.updatedDate  = new Date(recordset("updated_date"));
    this.updatedUser  = parseInt(recordset("updated_user"));
    this.authGroup    = parseInt(recordset("auth_group"));
    this.contentType  = parseInt(recordset("content_type"));
    if(new String(recordset("start_date")) != "null") this.validFrom    = new Date(recordset("start_date"));
    if(new String(recordset("end_date")) != "null") this.validTo      = new Date(recordset("end_date"));
      
      recordset.close();
      recordset = null;

      connection.close(); 
      connection = null;
    }
    catch(e){
      recordset = null;
      connection = null;
      Response.Write("Error in Content constructor: Supplied ID: " + id + ", Error: "+e.message);
    }
  }
  
  //retrieve the content list associated with this Content:
  Content.prototype.getInstanceList = function(){
    try{
      var contentInstanceArray = new Array();
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      
      //SQL to retrieve all versions for current content:
      var instSQL = "select id,version_id from content_version where content_id = " + this.id + " order by version_id;";
      recordset = connection.execute(instSQL);
      
      while(!recordset.EOF){
        contentInstanceArray.push(new ContentInstance(recordset("id")));
        recordset.MoveNext();
      }
      //END
      recordset.close();
      recordset   = null;
      connection.close(); 
      connection  = null;
      
      //return the instancelist:
      return contentInstanceArray;
    }
    catch(e){
      Response.Write("error in Content.getInstanceList(): " + e.message);
      recordset   = null;
      connection  = null;
      return null;
    }
  }
  /*
  Get a specified instance of the content:
  */
  Content.prototype.getInstance = function(instanceId){
    try{
      var contentInstance;
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      
      var instSQL = "select id from content_version where content_id = " + this.id +" and instance_id=" + instanceId;
      recordset = connection.execute(instSQL);
      
      contentInstance = new ContentInstance(recordset("id"));

      //END
      recordset.close();
      recordset   = null;
      connection.close(); 
      connection  = null;
      
      //return the instancelist:
      return contentInstance;
    }
    catch(e){
      recordset   = null;
      connection  = null;
      return null;
    }
  }
  
  /*
  get the current most recent active instance
  */
  Content.prototype.getActiveInstance = function(){
    try{
      var contentInstance;
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      
      var instSQL = "select top 1 (id) from content_version where content_id = " + this.id +" and state_id=" + State.ACTIVE +" order by version_id desc";

      recordset = connection.execute(instSQL);
      if(!recordset.EOF){
        contentInstance = new ContentInstance(recordset("id"));
        recordset.close();
        recordset   = null;
        connection.close(); 
        connection  = null;
        return contentInstance;
      }
      else{
        return false;
      }
    }
    catch(e){
      recordset   = null;
      connection  = null;
      Response.Write("error in Content.getActiveInstance(): " + e.message);
      return null;
    }
  }
  
  //get most recent instance regardless of state
  Content.prototype.getLatestInstance = function(){
    try{
      var contentInstance;
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      
      var instSQL = "select top 1 (id) from content_version where content_id = " + this.id +" order by version_id desc";

      recordset = connection.execute(instSQL);
      if(!recordset.EOF){
        contentInstance = new ContentInstance(recordset("id"));
        //END
        recordset.close();
        recordset   = null;
        connection.close(); 
        connection  = null;
        //return the instance:
        return contentInstance;
      }
      else{
        return false;
      }
    }
    catch(e){
      recordset   = null;
      connection  = null;
      Response.Write("error in Content.getLatestInstance(): " + e.message);
      return null;
    }
  }  
  
  
  Content.prototype.getCreatedUser = function(){
    return new User(this.createdUser);
  }
  
  Content.prototype.getUpdatedUser = function(){
    return new User(this.updatedUser);
  }
}
%>
