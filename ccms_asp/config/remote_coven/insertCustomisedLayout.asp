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
    var node = vt.getRoot();
    if(parseInt(Request.QueryString("nodeid"))){
      node = new Node(parseInt(Request.QueryString("nodeid")));
    }
    //GET THE ROOT NODE:
    var root      = (new Viewtree()).getRoot();
    //GET CURRENT CHILDLIST:
    var childs = node.getChildren();
    
    //GET PATH TO CURRENT NODE:
    var nav = new Navigation();
    var path = nav.getBreadcrumb(node);
    
    //coven homenav
    out = out.replace(/{CMS_COVEN_HOMENAV}/g,         getHomeNav(childs));
    
    //coven section heading (linktext from L2 parent)
    out = out.replace(/{CMS_COVEN_SECTIONHEADING}/g,  getSectionHeading(node,path));
    
    //coven main LH nav:
    out = out.replace(/{CMS_COVEN_LHNAV}/g,           getCovenLHNav(node,path,root));
    
    //coven section image (linktext and associated image from L2 parent)
    out = out.replace(/{CMS_COVEN_SECTIONIMAGE}/g,    getSectionImage());
    
    //coven section RH nav:
    out = out.replace(/{CMS_COVEN_RHNAV}/g,           getCovenRHNav(node));
  }
  catch(e){
    Response.Write("error in insertCustomisedLayout(): "+e.message);
  }
  return out;
}
%>
