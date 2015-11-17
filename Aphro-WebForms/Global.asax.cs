using System;
using System.Configuration;
using System.Web.Optimization;
using System.Web.Routing;

namespace Aphro_WebForms
{
    public class Global : System.Web.HttpApplication
    {
        public static readonly string Salt = "$2a$10$78mrCjBryPC5jhW3SeR2pe";
        public static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["OracleConnectionString"].ConnectionString;

        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}