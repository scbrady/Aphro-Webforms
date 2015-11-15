using System;
using System.Configuration;
using System.Data;
using DevOne.Security.Cryptography.BCrypt;
using Oracle.DataAccess.Client;

namespace Aphro_WebForms.Payment
{
    public partial class Pay : System.Web.UI.Page
    {
        private readonly string _connectionString;

        public Pay()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["OracleConnectionString"].ConnectionString;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

      
    }
}