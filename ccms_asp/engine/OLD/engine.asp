<%@ language="javascript" %>
<!--#include virtual="/classes/Page.asp"-->
<!--#include virtual="/classes/Content.asp"-->
<!--#include virtual="/classes/ContentInstance.asp"-->
<!--#include virtual="/classes/Layout.asp"-->

<%
//determine if the user is logged in:
var currentUser = false;
if(Session("currentUser") != null){
  currentUser = eval(Session("currentUser"));
}

Response.Write(currentUser);


var getPage = false;
if((new String(Request("pageid"))) != 'undefined'){
  var pageId = parseInt(new String(Request("pageid")));
  getPage = true;
  var myNewPage = new Page(); //get page ID from url param
  var content1 = "default1";
  var content2 = "default2";
  
  /*replace this bit with DB stuff:*/
  switch(pageId){
    case 1:
      content1 = "new content slot 1";
      content2 = "captain slow!";
    break;
    case 2:
      content1 = "I am your father!";
      content2 = "Will it help if I get out and push?";
    break;
    default:
      getPage = false;
  }
  
  if(getPage){
    //create content objects TODO: Sort mapping between PAGE ID AND SLOT ID
    var myNewContent1 = new ContentInstance(27);
    var myNewContent2 = new ContentInstance(443);
    myNewContent1.setContent(content1);
    myNewContent2.setContent(content2);
    
    //associate the content with the page:
    myNewPage.setContent(1,myNewContent1);
    myNewPage.setContent(2,myNewContent2);
    
    //create a layout object:
    var layout = new Layout(12);
    //simple HTML layout with slots:
    var html = "<html><head></head><body><p>layout fixed text...<table border=\"1\" width=\"100%\"><tr><td>dynamic 1: {CMS_CONTENT1}</td><td>dynamic 2: {CMS_CONTENT2}</td></tr></table>";
    layout.setHTMLCode(html);
    var out = layout.setContent(myNewPage);
    
    //Response.Write("new page: "+myNewPage.getContent(1)+"<br />");
    //Response.Write("new page: "+myNewPage.getContent(2)+"<br />");
  }
  else{
    out = "Page does not exist";
  }
}
else{
  out = "No page ID supplied";
}
Response.Write(out);
%>
