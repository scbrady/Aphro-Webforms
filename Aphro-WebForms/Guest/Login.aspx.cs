using System;
using System.Configuration;
using System.Data;
using DevOne.Security.Cryptography.BCrypt;
using Oracle.DataAccess.Client;

namespace Aphro_WebForms.Guest
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly string _connectionString;

        public Login()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["OracleConnectionString"].ConnectionString;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            using (OracleConnection objConn = new OracleConnection(_connectionString))
            {
                OracleCommand objCmd = new OracleCommand("TICKETS_QUERIES.getGuest", objConn);
                objCmd.BindByName = true;
                objCmd.CommandType = CommandType.StoredProcedure;

                objCmd.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                objCmd.Parameters.Add("p_Email", OracleDbType.Varchar2, email.Text, ParameterDirection.Input);

                try
                {
                    objConn.Open();
                    OracleDataAdapter adapter = new OracleDataAdapter(objCmd);
                    adapter.Fill(dt);
                }
                catch (Exception ex)
                {
                    labelMessage.Text = ex.ToString();
                }
        
                objConn.Close();
            }
            if (dt.Rows.Count > 0)
            {
                var guest = dt.Rows[0];
                if (BCryptHelper.CheckPassword(password.Text, guest["password"].ToString()))
                    labelMessage.Text = "Welcome " + guest["first_name"];
                else
                    labelMessage.Text = "Wrong, try again";
            }
            else
            {
                labelMessage.Text = "No guest found with that email";
            }
        }
    }
}