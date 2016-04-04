using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;

namespace Aphro_WebForms.Event
{
    public partial class AddEvent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DataTable eventTypeNamesTable = new DataTable();
                DataTable buildingsTable = new DataTable();
                DataTable seasonsTable = new DataTable();
                List<EventType> eventTypes = new List<EventType>();
                List<Building> buildings = new List<Building>();
                List<Season> seasons = new List<Season>();

                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    // Set up the eventTypes command
                    var eventTypesCommand = new OracleCommand("TICKETS_QUERIES.getEventTypeNames", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                    eventTypesCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                    // Set up the buildings command
                    var buildingsCommand = new OracleCommand("TICKETS_QUERIES.getBuildingNames", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                    buildingsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                    // Set up the seasons command
                    var seasonsCommand = new OracleCommand("TICKETS_QUERIES.getSeasonNames", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                    seasonsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                    try
                    {
                        // Execute the queries and auto map the results to models
                        objConn.Open();
                        var eventTypesAdapter = new OracleDataAdapter(eventTypesCommand);
                        var buildingAdapter = new OracleDataAdapter(buildingsCommand);
                        var seasonsAdapter = new OracleDataAdapter(seasonsCommand);
                        eventTypesAdapter.Fill(eventTypeNamesTable);
                        buildingAdapter.Fill(buildingsTable);
                        seasonsAdapter.Fill(seasonsTable);
                        eventTypes = Mapper.DynamicMap<IDataReader, List<EventType>>(eventTypeNamesTable.CreateDataReader());
                        buildings = Mapper.DynamicMap<IDataReader, List<Building>>(buildingsTable.CreateDataReader());
                        seasons = Mapper.DynamicMap<IDataReader, List<Season>>(seasonsTable.CreateDataReader());
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
                if (seasons.Count > 0)
                {
                    SeasonDropDown.DataTextField = "name";
                    SeasonDropDown.DataValueField = "season_id";
                    SeasonDropDown.DataSource = seasons;
                    SeasonDropDown.DataBind();
                }
                SeasonDropDown.Items.Insert(0, new ListItem("No Season", "-1"));
                SeasonDropDown.Items.Insert(1, new ListItem("Add New Season", "-1"));
                SeasonDropDown.ClearSelection();
                SeasonDropDown.SelectedIndex = 0;
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
                var insertEventCommand = new OracleCommand("TICKETS_API.insertEvent", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                insertEventCommand.Parameters.Add("p_EventName", OracleDbType.Varchar2, EventNameInput.Text, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_EventDescription", OracleDbType.Varchar2, DescriptionInput.Text, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_BuildingKey", OracleDbType.Int32, int.Parse(LocationDropDown.SelectedValue), ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_EventTypeId", OracleDbType.Int32, int.Parse(EventType.SelectedValue), ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_EventDatetime", OracleDbType.Varchar2, HiddenField1.Value, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_RegularPrice", OracleDbType.Decimal, RegularPrice.Text, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_PrimePrice", OracleDbType.Decimal, PrimePrice.Text, ParameterDirection.Input);
                insertEventCommand.Parameters.Add("p_EventPicture", OracleDbType.Varchar2, pictureName, ParameterDirection.Input);

                if (SeasonDropDown.SelectedValue.Equals("-1"))
                    insertEventCommand.Parameters.Add("p_SeasonId", OracleDbType.Int32, null, ParameterDirection.Input);
                else
                    insertEventCommand.Parameters.Add("p_SeasonId", OracleDbType.Int32, int.Parse(SeasonDropDown.SelectedValue), ParameterDirection.Input);

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