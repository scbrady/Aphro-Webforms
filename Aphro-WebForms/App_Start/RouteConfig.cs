using Microsoft.AspNet.FriendlyUrls;
using System.Web.Routing;

namespace Aphro_WebForms
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings() { AutoRedirectMode = RedirectMode.Permanent };

            // Allows urls to leave off the .aspx ending
            routes.EnableFriendlyUrls(settings);
        }
    }
}