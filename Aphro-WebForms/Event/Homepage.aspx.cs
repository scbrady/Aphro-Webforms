using System;
using AutoMapper;
using System.Collections.Generic;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Web.UI.WebControls;

namespace Aphro_WebForms.Event
{
    public partial class Homepage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                DataTable upcomingEventsTable = new DataTable();
                List<Models.Event> upcomingEvents = new List<Models.Event>();

                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    // Set up the upcomingEvents command
                    var upcomingEventsCommand = new OracleCommand("TICKETS_QUERIES.getAllUpcomingEvents", objConn);
                    upcomingEventsCommand.BindByName = true;
                    upcomingEventsCommand.CommandType = CommandType.StoredProcedure;
                    upcomingEventsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                    try
                    {
                        // Execute the queries and auto map the results to models
                        objConn.Open();
                        var upcomingEventsAdapter = new OracleDataAdapter(upcomingEventsCommand);
                        upcomingEventsAdapter.Fill(upcomingEventsTable);
                        upcomingEvents = Mapper.DynamicMap<IDataReader, List<Models.Event>>(upcomingEventsTable.CreateDataReader());
                    }
                    catch (Exception ex)
                    {
                        // TODO: Handle Exception
                        throw (ex);
                    }

                    objConn.Close();
                }

                // Fill list dropdowns with data from the database
                if (upcomingEvents.Count > 0)
                    EventListview.DataSource = upcomingEvents;
                EventListview.DataBind();
            }
        }
        

        protected void Delete_Event(object sender, EventArgs e)
        {
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the delete event command
                var deleteCommand = new OracleCommand("TICKETS_API.deleteEvent", objConn);
                deleteCommand.BindByName = true;
                deleteCommand.CommandType = CommandType.StoredProcedure;
                deleteCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, long.Parse(((LinkButton)sender).CommandArgument), ParameterDirection.Input);

                try
                {
                    // Execute the command
                    objConn.Open();
                    deleteCommand.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    throw (ex);
                }

                objConn.Close();
            }
            Response.Redirect("Homepage.aspx");
        }

    }

}