using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using Aphro_WebForms.Models;
using AutoMapper;
using Newtonsoft.Json;
using Oracle.DataAccess.Client;

namespace Aphro_WebForms.Guest
{
    /// <summary>
    /// Summary description for EmptySeats
    /// </summary>
    public class EmptySeats : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            if (string.IsNullOrEmpty(context.Request["eventId"]) || string.IsNullOrEmpty(context.Request["buildingKey"]))
            {
                context.Response.End();
            }

            string json = "";
            int eventId = int.Parse(context.Request["eventId"]);
            int buildingKey = int.Parse(context.Request["buildingKey"]);

            var building = getBuildingJson(buildingKey);
            building = getSeatData(building, buildingKey, eventId);

            json = JsonConvert.SerializeObject(building);
            context.Response.ContentType = "text/json";
            context.Response.Write(json);
        }

        private BuildingData getBuildingJson(int buildingKey)
        {
            var json = File.ReadAllText(HttpContext.Current.Server.MapPath("~/Content/maps/") + buildingKey + ".json");
            BuildingData building = JsonConvert.DeserializeObject<List<BuildingData>>(json).First();
            return building;
        }

        private BuildingData getSeatData(BuildingData building, int buildingKey, int eventId)
        {
            DataTable seatsTable = new DataTable();
            List<RowRecord> seats = new List<RowRecord>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the upcomingEvents command
                var eventCommand = new OracleCommand("TICKETS_QUERIES.getBuildingSeatsForEvent", objConn);
                eventCommand.BindByName = true;
                eventCommand.CommandType = CommandType.StoredProcedure;
                eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                eventCommand.Parameters.Add("p_EventId", OracleDbType.Int64, eventId, ParameterDirection.Input);
                eventCommand.Parameters.Add("p_BuildingKey", OracleDbType.Int64, buildingKey, ParameterDirection.Input);

                try
                {
                    // Execute the queries and auto map the results to models
                    objConn.Open();
                    var eventAdapter = new OracleDataAdapter(eventCommand);
                    eventAdapter.Fill(seatsTable);
                    seats = Mapper.DynamicMap<IDataReader, List<RowRecord>>(seatsTable.CreateDataReader());
                }
                catch (Exception ex)
                {
                    throw (ex);
                }

                objConn.Close();
            }

            if (seats.Any())
            {
                foreach (var seat in seats)
                {
                    foreach (var section in building.Data)
                    {
                        if (section.Section_Key == seat.Section_Key && section.Subsection == seat.Subsection)
                            section.Empty_Seats = seat.Empty_Seats;
                    }
                }
            }

            return building;
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