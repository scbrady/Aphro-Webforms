﻿using Oracle.ManagedDataAccess.Client;
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
    public class RemovedFromGroup : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            int personId = 0;
            int groupId = 0;

            if (!string.IsNullOrEmpty(context.Request["personId"]) &&
                !string.IsNullOrEmpty(context.Request["groupId"]))
            {
                personId = int.Parse(context.Request["personId"]);
                groupId = int.Parse(context.Request["groupId"]);
            }
            else
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "text/plain";
                context.Response.End();
            }

            try
            {
                rejectRequest(personId, groupId);
            }
            catch (Exception)
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "text/plain";
                context.Response.End();
            }
            context.Response.End();
        }

        
        private void rejectRequest(int personId, int groupId)
        {
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the searchPeople command
                var command = new OracleCommand("TICKETS_API.rejectRequest", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                command.Parameters.Add("p_PersonId", OracleDbType.Int64, personId, ParameterDirection.Input);
                command.Parameters.Add("p_GroupId", OracleDbType.Int64, groupId, ParameterDirection.Input);

                // Execute the query
                objConn.Open();
                command.ExecuteNonQuery();

                objConn.Close();
            }
        }

        public bool IsReusable
        {
            get { throw new NotImplementedException(); }
        }
    }
}