<%
/*
replace custom tags with custom output. Examples below.
Called ultimately from an instance of Layout
*/

//custom globals (shaldon nav):
var currColour;
    
function insertCustomisedLayout(inStr){
  var out = inStr;
  try
  {
    /*
    It's useful here to get the current node, its child nodes and the path to it - these
    are likely used for any customised navigation function, so it makse sense to only generate
    them once, and pass them as parameters to the various functions.: 
    */
    
    //GET CURRENT NODE:
    var vt  = new Viewtree();
    var node = vt.getRoot();
    if(parseInt(Request.QueryString("nodeid")))
    {
      node = new Node(parseInt(Request.QueryString("nodeid")));
    }
    
    //GET PATH TO CURRENT NODE:
    /*
    var nav = new Navigation();
    var path = nav.getBreadcrumb(node);
    
    var nodelist1 = null;
    var nodelist2 = null;
    var nodelist3 = null;
    if(path[1] != null){nodelist1 = nav.getSiblings(path[1]);nodelist2 = node.getChildren();}
    if(path[2] != null){nodelist2 = nav.getSiblings(path[2]);nodelist3 = node.getChildren();}
    if(path[3] != null){nodelist3 = nav.getSiblings(path[3]);}
    */
    
    //GET CURRENT CHILDLIST:
    //var childs = node.getChildren();
    
    //GET THE ROOT NODE:
    var root      = (new Viewtree()).getRoot();

    //new demo:
    out = out.replace(/{CMS_DEMO_LHNAV}/g,                getDemoTopNav(root,node));
    out = out.replace(/{CMS_DEMO_NEWS}/g,                 getDemoNews(root));
    out = out.replace(/{CMS_DEMO_BREADCRUMB}/g,           getDemoBC(root));
    out = out.replace(/{CMS_DEMO_SUBNAV}/g,               getDemoSubnav(node)); 
    

    /*
    //L1
    out = out.replace(/{CMS_CUSTOM_TOPNAV_HOME}/g,        getShaldonL1Nav(root.getChildren(),""));
    out = out.replace(/{CMS_CUSTOM_TOPNAV_BLUE}/g,        getShaldonL1Nav(nodelist1,"blue"));
    out = out.replace(/{CMS_CUSTOM_TOPNAV_GREEN}/g,       getShaldonL1Nav(nodelist1,"green"));
    out = out.replace(/{CMS_CUSTOM_TOPNAV_BROWN}/g,       getShaldonL1Nav(nodelist1,"brown"));
    
    //L2
    out = out.replace(/{CMS_CUSTOM_L2NAV}/g,        getShaldonL2Nav(nodelist2));

    //L2, animals
    out = out.replace(/{CMS_CUSTOM_L2NAV_ANIMALS}/, getShaldonL2AnimalsNav("brown"));

    //L3
    out = out.replace(/{CMS_CUSTOM_L3NAV}/g,        getShaldonL3Nav(nodelist3,currColour));

    //L3, animals
    out = out.replace(/{CMS_CUSTOM_L3NAV_ANIMALS}/, getShaldonL3AnimalsNav());
    out = out.replace(/{CMS_CUSTOM_ANIMAL}/, getShaldonAnimal(Request.QueryString("animalid")));
    out = out.replace(/{CMS_CUSTOM_ANIMAL_IMAGE}/, getShaldonAnimalImage(Request.QueryString("animalid")));

    //news
    out = out.replace(/{CMS_NEWS_OUTPUT}/g,             getShaldonNews());
    */
    //home news
    //out = out.replace(/{CMS_LATEST_NEWS_HOME}/g,        getTopNews(1));   //NOTE: Modify this to check for zero results

    //{CMS_CUSTOM_TOPNAV_GREEN}
    //out = out.replace(/{CMS_DEMO_LHNAV}/g,             getLHNav(node));
    //out = out.replace(/{CMS_CUSTOM_BREADCRUMB}/g,             getBreadcrumb(node));
    
    
    //coven homenav
    //out = out.replace(/{CMS_COVEN_HOMENAV}/g,         getHomeNav(childs));
    
    //coven section heading (linktext from L2 parent)
    //out = out.replace(/{CMS_COVEN_SECTIONHEADING}/g,  getSectionHeading(node,path));
    
    //coven main LH nav:
    //out = out.replace(/{CMS_COVEN_LHNAV}/g,           getCovenLHNav(node,path,root));
    
    //coven section image (linktext and associated image from L2 parent)
    //out = out.replace(/{CMS_COVEN_SECTIONIMAGE}/g,    getSectionImage());
    
    //coven section RH nav:
    //out = out.replace(/{CMS_COVEN_RHNAV}/g,           getCovenRHNav(node));
    
    /*
    
    //demo site stuff:
    */
    //out = out.replace(/{CMS_CUSTOM_HOMELINK}/g,             getHomeLink(root));
    //out = out.replace(/{CMS_CUSTOM_TOPNAV}/g,             getTopNav(node));
    //out = out.replace(/{CMS_CUSTOM_LHNAV}/g,             getLHNav(root));
    //out = out.replace(/{CMS_CUSTOM_BREADCRUMB}/g,             getBreadcrumb(node));
    
    //rick:
    //out = out.replace(/{CMS_CUSTOM_RICKTOPNAV}/g,             getRickTopNav(root));
    
    //dad   TODO:
    //out = out.replace(/{CMS_CUSTOM_DADLHNAV}/g,           getDadNavs(root,node,path));
    
    
  }
  catch(e){
    Response.Write("error in insertCustomisedLayout(): "+e.message+"<br />");
    for(p in e)
    {
       Response.Write(p+"="+e[p]+"<br />");
    }
  }
  return out;
}


function getDemoNews()
{
     try
     {
      var out = "";
      out = "<dl>";
      var a = 0;
      var query = new Query();
      query.setQuery("select id,name,description,start_date,created_user,updated_date,updated_user,auth_group from content where content_type=2 order by start_date desc;");
      query.execute();
      
      for(a=0;a<query.resultObject.length;a++)
      {
        out += "<dt><a href=\"/ccms.asp?nodeid=12" + "&amp;contentid=" + query.resultObject[a].id + "\" title=\"" + query.resultObject[a].description + "\">" + query.resultObject[a].name + "</a></dt>\n";// ("+dateUtils.getShortDate(query.resultObject[a].start_date)+")</li>\n";
        out += "<dd><span class=\"date\">" + query.resultObject[a].updated_date + "</span> " + query.resultObject[a].description + "</dd>"
      }
      out += "</dl>";
    return out;
  }
  catch(e){
    Response.Write("error in getDemoNews(): " + e.message);
    return "";
  }
}

function getDemoBC(root)
{
    try{
    var nav = new Navigation();
    var bc = nav.getBreadcrumb(node);
    var out = "";
    
    for(var a=0;a<bc.length;a++){
      if(bc[a].id != node.id){
        out += "<a href=\"/ccms.asp?nodeid=" + bc[a].id + "\">" + bc[a].getPage().linkText + "</a>&nbsp;&gt;&gt;&nbsp;";
        }
        else{
          out += "<b>" + bc[a].getPage().linkText + "</b>";
        }
    }
    
    return out;
  }
  catch(e){
    Response.Write("error in getBreadcrumb(): "+e.message);
    return "";
  }
}

function getDemoSubnav(root)
{
  try{
    //var vt = new Viewtree();
    //var root = vt.getRoot();
    var childs = root.getChildren();
    var out = "<ul>\n";
    for(var a=0;a<childs.length;a++){
      if(childs[a].id != parseInt(Request.QueryString("nodeid"))){
        out+="<li><a href=ccms.asp?nodeid=" +childs[a].id + ">" + childs[a].getPage().linkText + "</a></li>\n";
      }
      else{
        out+="<li>" + childs[a].getPage().linkText + "</li>\n";
      }
    }
    out += "</ul>\n";
    return out;
  }
  catch(e){
    Response.Write(e.message);
    return out;
  }
}

%>
