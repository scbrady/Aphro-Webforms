﻿using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Guest
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Global.CurrentPerson == null || Global.CurrentPerson.accountType != Account.Guest)
            {
                //Global.CurrentPerson = null;
                //Response.Redirect("Login.aspx");

                // Login - for expo purposes, we are just grabbing a random guest from the DB
                LoginRandomGuest();
            }

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
                EventListview.DataSource = upcomingEvents;
            EventListview.DataBind();
        }


        private void LoginRandomGuest()
        {
            DataTable guestTable = new DataTable();
            Person guest = null;

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                OracleCommand objCmd = new OracleCommand("TICKETS_QUERIES.getRandomStudent ", objConn);
                objCmd.BindByName = true;
                objCmd.CommandType = CommandType.StoredProcedure;

                objCmd.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                try
                {
                    objConn.Open();
                    OracleDataAdapter adapter = new OracleDataAdapter(objCmd);
                    adapter.Fill(guestTable);
                    guest = Mapper.DynamicMap<IDataReader, List<Person>>(guestTable.CreateDataReader()).FirstOrDefault();
                }
                catch (Exception ex)
                {
                    // TODO: handle exception
                    throw (ex);
                }

                objConn.Close();
            }
            if (guest != null)
            {
                Global.CurrentPerson = guest;
                Global.CurrentPerson.accountType = Account.guest;
            }
            else
                // TODO: handle exception
                throw (new Exception("Could not get a random guest"));
        }
    }
}