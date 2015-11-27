﻿using System;
using System.Configuration;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using Aphro_WebForms.Models;

namespace Aphro_WebForms
{
    public class Global : HttpApplication
    {
        public static readonly string Salt = "$2a$10$78mrCjBryPC5jhW3SeR2pe";
        public static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["OracleConnectionString"].ConnectionString;

        public static Person CurrentPerson
        {
            get
            {
                return (Person)HttpContext.Current.Session["CurrentPerson"];
            }

            set
            {
                HttpContext.Current.Session["CurrentPerson"] = value;
            }
        }

        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}