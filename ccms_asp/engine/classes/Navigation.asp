<%
/*
Abstraction of Node relationship methods
*/
function Navigation(){
}
//return an array of Nodes that share a direct parent. 'Self' node is flagged.
Navigation.prototype.getSiblings = function(selfNode){
  try{
    var parent = selfNode.getParent();
    var siblingArray = parent.getChildren();
    for(var a=0;a<siblingArray.length;a++){
      if(siblingArray[a].id == selfNode.id){
        siblingArray[a].isCurrentNode = true;
      }
      else{
        siblingArray[a].isCurrentNode = false;
      }
    }
    return siblingArray;
  }
  catch(e){
    return false;
  }
}

//return direct parent viewtree node:
Navigation.prototype.getParent = function(node){
  try{
    return new Node(node.parentId);
  }
  catch(e){
    return false;
  }
}

//return the path of nodes (the breadcrumb) that this Node references:
Navigation.prototype.getBreadcrumb = function(node){
  try{
    //var level = 0;
    var pathArray = new Array();
    var self = node;
    self.isCurrentNode = true;
    pathArray.push(self);
    while(node.parentId != 0){
      node = new Node(node.parentId); //add a getParent() method?
      node.isCurrentNode = false;
      pathArray.push(node);
    }
    return pathArray.reverse();
  }
  catch(e){
    //error trap
    return false;
  }
}

//get layout assigned to this node (see LayoutManager for layout determination method):
//return the page that this Node references:
Navigation.prototype.getLayoutId = function(){
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

/*
generic function to return an ancestor tree:
returns a complex object 
*/
Navigation.prototype.getCurrentBranch = function(node){
  try{
    //output holder
    var navArray      = new Array();
    
    var currentLevel  = node.level;
    //var nav           = new Navigation();
    
    //get the direct path from HERE to the root (an array of Nodes):
    var bc            = this.getBreadcrumb(node);
    
    //so first element will contain 'self', as I need to sequentially determine the parent of the node:
    bc.reverse(); 
    
    //first, add the children of current node:
    navArray[0]         = new Object();
    navArray[0].level   = currentLevel + 1;
    navArray[0].nodes   = node.getChildren();
    
    //placeholders for operations within the loop:
    var currNode        = node;
    var currSibs        = new Array();
    var o               = new Object();
    
    for(var a=0;a<bc.length;a++){
      o                 = new Object();                     //reset

      //get sibs of current node. This function already knows about 'self'
      currSibs          = this.getSiblings(currNode);
      
      //populate temporary object:
      o.level           = currNode.level;
      o.nodes           = currSibs;
      
      //add to output:
      navArray.push(o);
      currNode = currNode.getParent();
      //Response.Write("lev: " + bc[a].level+"<br>");
    }
    
    navArray.reverse();
    return(navArray);
  }
  catch(e){
    Response.Write("error in  Navigation.getCurrentBranch: " + e.message);
  }
}


//TODO?
Navigation.prototype.getLevel = function(){
    try{
    }
    catch(e){

  }
}

/*
TODO:
*/
Navigation.prototype.getDefaultNav = function(root,currNode,bc){
  try{
    var out = "";
    
    //define recursive function as a property of this object:
    var recurse = function(currNode,theNode,bc){
      if(currNode.hasChildren){// && currNode.id == bc[currNode.level].id){
        var currChilds = currNode.getChildren();
        out += "<ul>";
        for(var a=0;a<currChilds.length;a++){
          page = new Page(currChilds[a].pageId);
          
          /*
          As the array index of each breadcrumb element directly corresponds
          to the level, I can use this fact to easily do an intersect comparison to
          filter for the current branch. This basically suppresses recursion except for 
          direct ancestors and siblings of direct ancestors. Therefore, I get a standard
          nav structure...
          */
          if(currChilds[a].id == theNode.id){
            out += "<li>" + page.linkText;
          }
          else{
            out += "<li><a href='/ccms.asp?nodeid=" + currChilds[a].id + "'>" + page.linkText + "</a>";
            //TODO:
            //if(currChilds[a].hasChildren && currChilds[a].id != bc[currChilds[a].level].id){
            //  out += "+";
            //}
          }
          //only get childs if current item is in breadcrumb:
          if(currChilds[a].level < bc.length && currChilds[a].id == bc[currChilds[a].level].id){
            recurse(currChilds[a],theNode,bc);
          }
          out += "</li>";
        }
        out += "</ul>";
      }
    }    
   
   //call recursive function:
    recurse(root,currNode,bc)  
    return out;
  }
  catch(e){
    Response.Write("error in navigation.getDefaultNav(): " + e.message);
    return "";
  }
}




%>
