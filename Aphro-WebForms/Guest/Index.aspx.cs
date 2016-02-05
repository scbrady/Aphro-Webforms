using System;
using System.Collections.Generic;
using System.Data;
using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;

namespace Aphro_WebForms.Guest
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Global.CurrentPerson == null || Global.CurrentPerson.accountType != Account.Guest)
                Response.Redirect("Login.aspx");
            else
                GuestName.Text = "Hi " + Global.CurrentPerson.firstname;

            DataTable upcomingEventsTable = new DataTable();
            List<Models.Event> upcomingEvents = new List<Models.Event>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the upcomingEvents command
                var upcomingEventsCommand = new OracleCommand("TICKETS_QUERIES.getUpcomingEvents", objConn);
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
            {
                EventListview.DataSource = upcomingEvents;
                EventListview.DataBind();
            }
        }
    }
}