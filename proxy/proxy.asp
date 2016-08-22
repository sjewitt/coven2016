<%@ language="javascript" %>

<%


    /*

    if (context.Request.QueryString != null && context.Request.QueryString["endpoint"] != null)
    {
        //build request endpoint and query:
        string endpointModifier = context.Request.QueryString["endpoint"];
            
        string _url = null;
                           
        if(endpointModifier == "rss"){
            context.Response.AddHeader("Content-type","text/xml");
            _url = BaseUrl + endpointModifier + "/" + context.Request.QueryString["project_id"];
            //context.Response.Write(_url);
        }
        else{
            context.Response.AddHeader("Content-type","application/json");
            //default JSON call:
            _url = BaseUrl + endpointModifier + "?format=" +formatString+ "&"  + context.Request.QueryString;
        }

        //string _out = client.DownloadString(BaseUrl + endpointModifier + "?format=" +formatString+ "&"  + context.Request.QueryString);
        string _out = client.DownloadString(_url);
            
        //add MIME type header:
            
        context.Response.Write(_out);
    }
    else
    {
        context.Response.Write("NO DATA"); 
    }
    */



//https://msdn.microsoft.com/en-us/library/ms763809(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/ms766431(v=vs.85).aspx

try{
    //gather the required Query Parameters URL, Format, Encoding
    var BaseUrl = "https://librivox.org/";
    var FormatString = "json";

    var endpointModifier = (new String(Request.QueryString("endpoint")).toString());

    if (endpointModifier != "undefined") {
        //Response.Write("process start<br />");
        var _url = null;
        if (endpointModifier == "rss") {
            Response.ContentType = "text/xml" ;
            _url = BaseUrl + endpointModifier + "/" + Request.QueryString("project_id");
        }
        else {
            Response.ContentType = "application/json";
            //default JSON call:
            _url = BaseUrl + endpointModifier + "?format=" + FormatString + "&" + Request.QueryString;
        }
    }


//    var calltype = (new String(Request.QueryString("calltype")).toString());
//    var contentid = (new String(Request.QueryString("contentid")).toString());
//    var listall = (new String(Request.QueryString("listall")).toString());

//    switch (calltype) {
//        case "json":
//            Response.ContentType = "application/json";
//            break;
//        case "xml":
//            Response.ContentType = "text/xml";
//            break;
//    }
//    var calltypePart = "?calltype=" + calltype;
//    var contentPart = "&contentid=" + contentid;
//    if (listall != "undefined") {
//        contentPart = "&listall=true";
//    }
    
    //build content retrieval URL:
//    callUrl = proxyBaseUrl + calltypePart + contentPart;

    Response.Write(_url);
    var xmlhttp;
    xmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0");
    xmlhttp.open("GET", _url, false);	//IF doing a POST:   use --> "POST",url,false
    xmlhttp.send();

    //display the response
    Response.Write(xmlhttp.responseText);
}
catch(e)
{
    Response.Write(e.message);
}
%>