<%
/*
Abstraction of source layout template and
mapping to content.

Mapping for bespoke slots and function also 
accounted for (but see notes on CustomisedLayout)
*/

function Layout(layoutId){
  //properties:
  this.id               = 0;    //layout ID from DB
  this.active           = false;
  this.fileName         = "";
  this.source           = "";   //unprocessed template source code
  //this.parsedLayoutCode = "";
  this.slots            = null;
  //constructor:
  try{
    if(layoutId && parseInt(layoutId)){
      this.id = layoutId;
      
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var record     = Server.CreateObject("ADODB.Recordset");
      //var sql = "select layout_url from layout where id=" + this.id;
      
      //prepared statement for layout ID retrieval
      var sql = "select layout_url, active from layout where id = ? ;";
      
      //set the properties:
      var cmd               = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "layout_constructor";   //note naming convention...
      cmd.CommandText       = sql;                  //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramLayoutId",3,1,0,this.id));
      
      //retrieve the record:
      record   = cmd.execute();       
      
      var out = new Array();
      if(!record.EOF){
      
        this.fileName = new String(record("layout_url"));
        if(record("active") == 1)
        {
          this.active = true;  
        }
      }
      record.close();
      record = null;
      connection.close();
      connection = null;
    }
  }
  catch(e){
    Response.Write("error in Layout constructor: " + e.message);
  }
  
  
  /*
  Map supplied content to correxponding slots;
  Procedure:
   - When content is applied to a page, a record is written to 
  table PAGE_CONTENT_REF (TODO).
   - This maps contentId to pageId to slot number (slot numbers
  are defined at design time in the source of the layout page)
   - 
  */
  Layout.prototype.mapContent = function(){
    try{
    
    }
    catch(e){
    
    }
  }

  /*
  Abstraction of call to insertCustomisedLayout()
   - This remains a separate function as it will be modified as required to
  map arbitrary output to arbitrary CMS_TAG tags:
  */
  Layout.prototype.mapCustomisedLayout = function(){
    try{
      this.parsedLayoutCode = insertCustomisedLayout(this.parsedlayoutCode);
    }
    catch(e){
    }
  }

  /*
  retrieve the sourcecode and slots within this Layout:
  */
  Layout.prototype.parse = function(){  //do something with PATH here:
    try{
      var fs = Server.CreateObject("Scripting.FileSystemObject");
      var absolutePath = Server.MapPath("/ccms_asp/templates/" + this.fileName);
      var fContents = "";
      var objF;
      var ts;
      
      if(!fs.FileExists(absolutePath)){
        throw new Error("Cannot find template /ccms_asp/templates/" + this.fileName);
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
      var slots = fContents.match(re);  //this is actually a complex object, not an array. It is core JS regex stuff  
      this.slots = slots;
      this.source = fContents;
    }
    catch(e){
      Response.Write("Error in getTemplateSlots(): '" + absolutePath + "'! (" + e.message + ")<br />");
      return("error");
    }  
  }

}
%>
