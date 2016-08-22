using System;
using System.Web.UI;
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
        string BaseUrl = ConfigurationManager.AppSettings["CCMSBaseUrl"];

        if (context.Request.QueryString != null)
        {
            //build request endpoint and query:
            string calltype = context.Request.QueryString["calltype"];
            string contentid = context.Request.QueryString["contentid"];    //actually an int. 
            //or
            string listall = context.Request.QueryString["listall"]; 

            string _url = null;


            if (calltype != null)
            {
                switch (calltype)
                {
                    case "json":
                        context.Response.AddHeader("Content-type", "application/json");
                        break;

                    case "xml":
                        context.Response.AddHeader("Content-type", "text/xml");
                        break;
                };
                if (contentid != null)
                {
                    _url = BaseUrl + "?calltype=" + calltype + "&contentid=" + contentid;
                }
                if (listall != null)
                {
                    _url = BaseUrl + "?calltype=" + calltype + "&listall=" + listall;
                }


                //string _out = client.DownloadString(BaseUrl + endpointModifier + "?format=" +formatString+ "&"  + context.Request.QueryString);
                string _out = client.DownloadString(_url);

                //add MIME type header:
                context.Response.Write(_out);
            }
        }
        else
        {
            context.Response.Write("NO DATA");
        }
    }
}
