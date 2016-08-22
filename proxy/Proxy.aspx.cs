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
        string BaseUrl = ConfigurationManager.AppSettings["BaseUrl"];

        string formatString = ConfigurationManager.AppSettings["FormatString"];

        if (context.Request.QueryString != null && context.Request.QueryString["endpoint"] != null)
        {
            //build request endpoint and query:
            string endpointModifier = context.Request.QueryString["endpoint"];
            
            string _url = null;
                           
           if(endpointModifier == "rss"){
            	context.Response.AddHeader("Content-type","text/xml");
            	_url = BaseUrl + endpointModifier + "/" + context.Request.QueryString["project_id"];
            	//context.Response.Write(_url);
           }
            else{
            	context.Response.AddHeader("Content-type","application/json");
            	//default JSON call:
            	_url = BaseUrl + endpointModifier + "?format=" +formatString+ "&"  + context.Request.QueryString;
            }

            //string _out = client.DownloadString(BaseUrl + endpointModifier + "?format=" +formatString+ "&"  + context.Request.QueryString);
            string _out = client.DownloadString(_url);
            
            //add MIME type header:
            
            context.Response.Write(_out);
        }
        else
        {
            context.Response.Write("NO DATA");
        }
    }
}
