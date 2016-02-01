using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using AutoMapper;
using Oracle.DataAccess.Client;

namespace Aphro_WebForms.Guest
{
    public partial class EventSignup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["Event"]))
            {
                var eventId = long.Parse(Request.QueryString["Event"]);

                DataTable eventTable = new DataTable();
                List<Models.Event> eventModel = new List<Models.Event>();

                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    // Set up the upcomingEvents command
                    var eventCommand = new OracleCommand("TICKETS_QUERIES.getEvent", objConn);
                    eventCommand.BindByName = true;
                    eventCommand.CommandType = CommandType.StoredProcedure;
                    eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                    eventCommand.Parameters.Add("p_EventId", OracleDbType.Int64, eventId, ParameterDirection.Input);

                    try
                    {
                        // Execute the queries and auto map the results to models
                        objConn.Open();
                        var eventAdapter = new OracleDataAdapter(eventCommand);
                        eventAdapter.Fill(eventTable);
                        eventModel = Mapper.DynamicMap<IDataReader, List<Models.Event>>(eventTable.CreateDataReader());
                    }
                    catch (Exception ex)
                    {
                        // TODO: Handle Exception
                        throw (ex);
                    }

                    objConn.Close();
                }

                // Fill list dropdowns with data from the database
                if (eventModel.Count > 0)
                {
                    var currentEvent = eventModel.FirstOrDefault();
                    EventName.Text = currentEvent.name;
                    EventDescription.Text = currentEvent.description;
                    EventLocation.Text = currentEvent.building;
                    EventPrice.Text = "$" + currentEvent.regular_price;
                    EventPrimePrice.Text = "$" + currentEvent.prime_price;

                    EventDateListview.DataSource = eventModel;
                    EventDateListview.DataBind();
                }
            }
        }
    }
}