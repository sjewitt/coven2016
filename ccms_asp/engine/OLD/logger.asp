<%
function logger(msg){
  var file = Server.MapPath("/logs/logfile.log");
  try{
    var d = new Date();
    var objF;
    var ts;
    var fs = Server.CreateObject("Scripting.FileSystemObject");
    if(!fs.FileExists(file)){
      objF = fs.CreateTextFile(file,false);
    }
    objF = fs.GetFile(file);
  
    //open text stream:
    ts = objF.OpenAsTextStream(8,0);
    ts.WriteLine(d +"." + d.getMilliseconds() + ": " + msg);
    
    //ensure textstream is closed:
    ts.close();
    f = null;
    fs = null;
  }
  catch(e){
    //Response.Write("Cannot create/append to logfile '" + file + "'! (" + e.message + ")");
  }  
}
%>

