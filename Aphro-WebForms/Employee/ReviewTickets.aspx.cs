using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Employee
{
    public partial class ReviewTickets : System.Web.UI.Page
    {
        protected long SeriesId;
        protected int GuestTickets = 0;
        protected int FacultyTickets = 0;
        protected string LeaderName = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Global.CurrentPerson == null || string.IsNullOrEmpty(Request.QueryString["Series"]))
                Response.Redirect("Index.aspx");

            SeriesId = long.Parse(Request.QueryString["Series"]);

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
                    throw (ex);
                }

                objConn.Close();

                // If the person already has tickets, redirect them to the page where they can review it
                if (eventSeatsModel.Any())
                {
                    Date.InnerText = eventSeatsModel.FirstOrDefault().event_datetime.ToString("dddd, MMMM d - h:mm tt");
                    Section.InnerText = eventSeatsModel.FirstOrDefault().description;

                    string location = "Row ";
                    location += eventSeatsModel.FirstOrDefault().seat_row + ", ";
                    if (eventSeatsModel.Count > 1)
                    {
                        location += "Seats ";
                        location += eventSeatsModel.Min(t => t.seat_number).ToString() + "-";
                        location += eventSeatsModel.Max(t => t.seat_number).ToString();
                    }
                    else
                    {
                        location += "Seat ";
                        location += eventSeatsModel.FirstOrDefault().seat_number.ToString();
                    }
                    Location.InnerText = location;

                    Door.InnerText = "Enter By Door " + eventSeatsModel.FirstOrDefault().door;

                    try
                    {
                        var leaderInformation = eventSeatsModel.First(t => t.leader == 1);
                        LeaderName = leaderInformation.firstname + " " + leaderInformation.lastname;
                        GuestTickets = leaderInformation.guest_tickets;
                        FacultyTickets = leaderInformation.faculty_tickets;
                        eventSeatsModel.RemoveAll(t => t.leader == 1);
                        GroupList.DataSource = eventSeatsModel;
                        GroupList.DataBind();
                    }
                    catch
                    {
                        // This means that there was no group, this person is by himself
                    }
                }
                else
                    Response.Redirect("EventSignup.aspx?Series=" + SeriesId);
            }
        }
    }
}