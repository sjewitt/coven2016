<%
/*
id (int)               nodeId of viewtree item
19.05.09  This model for the classes works well.
281109: Added constructor flag to recursively load all childs
*/
function Node(id,loadChildArray){
  
  //Response.Write(loadChildArray + "<br>")
  
  this.id               = 0;
  this.parentId         = 0;
  this.pageId           = 0;
  this.hasChildren      = false;
  this.ordering         = 0;
  this.level            = -1;
  this.layoutId         = -1;
  this.layoutInherited  = true; //todo.
  this.isCurrentNode    = false;    //for use with Navigation-generated nodelists.
  this.childArray       = new Array();
  this.exists           = false;
  

  /*
  'constructor'.
  TODO: Wrap in try/catch/throw
  */
  try{
    if(id){
    
      
      this.id           = id;
      var connection    = Server.CreateObject("ADODB.Connection");
  
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
  
      //create a Command object to prepare the SQL:
      var cmd           = Server.CreateObject("ADODB.Command");
      var sql = "select id,parent_id,page_id,layout_id, ordering from viewtree where id = ? ;";
      //set the properties:
      cmd.CommandType       = 1;            //adCmdText - sql query
      cmd.Name              = "Node_init";  //note naming convention...
      cmd.CommandText       = sql;          //Parameterised SQL
      cmd.ActiveConnection  = connection;   //set the active connection
      cmd.Prepared          = true;         //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      var paramNodeId = cmd.CreateParameter("paramNodeId",3,1,0,this.id);
      cmd.Parameters.Append(paramNodeId);
      
      //retrieve the record:
      recordset   = cmd.execute();
      
      //Response.Write("record BOF: "+recordset.BOF+"<br />")
      //Response.Write("record EOF: "+recordset.EOF+"<br />")
  
      //there should be one, or none:
      if(!recordset.EOF){
        this.id         = parseInt(recordset("id"));
        this.parentId   = parseInt(recordset("parent_id"));
        this.pageId     = parseInt(recordset("page_id"));
        this.layoutId   = parseInt(recordset("layout_id")) ? parseInt(recordset("layout_id")) : 0;
        this.ordering   = parseInt(recordset("ordering"));
        this.exists     = true;
        
        //has children: prepared statement for child queries
        sql = "select count (*) as count from viewtree where parent_id = ? ;";
        //set the properties:
        cmd           = Server.CreateObject("ADODB.Command"); //reset the Command object
        cmd.CommandType       = 1;            //adCmdText - sql query
        cmd.Name              = "Node_childcount";  //note naming convention...
        cmd.CommandText       = sql;          //Parameterised SQL
        cmd.ActiveConnection  = connection;   //set the active connection
        cmd.Prepared          = true;         //set the statement to prepared.
  
        //append the parameter to the Parameters collection of the Command object:
        cmd.Parameters.Append(paramNodeId);
        
        //retrieve the record:
        recordset   = cmd.execute();
  
        if(parseInt(recordset("count")) > 0){
          this.hasChildren = true;
          //Response.Write("childs=ok<br>")
          //Response.Write("load childs="+loadChildArray+"<br>")
          //if the loadChildArray flag is passed, load the childs:
          if(loadChildArray){
            this.childArray = this.getChildren(loadChildArray); //recursively load children
          }
        }
  
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
  
    //set level:
    var levelCheckNode = this;
    var level = 0;
    while(levelCheckNode.parentId != 0){
      levelCheckNode = new Node(levelCheckNode.parentId); //add a getParent() method?
      level++;
    }
    this.level = level;
  
  }
  catch(e){
     recordset = null;
     connection.close(); 
     connection = null;
     this.exists = false;
  }
}

//return an array of Nodes that are direct children of this Node:
Node.prototype.getChildren = function(loadChildArray){
  try{
    var loadChilds = false;
    if (loadChildArray) loadChilds = true;
    var childArray = new Array();
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var recordset     = Server.CreateObject("ADODB.Recordset");

    //has children: prepared statement for child queries
    sql = "select id,page_id from viewtree where parent_id = ? order by ordering;";
    
    //set the properties:
    var cmd               = Server.CreateObject("ADODB.Command");
    cmd.CommandType       = 1;                    //adCmdText - sql query
    cmd.Name              = "node_getchildren";   //note naming convention...
    cmd.CommandText       = sql;                  //Parameterised SQL
    cmd.ActiveConnection  = connection;           //set the active connection
    cmd.Prepared          = true;                 //set the statement to prepared.
    
    //append the parameter to the Parameters collection of the Command object:
    cmd.Parameters.Append(cmd.CreateParameter("paramNodeId",3,1,0,this.id));
    
    //retrieve the record:
    recordset   = cmd.execute();    

    while(!recordset.EOF){
      childArray.push(new Node(parseInt(recordset("id")),loadChilds));
      recordset.MoveNext();
    }
    return(childArray);
  }
  catch(e){
    Response.Write(e.message)
    connection = null;
    recordset = null;
    return false;
  }
}

//return direct parent viewtree node:
Node.prototype.getParent = function(){
  try{
    return new Node(this.parentId);
  }
  catch(e){
    
  }
}

//return the page that this Node references:
Node.prototype.getPage = function(){
  try{
    return new Page(this.pageId);
  }
  catch(e){
    return false;
  }
}

//get layout assigned to this node (see LayoutManager for layout determination method):
//return the page that this Node references:
Node.prototype.getLayoutId = function(){
    try{
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");

      //prepared statement for layout retrieval
      var sql = "select layout_id from viewtree where id = ? ;";
      
      //set the properties:
      var cmd               = Server.CreateObject("ADODB.Command");
      cmd.CommandType       = 1;                    //adCmdText - sql query
      cmd.Name              = "node_getlayoutid";   //note naming convention...
      cmd.CommandText       = sql;                  //Parameterised SQL
      cmd.ActiveConnection  = connection;           //set the active connection
      cmd.Prepared          = true;                 //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramNodeId",3,1,0,this.id));
      
      //retrieve the record:
      recordset   = cmd.execute(); 
      
      var layoutId = 0;
      if(parseInt(recordset("layout_id"))){
        layoutId = parseInt(recordset("layout_id"));
      }
      
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

//update the node:
Node.prototype.update = function(){
  try{
    var connection    = Server.CreateObject("ADODB.Connection");
    connection.open(renderUtils.getConnectionString());
    var updateSql = "update viewtree set page_id='" + this.pageId + "',parent_id='" + this.parentId + "',ordering='" + this.ordering + "' where id="+this.id;
    
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
    Response.Write("error in node.update(): "+e.message);
  }
}

//TODO
Node.prototype.getLevel = function(){
    try{
      return this.level;
    }
    catch(e){

  }
}

%>
