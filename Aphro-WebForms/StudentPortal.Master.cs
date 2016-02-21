using System;

namespace Aphro_WebForms
{
    public partial class StudentPortal : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Global.CurrentPerson = null;
            Response.Redirect("Index.aspx");
        }
    }
}