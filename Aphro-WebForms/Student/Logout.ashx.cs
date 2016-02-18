using System.Web;
using System.Web.SessionState;

namespace Aphro_WebForms.Student
{
    public class Logout : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            Global.CurrentPerson = null;
            context.Response.Redirect("Index", true);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}