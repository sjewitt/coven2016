<%
function getShaldonL2Nav(node){
  try{
    var self = node;
    var vt = new Viewtree();
    var lev = vt.getLevel(self);
    var out = '';
    var nodeArray;
    if(lev == 1){ //we are at level 1 - get direct children [do these as constants?]
      nodeArray = node.getChildren();
      var page;
      for(var a=0;a<nodeArray.length;a++){
        page = new Page(nodeArray[a].pageId);
        out += '<td><a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodeArray[a].id + '" class="subnav">' + page.linkText + "</a></td>\n";
      }
    }
    
    //otherwise, walk up the tree until L1 and get the direct children, then do a comparison to get 'current' item:
    if(lev > 1){
      var currLevel = lev;
      while(currLevel != 1){
        node = node.getParent();
        currLevel = vt.getLevel(node);
        nodeArray = node.getChildren();
      }
      //now process the nodeArray:
      for(var a=0;a<nodeArray.length;a++){
        page = new Page(nodeArray[a].pageId);
        if(nodeArray[a].id != self.id){
          out += '<td><a title="' + page.linkText + '" href="/ccms.asp?nodeid=' + nodeArray[a].id + '" class="subnav">' + page.linkText + "</a></td>\n";
        }
        else{
          out += '<td class="hilite"><span>' + page.linkText + "</span></td>\n";
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
