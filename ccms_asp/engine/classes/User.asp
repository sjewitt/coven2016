<%

function User(id){
  this.id                = null;
  this.login             = null;
  this.password          = null;
  this.fullName          = null;
  this.email             = null;
  this.permissions       = null;
  this.active            = false;
  this.exists            = false;
  
  try{
    /*
    'constructor'.
    If an ID is passed, set the property and retrieve the instancelist:
    */
    
    if(id){  
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      
      var count = 0;
      var countSql = "select count (*) as count from users where id=" + id;
      recordset = connection.execute(countSql);
      count         = parseInt(recordset("count"));

      if(count == 1){
        this.exists     = true;
        this.id         = id;
        var dataSql     = "select id,login,password,fullname,email,active,permissions from users where id=" + id;
        recordset       = connection.execute(dataSql);
        this.id         = parseInt(recordset("id"));
        this.login      = new String(recordset("login"));
        this.password      = new String(recordset("password"));   //todo - CRYPT!!
        this.fullName   = new String(recordset("fullname"));
        this.email      = new String(recordset("email"));
        this.permissions = parseInt(recordset("permissions"));
        if(recordset("active") == true) this.active = true; 
        else this.active = false; 
      }
      //else{
      //  throw new Error("User ID does not exist. ");
      //}
      
      recordset.close();
      recordset = null;
      connection.close(); 
      connection = null
      
    }
  }
  catch(e){
    Response.Write(e.message);
  }
  
  //user methods:
}
%>
