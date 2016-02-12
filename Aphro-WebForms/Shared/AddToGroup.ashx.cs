using System;
using System.Data;
using System.Web;
using Oracle.ManagedDataAccess.Client;
using System.Net;
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
            int personType = 0;
            int seriesId = 0;

            if (!string.IsNullOrEmpty(context.Request["personId"]) &&
                !string.IsNullOrEmpty(context.Request["personType"]) &&
                !string.IsNullOrEmpty(context.Request["seriesId"]))
            {
                personId = int.Parse(context.Request["personId"]);
                personType = int.Parse(context.Request["personType"]);
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
                addPersonToGroup(personId, personType, seriesId);
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "text/plain";
                context.Response.End();
            }
            context.Response.End();
        }

        private void addPersonToGroup(int personId, int personType, int seriesId)
        {
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the searchPeople command
                var command = new OracleCommand("TICKETS_API.insertGroupRequests", objConn);
                command.BindByName = true;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);
                command.Parameters.Add("p_RequestedId", OracleDbType.Int64, personId, ParameterDirection.Input);
                command.Parameters.Add("p_RequestedType", OracleDbType.Int16, personType, ParameterDirection.Input);
                command.Parameters.Add("p_SeriesId", OracleDbType.Int64, seriesId, ParameterDirection.Input);

                try
                {
                    // Execute the query and auto map the results to models
                    objConn.Open();
                    command.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    //Todo: handle exception
                    throw (ex);
                }

                objConn.Close();
            }
        }

        public bool IsReusable
        {
            get
            {
                throw new NotImplementedException();
            }
        }
    }
}