using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web.UI.WebControls;

namespace Aphro_WebForms.Student
{
    public partial class ChooseGroup : System.Web.UI.Page
    {
        protected long SeriesId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Global.CurrentPerson == null || string.IsNullOrEmpty(Request.QueryString["Series"]))
                    Response.Redirect("Index.aspx");

                SeriesId = long.Parse(Request.QueryString["Series"]);
                SeriesIdField.Value = SeriesId.ToString();

                DataTable eventTable = new DataTable();
                List<Models.Event> eventModel = new List<Models.Event>();
                DataTable requestsTable = new DataTable();
                List<Models.GroupRequest> requestsModel = new List<Models.GroupRequest>();

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
                        Response.Redirect("EventSignup.aspx?Series=" + SeriesId);
                    }

                    objConn.Close();
                }

                if (eventModel.Any())
                {
                    var currentEvent = eventModel.FirstOrDefault();
                    EventName.InnerHtml = currentEvent.name;
                    EventDescription.Text = currentEvent.description;
                    EventLocation.Text = currentEvent.building;

                    EventDateList.DataSource = eventModel;
                    EventDateList.DataBind();
                }

                if (requestsModel.Any())
                {
                    if (requestsModel.Any(r => r.requested_id == Global.CurrentPerson.person_id && r.has_accepted == 1))
                        Response.Redirect("AcceptedGroup.aspx?Series=" + SeriesId);

                    List<Group> groups = requestsModel.GroupBy(distinctGroup => distinctGroup.group_id).Select(group => new Group
                    {
                        group_id = group.First().group_id,
                        group_leader_firstname = group.First().group_leader_firstname,
                        group_leader_lastname = group.First().group_leader_lastname,
                        group_requests = requestsModel.Where(r => r.group_id == group.First().group_id).ToList(),
                        guests = group.First().guest_tickets
                    }).ToList();

                    GroupsList.DataSource = groups;
                    GroupsList.DataBind();
                }
                else
                    Response.Redirect("EventSignup.aspx?Series=" + SeriesId);
            }
        }

        protected void AcceptButton_Click(object sender, EventArgs e)
        {
            bool failed = false;

            SeriesId = int.Parse(SeriesIdField.Value);
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the accepting group command
                var acceptCommand = new OracleCommand("TICKETS_API.acceptRequest", objConn);
                acceptCommand.BindByName = true;
                acceptCommand.CommandType = CommandType.StoredProcedure;
                acceptCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                acceptCommand.Parameters.Add("p_GroupId", OracleDbType.Int64, long.Parse(((Button)sender).CommandArgument), ParameterDirection.Input);

                try
                {
                    // Execute the command
                    objConn.Open();
                    acceptCommand.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    failed = true;
                    Error.Text = "Could not accept the group. Try again later";
                    Error.Visible = true;
                }

                objConn.Close();
            }
            
            if (!failed)
                Response.Redirect("AcceptedGroup.aspx?Series=" + SeriesId);
        }

        protected void RejectButton_Click(object sender, EventArgs e)
        {
            bool failed = false;
            SeriesId = int.Parse(SeriesIdField.Value);
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the rejecting group command
                var rejectCommand = new OracleCommand("TICKETS_API.rejectRequest", objConn);
                rejectCommand.BindByName = true;
                rejectCommand.CommandType = CommandType.StoredProcedure;
                rejectCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                rejectCommand.Parameters.Add("p_GroupId", OracleDbType.Int64, long.Parse(((Button)sender).CommandArgument), ParameterDirection.Input);

                try
                {
                    // Execute the command
                    objConn.Open();
                    rejectCommand.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    failed = true;
                    Error.Text = "Could not reject group. Try again later.";
                    Error.Visible = true;
                }

                objConn.Close();
            }

            if (!failed)
                Response.Redirect("ChooseGroup.aspx?Series=" + SeriesId);
        }
    }
}