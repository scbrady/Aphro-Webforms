﻿using AutoMapper;
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
        protected int AlreadyPurchasedTickets = 0;
        protected string MaxExtraTickets;

        protected void Page_Load(object sender, EventArgs e)
        {
            GuestTicketsSize.Attributes.Add("readonly", "readonly");
            if (!IsPostBack)
            {
                if (Global.CurrentPerson == null || string.IsNullOrEmpty(Request.QueryString["Series"]))
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
                    try
                    {
                        // Set up the getEvent command
                        var eventCommand = new OracleCommand("TICKETS_QUERIES.getEvent", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                        eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                        eventCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);

                        // Set up the getGroupRequestsForEvent command
                        var requestsCommand = new OracleCommand("TICKETS_QUERIES.getGroupForEvent", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                        requestsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                        requestsCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);
                        requestsCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);

                        // Execute the queries and auto map the results to models
                        objConn.Open();
                        var eventAdapter = new OracleDataAdapter(eventCommand);
                        eventAdapter.Fill(eventTable);
                        eventModel = Mapper.DynamicMap<IDataReader, List<Models.Event>>(eventTable.CreateDataReader());

                        var requestsAdapter = new OracleDataAdapter(requestsCommand);
                        requestsAdapter.Fill(requestsTable);
                        requestsModel = Mapper.DynamicMap<IDataReader, List<Models.GroupRequest>>(requestsTable.CreateDataReader());
                    }
                    catch (Exception)
                    {
                        Response.Redirect("Index.aspx");
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

                    eventModel.ForEach(ed => ed.friendly_date = ed.event_datetime.ToString("dddd, MMMM d - h:mm tt"));
                    EventDateDropDown.DataTextField = "friendly_date";
                    EventDateDropDown.DataValueField = "event_id";
                    EventDateDropDown.DataSource = eventModel;
                    EventDateDropDown.DataBind();
                }

                if (requestsModel.Count > 0)
                {
                    AlreadyPurchasedTickets = requestsModel.FirstOrDefault().guest_tickets + 1;
                    GroupSize.Text = AlreadyPurchasedTickets.ToString();
                    GuestTicketsSize.Text = "0";
                    if (Request.QueryString["Error"] != null)
                    {
                        Error.Text = "Those seats are no longer available. Please pick new seats.";
                        Error.Visible = true;
                    }
                }
            }
        }

        private void checkIfTicketsAlreadyPurchased(long seriesId)
        {
            DataTable eventSeatsTable = new DataTable();
            List<Models.EventSeats> eventSeatsModel = new List<Models.EventSeats>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the getEventSeats command
                var eventSeatsCommand = new OracleCommand("TICKETS_QUERIES.getEventSeats", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
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
                catch (Exception)
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

            if (!getExtraTickets())
            {
                Error.Visible = true;
                return;
            }

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                try
                {
                    // Set up the inserting seats command
                    var seatCommand = new OracleCommand("TICKETS_API.insertEventSeats", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                    seatCommand.Parameters.Add("p_EventId", OracleDbType.Int64, int.Parse(EventDateDropDown.SelectedValue), ParameterDirection.Input);
                    seatCommand.Parameters.Add("p_SectionKey", OracleDbType.Int32, int.Parse(SelectedSection.Value), ParameterDirection.Input);
                    seatCommand.Parameters.Add("p_Subsection", OracleDbType.Int32, int.Parse(SelectedSubsection.Value), ParameterDirection.Input);
                    seatCommand.Parameters.Add("p_SeatRow", OracleDbType.Varchar2, SelectedRow.Value, ParameterDirection.Input);
                    seatCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);

                    // Execute the command
                    objConn.Open();
                    seatCommand.ExecuteNonQuery();
                }
                catch (Exception)
                {
                    // Couldn't get those seats (probably taken), pick again
                    failed = true;
                }

                objConn.Close();
            }
            if (!failed)
                Response.Redirect("ReviewTickets.aspx?Series=" + SeriesId);
            else
                Response.Redirect(string.Format("EventSignup.aspx?Series={0}&Error=1", SeriesId));
        }

        // "Purchase" tickets
        // Make new group or add this many people to the group that is already made
        protected bool getExtraTickets()
        {
            int extraTickets;

            int.TryParse(GroupSize.Text, out AlreadyPurchasedTickets);

            if (!long.TryParse(SeriesIdField.Value, out SeriesId) || !int.TryParse(GuestTicketsSize.Text, out extraTickets))
            {
                Error.Text = "Could not buy extra tickets, try again later.";
                return false;
            }

            if ((AlreadyPurchasedTickets == 0 && (extraTickets <= 0 || extraTickets > 10)) ||
                (AlreadyPurchasedTickets > 0 && (extraTickets < 0 || extraTickets > 10 - AlreadyPurchasedTickets)))
            {
                Error.Text = "You may not have more than 10 members in your group (including yourself).";
                return false;
            }

            extraTickets = AlreadyPurchasedTickets == 0 ? extraTickets - 1 : extraTickets;

            if (extraTickets > 0)
            {
                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    try
                    {
                        // Set up the inserting groups command
                        var groupsCommand = new OracleCommand("TICKETS_API.insertGroups", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                        groupsCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                        groupsCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);
                        groupsCommand.Parameters.Add("p_ExtraGuestSeats", OracleDbType.Int32, extraTickets, ParameterDirection.Input);
                        groupsCommand.Parameters.Add("p_ExtraFacultySeats", OracleDbType.Int32, 0, ParameterDirection.Input);

                        // Execute the command
                        objConn.Open();
                        groupsCommand.ExecuteNonQuery();
                    }
                    catch (Exception)
                    {
                        Error.Text = "Could not buy extra tickets, try again later.";
                        return false;
                    }

                    objConn.Close();
                }
            }
            return true;
        }
    }
}