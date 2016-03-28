using Aphro_WebForms.Models;
using AutoMapper;
using DevOne.Security.Cryptography.BCrypt;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Guest
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Global.CurrentPerson != null && Global.CurrentPerson.accountType == Account.Guest)
            {
                Response.Redirect("Index.aspx");
            }
            else if (Global.CurrentPerson != null)
                Global.CurrentPerson = null;
        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            DataTable guestTable = new DataTable();
            Person guest = null;

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Hash and salt the password using Bcrypt before checking it with the hashed password in the Database
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
                    guest = Mapper.DynamicMap<IDataReader, List<Person>>(guestTable.CreateDataReader()).FirstOrDefault();
                }
                catch (Exception ex)
                {
                    labelMessage.Text = "Could not login. Try again later.";
                }

                objConn.Close();
            }
            if (guest != null)
            {
                Global.CurrentPerson = guest;
                Global.CurrentPerson.accountType = Account.Guest;
                Response.Redirect("Index.aspx");
            }
            else
                labelMessage.Text = "Wrong email/password";
        }
    }
}