<%
/*
retrieve the slots from the template. This will
eventually include the core and custom slotas as well as separate properties 
of a complex return object.

turn this into a class, return the HTML source as well.

TODO: Move this to the LayoutManager class!!!
*/
function getTemplateSlots(template){  //do something with PATH here:
  try{
    var returnObj = new Object();
    
    
    var fs = Server.CreateObject("Scripting.FileSystemObject");
    var absolutePath = Server.MapPath("/ccms_asp/templates/" + template);
    //Response.Write(absolutePath);
    var fContents = "";
    var objF;
    var ts;
    //Response.Write(fs.FileExists(absolutePath)+"<br />");
    
    if(!fs.FileExists(absolutePath)){
      throw new Error("Cannot find template /ccms_asp/templates/" + template);
    }
    else{
      //open text stream:
      ts = fs.OpenTextFile(absolutePath,1);
    
      fContents = ts.ReadAll();
      
      //ensure textstream is closed:
      ts.close();
      f = null;
      fs = null;
    }
    
    var re = /{CMS_CONTENT_[0-9]}/g;
    var slots = fContents.match(re);    
    returnObj.slots = slots;
    returnObj.source = fContents;
    return returnObj;
  }
  catch(e){
    Response.Write("Error in getTemplateSlots(): '" + absolutePath + "'! (" + e.message + ")<br />");
    return("error");
  }  
}
%>

