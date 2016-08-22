<%@ language="javascript" %>
<!--#include virtual="/ccms_asp/engine/api.asp"-->
<%
var referrer = new String(Request.QueryString("referrer"));
if(Session("referrer") == null){
  Session("referrer") = referrer;
}
%><?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>

    <link rel="stylesheet" href="/ccms_asp/editor/styles/editstyles.css" type="text/css" />
    <title>Login</title>
  </head>
  <body onload="loginFocus();">
    <div id="container">
      <div id="loginform">
        <h1>CCMS Login</h1>
<%
//TRY LOGIN CREDENTIALS:
if((new String(Request.Form("login"))) != "undefined" && (new String(Request.Form("password"))) != "undefined"){
  var user = userFactory.login(Request.Form("login"),Request.Form("password"));
  if(user){
      Response.Redirect(Session("referrer"));
  }
  else{
%>
  <form name="loginform" id="login" action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method="post">
    <p class="error">Not logged in! try again...</p>
    <table>
      <tr>
        <td>Username</td>
        <td><input type="text" name="login" value="" /></td>
      </tr>
      <tr>
        <td>Password</td>
        <td><input type="password" name="password" value="" /></td>
      </tr>
    </table>
    <p>
      <input type="submit" value="login" />
    </p>
  </form>
<%
  }
}
else{
%>
  <form name="loginform" id="login" action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method="post">
    <p>Please log in:</p>
    <table>
      <tr>
        <td>Username</td>
        <td><input type="text" name="login" value="" /></td>
      </tr>
      <tr>
        <td>Password</td>
        <td><input type="password" name="password" value="" /></td>
      </tr>
    </table>
    <p>
      <input type="submit" value="login" />
    </p>
  </form>
<%
}
%>
      <a href="<%=Session("referrer")%>">Cancel</a>
    </div>
  </div>
  <script type="text/javascript">
    <!--
    function loginFocus(){
      document.loginform.login.focus();
    }
    //-->
    </script>
</body>
</html>
