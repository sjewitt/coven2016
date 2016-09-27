<%@ language="javascript" %>
<%
//https://msdn.microsoft.com/en-us/library/ms763809(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/ms766431(v=vs.85).aspx

try{
    //gather the required Query Parameters URL, Format, Encoding
    var proxyBaseUrl = "http://local.ccms.asp/ccms.asp";
    var callUrl;

    var calltype = (new String(Request.QueryString("calltype")).toString());
    var contentid = (new String(Request.QueryString("contentid")).toString());
    var listall = (new String(Request.QueryString("listall")).toString());

    switch (calltype) {
        case "json":
            Response.ContentType = "application/json";
            break;
        case "xml":
            Response.ContentType = "text/xml";
            break;
    }
    var calltypePart = "?calltype=" + calltype;
    var contentPart = "&contentid=" + contentid;
    if (listall != "undefined") {
        contentPart = "&listall=true";
    }
    
    //build content retrieval URL:
    callUrl = proxyBaseUrl + calltypePart + contentPart;

    var xmlhttp;
    xmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0");
    xmlhttp.open("GET", callUrl, false);	//IF doing a POST:   use --> "POST",url,false
    xmlhttp.send();

    //display the response
    Response.Write(xmlhttp.responseText);
}
catch(e)
{
    Response.Write(e.message);
}
%>