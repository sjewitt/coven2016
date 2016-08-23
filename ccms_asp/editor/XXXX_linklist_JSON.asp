<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
Response.ContentType = "text/javascript";
Response.AddHeader('Pragma','no-cache');
Response.AddHeader('Expires','0'); // i.e. contents have already expired

var currentUser = userFactory.getCurrentUser();
if(currentUser){
  var out = "";
  var tempArr = new Array();
  tempArr = tempArr.concat(editUtils.getInternalLinkArray());
  tempArr = tempArr.concat(editUtils.getUploadedBinaryLinkArray());
  out = tempArr.join(",");
%>
var tinyMCELinkList = new Array(
	<%=out%>
);
<%
}
else{
  Response.Write('[]');
}
%>
