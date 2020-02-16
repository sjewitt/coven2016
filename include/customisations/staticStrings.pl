#get a data struture holding navigation data:
$LOGIN_PAGE_HEADER = 
"Content-type: text/html\r\n\r\n
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
<html>
  <head>
    <title>Login</title>
    <link rel=\"stylesheet\" href=\"/styles/coven.css\" type=\"text/css\" />
    <script src=\"/script/edit.js\" type=\"text/javascript\"></script>
    <meta name=\"keywords\"       content=\"login\" />
    <meta name=\"description\"    content=\"login\" />
    <meta name=\"author\"         content=\"silas\" />
  </head>
  <body>
   <div class=\"contentlogo\"></div>
    <div class=\"contentheader\">
      <div class=\"thumbheader\"></div>
      <img src=\"/images/logos/{CMS_CONTENT2}\" />
    </div>
    <div class=\"content\">";

$LOGIN_PAGE_FOOTER = 
"</div>
    <div class=\"homelink\">
        <a href=\"/\" title=\"Back to homepage\">
            <img src=\"/images/structure/transpacer.gif\" width=\"150\" height=\"30\" alt=\"spacer\" />
        </a>
    </div>
  </body>
</html>";

$LOGIN_PAGE_INITIAL_FORM = 
"<h1>Login</h1>
        <p>
            Please login with your username and password:
        </p>
<form name=\"login\" method=\"POST\" action=\"\">
<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
    <tr>
        <td class=\"content\">
            <table>
                <tr>
                    <td width=\"180\">Name</td>
                    <td><input type=\"text\" name=\"user\" value=\"\"></td>
                </tr>
                <tr>
                    <td width=\"180\">Password</td>
                    <td><input type=\"password\" name=\"pwd\" value=\"\"></td>
                </tr>
                <tr>
                    <td colspan=\"2\"><input type=\"submit\" value=\"Log In\"></td>
                </tr>          
            </table>
        </td>
</table>
</form>";
1;  #must always return 1.
