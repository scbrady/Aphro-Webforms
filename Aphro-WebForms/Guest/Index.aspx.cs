using System;

namespace Aphro_WebForms.Guest
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Global.CurrentPerson != null)
                GuestName.Text = Global.CurrentPerson.firstname + " " + Global.CurrentPerson.lastname;
            else
                GuestName.Text = "Not Logged In!";
        }
    }
}