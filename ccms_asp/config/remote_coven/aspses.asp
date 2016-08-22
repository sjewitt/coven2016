<%
'ASP session time out checker by James Lopez

Response.Write("Session test<br>")

if isNULL(Session("time1")) or Session("time1") = "" then

Session("time1") = Time() 

Response.Write("You first visited this site at: " & Session("time1") & "<br>")

else 

Response.Write("The timeout is: " & Session.Timeout & "- first visited: " & Session("time1"))

end if

%>
