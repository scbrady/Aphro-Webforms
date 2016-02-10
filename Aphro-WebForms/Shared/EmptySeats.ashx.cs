using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using Aphro_WebForms.Models;
using AutoMapper;
using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;

namespace Aphro_WebForms.Shared
{
    /// <summary>
    /// Summary description for EmptySeats
    /// </summary>
    public class EmptySeats : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string json = "";
            int eventId = 0;
            int buildingKey = 0;
            int sectionKey = 0;
            int subsection = 0;

            if (!string.IsNullOrEmpty(context.Request["eventId"]) &&
                !string.IsNullOrEmpty(context.Request["buildingKey"]))
            {
                eventId = int.Parse(context.Request["eventId"]);
                buildingKey = int.Parse(context.Request["buildingKey"]);
                
            } else if (!string.IsNullOrEmpty(context.Request["eventId"]) &&
                       !string.IsNullOrEmpty(context.Request["sectionKey"]))
            {
                eventId = int.Parse(context.Request["eventId"]);
                sectionKey = int.Parse(context.Request["sectionKey"]);
                if (!string.IsNullOrEmpty(context.Request["subsection"]))
                    subsection = int.Parse(context.Request["subsection"]);
            }
            else
            {
                context.Response.End();
            }

            // If a building key is passed, return the empty seats for the building
            if (buildingKey > 0)
            {
                var building = getBuildingJson(buildingKey);
                building = getBuildingSeatData(building, buildingKey, eventId);

                json = JsonConvert.SerializeObject(building);
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
            }
            // Else, if a section key is passed, return the empty seats for sections
            else if (sectionKey > 0)
            {
                var section = getSectionJson(sectionKey, subsection);
                section = getSectionSeatData(section, sectionKey, subsection, eventId);

                json = JsonConvert.SerializeObject(section);
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
            }
            // Else, return an empty response
            else
                context.Response.End();
        }

        private SeatingData getBuildingJson(int buildingKey)
        {
            var json = File.ReadAllText(HttpContext.Current.Server.MapPath("~/Content/maps/") + buildingKey + ".json");
            SeatingData building = JsonConvert.DeserializeObject<List<SeatingData>>(json).First();
            return building;
        }

        private SeatingData getSectionJson(int sectionKey, int subsection)
        {
            var subsectionFilename = (subsection == 0) ? "" : "-" + subsection;
            var json = File.ReadAllText(HttpContext.Current.Server.MapPath("~/Content/maps/sections/") + sectionKey + subsectionFilename + ".json");
            SeatingData section = JsonConvert.DeserializeObject<List<SeatingData>>(json).First();
            return section;
        }

        private SeatingData getBuildingSeatData(SeatingData building, int buildingKey, int eventId)
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

        private SeatingData getSectionSeatData(SeatingData section, int sectionKey, int subsection, int eventId)
        {
            DataTable seatsTable = new DataTable();
            List<RowRecord> seats = new List<RowRecord>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the upcomingEvents command
                var eventCommand = new OracleCommand("TICKETS_QUERIES.getSectionSeatsForEvent", objConn);
                eventCommand.BindByName = true;
                eventCommand.CommandType = CommandType.StoredProcedure;
                eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                eventCommand.Parameters.Add("p_EventId", OracleDbType.Int64, eventId, ParameterDirection.Input);
                eventCommand.Parameters.Add("p_SectionKey", OracleDbType.Int64, sectionKey, ParameterDirection.Input);
                eventCommand.Parameters.Add("p_Subsection", OracleDbType.Int64, subsection, ParameterDirection.Input);

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
                    foreach (var row in section.Data)
                    {
                        if (row.Seat_Row == seat.Seat_Row)
                            row.Empty_Seats = seat.Empty_Seats;
                    }
                }
            }

            return section;
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