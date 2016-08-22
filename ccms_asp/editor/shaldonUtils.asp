<%
var shaldonUtils = new Object();

shaldonUtils.AnimalSection = new Array();
shaldonUtils.AnimalSection.push({id:1,name:"Mammals"});
shaldonUtils.AnimalSection.push({id:2,name:"Birds"});
shaldonUtils.AnimalSection.push({id:3,name:"Reptiles"});



shaldonUtils.getAnimalsList = function()
{
  try
  {

    var connection        = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var sql               = "select id from shaldon_animals order by common_name;";
    var recordset         = Server.CreateObject("ADODB.Recordset");
    var cmd               = Server.CreateObject("ADODB.Command");
    cmd.CommandType       = 1;                    //adCmdText - sql query
    cmd.Name              = "shaldonutils_getallanimals";   //note naming convention...
    cmd.CommandText       = sql;                  //Parameterised SQL
    cmd.ActiveConnection  = connection;           //set the active connection
    cmd.Prepared          = true;                 //set the statement to prepared.
    
    recordset             = cmd.execute();
    
    var result = new Array();
    
      var animal = new ShaldonAnimal();
      while(!recordset.EOF)
      {
        result.push(new ShaldonAnimal(parseInt(recordset("id"))));
        recordset.MoveNext();
      }	
    return result;
  }
  catch(e)
  {
    Response.Write("error in shaldonUtils.getAnimalsList(): " + e.message);
    recordset = null;
    connection = null;
    return null;
  }
}

shaldonUtils.getAnimal = function(animalId){
  try
  {
    return new ShaldonAnimal(animalId);
  }
  catch(e)
  {
    Response.Write("error in shaldonUtils.getAnimal(): " + e.message);
    return null;
  }
}

//generate HTML dropdown:
shaldonUtils.getExistingAnimals = function(animalList,currentAnimal,formElementWidth)
{
  try
  {
    var out = "<select style=\"width:" + formElementWidth + "px;\" name=\"current_animal\" onchange=\"setValues(this[this.selectedIndex].value);\">";
    out += "<option value=\"-1\"> - Add new - </option>"
    for(var a=0;a<animalList.length;a++)
    {
      out += "<option value=\"" + animalList[a].id + "\"";
      if(currentAnimal.id == animalList[a].id)
      {
        out += " selected=\"selected\""
      }
      out += ">" +animalList[a].common_name + " (" + animalList[a].specific_name + ")"+ "</option>\n"
    }
    out += "</select>";
    return out;
  }
  catch(e)
  {
    Response.Write("error in shaldonUtils.getExistingAnimals(): " + e.message);
    return "";
  }
}

shaldonUtils.getUploadedImageArray = function(){
  try{
    
    var imagePath   = UPLOADFILEPATH;
    var realpath    = Server.MapPath("/" + UPLOADFILEPATH + "/");
    var filesystem  = Server.CreateObject("Scripting.FileSystemObject");
    var folder      = filesystem.GetFolder(realpath);
    var files       = folder.Files;
    var enumerator  = new Enumerator(files);         //MS ScriptingHost object
    var data        = new Array();
    //enumerate:
    enumerator.moveFirst();
    var currFile;
    var currExtension;
    while(!enumerator.atEnd()){
      currFile = enumerator.item();
      currExtension = currFile.Name.substring(currFile.Name.lastIndexOf(".")+1,currFile.Name.length);
      //get images = true, configured image types, NOT download object type:
      if(IMAGETYPES[currExtension.toUpperCase()] &! (INSERTABLEDOWNLOADTYPES[currExtension.toUpperCase()])){
        data.push({title:currFile.Name.substring(0,currFile.Name.lastIndexOf(".")),url:UPLOADFILEPATH + '/' + currFile.Name});
      }
      enumerator.moveNext();  
    }
    return(data);
  }
  catch(e){
    Response.Write("error in editUtils.getUploadedBinaryLinkArray(): "+e.message);
  }
}


/*
id
section
common_name
specific_name
family
behaviour
diet
habitat
status
location


    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var updateSQL = "insert into page_content_ref(content_id,page_id,slot_num) values (" + contentId + ", " + pageId + ", " + slotId + " );";
    connection.execute(updateSQL);
    connection.close(); 
    connection = null;
    return true;


*/

shaldonUtils.updateAnimal = function(animal)
{
  //showObject(animal);
    var connection        = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    
    var isActive = 0;
    if(animal.active) isActive = 1;
    
    var sql               = "update shaldon_animals set section='" + animal.section 
            + "',common_name='" + animal.common_name.replace(/\'/g,"''")
            + "', specific_name='" + animal.specific_name 
            + "', family='" + animal.family 
            + "', behaviour='" + animal.behaviour 
            + "', diet='" + animal.diet 
            + "', habitat='" + animal.habitat 
            + "', status='" + animal.status 
            + "', location='" + animal.location 
            + "', main_image='" + animal.main_image 
            + "',threats='" + animal.threats 
            + "', active=" + isActive 
            + " where id='" + animal.id + "'";
    //Response.Write(sql);
    connection.execute(sql);
    connection.close(); 
    connection = null;
}

shaldonUtils.addAnimal = function(animal)
{
    var connection        = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    
    var isActive = 0;
    if(animal.active) isActive = 1;
    
    var sql               = "insert into shaldon_animals (section, common_name, specific_name,family,behaviour,diet,habitat,status,location,main_image,threats,active) values('" + animal.section + "','" + animal.common_name + "','" + animal.specific_name + "','" + animal.family + "','" + animal.behaviour + "','" + animal.diet + "','" + animal.habitat + "','" + animal.status + "','" + animal.location + "','" + animal.main_image + "','" + animal.threats + "'," + isActive + ");";
    connection.execute(sql);
    connection.close();
    connection = null;
}

shaldonUtils.getAnimalsBySection = function(sectionId)
{
  try
  {
      var connection        = Server.CreateObject("ADODB.Connection");
      var recordset         = Server.CreateObject("ADODB.Recordset");
      var cmd               = Server.CreateObject("ADODB.Command");
      connection.open(renderUtils.getConnectionString());
      var sql               = "select id,common_name from shaldon_animals where active=1 and section= ? order by common_name;";
      
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "shaldonutils_getanimalsbysection";   //note naming convention...
      cmd.CommandText       = sql;                  //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      var paramSectionId = cmd.CreateParameter("paramSectionId",3,1,0,parseInt(Request.QueryString("section")));
      cmd.Parameters.Append(paramSectionId);
      
      //retrieve the record:
      recordset   = cmd.execute();
      
      var result = new Array();
      
      var animal = new ShaldonAnimal();
      while(!recordset.EOF)
      {
        result.push(new ShaldonAnimal(parseInt(recordset("id"))));
        recordset.MoveNext();
      }	
      return result;
  }
  catch(e)
  {
        return(e.message);
  }
}


%>
