<%
/*
replace custom tags with custom output. Examples below.
Called ultimately from an instance of Layout
*/

//custom globals (shaldon nav):
var currColour;
    
function insertCustomisedLayout(inStr){
  var out = inStr;
  try{
    /*
    It's useful here to get the current node, its child nodes and the path to it - these
    are likely used for any customised navigation function, so it makse sense to only generate
    them once, and pass them as parameters to the various functions.: 
    */
    
    //GET CURRENT NODE:
    var vt  = new Viewtree();
    var root = vt.getRoot();
    var node = root;
    if(parseInt(Request.QueryString("nodeid"))){
      node = new Node(parseInt(Request.QueryString("nodeid")));
    }
    
    //GET PATH TO CURRENT NODE:
    var nav = new Navigation();
    var path = nav.getBreadcrumb(node);

    //dad  
    out = out.replace(/{CMS_CUSTOM_DADLHNAV}/g,getDadNavs(root,node,path));

  }
  catch(e){
    Response.Write("error in insertCustomisedLayout(): "+e.message);
  }
  return out;
}
%>
