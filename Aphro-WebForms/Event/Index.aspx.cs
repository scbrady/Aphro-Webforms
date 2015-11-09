using System;
using System.Data;
using Oracle.DataAccess.Client;

namespace Aphro_WebForms.Event
{
    public partial class Index : System.Web.UI.Page
    {
        OracleConnection connection = new OracleConnection("Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=csdb.cegx4epbufif.us-west-2.rds.amazonaws.com)(PORT=1521)))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=csdb)));User Id=TeamAphro;Password=house91Eagle;");

        protected void Page_Load(object sender, EventArgs e)
        {
            using (connection)
            {
                OracleCommand command = new OracleCommand("SELECTLOCATIONNAMES");
                command.Parameters.Add("name_cursor", OracleDbType.RefCursor).Direction = ParameterDirection.Output;
                DataSet dataSet = new DataSet();
                OracleDataAdapter dataAdapter = new OracleDataAdapter();
                dataAdapter.SelectCommand = command;
                dataAdapter.Fill(dataSet);
            }
        }
    }
}