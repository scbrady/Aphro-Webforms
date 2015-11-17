using System;
using System.Collections.Generic;
using System.Data;
using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.DataAccess.Client;

namespace Aphro_WebForms.Event
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable eventTypeNamesTable = new DataTable();
            List<EventType> eventTypes = new List<EventType>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                OracleCommand objCmd = new OracleCommand("TICKETS_QUERIES.getEventTypeNames", objConn);
                objCmd.BindByName = true;
                objCmd.CommandType = CommandType.StoredProcedure;

                objCmd.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                try
                {
                    objConn.Open();
                    OracleDataAdapter adapter = new OracleDataAdapter(objCmd);
                    adapter.Fill(eventTypeNamesTable);
                    eventTypes = Mapper.DynamicMap<IDataReader, List<EventType>>(eventTypeNamesTable.CreateDataReader());
                }
                catch (Exception ex)
                {
                    throw (ex);
                }

                objConn.Close();
            }
        }
    }
}