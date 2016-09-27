<%@ language="JScript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
/*
Entry point for page renders. Logic:

page ID passed on URL
 - does page exist/is it active?
  Y -> query for core properties  
  N -> render/log error
  
 - is page in viewtree?
 TODO: Allow passing of PAGEID as well - that way I can also render a page that is NOT 
 in the viewtree.

*/




//handle login/out:
var queryStr = new String(Request.QueryString);
if(queryStr.indexOf("login") != -1){
  Session("referrer") = null; //reset the return URL
  var params = new String("?referrer=" + Request.ServerVariables("SCRIPT_NAME") + "?nodeid=" + Request.QueryString("nodeid"));
    Response.Redirect("/ccmslogin.asp" + params);
};
//if(queryStr.indexOf("logout") != -1){
//TODO 24.08.10: Do a config switch around either standard ASP session or my bespoke one
if(Request.QueryString("logout") == "true"){
  
  Application.Contents.RemoveAll();
  if(SESSIONTYPE == "asp"){
    Session.abandon();
  }
  else if(SESSIONTYPE == "internal"){
    var sessionMgr = new SessionManager();
    sessionMgr.expireSession(Request.Cookies("CCMSSESSIONGUID"));
  }
  var param = "?";
  if(Request.QueryString("nodeid") && (new String(Request.QueryString("nodeid"))) != "undefined"){
    param = "?nodeid=" + (new String(Request.QueryString("nodeid")) + "&");
  }
  Response.Redirect(Request.ServerVariables("SCRIPT_NAME") + param); //TODO: redirect to self...
}

//handle debug requests:
if(Request.QueryString("debug") == "clearcache"){
  Application.Contents.RemoveAll();
  var param = "?";
  if(Request.QueryString("nodeid") && (new String(Request.QueryString("nodeid"))) != "undefined"){
    param = "?nodeid=" + (new String(Request.QueryString("nodeid")) + "&");
  }
  Response.Redirect(Request.ServerVariables("SCRIPT_NAME") + param); //TODO: redirect to self...
}

var currentUser = userFactory.getCurrentUser();
//if(currentUser){
//     Response.Expires = -1;
//}

var out = "";
//Response.Write("CACHETIMEOUT: "+CACHETIMEOUT+",<br>")
//Response.Write("SESSION TIMEOUT: "+Session.Timeout+",<br>")
try{
  /*
  March 2016:
  TODO:  Add handler for getting content only for REST requests
  ***********************************************************************************************
  also retrieve content by ID and return JSON/XML for REST calls.
  This should also include REST calls for retrieving viewtree and perhaps template source as well
  */
    var _out2 = "";
        if(Request.QueryString("calltype") && (new String(Request.QueryString("calltype"))) != "undefined")
	{
            var callType = new String(Request("calltype"))+"";
            if(Request.QueryString("contentid") && (new String(Request.QueryString("contentid"))) != "undefined")
            {
                //get all content items/active instance.
                _out2 = renderUtils.getSerialisedInstance(parseInt(new String(Request("contentid"))),callType);
            }

            if(Request.QueryString("listall") && (new String(Request.QueryString("listall"))) != "undefined")
            {
                //Response.Write("ALL");
                var q = new Query("select id from content");
                q.execute();
                _out2 = "";

                //outer wrapper header:
                switch (callType)
                {
                    case "xml" :	_out2 = "<ArrayOfContentInstance xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n";	break;
                    case "json" :   _out2 = "["; break;
                }

                for(var a=0;a<q.resultObject.length;a++){
                    _out2 += renderUtils.getSerialisedInstance(q.resultObject[a].id,callType);
                    if(callType === "json" && a < q.resultObject.length-1){
                        _out2 += ",";
                    }
                };

                //outer wrapper footer:
                switch (callType)
                {
                    case "xml":
                        _out2 += "</ArrayOfContentInstance>\n\n";
                        Response.AddHeader("Content-type","text/xml");
                        break;
                    case "json":
                        _out2 += "]";
                        Response.AddHeader("Content-type","application/json");
                        break;
                }
            }
            
            Response.Write(_out2);
	}
  else{
    Response.Write("RENDER...");
    //RETRIEVE START NODE - assume root, and check for a nodeID on the URL:
    var node = (new Viewtree()).getRoot(); 
    if((new String(Request("nodeid"))) != 'undefined'){
      node = new Node(parseInt(new String(Request("nodeid"))));
    }
    
    //SET CACHE KEY - the current node ID:
    //TODO: Do something with other URL parameters too - can I just use the URL as the cache key? Also, CONFIGURE this!!
    //var key = "cache_" + node.id;
    var key = "cache_" + Request.QueryString;
    
    //IF CACHED, RETRIEVE:
    if(USECACHE && (cache.contains(key) &! currentUser)){ //sort out for logged-in browse users.
      //Response.Write("using cache...<br />")
      out = cache.get(key);
    }
    
    //OTHERWISE, GENERATE THE OUTPUT AND POPULATE THE CACHE:
    else{
      //Response.Write("rendering new...<br/>");
      //Retrieve layout (direct property, parent viewtree node or finally the default?): TODO
      var layout          = false;
      var layoutManager   = new LayoutManager();
      var layoutId        = layoutManager.getLayoutId(node);  //TODO: COMBINE THESE!
      layout              = layoutManager.getLayout(layoutId);
      
      //LOAD PAGE FROM NODEID:
      var page = node.getPage(); 
      
      //GET THE MAPPING BETWEEN THE PAGE, THE CONTENT AND THE SLOT IDS FOR THE CURRENT PAGE LAYOUT
      var map = new ContentMap(page.id);
      
      //LOAD THE CONTENT:
      var contentArray = page.getContent();
      
      //RETRIEVE A LAYOUT OBJECT (basically the layout sourcecode with CCMS tokens): 
      var template = layoutManager.getTemplateSlots(layout.fileName);  //TODO: abstract output to a Template object? Possibly rename the method...
      
      //GET THE SOURCE OF THE LAYOUT CODE:
      var out = template.source;
      
      //ADD EACH ACTIVE CONTENT INSTANCE TO THE ARRAY OF CONTENT ITEMS FOR THE PAGE:
      var activeContentArray = new Array();
      var currInstance;
      for(var a=0;a<contentArray.length;a++){
      
        //handle editing:
        if(
            (currentUser.permissions & Permissions.EDITCONTENT) || 
            (currentUser.permissions & Permissions.EDITPAGE) || 
            (currentUser.permissions & Permissions.ADMINISTRATOR) 
          ){
          currInstance = contentArray[a].getLatestInstance();
        }
        else{
          currInstance = contentArray[a].getActiveInstance();   //this may be FALSE if no active instances.
        }
        activeContentArray[a]= currInstance;
      }
      
      //FOR EDITING WHEN LOGGED IN
      var currSlot          = new Object();
      var currEditSlot      = "";  //the javascript and form data
      var currContentIdMap  = 0; 
      
      //REPLACE THE CONTENT:
      if(template.slots != null)
      {
        for(var c=0;c<template.slots.length;c++){
          
          //GET THE SLOT:
          currSlot = editUtils.getSlot(template.slots[c],map);  //TODO: modify the slots[c] object to include the slot NUMBER, so I can map slot num to content ID properly 
      
          //RENDER EDIT OPTIONS IF LOGGED IN AND HAVE PERMS (sort out permissions)
          if(
              (currentUser.permissions & Permissions.EDITCONTENT) || 
              (currentUser.permissions & Permissions.EDITPAGE) || 
              (currentUser.permissions & Permissions.ADMINISTRATOR) 
            ){
            currEditSlot = currSlot.content;
          }
          
          currContentIdMap = 0; //reset
          
          //FIRST RETRIEVE THE MAPPING BETWEEN SLOT ID AND CONTENT ID FOR THE CURRENT SLOT:
          for(var d=0;d<map.mapping.length;d++){
            if(map.mapping[d].slotId == currSlot.slotId){
              currContentIdMap = map.mapping[d].contentId;
            }
          }
          
          if(currContentIdMap > 0){
            //THEN RETRIEVE THE CONTENT FROM THE ACTIVECONTENTARRAY USING THE DETERMINED MAP ABOVE:
            for(d=0;d<activeContentArray.length;d++){
              //Response.Write(activeContentArray[d]+"<br>")
              if(activeContentArray[d].contentId == currContentIdMap){
                out = out.replace(template.slots[c],currEditSlot + activeContentArray[d].content);
              }
            }
          }
          else{
            out = out.replace(template.slots[c],currEditSlot);
          }
        }
      }
      //GET THE EDIT BANNER IF USER IS LOGGED IN:
      out = editUtils.replaceEditBanner(out,currentUser,page);
      
      //REPLACE CORE PROPS:
      out = renderUtils.replaceCoreProperties(out,page,map);
      
      //REPLACE ANY CUSTOMISATIONS:
      out = insertCustomisedLayout(out,node);
  
      //only cache if there is no session:
      if(!currentUser){
        //Response.Write("storing in cache...");
        cache.store(key,out);
      }
    }
  }
  
  //TODO: add any other more dynamic stuff AFTER the cache logic (eg news etc.)
}
catch(e){
  Response.Write("error in core engine: " + e.message);
  for(p in e)
  {
      Response.Write(p +"="+e[p]+"<br />");
  }
}
%>
<%=out%>
