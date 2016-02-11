using System;
using Oracle.ManagedDataAccess.Client;
using System.Collections.Generic;
using System.Data;
using AutoMapper;
using Aphro_WebForms.Models;
using System.Linq;

namespace Aphro_WebForms.Student
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Global.CurrentPerson == null || Global.CurrentPerson.accountType != Models.Account.Student)
            {
                // Login - for expo purposes, we are just grabbing a random student from the DB
                LoginRandomStudent();
            }

            StudentName.Text = "Hi " + Global.CurrentPerson.firstname;

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

        private void LoginRandomStudent()
        {
            DataTable studentTable = new DataTable();
            Person student = null;

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
                    adapter.Fill(studentTable);
                    student = Mapper.DynamicMap<IDataReader, List<Person>>(studentTable.CreateDataReader()).FirstOrDefault();
                }
                catch (Exception ex)
                {
                    // TODO: handle exception
                    throw (ex);
                }

                objConn.Close();
            }
            if (student != null)
            {
                Global.CurrentPerson = student;
                Global.CurrentPerson.accountType = Account.Student;
            }
            else
                // TODO: handle exception
                throw (new Exception("Could not get a random student"));
        }
    }
}