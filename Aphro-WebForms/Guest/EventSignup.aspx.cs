using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Guest
{
    public partial class EventSignup : System.Web.UI.Page
    {
        protected long SeriesId;
        protected long BuildingKey;
        protected string Building;
        protected int Members = 1;
        protected string MaxExtraTickets;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Global.CurrentPerson == null)
                    Response.Redirect("Login.aspx");
                else if (string.IsNullOrEmpty(Request.QueryString["Series"]))
                    Response.Redirect("Index.aspx");

                SeriesId = long.Parse(Request.QueryString["Series"]);
                SeriesIdField.Value = SeriesId.ToString();

                checkIfTicketsAlreadyPurchased(SeriesId);

                DataTable eventTable = new DataTable();
                List<Models.Event> eventModel = new List<Models.Event>();
                DataTable requestsTable = new DataTable();
                List<Models.GroupRequest> requestsModel = new List<Models.GroupRequest>();

                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    // Set up the getEvent command
                    var eventCommand = new OracleCommand("TICKETS_QUERIES.getEvent", objConn);
                    var requestsCommand = new OracleCommand("TICKETS_QUERIES.getGroupForEvent", objConn);

                    try
                    {
                        eventCommand.BindByName = true;
                        eventCommand.CommandType = CommandType.StoredProcedure;
                        eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                        eventCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);

                        // Set up the getGroupRequestsForEvent command                       
                        requestsCommand.BindByName = true;
                        requestsCommand.CommandType = CommandType.StoredProcedure;
                        requestsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                        requestsCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);
                        requestsCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                    }
                    catch (Exception ex)
                    {
                        // TODO: Handle Exception
                        Response.Redirect("www.google.com");
                    }

                    try
                    {
                        // Execute the queries and auto map the results to models
                        objConn.Open();
                        var eventAdapter = new OracleDataAdapter(eventCommand);
                        eventAdapter.Fill(eventTable);
                        eventModel = Mapper.DynamicMap<IDataReader, List<Models.Event>>(eventTable.CreateDataReader());

                        var requestsAdapter = new OracleDataAdapter(requestsCommand);
                        requestsAdapter.Fill(requestsTable);
                        requestsModel = Mapper.DynamicMap<IDataReader, List<Models.GroupRequest>>(requestsTable.CreateDataReader());
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
                    BuildingKeyField.Value = BuildingKey.ToString();

                    EventName.Text = currentEvent.name;
                    EventDescription.Text = currentEvent.description;
                    EventLocation.Text = currentEvent.building;
                    EventPrice.Text = "$" + currentEvent.regular_price;
                    EventPrimePrice.Text = "$" + currentEvent.prime_price;

                    EventDateDropDown.DataTextField = "event_datetime";
                    EventDateDropDown.DataValueField = "event_id";
                    EventDateDropDown.DataSource = eventModel;
                    EventDateDropDown.DataBind();
                }

                if (requestsModel.Count > 0)
                {
                    Members = requestsModel.FirstOrDefault().members;
                }
                MaxExtraTickets = (10 - Members).ToString();
                TicketQuantityRangeValidator.MaximumValue = MaxExtraTickets;
                GroupSize.Text = Members.ToString();
            }
        }

        private void checkIfTicketsAlreadyPurchased(long seriesId)
        {
            DataTable eventSeatsTable = new DataTable();
            List<Models.EventSeats> eventSeatsModel = new List<Models.EventSeats>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the getEventSeats command
                var eventSeatsCommand = new OracleCommand("TICKETS_QUERIES.getEventSeats", objConn);
                eventSeatsCommand.BindByName = true;
                eventSeatsCommand.CommandType = CommandType.StoredProcedure;
                eventSeatsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                eventSeatsCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);
                eventSeatsCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);

                try
                {
                    // Execute the queries and auto map the results to models
                    objConn.Open();
                    var eventSeatsAdapter = new OracleDataAdapter(eventSeatsCommand);
                    eventSeatsAdapter.Fill(eventSeatsTable);
                    eventSeatsModel = Mapper.DynamicMap<IDataReader, List<Models.EventSeats>>(eventSeatsTable.CreateDataReader());
                }
                catch (Exception ex)
                {
                    // This is ok if an error comes up, let the program handle it later
                }

                objConn.Close();

                // If the person already has tickets, redirect them to the page where they can review it
                if (eventSeatsModel.Any())
                    Response.Redirect("ReviewTickets.aspx?Series=" + SeriesId);
            }
        }

        protected void GetTickets_Click(object sender, EventArgs e)
        {
            bool failed = false;
            SeriesId = int.Parse(SeriesIdField.Value);
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the inserting seats command
                var seatCommand = new OracleCommand("TICKETS_API.insertEventSeats", objConn);
                try
                {
                    seatCommand.BindByName = true;
                    seatCommand.CommandType = CommandType.StoredProcedure;
                    seatCommand.Parameters.Add("p_EventId", OracleDbType.Int64, int.Parse(EventDateDropDown.SelectedValue), ParameterDirection.Input);
                    seatCommand.Parameters.Add("p_SectionKey", OracleDbType.Int32, int.Parse(SelectedSection.Value), ParameterDirection.Input);
                    seatCommand.Parameters.Add("p_Subsection", OracleDbType.Int32, int.Parse(SelectedSubsection.Value), ParameterDirection.Input);
                    seatCommand.Parameters.Add("p_SeatRow", OracleDbType.Varchar2, SelectedRow.Value, ParameterDirection.Input);
                    seatCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                    failed = false;
                }
                catch(Exception ex)
                {
                    Error.Visible = true;
                    failed = true;
                }
                if (failed == false)
                {
                    try
                    {
                        // Execute the command
                        objConn.Open();
                        seatCommand.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        // Couldn't get those seats (probably taken), pick again
                        throw (ex);
                    }

                    objConn.Close();
                    Response.Redirect("ReviewTickets.aspx?Series=" + SeriesId);
                }
            }
        }

        protected void GetExtraTickets_Click(object sender, EventArgs e)
        {
            SeriesId = int.Parse(SeriesIdField.Value);
            Members = int.Parse(GroupSize.Text);
            int extraTickets = int.Parse(TicketQuantity.Text);
            // "Purchase" tickets
            // Make new group or add this many people to the group that is already made
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the inserting groups command
                var groupsCommand = new OracleCommand("TICKETS_API.insertGroups", objConn);
                groupsCommand.BindByName = true;
                groupsCommand.CommandType = CommandType.StoredProcedure;
                groupsCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                groupsCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);
                groupsCommand.Parameters.Add("p_ExtraSeats", OracleDbType.Int32, extraTickets, ParameterDirection.Input);

                try
                {
                    // Execute the command
                    objConn.Open();
                    groupsCommand.ExecuteNonQuery();

                    Members += extraTickets;
                    MaxExtraTickets = (10 - Members).ToString();
                    TicketQuantityRangeValidator.MaximumValue = MaxExtraTickets;
                    GroupSize.Text = Members.ToString();
                    TicketQuantity.Text = "";
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