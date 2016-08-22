<%
/*
Abstraction of table PAGE_CONTENT_REF.

Rendering:
 - Select where page ID = curr page
 - populate variables below
*/
function ContentMap(pageId){

  this.pageId     = null
  this.mapping    = new Array(); //of slot/content ID pairs, equal to the number of slots on the page

  /*
  'constructor'.
  TODO: Wrap in try/catch/throw
  */
  try{
    if(pageId){  
      this.pageId           = pageId;
      
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");

      var sql = "select content_id,slot_num from page_content_ref where page_id = ? ;";
    
      //set the properties:
      cmd                   = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "page_getcontent";   //note naming convention...
      cmd.CommandText       = sql;             //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramcontentmap",3,1,0,this.pageId));
      
      //retrieve the record:
      recordset   = cmd.execute(); 
  
      //there may not actually be any - eg when the page is created:
      var counter = 0;
      while(!recordset.EOF){
        this.mapping[counter] = {slotId:parseInt(recordset("SLOT_NUM")),contentId:parseInt(recordset("CONTENT_ID"))};
        counter++;
        recordset.MoveNext();
      }
      recordset.close();
      recordset = null;
      connection.close(); 
      connection = null
    }
  }
  catch(e){
    recordset = null
    connection = null;
    Response.Write("error in ContentMap constructor: " + e.message);
  }
}

%>
