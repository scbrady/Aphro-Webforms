using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI.WebControls;

namespace Aphro_WebForms.Event
{
    public partial class Index : System.Web.UI.Page
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
                    var upcomingEventsCommand = new OracleCommand("TICKETS_QUERIES.getAllEvents", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
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
                // Get the seriesId and picture name from the button
                string[] commandArgs = (((LinkButton)sender).CommandArgument).ToString().Split(new char[] { ',' });
                string seriesId = commandArgs[0];
                string pictureName = commandArgs[1];

                // Delete the picture uploaded if it is not the default picture
                if (pictureName != "events_medium.jpg")
                {
                    string filePath = Server.MapPath("~/Content/pictures/" + pictureName);
                    if (System.IO.File.Exists(filePath))
                    {
                        System.IO.File.Delete(filePath);
                    }
                }

                // Set up the delete event command
                var deleteCommand = new OracleCommand("TICKETS_API.deleteEvent", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                deleteCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, long.Parse(seriesId), ParameterDirection.Input);

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
            Response.Redirect("Index.aspx");
        }
    }
}