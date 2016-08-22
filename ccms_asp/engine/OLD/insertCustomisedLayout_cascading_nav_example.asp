<%
/*
replace custom tags with custom output. Examples below.
Called ultimately from an instance of Layout
*/
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

    //GET PATH TO CURRENT NODE:
    var nav = new Navigation();
    var path = nav.getBreadcrumb(node);
    
    //GET CURRENT CHILDLIST:
    var childs = node.getChildren();
    
    //GET THE ROOT NODE:
    var root      = (new Viewtree()).getRoot();
    
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
    
    /*
    var nav = new Navigation();
    var branch = nav.getCurrentBranch(node);
    //the array element index corresponds to the level... Therefore, I can simply pass in branch[1] for L1 etc. and the 
    //called functions do not need to determine the node lists.

    var dataArray = new Array();
    dataArray[0] = false;
    dataArray[1] = false;
    dataArray[2] = false;
    dataArray[3] = false;
    
    //I need to pass in FALSE to those functions not yet reached (by level)
    for(var a=0;a<branch.length;a++){
      if(branch[a] != undefined) dataArray[a] = branch[a].nodes;
    }
    
    out = out.replace(/{CMS_CUSTOM_TOPNAV_HOME}/g,  getShaldonL1Nav(dataArray[1],""));
    out = out.replace(/{CMS_CUSTOM_TOPNAV_GREEN}/g, getShaldonL1Nav(dataArray[1],"green"));
    out = out.replace(/{CMS_CUSTOM_TOPNAV_BLUE}/g,  getShaldonL1Nav(dataArray[1],"blue"));
    out = out.replace(/{CMS_CUSTOM_TOPNAV_BROWN}/g, getShaldonL1Nav(dataArray[1],"brown"));
    out = out.replace(/{CMS_CUSTOM_L2NAV}/g,        getShaldonL2Nav(dataArray[2]));
    out = out.replace(/{CMS_CUSTOM_L3NAV}/g,        getShaldonL3Nav(dataArray[3]));
    */
  }
  catch(e){
    Response.Write("error in insertCustomisedLayout(): "+e.message);
  }
  return out;
}
%>
