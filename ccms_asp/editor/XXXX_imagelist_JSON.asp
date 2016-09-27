<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
Response.ContentType = "text/javascript";
Response.AddHeader('Pragma','no-cache');
Response.AddHeader('Expires','0'); // i.e. contents have already expired

var currentUser = userFactory.getCurrentUser();
if(currentUser){
  var out = "";
  var tempArr = editUtils.getUploadedBinaryLinkArray(true);
  out = tempArr.join(",");
%>
var tinyMCEImageList = new Array(
	<%=out%>
);
<%
}
else{
  Response.Write('[]');
}
%>