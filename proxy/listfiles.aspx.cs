using System;
using System.Web.UI;
using System.Net;
using System.Configuration;
using System.IO;
using System.Collections.Generic;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ProcessRequest(this.Page);
    }

    private String[] _mask = {"/images/wedding/"};  //from config

    public void ProcessRequest(Page context)
    {
        List<String> _temp = new List<string>();

        Response.ContentType = "application/json";
        Response.Write("{\"images\" : [");

        //http://stackoverflow.com/questions/275781/server-mappath-server-mappath-server-mappath-server-mappath
        //http://stackoverflow.com/questions/3164/absolute-path-back-to-web-relative-path
        //http://stackoverflow.com/questions/1591747/how-do-i-get-a-list-of-files-from-a-web-directory

        foreach (string filename in Directory.GetFiles(Server.MapPath(_mask[0]), "*.jpg", SearchOption.TopDirectoryOnly))
        {
            _temp.Add("\"" + _mask[0] + getRelativePath(filename) + "\"");
        }

        Response.Write(String.Join(",",_temp.ToArray()));
        Response.Write("]}");
    }

    private String getRelativePath(String fullPath){
        String _out = "";
        _out = fullPath.Replace("\\","/");
       // Response.Write(_out.Split(_mask,StringSplitOptions.None)[1]);
        _out = _out.Split(_mask,StringSplitOptions.None)[1];
        return _out;
    }
}
