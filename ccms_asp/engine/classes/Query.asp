<%
/*
Query the CCMS database.


This is purely a read-only factory
*/
function Query(sql){
  //constructor:
  Query.prototype.dataSource    = DBSERVER;
  Query.prototype.user          = DBUSER;
  Query.prototype.password      = DBPASSWORD;
  Query.prototype.sql           = null;
  Query.prototype.errorMessage  = "";
  Query.prototype.resultObject  = new Array();
  Query.prototype.connection   = Server.CreateObject("ADODB.Connection");
  Query.prototype.connection.open(Query.getConnectionString());
  Query.prototype.recordset    = Server.CreateObject("ADODB.Recordset");
  
  /*
  constructor. Optionally pass in SQL query
  */
  if(sql){ 
    this.sql = sql;
  }
/*
NOT SURE ABOUT THIS...

*/
  Query.prototype.insert = function(sql){
    try{
      this.sql = sql;
      this.connection.execute(this.sql);
    }
    catch(e){
      Response.Write("Error in Query.update(): " + e.message);
    }
  }

    Query.prototype.del = function(sql){
      this.insert(sql); //its actually the same call...
  }

  /*
  Retrieve a recordset and abstract to an Object:
   - This method sets the resultObject property.
  */
  Query.prototype.execute = function(){
    try{
      var out = new Array();
      this.resultObject = new Array();
      var currRowObject = new Object();
      var counter = 0;
      var field;
      this.recordset = this.connection.execute(this.sql);

      while(!this.recordset.EOF){
        currRowObject = new Object(); //reset
        for(counter=0; counter<this.recordset.Fields.Count; counter++){
          field = this.recordset.Fields(counter);
          currRowObject[field.name] = field.value;
        }
        this.resultObject.push(currRowObject);
        this.recordset.MoveNext();
      }
      return(out);
    }
    catch(e){
      Response.Write("Error in Query.execute(): " + e.message);
      
      this.recordset    = false;
      this.errorMessage = e.message;
    }
  }

  //close the connection
  Query.prototype.close = function(){
    if(this.connection) this.connection.close();
    this.connection = null;
    this.recordset = null;
  }

  Query.prototype.closeRecordset = function(){
    this.recordset.close();  
  }

  /*
  
  */
  Query.prototype.setQuery = function(sql){
    this.sql = sql;
  }
}

/*
Static method to return default connection string:
*/
Query.getConnectionString = function(){
  try{
    var connStr     = "Driver="     + DBDRIVER; //{SQL Server}
    connStr         += ";Server="   + DBSERVER;
    connStr         += ";Database=" + DBNAME;
    connStr         += ";Uid="      + DBUSER;
    connStr         += ";Pwd="      + DBPASSWORD;
    return connStr;
  }
  catch(e){
    return(false);
  }
}


%>

