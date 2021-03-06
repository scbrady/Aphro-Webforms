﻿using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Net;
using System.Web;

namespace Aphro_WebForms.Event
{
    /// <summary>
    /// Summary description for EmptySeats
    /// </summary>
    public class InsertSeason : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string seasonName = "";
            float seasonPrice = 0.0f;

            if (!string.IsNullOrEmpty(context.Request["seasonName"]) || context.Request["seasonPrice"] != null)
            {
                seasonName = context.Request["seasonName"];
                seasonPrice = float.Parse(context.Request["seasonPrice"]);
            }
            else
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "text/plain";
                context.Response.End();
            }

            try
            {
                long seasonId = AddSeason(seasonName, seasonPrice);
                context.Response.Write(seasonId);
            }
            catch (Exception)
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "text/plain";
                context.Response.End();
            }
            context.Response.End();
        }

        private long AddSeason(string seasonName, float seasonPrice)
        {
            long seasonId = 0;
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                var command = new OracleCommand("TICKETS_API.insertSeason", objConn);
                command.Parameters.Add("p_Return", OracleDbType.Int64, ParameterDirection.ReturnValue);
                command.Parameters.Add("p_SeasonName", OracleDbType.Varchar2, seasonName, ParameterDirection.Input);
                command.Parameters.Add("p_SeasonPrice", OracleDbType.Decimal, seasonPrice, ParameterDirection.Input);
                command.CommandType = CommandType.StoredProcedure;

                try
                {
                    objConn.Open();
                    command.ExecuteNonQuery();
                    seasonId = long.Parse(command.Parameters["p_Return"].Value.ToString());
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }

            return seasonId;
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