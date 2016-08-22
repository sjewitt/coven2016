<%
/*
do as singleton?
*/

//constuctor:
function Viewtree(){
  
  //TODO: Add a Viewtree.AtRoot property (boolean)
  
  
  /*
  Retrieve a node by ID. Is the same as directly instantiating a Node() object.
  */
  Viewtree.prototype.getNode = function(viewtreeId){
    try{
      var node = false;
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");
        
      var count = 0;
      //does the passed ID exist?
      var sql  = "select count (*) as count from viewtree where id=" + viewtreeId;
      recordset     = connection.execute(sql);     
      count         = parseInt(recordset("count"));
      
      //no node:
      if(count == 0){
        throw new Error("Specified node does not exist");
      }
      
      //duplicate node ID: ERROR!
      else if(count > 1){
        throw new Error("Duplicate node ID! Cannot continue.");
      }
      
      //Proceed:
      else{
        sql = "select id from viewtree where id=" + viewtreeId;
        //Response.Write(sql+"<br>");
        recordset = connection.execute(sql);
        node = new Node(parseInt(recordset("id")));
      }
      
     
      recordset.close();
      recordset = null;
      connection.close(); 
      connection = null
      return node;
    }
    catch(e){
      //recordset.close();
      recordset = null;
      //connection.close(); 
      connection = null;      
      //log stuff here
      Response.Write("Error in Viewtree.getNode(): " + e.message);
    }
  }
  
  /*
  FIRST CALL BY ENGINE.
  retrieve the root node:
  */
  Viewtree.prototype.getRoot = function(){
    try{
      var sql           = "select id from viewtree where parent_id=0;";  //there should only be one...
      var connection    = Server.CreateObject("ADODB.Connection");
      var node;
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");

      //create a Command object to prepare the SQL:
      var cmd           = Server.CreateObject("ADODB.Command");
      //set the properties:
      cmd.CommandType       = 1;            //adCmdText - sql query
      cmd.Name              = "VT_getRoot"; //note naming convention...
      cmd.CommandText       = sql;          //NOTE - no parameters needed here!
      cmd.ActiveConnection  = connection;   //set the active connection
      cmd.Prepared          = true;         //set the statement to prepared.

      //check for duplicates/no values: TODO:
      recordset   = cmd.execute();
      
      node = new Node(parseInt(recordset("id")));
      //showObject(node);
      recordset.close();
      recordset   = null;
      connection.close(); 
      connection  = null;
      return node;
     
    }
    catch(e){
      recordset   = null;
      connection  = null;
      Response.Write("error in Viewtree.getRoot(): " + e.message);
    }      
  }
  
  /*
  retrieve a branch recusively:
  */
  Viewtree.prototype.getBranch = function(node){
    try{
      var _branch = node.getChildren(true);
      node.childArray = _branch;
      return(node);  
        
    }
    catch(e){
      return false;
    }
  }
  
  /*
  Get the level of the supplied node:
  Deprecated. Node.level is set when a Node is instansiated.
  */
  Viewtree.prototype.getLevel = function(node){
    try{
      var level = 0;
      while(node.parentId != 0){
        node = new Node(node.parentId); //add a getParent() method?
        level++;
      }
      return level;
    }
    catch(e){
      //error trap
      return 0;
    }
  }
  
  /*
  retrieve entire tree recusively:
  */
  Viewtree.prototype.get = function(){
    try{

    }
    catch(e){
      
    }
  }
  
  /*
  return node(s) referencing supplied page:
  */
  Viewtree.prototype.getVTRefs = function(page){
    try{
      var out = new Array();    //of nodes referencing the supplied page object:
      var sql           = "select id from viewtree where page_id = ? ;";
      var connection    = Server.CreateObject("ADODB.Connection");
      var node;
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");

      //create a Command object to prepare the SQL:
      var cmd           = Server.CreateObject("ADODB.Command");
      //set the properties:
      cmd.CommandType       = 1;            //adCmdText - sql query
      cmd.Name              = "VT_getVTRefs"; //note naming convention...
      cmd.CommandText       = sql;          
      cmd.ActiveConnection  = connection;   //set the active connection
      cmd.Prepared          = true;         //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramVTRefs",3,1,0,page.id));

      //check for duplicates/no values: TODO:
      recordset   = cmd.execute();
      
      while(!recordset.EOF){
        //out.push(new Node(recordset("id") ));
        out.push(new Node(recordset("id")));
        recordset.MoveNext();
      }
      
      return out;
    }
    catch(e){
      return e
    }
  }
  
  /*
  return node(s) referencing supplied page:
  */
  Viewtree.prototype.getVTRefCount = function(page){
    try{
      var count = 0;
      var sql           = "select count(*) as count from viewtree where page_id = ? ;";
      var connection    = Server.CreateObject("ADODB.Connection");
      var node;
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");

      //create a Command object to prepare the SQL:
      var cmd           = Server.CreateObject("ADODB.Command");
      //set the properties:
      cmd.CommandType       = 1;            //adCmdText - sql query
      cmd.Name              = "VT_getVTRefCount"; //note naming convention...
      cmd.CommandText       = sql;          
      cmd.ActiveConnection  = connection;   //set the active connection
      cmd.Prepared          = true;         //set the statement to prepared.
      
      //append the parameter to the Parameters collection of the Command object:
      cmd.Parameters.Append(cmd.CreateParameter("paramVTRefCount",3,1,0,page.id));

      //check for duplicates/no values: TODO:
      recordset   = cmd.execute();
      
      if(!recordset.EOF){
        count = parseInt(recordset("count"));
      }
      
      return count;
    }
    catch(e){
      return 0
    }
  }

  /*
  Add a node to specified parent:
  TODO: Add a return value and better error trapping
  */
  Viewtree.prototype.addNode = function(parentNode,newNode){
    try{
      var sql           = "insert into viewtree (page_id,parent_id,ordering) values(" + newNode.pageId + "," + parentNode.id + "," + newNode.ordering + ");";
      var connection    = Server.CreateObject("ADODB.Connection");
      connection.open(renderUtils.getConnectionString());
      connection.execute(sql);
      
      //do check for SQL status:
      return true;
    }
    catch(e){
      Response.Write("error in Viewtree.addNode(): " + e.message);
      return false;
    }
  }
  
  /*
  return all nodes in the viewtree (non-recursive, flat array)
  */
  Viewtree.prototype.getAllNodes = function(page){
    try{
      var out = new Array();    //of nodes referencing the supplied page object:
      //var sql           = "select id from viewtree order by id;";
      var sql = "select vt.id,vt.page_id,p.linktext from viewtree vt inner join page p on p.id = vt.page_id order by p.linktext;"
      
      var connection    = Server.CreateObject("ADODB.Connection");
      var node;
      connection.open(renderUtils.getConnectionString());
      var recordset     = Server.CreateObject("ADODB.Recordset");

      //create a Command object to prepare the SQL:
      var cmd           = Server.CreateObject("ADODB.Command");
      cmd.CommandText       = sql;          
      cmd.ActiveConnection  = connection;   //set the active connection
      cmd.Prepared          = true;         //set the statement to prepared.
      recordset   = cmd.execute();
      
      while(!recordset.EOF){
        out.push(new Node(recordset("id") ));
        recordset.MoveNext();
      }
      
      return out;
    }
    catch(e){
      return e
    }
  }
  
  //assign a new parent to a node
  Viewtree.prototype.moveNode = function(nodeToMove,newParentNode){
    //Response.Write((sourceNode.level) + "<br />")
   try{
      if(nodeToMove.level < 1){
        //Response.Write("root...<br />");
        throw new Error("Cannot move root node.");
      }  
      else{
         //get the branch from the source and check whether the target is one of these. If so, throw error:
         //var branch = this.getBranch(nodeToMove);
         //showObject(branch);
         
         //check whether newParentNode is in the branch:
         var targetInSource = false;
         //Response.Write("New parent: "+newParentNode.id+"<br />")
         
         var recurse = function(node,newParentNode){
           //Response.Write(node.id+"<br />");
           if(node.id == newParentNode.id){
             targetInSource = true;
           }
           var childs = node.getChildren();
           for(var a=0;a<childs.length;a++){
             recurse(childs[a],newParentNode)
           }
         }
         
         recurse(nodeToMove,newParentNode);
         
         //if target is not in branch to move, execute SQL:
         if(!targetInSource){
          //Response.Write("moving object to new parent...")
          var sql           = "update viewtree set parent_id=" + newParentNode.id + " where id=" + nodeToMove.id;
          var connection    = Server.CreateObject("ADODB.Connection");
          connection.open(renderUtils.getConnectionString());
          connection.execute(sql);
          return true;
         }
         else{
          return false;
         }
      }
    }
    catch(e){
      Response.Write("returning error '" + e.message + "'<br />")
      throw(e);
    }
  }  
  //Viewtree.
}
%>
