using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Guest
{
    public partial class BuySeasonTickets : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Global.CurrentPerson == null)
                    Response.Redirect("Index.aspx");

                DataTable seasonsTable = new DataTable();
                List<Season> seasons = new List<Season>();

                using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
                {
                    // Set up the seasons command
                    var seasonsCommand = new OracleCommand("TICKETS_QUERIES.getSeasonNames", objConn);
                    seasonsCommand.BindByName = true;
                    seasonsCommand.CommandType = CommandType.StoredProcedure;
                    seasonsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);

                    try
                    {
                        // Execute the queries and auto map the results to models
                        objConn.Open();
                        var seasonsAdapter = new OracleDataAdapter(seasonsCommand);
                        seasonsAdapter.Fill(seasonsTable);
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
                if (seasons.Count > 0)
                {
                    SeasonDropDown.DataTextField = "name";
                    SeasonDropDown.DataValueField = "season_id";
                    SeasonDropDown.DataSource = seasons;
                    SeasonDropDown.DataBind();
                }
            }
        }

        protected void Submit_Click(object sender, EventArgs e)
        {
            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                var insertPersonSeason = new OracleCommand("TICKETS_API.insertPersonSeason", objConn);
                insertPersonSeason.BindByName = true;
                insertPersonSeason.CommandType = CommandType.StoredProcedure;
                insertPersonSeason.Parameters.Add("p_PersonId", OracleDbType.Int32, int.Parse(SeasonDropDown.SelectedValue), ParameterDirection.Input);
                insertPersonSeason.Parameters.Add("p_SeasonId", OracleDbType.Int32, Global.CurrentPerson.person_id, ParameterDirection.Input);

                try
                {
                    objConn.Open();
                    insertPersonSeason.ExecuteNonQuery();
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