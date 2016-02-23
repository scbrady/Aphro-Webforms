using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;

namespace Aphro_WebForms.Student
{
    public partial class ChooseGroup : System.Web.UI.Page
    {
        protected long SeriesId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Global.CurrentPerson == null || string.IsNullOrEmpty(Request.QueryString["Series"]))
                Response.Redirect("Index.aspx");

            SeriesId = long.Parse(Request.QueryString["Series"]);

            DataTable eventTable = new DataTable();
            List<Models.Event> eventModel = new List<Models.Event>();
            DataTable requestsTable = new DataTable();
            List<Models.GroupRequest> requestsModel = new List<Models.GroupRequest>();
            List<Group> groups = new List<Group>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the getEvent command
                var eventCommand = new OracleCommand("TICKETS_QUERIES.getEvent", objConn);
                eventCommand.BindByName = true;
                eventCommand.CommandType = CommandType.StoredProcedure;
                eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                eventCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);

                // Set up the getGroupRequestsForEvent command
                var requestsCommand = new OracleCommand("TICKETS_QUERIES.getGroupRequestsForEvent", objConn);
                requestsCommand.BindByName = true;
                requestsCommand.CommandType = CommandType.StoredProcedure;
                requestsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                requestsCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);
                requestsCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);

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

            if(requestsModel.Any())
            {
                groups = requestsModel.GroupBy(distinctGroup => distinctGroup.group_id).Select(group => new Group
                {
                    group_id = group.First().group_id,
                    group_leader_firstname = group.First().group_leader_firstname,
                    group_leader_lastname = group.First().group_leader_lastname,
                    group_requests = requestsModel.Where(r => r.group_id == group.First().group_id).ToList(),
                    guests = group.First().members - requestsModel.Where(r => r.group_id == group.First().group_id).Count() - 1
                }).ToList();
            }

            GroupsList.DataSource = groups;
            GroupsList.DataBind();
        }
    }
}