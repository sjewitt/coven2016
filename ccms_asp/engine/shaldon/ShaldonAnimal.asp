<%
function ShaldonAnimal(id)
{
  //properties:
  this.id             = 0;
	this.section        = 0; 
	this.common_name    = "";
	this.specific_name  = "";
	this.main_image     = "";
	this.family         = "";
	this.behaviour      = "";
	this.diet           = "";
	this.habitat        = "";
	this.status         = "";
	this.location       = "";
	this.threats        = "";
	this.active         = false;


  try
  {
    if(id){
      this.id           = id;
      var connection    = Server.CreateObject("ADODB.Connection");
  
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
  
      //create a Command object to prepare the SQL:
      var cmd           = Server.CreateObject("ADODB.Command");
      var sql = "select id, section, common_name, specific_name, family, behaviour, diet, habitat, status, location, main_image,threats,active from shaldon_animals where id = ? ;";
      
      
      //set the properties:
      cmd.CommandType       = 1;            //adCmdText - sql query
      cmd.Name              = "ShaldonAnimal_init";  //note naming convention...
      cmd.CommandText       = sql;          //Parameterised SQL
      cmd.ActiveConnection  = connection;   //set the active connection
      cmd.Prepared          = true;         //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      var paramNodeId = cmd.CreateParameter("paramNodeId",3,1,0,this.id);
      cmd.Parameters.Append(paramNodeId);
      
      //retrieve the record:
      recordset   = cmd.execute();
      
      //there should be one, or none:
      if(!recordset.EOF){
        this.id             = parseInt(recordset("id"));
      	this.section        = parseInt(recordset("section"));
      	this.common_name    = clean(new String(recordset("common_name")));
      	this.specific_name  = clean(new String(recordset("specific_name")));
      	this.family         = clean(new String(recordset("family")));
      	this.behaviour      = clean(new String(recordset("behaviour")));
      	this.diet           = clean(new String(recordset("diet")));
      	this.habitat        = clean(new String(recordset("habitat")));
      	this.status         = clean(new String(recordset("status")));
      	this.location       = clean(new String(recordset("location")));
        this.main_image     = clean(new String(recordset("main_image")));
      	this.threats        = clean(new String(recordset("threats")));
      	//this.active         = false;
      	if(new String(recordset("active")) == "true")
      	{
      	  
      	  this.active       = true;  
        }
        else
        {
           this.active       = false;  
        }
        //showObject(this)
      	//Response.Write("VAL: "+recordset("active")+"<br>");
      	//this.active = false;
        //if(isActive == "true") this.active = true;
      	
    
        recordset.close();
        recordset = null;
      }
      else{
        throw new Error("no data");
      }
      recordset = null;
      connection.close(); 
      connection = null
    }
  }
  catch(e){
    for(p in e)
    {
      Response.Write("ERR:")
      Response.Write(p+"="+e[p]+"<br />");
    }
     recordset = null;
     connection.close(); 
     connection = null;
     this.exists = false;
  }
}

function clean(inStr){
  if(inStr == "undefined") inStr = "";
  if(inStr == "null") inStr = "";
  return inStr;  
}

%>