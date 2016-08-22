<%
function showObject(obj, spacer){
  var logger = log4CCMS.init();
	try{
    if(!spacer){
  		spacer = "";
  	}
  	for(var prop in obj){
  	  if(typeof(obj[prop]) != 'function'){
  		  Response.Write(spacer + ">" + prop + " (" + typeof(obj[prop]) + ") " + " - " + obj[prop] +"<br>\n");
  		}
      if(typeof(obj[prop]) == "object"){
  			showObject(obj[prop], spacer + "__");
  		}
  	}
  }
  catch(e){
    logger.warn(e.message,"showObject");
  }
}
%>
