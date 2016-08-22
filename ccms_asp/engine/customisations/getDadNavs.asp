<%

function getDadNavs(root,currNode,bc){
  try{
    var out = "";
     
    //define recursive function as a property of this object:
    var recurse = function(currentIterativeNode,currNode,bc){
    
      
      
      if(currentIterativeNode.hasChildren){// && currNode.id == bc[currNode.level].id){
        
        out += "<ul>\n";
        //add the root link:
        if(currentIterativeNode.level == 0){  //its the root node
          out += getRootLink(currentIterativeNode,currNode);
        }
        
        
        var currChilds = currentIterativeNode.getChildren();
        for(var a=0;a<currChilds.length;a++){
          out += "<li>\n";
          page = new Page(currChilds[a].pageId);
          
          /*
          As the array index of each breadcrumb element directly corresponds
          to the level, I can use this fact to easily do an intersect comparison to
          filter for the current branch. This basically suppresses recursion except for 
          direct ancestors and siblings of direct ancestors. Therefore, I get a standard
          nav structure...
          */
          if(currChilds[a].id == currNode.id){
            out += page.linkText;
          }
          else{
            out += "<a href='/ccms.asp?nodeid=" + currChilds[a].id + "'>" + page.linkText + "</a>\n";
          }
          //only get childs if current item is in breadcrumb:
          if(currChilds[a].level < bc.length && currChilds[a].id == bc[currChilds[a].level].id){
            recurse(currChilds[a],currNode,bc);
          }
          out += "</li>\n";
        }
        out += "</ul>\n";
      }
    }
    
    //method property to return the root link tag:
    var getRootLink = function(r,c){
      //add the home link: 
      var returnVal = "<li>\n"
      if(r.id == c.id){
        returnVal += (new Page(r.id)).linkText + "\n";
      }
      else{
        returnVal += "<a href='/ccms.asp?nodeid=" + r.id + "'>" + (new Page(r.id)).linkText + "</a>\n"
      }
      returnVal += "</li>\n"
      
      return returnVal;  
    }    
   
   //call recursive function:
    recurse(root,currNode,bc)  
    return out;
  }
  catch(e){
    Response.Write("error in getDadNavs(): " + e.message);
    return "";
  }
}
%>
