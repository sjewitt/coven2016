<%
/*
Represents an individual content instance. Maps to DB table CONTENTINSTANCE:

id            int, PK
contentId     int, FK to CONTENT
instanceNum   int, version number
content       blob/text?
createdDate   date
updatedDate   date

TODO: retrieve the specified content in the constructor:
*/
function ContentInstance(id){
  //this.logger     = log4CCMS.init();
  this.content      = "";
  this.id           = parseInt(id);   //unique DB identifier
  this.contentId    = 0;              //the parent content ID
  this.instanceNum  = 0;              //the inremental version number
  this.state;
  this.updatedDate;
  this.editUser;
  
  var connection    = Server.CreateObject("ADODB.Connection");
  connection.open(renderUtils.getConnectionString());
  var recordset     = Server.CreateObject("ADODB.Recordset");
  var instSQL = "select state_id,data,edit_user,content_id,version_id,updated_date from content_version where id = " + this.id;
  
  //TODO - get ALL instances...
  recordset = connection.execute(instSQL);
    
  this.content = new String(recordset("data"));
  if(this.content == 'null') this.content = "";
  this.state        = parseInt(recordset("state_id"));
  this.editUser     = parseInt(recordset("edit_user"));
  this.contentId    = parseInt(recordset("content_id"));
  this.instanceNum  = parseInt(recordset("version_id"));
  this.updatedDate  = new Date(recordset("updated_date"));
    
    
  recordset.close();
  recordset = null;
  connection.close(); 
  connection = null
  
  
  
  
  /*
  I need to do something here around differentiating between characters in body copy and inside HTML tag attributes
  */
  ContentInstance.prototype.setContent = function(content){
    try{
      content = content+"";       //why does toString() fail?
      
      //replace DB unsafe chars:
      content = content.replace(/'/g,"&#39;");
      this.content = content;
    }
    catch(e){
      Response.Write("error on ContentInstance.setContent(): " + e.message);
    }  
  }
  
  ContentInstance.prototype.getContent = function(content){
    return this.content;
  }
  
  ContentInstance.prototype.setState = function(state){
    //SQL here - in constructor?
    this.state = state;
  }
  
  /*
  STATE will default to ATWORK
  updates will default to creating a new version
  */
  ContentInstance.prototype.update = function(updateCurrentVersion){
    try{
        
      var currentUser = userFactory.getCurrentUser();
      if(!currentUser){
        throw new Error("Current user is undefined. Cannot continue.")
      }
      
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      
      if(updateCurrentVersion){
        var updateSql = "update content_version set data='" + this.content + "', state_id=" + this.state + ", edit_user=" + currentUser.id + ", updated_date=GETDATE() where id=" + this.id + " and content_id=" + this.contentId + ";";
        connection.execute(updateSql);
      }
      else{
        var recordset     = Server.CreateObject("ADODB.Recordset");
        var instSql = "select (select max(version_id)+1 from content_version where content_id=" + this.contentId + ") as newversion, cv.content_id as content_id from content_version cv where cv.content_id=" + this.contentId;
        recordset = connection.execute(instSql);
        var newInstId = parseInt(recordset("newversion"));
        var contentId = parseInt(recordset("content_id"));

        //TODO: TRANSACTION, PREPARED STATEMENT:
        var sql2 = "insert into content_version (data,content_id,state_id,edit_user,updated_date,version_id) values('" + this.content + "'," + contentId + "," + State.ATWORK + "," + currentUser.id + ",GETDATE()," + newInstId + ")";
        connection.execute(sql2);
      }  
      
      connection.close();
      connection = null;
    }
    catch(e){
      Response.Write("Error in ContentInstance.update(): " + e.message);
    }
  }
}

%>
