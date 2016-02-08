using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;

namespace Aphro_WebForms.Guest
{
    public partial class EventSignup : System.Web.UI.Page
    {
        protected long EventId;
        protected long BuildingKey;
        protected string Building;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Global.CurrentPerson == null)
                Response.Redirect("Login.aspx");

            if (!string.IsNullOrEmpty(Request.QueryString["Event"]))
            {
                EventId = long.Parse(Request.QueryString["Event"]);

                DataTable eventTable = new DataTable();
                List<Models.Event> eventModel = new List<Models.Event>();

                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    // Set up the getEvent command
                    var eventCommand = new OracleCommand("TICKETS_QUERIES.getEvent", objConn);
                    eventCommand.BindByName = true;
                    eventCommand.CommandType = CommandType.StoredProcedure;
                    eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                    eventCommand.Parameters.Add("p_EventId", OracleDbType.Int64, EventId, ParameterDirection.Input);

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
                    BuildingKey = currentEvent.building_key;
                    Building = currentEvent.building;

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

        protected void GetTickets_Click(object sender, EventArgs e)
        {
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the inserting seats command
                var seatCommand = new OracleCommand("TICKETS_API.insertEventSeats", objConn);
                seatCommand.BindByName = true;
                seatCommand.CommandType = CommandType.StoredProcedure;
                seatCommand.Parameters.Add("p_EventId", OracleDbType.Int64, EventId, ParameterDirection.Input);
                seatCommand.Parameters.Add("p_SectionKey", OracleDbType.Int32, int.Parse(SelectedSection.Value), ParameterDirection.Input);
                seatCommand.Parameters.Add("p_Subsection", OracleDbType.Int32, int.Parse(SelectedSubsection.Value), ParameterDirection.Input);
                seatCommand.Parameters.Add("p_SeatRow", OracleDbType.Varchar2, SelectedRow.Value, ParameterDirection.Input);
                seatCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);

                try
                {
                    // Execute the command
                    objConn.Open();
                    seatCommand.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    throw (ex);
                }

                objConn.Close();
            }
        }

        protected void GetExtraTickets_Click(object sender, EventArgs e)
        {
            // "Purchase" tickets
            // Make new group or add this many people to the group that is already made
        }
    }
}