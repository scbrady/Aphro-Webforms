using System;
using System.Collections.Generic;
using System.Data;
using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.DataAccess.Client;

namespace Aphro_WebForms.Event
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable eventTypeNamesTable = new DataTable();
            DataTable buildingsTable = new DataTable();
            List<EventType> eventTypes = new List<EventType>();
            List<Building> buildings = new List<Building>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the eventTypes command
                var eventTypesCommand = new OracleCommand("TICKETS_QUERIES.getEventTypeNames", objConn);
                eventTypesCommand.BindByName = true;
                eventTypesCommand.CommandType = CommandType.StoredProcedure;
                eventTypesCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                // Set up the buildings command
                var buildingsCommand = new OracleCommand("TICKETS_QUERIES.getBuildingNames", objConn);
                buildingsCommand.BindByName = true;
                buildingsCommand.CommandType = CommandType.StoredProcedure;
                buildingsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                try
                {
                    // Execute the queries and auto map the results to models
                    objConn.Open();
                    var eventTypesAdapter = new OracleDataAdapter(eventTypesCommand);
                    var buildingAdapter = new OracleDataAdapter(buildingsCommand);
                    eventTypesAdapter.Fill(eventTypeNamesTable);
                    buildingAdapter.Fill(buildingsTable);
                    eventTypes = Mapper.DynamicMap<IDataReader, List<EventType>>(eventTypeNamesTable.CreateDataReader());
                    buildings  = Mapper.DynamicMap<IDataReader, List<Building>>(buildingsTable.CreateDataReader());
                }
                catch (Exception ex)
                {
                    throw (ex);
                }

                objConn.Close();
            }

            // Fill list dropdowns with data from the database
            if (eventTypes.Count > 0)
            {
                EventType.DataTextField = "name";
                EventType.DataValueField = "event_type_id";
                EventType.DataSource = eventTypes;
                EventType.DataBind();
            }
            if (buildings.Count > 0)
            {
                LocationDropDown.DataTextField = "description";
                LocationDropDown.DataValueField = "building_key";
                LocationDropDown.DataSource = buildings;
                LocationDropDown.DataBind();
            }
        }
    }
}