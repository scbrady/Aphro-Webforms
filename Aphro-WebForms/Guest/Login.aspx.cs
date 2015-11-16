using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using AutoMapper;
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
            DataTable guestTable = new DataTable();
            Models.Guest guest = null;

            using (OracleConnection objConn = new OracleConnection(_connectionString))
            {
                var saltedPassword = BCryptHelper.HashPassword(password.Text, Global.Salt);

                OracleCommand objCmd = new OracleCommand("TICKETS_QUERIES.loginGuest", objConn);
                objCmd.BindByName = true;
                objCmd.CommandType = CommandType.StoredProcedure;

                objCmd.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                objCmd.Parameters.Add("p_Email", OracleDbType.Varchar2, email.Text, ParameterDirection.Input);
                objCmd.Parameters.Add("p_Password", OracleDbType.Varchar2, saltedPassword, ParameterDirection.Input);

                try
                {
                    objConn.Open();
                    OracleDataAdapter adapter = new OracleDataAdapter(objCmd);
                    adapter.Fill(guestTable);
                    guest = Mapper.DynamicMap<IDataReader, List<Models.Guest>>(guestTable.CreateDataReader()).FirstOrDefault();
                }
                catch (Exception ex)
                {
                    labelMessage.Text = ex.ToString();
                }
        
                objConn.Close();
            }
            if (guest != null)
                labelMessage.Text = "Welcome " + guest.firstname;
            else
                labelMessage.Text = "Wrong email/password";
        }
    }
}