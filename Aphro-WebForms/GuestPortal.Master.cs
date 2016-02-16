using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aphro_WebForms
{
    public partial class GuestPortal : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {

            if (Global.CurrentPerson != null)
                Global.CurrentPerson = null;
            Response.Redirect("Login.aspx");
        }
    }
}