using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

namespace Aphro_WebForms.Event
{
    public partial class EditEvent : System.Web.UI.Page
    {
        protected string image;
        protected int totalDates = 0;
        protected int lowestId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["Series"]))
                Response.Redirect("Index.aspx");
            // Get the seriesId and picture name from the button
            long seriesId;

            seriesId = long.Parse(Request.QueryString["Series"]);

            DataTable eventTable = new DataTable();
            DataTable eventTypeNamesTable = new DataTable();
            DataTable buildingsTable = new DataTable();
            List<Models.Event> events = new List<Models.Event>();
            List<EventType> eventTypes = new List<EventType>();
            List<Building> buildings = new List<Building>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                var eventCommand = new OracleCommand("TICKETS_QUERIES.getEvent", objConn);
                var eventTypesCommand = new OracleCommand("TICKETS_QUERIES.getEventTypeNames", objConn);
                var buildingsCommand = new OracleCommand("TICKETS_QUERIES.getBuildingNames", objConn);
                try
                {
                    eventCommand.BindByName = true;
                    eventCommand.CommandType = CommandType.StoredProcedure;
                    eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                    eventCommand.Parameters.Add("p_SeriesId", OracleDbType.Int64, seriesId, ParameterDirection.Input);

                    // Set up the eventTypes command
                    eventTypesCommand.BindByName = true;
                    eventTypesCommand.CommandType = CommandType.StoredProcedure;
                    eventTypesCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                    // Set up the buildings command
                    buildingsCommand.BindByName = true;
                    buildingsCommand.CommandType = CommandType.StoredProcedure;
                    buildingsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                }
                catch (Exception)
                {
                    // TODO: Handle Exception
                    Response.Redirect("Index.aspx");
                }

                try
                {
                    // Execute the queries and auto map the results to models
                    objConn.Open();
                    var eventAdapter = new OracleDataAdapter(eventCommand);
                    var eventTypesAdapter = new OracleDataAdapter(eventTypesCommand);
                    var buildingAdapter = new OracleDataAdapter(buildingsCommand);

                    eventAdapter.Fill(eventTable);
                    eventTypesAdapter.Fill(eventTypeNamesTable);
                    buildingAdapter.Fill(buildingsTable);

                    events = Mapper.DynamicMap<IDataReader, List<Models.Event>>(eventTable.CreateDataReader());
                    eventTypes = Mapper.DynamicMap<IDataReader, List<EventType>>(eventTypeNamesTable.CreateDataReader());
                    buildings = Mapper.DynamicMap<IDataReader, List<Building>>(buildingsTable.CreateDataReader());
                }
                catch (Exception ex)
                {
                    // TODO: Handle Exception
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

            var currentEvent = events.FirstOrDefault();
            image = currentEvent.event_picture;

            EventType.SelectedValue = currentEvent.event_type.ToString();
            EventNameInput.Text = currentEvent.name;
            DescriptionInput.Text = currentEvent.description;
            EventDate.Text = currentEvent.event_datetime.ToString("dd-MMM-yy hh:mm tt"); // format: 'DD-MMM-YY hh:mm A'
            LocationDropDown.SelectedValue = currentEvent.building_key.ToString();
            RegularPrice.Text = currentEvent.regular_price.ToString();
            PrimePrice.Text = currentEvent.prime_price.ToString();

            lowestId = (int)currentEvent.event_id;
            foreach (var a in events)
            {
                if (lowestId > (int)a.event_id)
                    lowestId = (int)a.event_id;
            }
        }

        protected void Submit_Click(object sender, EventArgs e)
        {
            Guid pictureUUID = Guid.NewGuid();
            string pictureName = "events_medium.jpg";
            if (uploadBtn.HasFile)
            {
                string extension = Path.GetExtension(uploadBtn.PostedFile.FileName);
                if (extension == ".jpg" || extension == ".jpeg" || extension == ".png")
                {
                    pictureName = pictureUUID.ToString() + extension;
                    uploadBtn.PostedFile.SaveAs(Server.MapPath("~/Content/pictures/") + pictureName);
                    Store_Event(pictureName);
                }
                else
                {
                    Response.Write("Only .JPG or .JPEG or .PNG allowed");
                }
            }
            else
            {
                Store_Event(pictureName);
            }
            Response.Redirect("index.aspx");
        }

        protected void Store_Event(string pictureName)
        {
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the eventTypes command
                var insertEventCommand = new OracleCommand("TICKETS_API.insertEvent", objConn);
                insertEventCommand.BindByName = true;
                insertEventCommand.CommandType = CommandType.StoredProcedure;
                insertEventCommand.Parameters.Add("p_EventName", OracleDbType.Varchar2, EventNameInput.Text, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_EventDescription", OracleDbType.Varchar2, DescriptionInput.Text, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_BuildingKey", OracleDbType.Int32, int.Parse(LocationDropDown.SelectedValue), ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_EventTypeId", OracleDbType.Int32, (int)long.Parse(EventType.SelectedValue), ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_SeasonId", OracleDbType.Int32, null, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_EventDatetime", OracleDbType.Varchar2, HiddenField1.Value, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_RegularPrice", OracleDbType.Decimal, RegularPrice.Text, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_PrimePrice", OracleDbType.Decimal, PrimePrice.Text, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_EventPicture", OracleDbType.Varchar2, pictureName, ParameterDirection.Input);
                try
                {
                    objConn.Open();
                    insertEventCommand.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    // TODO: Handle Exception
                    throw ex;
                }

                objConn.Close();
            }

            Response.Redirect("Index.aspx");
        }
    }
}