using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Student
{
    public partial class ReviewTickets : System.Web.UI.Page
    {
        protected long SeriesId;

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
                    Section.Text = eventSeatsModel.FirstOrDefault().description;
                    TicketRow.Text = eventSeatsModel.FirstOrDefault().seat_row;
                    TicketSeat.Text = eventSeatsModel.Min(t => t.seat_number).ToString();
                    TicketSeatMax.Text = eventSeatsModel.Max(t => t.seat_number).ToString();
                    TicketDoor.Text = eventSeatsModel.FirstOrDefault().door;

                    eventSeatsModel.RemoveAll(t => t.firstname == null);
                    GroupList.DataSource = eventSeatsModel;
                    GroupList.DataBind();
                }
                else
                    Response.Redirect("EventSignup.aspx?Series=" + SeriesId);
            }
        }
    }
}