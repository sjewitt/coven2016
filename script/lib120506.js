var obj = new Object();
obj.newsLink;
obj.onNewsPage = false;

/**
//FIRST LEVEL NAVIGATION ARRAY: order: andi, indi, mandy, clare
var primarynav = new Array();
primarynav[0] = {url: "/andi/andi.htm", linktext: "Andi", image: "/images/andi_sml.jpg"};
primarynav[1] = {url: "/indi/indi.htm", linktext: "Indi", image: "/images/indi_sml.jpg"};
primarynav[2] = {url: "/mandy/mandy.htm", linktext: "Mandy", image: "/images/mandy_sml.jpg"};
primarynav[3] = {url: "/clare/clare.htm", linktext: "Clare", image: "/images/clare_sml.jpg"};

//SECOND LEVEL NAVIGATION ARRAY:
var nav = new Object();

//andi
nav.andinav = new Array();
nav.andinav[0] = new Object();
nav.andinav[0].page = {url: "/andi/me.htm", linktext: "Me"};
nav.andinav[0].children = new Array();

//indi
nav.indinav = new Array();
nav.indinav[0] = new Object();
nav.indinav[0].page = {url: "/indi/me.htm", linktext: "Me"};
nav.indinav[0].children = new Array();

//mandy
nav.mandynav = new Array();
nav.mandynav[0] = new Object();
nav.mandynav[0].page = {url: "/mandy/me.htm", linktext: "Me"};
nav.mandynav[0].children = new Array();

//clare
nav.clarenav = new Array();
nav.clarenav[0] = new Object();
nav.clarenav[0].page = {url: "/clare/me.htm", linktext: "Me"};
nav.clarenav[0].children = new Array();
nav.clarenav[0].children[0] = {url: "/clare/me/work.htm", linktext: "My&nbsp;Work"};
nav.clarenav[1] = new Object();
nav.clarenav[1].page = {url: "/clare/gigs.htm", linktext: "Gigs"};
nav.clarenav[1].children = new Array();
nav.clarenav[1].children[0]   = {url: "/clare/gigs/boc.htm",            linktext: "Blue Oyster Cult"};
nav.clarenav[1].children[1]   = {url: "/clare/gigs/download2004.htm",   linktext: "Download 2004"};
nav.clarenav[1].children[2]   = {url: "/clare/gigs/rasmus.htm",         linktext: "The&nbsp;Rasmus"};
nav.clarenav[1].children[3]   = {url: "/clare/gigs/hundredreasons.htm", linktext: "Hundred&nbsp;Reasons"};
nav.clarenav[1].children[4]   = {url: "/clare/gigs/motorhead.htm",      linktext: "Mot&ouml;rhead"};
nav.clarenav[1].children[5]   = {url: "/clare/gigs/machinehead.htm",    linktext: "Machinehead"};
nav.clarenav[1].children[6]   = {url: "/clare/gigs/maiden.htm",         linktext: "Iron&nbsp;Maiden"};
nav.clarenav[1].children[7]   = {url: "/clare/gigs/dlr.htm",            linktext: "David&nbsp;Lee&nbsp;Roth"};
nav.clarenav[1].children[8]   = {url: "/clare/gigs/ozzfest2003.htm",    linktext: "Ozzfest&nbsp;2003"};
nav.clarenav[1].children[9]   = {url: "/clare/gigs/jerry.htm",          linktext: "Jerry Springer Opera"};
nav.clarenav[1].children[10]  = {url: "/clare/gigs/drn.htm",            linktext: "Dumpy's&nbsp;Rusty&nbsp;Nuts"};
nav.clarenav[1].children[11]  = {url: "/clare/gigs/dio.htm",            linktext: "Dio"};

nav.clarenav[2] = new Object();
nav.clarenav[2].page = {url: "/clare/food.htm", linktext: "Food"};
nav.clarenav[2].children = new Array();
nav.clarenav[2].children[0] = {url: "/clare/food/yumyum.htm", linktext: "Yum&nbsp;Yum"};
nav.clarenav[2].children[1] = {url: "/clare/food/fishpie.htm", linktext: "Fish&nbsp;Pie"};
nav.clarenav[2].children[2] = {url: "/clare/food/scp.htm", linktext: "Sweet&nbsp;Chicken&nbsp;Pie"};

nav.clarenav[3] = new Object();
nav.clarenav[3].page = {url: "/clare/hols.htm", linktext: "Hols!"};
nav.clarenav[3].children = new Array();
nav.clarenav[3].children[0] = {url: "/clare/hols/windermere2004.htm", linktext: "Windermere 2004"};

nav.clarenav[4] = new Object();
nav.clarenav[4].page = {url: "/clare/scot2004.htm", linktext: "Scotland&nbsp;2004"};
nav.clarenav[4].children = new Array();
nav.clarenav[4].children[0] = {url: "/clare/scot2004/scot2004_16.htm", linktext: "Diary"};
nav.clarenav[4].children[1] = {url: "/clare/scot2004/scot2004_1.htm", linktext: "Sealife&nbsp;Centre"};
nav.clarenav[4].children[2] = {url: "/clare/scot2004/scot2004_2.htm", linktext: "Kilmartin&nbsp;House&nbsp;Museum"};
nav.clarenav[4].children[3] = {url: "/clare/scot2004/scot2004_3.htm", linktext: "Lady&nbsp;Glassery&nbsp;Wood"};
nav.clarenav[4].children[4] = {url: "/clare/scot2004/scot2004_4.htm", linktext: "Nether&nbsp;Largie&nbsp;Stones"};
nav.clarenav[4].children[5] = {url: "/clare/scot2004/scot2004_5.htm", linktext: "Temple&nbsp;Wood&nbsp;Circles"};
nav.clarenav[4].children[6] = {url: "/clare/scot2004/scot2004_6.htm", linktext: "Nether&nbsp;Largie&nbsp;South&nbsp;Cairn"};
nav.clarenav[4].children[7] = {url: "/clare/scot2004/scot2004_7.htm", linktext: "Ballymeanoch&nbsp;Stones"};
nav.clarenav[4].children[8] = {url: "/clare/scot2004/scot2004_8.htm", linktext: "Achnabrech&nbsp;Carvings"};
nav.clarenav[4].children[9] = {url: "/clare/scot2004/scot2004_9.htm", linktext: "Oban&nbsp;Highland&nbsp;Gathering"};
nav.clarenav[4].children[10] = {url: "/clare/scot2004/scot2004_10.htm", linktext: "Dunstaffnage&nbsp;Castle"};
nav.clarenav[4].children[11] = {url: "/clare/scot2004/scot2004_11.htm", linktext: "Atlantic&nbsp;Bridge"};
nav.clarenav[4].children[12] = {url: "/clare/scot2004/scot2004_12.htm", linktext: "Walter&nbsp;Scott&nbsp;Memorial"};
nav.clarenav[4].children[13] = {url: "/clare/scot2004/scot2004_13.htm", linktext: "Edinburgh&nbsp;Castle"};
nav.clarenav[4].children[14] = {url: "/clare/scot2004/scot2004_14.htm", linktext: "Camera&nbsp;Obscura"};
nav.clarenav[4].children[15] = {url: "/clare/scot2004/scot2004_15.htm", linktext: "Science&nbsp;Centre"};

nav.clarenav[5] = new Object();
nav.clarenav[5].page = {url: "/clare/gizmo.htm", linktext: "Gizmo!"};
nav.clarenav[5].children = new Array();
nav.clarenav[5].children[0] = {url: "/clare/gizmo/gizmo1.htm", linktext: "Pictures&nbsp;1"};
nav.clarenav[5].children[1] = {url: "/clare/gizmo/gizmo2.htm", linktext: "Gizmo&nbsp;2"};
nav.clarenav[5].children[2] = {url: "/clare/gizmo/gizmo3.htm", linktext: "Gizmo&nbsp;3"};
nav.clarenav[5].children[3] = {url: "/clare/gizmo/gizmo4.htm", linktext: "Gizmo&nbsp;4"};
nav.clarenav[5].children[4] = {url: "/clare/gizmo/gizmo5.htm", linktext: "Gizmo&nbsp;5"};

nav.clarenav[6] = new Object();
nav.clarenav[6].page = {url: "/clare/news.htm", linktext: "Clare's News"};
nav.clarenav[6].children = new Array();
*/

function urlencode(string)
{
  try
  {
    var arr = string.split("/");
    var returnstring = arr.join("%2F")
    return(returnstring);
    //return(typeof(string));
  }
  
  catch(e)
  {
    return(e.message);
  }
}

//function to build second level nav:
function getL2Nav(currnavstring,currchildren,url)
{
  var returnval = "<table border='0' cellpadding='0' cellspacing='0'><tr><td width='15'>&nbsp;</td><td>";
  for(var a = 0; a < currchildren.length; a++)
  {
    if(currchildren[a].url == url)
    {
      returnval += "<u class='navlinktext'>" + currchildren[a].linktext + "</u><br>\n";
    }
    
    else
    {
      returnval += "<a href='" + currchildren[a].url + "'  class='navlinktext'>" + currchildren[a].linktext + "</a><br>\n";
    }
  }
  returnval += "</td></tr></table>";
  return(returnval);
}
//matching url should be linktext only. match with subnav to determine which subnav to open
function getNav(owner,url,subnav)
{
  try
  {
    //alert(owner);
    var returnval = "";
    //loop over owner array:
    if(nav[owner])
    {
      for(var a = 0; a < nav[owner].length; a++)
      {
        //if(nav[owner][a].page.url.indexOf("news.htm") == -1) //don't want news page to appear in nav:
        //{
          if(nav[owner][a].page.url == url)
          {
            returnval += "<u>" + nav[owner][a].page.linktext + "</u><br>\n";
            //if(subnav == nav[owner][a].page.linktext)
           // {
           //   returnval += getL2Nav(returnval,nav[owner][a].children,url);
           // }
          }
          
          else
          {
            returnval += "<a href='" + nav[owner][a].page.url + "'>" + nav[owner][a].page.linktext + "</a><br>\n";
            //if(subnav == nav[owner][a].page.linktext)
            //{
            //  returnval += getL2Nav(returnval,nav[owner][a].children,url);
            //}
          }
        //}
      }
    }
    //alert(returnval)
    //add additional common elements:
    //returnval += "<a href='#' class='navlink'>News</a><br />";
    //returnval += "<a href='/cms/login.pl' class='navlink'>Edit my content</a><br />";
    
    return(returnval);
    }
    catch(e)
    {
      return("error: "+e.message);
    }
}

function getprimarynav(owner,flag)
{
  try
  {
    //capitalise owner:
    var name = owner.substring(0,1).toUpperCase() + owner.substring(1,owner.length);
    //alert(owner)
    //check for flag:
    if(flag && flag == "newspage")
    {
      obj.onNewsPage = true;
      obj.newslink = "<br><a href='#'>" +  + "</a><p>"
    }
  
    var returnval = "<div class='contentnav'>";
    
    //add additional global links:
    if(obj.onNewsPage == false)
    {
      //obj.newslink = owner.substring(0,1).toUpperCase() + owner.substring(1,owner.length);
      returnval += "<br><a href='/" + owner + "/news.htm' title='" + name + "&#39;s Latest News'>" + name + "&#39;s&nbsp;News</a><p >";
    }
    
    else
    {
      returnval += "<br><a href='/" + owner + "/" + owner + ".htm' title='" + name + "&#39;s Home'>" + name + "&#39;s&nbsp;Homepage</a><p >";
    }
    //returnval += "<br><a href='/" + owner + "/news.htm' title='" + obj.newslink + "&#39;s Latest News'>" + obj.newslink + "&#39;s&nbsp;News</a><p >";

        for(var a = 0; a < primarynav.length; a++)
    {
      if(primarynav[a].linktext.toLowerCase() != owner)
      {
        //returnval += "<div class='contentnav'><div class='thumbnav'>" + primarynav[a].linktext + "<\/div><a href='" + primarynav[a].url + "'><img src='" + primarynav[a].image + "'><\/a><\/div>\n";
        returnval += "<div class='thumbnav'>" + primarynav[a].linktext + "<\/div><a href='" + primarynav[a].url + "'><img src='" + primarynav[a].image + "'><\/a>";
      }
    }
        
    //add the contact link:
    returnval += "<div class='footer2'>&copy;TheCoven&nbsp;2004<br><a href='mailto:webmaster@thecoven.co.uk' class='navlink'>Webmaster@thecoven.co.uk</a><\/div><br>";
    
    //end the containing div:
    returnval += "<\/div>";
    
    return(returnval);
  }
  
  catch(e)
  {
    alert(e);
  }
}

function getEditLinks(user)
{
  try
  {
  var output = "";
  var secondarynav;
  //output += user;
  //get the secondary nav: (perhaps I should have rewritten everything as the site developed, but bollocks I didn't...)
  switch(user)
  {
    case "Andi":
      secondarynav = nav.andinav;
    break;
    
    case "Indi":
      secondarynav = nav.indinav;
    break;
    
    case "Mandy":
      secondarynav = nav.mandynav;
    break;
    
    case "Clare":
      secondarynav = nav.clarenav;
    break;
  
  }
    for(var a = 0; a < primarynav.length; a++)
    {
      
      if(primarynav[a].linktext == user)
      {
        //output += primarynav[a].url;
        output += "<a href='/cms/edittag_ww.pl?file=" + urlencode(primarynav[a].url.substring(1,primarynav[a].url.length)) + "'>" + primarynav[a].linktext + "</a><br>";
        for(var b = 0; b < secondarynav.length; b++)
        {
          output += "&nbsp;&nbsp;<a href='/cms/edittag_ww.pl?file=" + urlencode(secondarynav[b].page.url.substring(1,secondarynav[b].page.url.length)) + "'>" + secondarynav[b].page.linktext + "</a><br>";
          if(secondarynav[b].children.length > 0)
          {
            for(var c = 0; c < secondarynav[b].children.length; c++)
            {
              output += "&nbsp;&nbsp;&nbsp;&nbsp;<a href='/cms/edittag_ww.pl?file=" + urlencode(secondarynav[b].children[c].url.substring(1,secondarynav[b].children[c].url.length)) + "'>" + secondarynav[b].children[c].linktext + "</a><br>";
            }
          }
        }
      }
    }
    
    return(output);
  }
  
  catch(e)
  {
    return(e.message)
  }
}
