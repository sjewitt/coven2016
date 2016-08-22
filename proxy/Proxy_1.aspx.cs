using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;
using System.Web.UI;
//using System.Web.UI.WebControls;
using System.Net;
using System.Configuration;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ProcessRequest(this.Page);
    }



    public void ProcessRequest(Page context)
    {
        WebClient client = new WebClient();
        string BaseUrl = ConfigurationManager.AppSettings["BaseUrl2"];

        if (context.Request.QueryString != null)
        {
            string _out = client.DownloadString(BaseUrl + "?"  + context.Request.QueryString);
            context.Response.Write(_out);
        }
        else
        {
            context.Response.Write("NO DATA");
        }
    }
}
