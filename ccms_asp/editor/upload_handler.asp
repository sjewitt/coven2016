<%@ Language=VBScript %>
<% 
option explicit 
Response.Expires = -1
Server.ScriptTimeout = 600
%>
<!-- #include virtual="/ccms_asp/editor/freeaspupload.asp" -->
<%
  'handle posted data:
  Dim diagnostics
  if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
          
  else
    Dim uploadsDirVar
    uploadsDirVar = Server.MapPath("\images")
    SaveFiles()
    Response.Redirect(Request.ServerVariables("HTTP_REFERER") & "?uploaded=done")
  end if

function SaveFiles
    Dim Upload, fileName, fileSize, ks, i, fileKey
    
    SaveFiles = ""
    Set Upload = New FreeASPUpload
    
    Upload.Save(uploadsDirVar)

	  ' If something fails inside the script, but the exception is handled
	  If Err.Number<>0 then Exit function

    
    ks = Upload.UploadedFiles.keys
    if (UBound(ks) <> -1) then
        SaveFiles = "<B>Files uploaded:</B> "
        for each fileKey in Upload.UploadedFiles.keys
            SaveFiles = SaveFiles & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
        next
    else
        SaveFiles = "The file name specified in the upload form does not correspond to a valid file in the system."
    end if
	SaveFiles = SaveFiles & "<br>type = " & Upload.Form("filetype") & "<br>"
end function
%>

<HTML>
<HEAD>
<TITLE>Test Free ASP Upload 2.0</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style>
BODY {background-color: white;font-family:arial; font-size:12}
</style>
</HEAD>
<BODY>
<br><br>
<div style="border-bottom: #A91905 2px solid;font-size:16">Upload files to your server</div>
<br><br>
</BODY>
</HTML>
