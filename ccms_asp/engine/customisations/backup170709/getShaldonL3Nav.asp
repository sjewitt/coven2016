<%
/*
return the PATH so L2 and L1 can highlight...
*/
function getShaldonL3Nav(node){
  try{
    var self = node;
    var vt = new Viewtree();
    var lev = vt.getLevel(self);
    var out = '';
    var nodeArray;
    if(lev == 2){ //we are at level 1 - get direct children [do these as constants?]
      nodeArray = node.getChildren();
      var page;
      for(var a=0;a<nodeArray.length;a++){
        page = new Page(nodeArray[a].pageId);
        out += '<a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodeArray[a].id + '" class="subnav">' + page.linkText + "</a>";
      }
    }
    
    //otherwise, walk up the tree until L1 and get the direct children, then do a comparison to get 'current' item:
    if(lev > 2){
      var currLevel = lev;
      while(currLevel != 2){
        node = node.getParent();
        currLevel = vt.getLevel(node);
        nodeArray = node.getChildren();
      }
      //now process the nodeArray:
      for(var a=0;a<nodeArray.length;a++){
        page = new Page(nodeArray[a].pageId);
        if(nodeArray[a].id != self.id){
          out += '<a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodeArray[a].id + '" class="subnav">' + page.linkText + "</a>";
        }
        else{
          out += '<span>' + page.linkText + "</span>";
        }
      }
    }
    return out;
  }
  catch(e){
    Response.Write("error in getShaldonL2Nav(): " + e.message);
    return "";
  }
}


function getShaldonL3Nav_v2(node){
  try{
    var self = node;
    var vt = new Viewtree();
    var lev = vt.getLevel(self);
    var out = '';
    var nodeArray;
    if(lev == 2){ //we are at level 1 - get direct children [do these as constants?]
      nodeArray = node.getChildren();
      var page;
      for(var a=0;a<nodeArray.length;a++){
        page = new Page(nodeArray[a].pageId);
        out += '<a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodeArray[a].id + '" class="subnav">' + page.linkText + "</a>";
      }
    }
    
    //otherwise, walk up the tree until L1 and get the direct children, then do a comparison to get 'current' item:
    if(lev > 2){
      var currLevel = lev;
      while(currLevel != 2){
        node = node.getParent();
        currLevel = vt.getLevel(node);
        nodeArray = node.getChildren();
      }
      //now process the nodeArray:
      for(var a=0;a<nodeArray.length;a++){
        page = new Page(nodeArray[a].pageId);
        if(nodeArray[a].id != self.id){
          out += '<a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodeArray[a].id + '" class="subnav">' + page.linkText + "</a>";
        }
        else{
          out += '<span>' + page.linkText + "</span>";
        }
      }
    }
    return out;
  }
  catch(e){
    Response.Write("error in getShaldonL2Nav(): " + e.message);
    return "";
  }
}

%>
