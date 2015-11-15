using System;
using Oracle.DataAccess.Client;
using System.Configuration;
using System.Data;
using DevOne.Security.Cryptography.BCrypt;
using OracleCommand = Oracle.DataAccess.Client.OracleCommand;
using OracleConnection = Oracle.DataAccess.Client.OracleConnection;

namespace Aphro_WebForms.Guest
{
    public partial class Register : System.Web.UI.Page
    {
        private readonly string _connectionString;

        public Register()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["OracleConnectionString"].ConnectionString;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            labelMessage.Text = "";
        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                var salt = BCryptHelper.GenerateSalt();
                var saltedPassword = BCryptHelper.HashPassword(password.Text, salt);

                using (OracleConnection objConn = new OracleConnection(_connectionString))
                {
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
                    labelMessage.Text = "Guest added!";
            }
        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            if(Page.IsValid)
                Response.Redirect("Login.aspx");
        }
    }
}