<%

/*
generic function to return an ancestor tree:
returns a complex object 
*/
function navtest(node){
  try{
    //output holder
    var navArray      = new Array();
    
    var currentLevel  = node.level;
    var nav           = new Navigation();
    
    //get the direct path from HERE to the root (an array of Nodes):
    var bc            = nav.getBreadcrumb(node);
    
    //so first element will contain 'self', as I need to sequesntially determine the parent of the node:
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
      currSibs          = nav.getSiblings(currNode);
      
      //populate temporary object:
      o.level           = currNode.level;
      o.nodes           = currSibs;
      
      //add to output:
      navArray.push(o);
      currNode = currNode.getParent();
      Response.Write("lev: " + bc[a].level+"<br>");
    }
    
    navArray.reverse();
    showObject(navArray)
  }
  catch(e){
    Response.Write("error in  navtest: " + e.message);
  }
}
%>
