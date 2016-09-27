<%
/*
Class representing a layout object.
 It maps directly to the database row:
  id          the primary key
s
This just abstracts the layout and returns the HTML string. This class also holds utility
methods for retrieving a layout ID for a page/node (because the same page may be in different
nodes) and for setting 
*/

function LayoutManager(){
  
  this.layoutId   = 0;
  this.layout     = new Object();   //a Layout instance;
  
  /*
  Retrieve a layout for a given node.
  This will walk up the viewtree if the supplied node
  does not have a layout directly applied:
  */
  LayoutManager.prototype.getLayoutId = function(node){
    try{
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
      
      //prepared statement for layout ID retrieval
      var sql = "select layout_id from viewtree where id = ? ;";
      
      //set the properties:
      var cmd               = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "layoutmanager_getlayoutid";   //note naming convention...
      cmd.CommandText       = sql;                  //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramNodeId",3,1,0,node.id));
      
      //retrieve the record:
      recordset   = cmd.execute(); 
      
      var layoutId = -1;
      if(!parseInt(recordset("layout_id"))){
        var parent = node.getParent();
        
        //check for infinite recursion here:
        while(parent.layoutId == 0){
          //Response.Write("iterating...<br />")
          parent = parent.getParent();
        }
        layoutId = parent.layoutId;
      }
      else{
        layoutId = parseInt(recordset("layout_id"));
      }
      //make a class, Layout()?
      
      recordset.close();
      recordset = null;
      connection.close();
      connection = null;
      return layoutId;
    }
    catch(e){
      recordset = null;
      connection = null;
      Response.Write("Error in LayoutManager.getLayoutId(): "+e.message);
    }
  }
  
  /*
  Retrieve a Layout instance.
  TODO: This is basiclly the getTemplateSlots function. It returns an instance of Layout
  */
  LayoutManager.prototype.getLayout = function(layoutId){
    try{
      return(new Layout(layoutId));
    }
    catch(e){
      Response.Write("Error in LayoutManager.getTemplateFile(): "+e.message+"<br>");
      return false;
    }
  }
  
  /*
  get all layouts:
  Return an object array of layouts; TODO: Layout() 
  returns all active layouts. Pass TRUE for loadAll to return all
  regardless of state:
  */
  LayoutManager.prototype.getAllLayouts = function(loadAll){
    try{
      var loadAllStr = " where active=1";
      if(loadAll)
      {
        loadAllStr = "";
      }
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
     
      //prepared statement for ALL layout retrieval
      var sql = "select id, layout_url from layout" + loadAllStr + ";";   //no params
      
      //set the properties:
      var cmd               = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "layoutmanager_getalllayouts";   //note naming convention...
      cmd.CommandText       = sql;                  //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      //cmd.Parameters.Append(cmd.CreateParameter("paramLayoutId",3,1,0,layoutId));
      
      //retrieve the record:
      recordset   = cmd.execute();  
      
      var out = new Array();
      while(!recordset.EOF){
        //out.push({layoutFile:new String(recordset("layout_url")),layoutId:parseInt(recordset("layout_url"))});
        out.push(new Layout(parseInt(recordset("id"))));
        recordset.MoveNext();
      }
      recordset.close();
      recordset = null;
      connection.close();
      connection = null;
      return(out);
    }
    catch(e){
      Response.Write("Error in LayoutManager.getTemplateFiles(): "+e.message+"<br>");
      connection = null;
      recordset = null;
    }    
  }
  
  //return the layout + contained slots: THIS SHOULD BE RENAMED!!!!!!!!!!
  LayoutManager.prototype.getTemplateSlots = function(template){  //do something with PATH here:
    try{
      var returnObj = new Object();
      
      var fs = Server.CreateObject("Scripting.FileSystemObject");
      var absolutePath = Server.MapPath("/ccms_asp/templates/" + template);
      //Response.Write(absolutePath);
      var fContents = "";
      var objF;
      var ts;
      //Response.Write(fs.FileExists(absolutePath)+"<br />");
      
      if(!fs.FileExists(absolutePath)){
        throw new Error("Cannot find template /ccms_asp/templates/" + template);
      }
      else{
        //open text stream:
        ts = fs.OpenTextFile(absolutePath,1);
      
        fContents = ts.ReadAll();
        
        //ensure textstream is closed:
        ts.close();
        f = null;
        fs = null;
      }
      
      var re = /{CMS_CONTENT_[0-9]}/g;
      var slots = fContents.match(re);    
      returnObj.slots = slots;
      returnObj.source = fContents;
      return returnObj;
    }
    catch(e){
      Response.Write("Error in getTemplateSlots(): '" + absolutePath + "'! (" + e.message + ")<br />");
      return("error");
    }  
  }
  
  /*
  set visibility flag of supplied layout for editors:
  */
  LayoutManager.prototype.setAvailability = function(layout,visible){
    try{
      //showObject(layout)
      var activeFlag = 0;
      if(visible)
      {
        activeFlag = 1;
      }
      
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      
      var sql = "update layout set active=" + activeFlag + " where id = ? ;";
      
      //set the properties:
      var cmd               = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "layoutmanager_setvisibility";   //note naming convention...
      cmd.CommandText       = sql;                  //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramLayoutId",3,1,0,layout.id));
      
      //update the record:
      cmd.execute(); 
      
      connection.close();
      connection = null;
      return true;
    }
    catch(e){
      connection = null;
      Response.Write("Error in LayoutManager.setAvailability(): " + e.message);
      return false;
    }
  }
  
  
  

}
%>
