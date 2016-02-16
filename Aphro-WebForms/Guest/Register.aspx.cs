using System;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;
using System.Data;
using DevOne.Security.Cryptography.BCrypt;
using OracleCommand = Oracle.ManagedDataAccess.Client.OracleCommand;
using OracleConnection = Oracle.ManagedDataAccess.Client.OracleConnection;
using Aphro_WebForms.Models;

namespace Aphro_WebForms.Guest
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            labelMessage.Text = "";
            if (Global.CurrentPerson != null && Global.CurrentPerson.accountType == Account.Guest)
            {
                Response.Redirect("Index.aspx");
            }
            else if (Global.CurrentPerson != null)
                Global.CurrentPerson = null;
        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Hash and salt the password using Bcyrpt before it gets sent to the database
                var saltedPassword = BCryptHelper.HashPassword(password.Text, Global.Salt);

                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    // Declare the stored procedure to execute and send it the parameters it needs
                    OracleCommand objCmd = new OracleCommand("tickets_api.insertGuest", objConn);
                    objCmd.BindByName = true;
                    objCmd.CommandType = CommandType.StoredProcedure;

                    objCmd.Parameters.Add("p_FirstName", OracleDbType.Varchar2, first_name.Text, ParameterDirection.Input);
                    objCmd.Parameters.Add("p_LastName", OracleDbType.Varchar2, last_name.Text, ParameterDirection.Input);
                    objCmd.Parameters.Add("p_Email", OracleDbType.Varchar2, email.Text, ParameterDirection.Input);
                    objCmd.Parameters.Add("p_Password", OracleDbType.Varchar2, saltedPassword, ParameterDirection.Input);

                    try
                    {
                        objConn.Open();
                        objCmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        labelMessage.Text = ex.ToString();
                    }
                               
                    objConn.Close();
                }

                if (string.IsNullOrEmpty(labelMessage.Text))
                    Response.Redirect("Login.aspx");
            }
        }
    }
}