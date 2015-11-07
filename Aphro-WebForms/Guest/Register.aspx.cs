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
                    OracleCommand objCmd = new OracleCommand("GUEST_ACCOUNTS.INSERT_GUEST", objConn);
                    objCmd.BindByName = true;
                    objCmd.CommandType = CommandType.StoredProcedure;

                    objCmd.Parameters.Add("g_first_name", OracleDbType.Varchar2, first_name.Text,
                        ParameterDirection.Input);
                    objCmd.Parameters.Add("g_last_name", OracleDbType.Varchar2, last_name.Text, ParameterDirection.Input);
                    objCmd.Parameters.Add("g_email", OracleDbType.Varchar2, email.Text, ParameterDirection.Input);
                    objCmd.Parameters.Add("g_password", OracleDbType.Varchar2, saltedPassword, ParameterDirection.Input);

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
    }
}