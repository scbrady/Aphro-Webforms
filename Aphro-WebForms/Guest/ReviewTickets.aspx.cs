﻿using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Guest
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
                    Response.Redirect("EventSignup.aspx?Series=" + SeriesId);
                }

                objConn.Close();

                // If the person already has tickets, redirect them to the page where they can review it
                if (eventSeatsModel.Any())
                {
                    Event.Text = eventSeatsModel.FirstOrDefault().name;
                    Date.InnerText = eventSeatsModel.FirstOrDefault().event_datetime.ToString("dddd, MMMM d - h:mm tt");
                    Section.InnerText = eventSeatsModel.FirstOrDefault().description;

                    string location = string.Format("Row {0}, ", eventSeatsModel.FirstOrDefault().seat_row);
                    if (eventSeatsModel.Count > 1)
                    {
                        location += string.Format("Seats {0}-{1}", eventSeatsModel.Min(t => t.seat_number), eventSeatsModel.Max(t => t.seat_number));
                    }
                    else
                    {
                        location += "Seat " + eventSeatsModel.FirstOrDefault().seat_number.ToString();
                    }
                    Location.InnerText = location;

                    Door.InnerText = "Enter By Door " + eventSeatsModel.FirstOrDefault().door;
                }
                else
                    Response.Redirect("EventSignup.aspx?Series=" + SeriesId);
            }
        }

        protected void back_Click(object sender, EventArgs e)
        {
            Response.Redirect("Index.aspx");
        }
    }
}