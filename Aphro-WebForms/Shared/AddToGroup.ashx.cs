using Aphro_WebForms.Models;
using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Net;
using System.Web;
using System.Web.SessionState;

namespace Aphro_WebForms.Shared
{
    /// <summary>
    /// Summary description for EmptySeats
    /// </summary>
    public class AddToGroup : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            int personId = 0;
            int seriesId = 0;

            if (!string.IsNullOrEmpty(context.Request["personId"]) &&
                !string.IsNullOrEmpty(context.Request["seriesId"]))
            {
                personId = int.Parse(context.Request["personId"]);
                seriesId = int.Parse(context.Request["seriesId"]);
            }
            else
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "text/plain";
                context.Response.End();
            }

            try
            {
                PersonInGroup(personId, seriesId);
                var result = addPersonToGroup(personId, seriesId);
                var json = JsonConvert.SerializeObject(result);
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
            }
            catch (Exception)
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "text/plain";
                context.Response.End();
            }
            context.Response.End();
        }

        private GroupRequest addPersonToGroup(int personId, int seriesId)
        {
            DataTable groupTable = new DataTable();
            GroupRequest groupResult = new GroupRequest();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the searchPeople command
                var command = new OracleCommand("TICKETS_API.insertGroupRequests", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                command.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                command.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                command.Parameters.Add("p_RequestedId", OracleDbType.Int64, personId, ParameterDirection.Input);
                command.Parameters.Add("p_SeriesId", OracleDbType.Int64, seriesId, ParameterDirection.Input);

                // Execute the query and map the results to models
                objConn.Open();
                var groupAdapter = new OracleDataAdapter(command);
                groupAdapter.Fill(groupTable);
                groupResult.group_id = long.Parse(groupTable.Rows[0]["group_id"].ToString());
                groupResult.requested_id = long.Parse(groupTable.Rows[0]["requested_id"].ToString());

                objConn.Close();
            }

            return groupResult;
        }

        private void PersonInGroup(int personId, int seriesId)
        {
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                var command = new OracleCommand("TICKETS_QUERIES.getHasAccepted", objConn);
                command.Parameters.Add("p_PersonId", OracleDbType.Int64, personId, ParameterDirection.Input);
                command.Parameters.Add("p_SeriesId", OracleDbType.Int64, seriesId, ParameterDirection.Input);
                command.Parameters.Add("p_CurrentPersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                command.CommandType = CommandType.StoredProcedure;

                // Execute the query and auto map the results to models
                objConn.Open();
                command.ExecuteNonQuery();
            }
        }

        public bool IsReusable
        {
            get { throw new NotImplementedException(); }
        }
    }
}