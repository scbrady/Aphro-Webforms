using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Student
{
    public partial class AcceptedGroup : System.Web.UI.Page
    {
        protected long SeriesId;
        protected int GuestTickets = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Global.CurrentPerson == null || string.IsNullOrEmpty(Request.QueryString["Series"]))
                    Response.Redirect("Index.aspx");

                SeriesId = long.Parse(Request.QueryString["Series"]);

                DataTable eventTable = new DataTable();
                List<Models.Event> eventModel = new List<Models.Event>();
                DataTable requestsTable = new DataTable();
                List<Models.GroupRequest> requestsModel = new List<Models.GroupRequest>();

                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    // Set up the getEvent command
                    var eventCommand = new OracleCommand("TICKETS_QUERIES.getEvent", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                    eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                    eventCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, SeriesId, ParameterDirection.Input);

                    // Set up the getGroupRequestsForEvent command
                    var requestsCommand = new OracleCommand("TICKETS_QUERIES.getAcceptedGroupForEvent", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
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
                    catch (Exception)
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
                    var leaderInformation = requestsModel.First();
                    GroupLeaderName.Text = string.Format("{0} {1}", leaderInformation.group_leader_firstname, leaderInformation.group_leader_lastname);
                    GuestTickets = leaderInformation.guest_tickets;
                    GroupList.DataSource = requestsModel;
                    GroupList.DataBind();
                }
                else
                    Response.Redirect("EventSignup.aspx?Series=" + SeriesId);
            }
        }
    }
}