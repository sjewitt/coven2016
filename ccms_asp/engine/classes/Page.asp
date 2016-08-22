<%
/*
TODO: USE PREPARED STATEMENTS.

Class representing a page object.
 It maps directly to the database row:
  id          the primary key
  content     hashmap of content slot numbers to Content objects IDs
               - this would be determined either globally or dynamically from a content
                 structure definition.
  TODO: Modify to be as Node - ie only load the sub-properties when called.
*/


//constuctor:
function Page(id,all){

  this.id             = null;
  this.exists         = false;
  this.linkText       = null;
  this.title          = null;
  this.description    = null;
  this.keywords       = null;
  this.content        = new Array();
  this.createdUser    = null;
  //this.updatedUser    = null;
  this.layoutId       = null;
  //this.status         = new Object();
  //this.logger         = log4CCMS.init();
  
  try{
    if(id){
      id = parseInt(id);  //cast to correct type (it is a record object otherwise...)
      //use boolean ALL to load atwork pages also
      if(all){
        /*
        TODO: 
        Modify the SQL to load page regardless of state
        if this flag is passed.
        */ 
      }
    
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      
      var count = 0;
      //does the passed ID exist?
      //prepared statement for layout retrieval
      var countSql = "select count (*) as count from page where id = ? ;";
      
      //set the properties:
      var cmd               = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "page_exists";        //note naming convention...
      cmd.CommandText       = countSql;             //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramPageExists",3,1,0,id));
      
      //retrieve the record:
      recordset   = cmd.execute();       
      count       = parseInt(recordset("count"));
      
      //if page exists, build it:
      if(count == 1){
        this.id       = id;
        this.exists   = true;
        
        //retrieve core page properties:
        var dataSql = "select name, linktext, description, keywords, title, created_user, updated_user,created_date,updated_date,layout_id from page where state=" + State.ACTIVE + " and id = ? ;";
      
        //set the properties:
        cmd                   = Server.CreateObject("ADODB.Command");
        cmd.CommandType       = 1;                    //adCmdText - sql query
        cmd.Name              = "page_constructor";   //note naming convention...
        cmd.CommandText       = dataSql;             //Parameterised SQL
        cmd.ActiveConnection  = connection;           //set the active connection
        cmd.Prepared          = true;                 //set the statement to prepared.
        
        //append the parameter to the Parameters collection of the Command object:
        cmd.Parameters.Append(cmd.CreateParameter("paramPageExists",3,1,0,this.id));
        
        //retrieve the record:
        recordset   = cmd.execute(); 
        
        //this.name         = new String(recordset("name"));
        this.name         = recordset("name")+"";
        this.linkText     = recordset("linktext")+"";
        this.title        = recordset("title")+"";         if(this.title == "null")  this.title = "";
        this.description  = recordset("description")+"";   if(this.description == "null")  this.description = "";
        this.keywords     = recordset("keywords")+"";      if(this.keywords == "null")     this.keywords = "";
        this.createdDate  = new Date(recordset("created_date"));
        this.updatedDate  = new Date(recordset("updated_date"));
        this.createdUser  = parseInt(recordset("created_user"));
        this.updatedUser  = parseInt(recordset("updated_user"));
        this.layoutId     = parseInt(recordset("layout_id"))
      }
      else if(count > 1){
        throw new Error("Duplicate page ID found! Cannot continue. ");
      }
      else{
        throw new Error("No page ID found! Cannot continue. ");
      }
      recordset.close();
      recordset = null;
      connection.close(); 
      connection = null
    }
    else{
      //also programmatic new page?
    }
  }
  catch(e){
    //this.logger.fatal("Cannot instantiate Page object: " + e.message,"Page");
    return false;
  }

  /*
  get content array:
  This call will populate the content array. The current content array population
  in the constructor should move here - TODO:
   - the content instance stuff is then called from each CONTENT ITEM.
  */
  Page.prototype.getContent = function(){
    try{
      var contentArray = new Array();
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      //retrieve content array:
      var contentListSql = "select content_id from page_content_ref where page_id = ? ;";
    
      //set the properties:
      cmd                   = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "page_getcontent";   //note naming convention...
      cmd.CommandText       = contentListSql;             //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramPageExists",3,1,0,this.id));
      
      //retrieve the record:
      recordset   = cmd.execute(); 
      
      while(!recordset.EOF){
        contentArray.push(new Content(recordset("content_id")));
        this.content.push(new Content(recordset("content_id")));
        recordset.MoveNext();
      }
      recordset.close();
      recordset = null;
      connection.close(); 
      connection = null;
      return contentArray;
    }
    catch(e){
      recordset = null;
      connection = null;
      Response.Write("Error in method Page.getContent(): " + e.message);
      return null;
    }
  }
  
  /*
  update any and all properties.
  These are JUST the direct database table proeprties. The content is mapped
  from another table, so is independant of this.
  */
  Page.prototype.update = function(){
    try{
      //update core proeprties:
      var currentUser = userFactory.getCurrentUser();  //default to admin.
      if(!currentUser){
        currentUser = new User(1);
      }
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      
      var updateSql = "update page set name='" + this.name + "',linktext='" + this.linkText + "',description='" + this.description + "',keywords='" + this.keywords + "', title='" + this.title + "', updated_user=" + currentUser.id + ", updated_date=GETDATE() where id="+this.id
      
      //Response.Write(updateSql)
      
      connection.execute(updateSql);
      connection.close()
      connection = null;
      
      //TODO:
      //if(USEAUDIT){
      //  audit(this,Audit.PAGEUPDATE); //or something...
      //}
    }    
    catch(e){  
      connection = null;
      Response.Write("UPDATE ERROR: "+e.message);
    }
  }
}
%>
