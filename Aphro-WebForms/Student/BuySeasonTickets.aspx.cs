﻿using Aphro_WebForms.Models;
using AutoMapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Aphro_WebForms.Student
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
                    var seasonsCommand = new OracleCommand("TICKETS_QUERIES.getSeasonsForPurchase", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                    seasonsCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                    seasonsCommand.Parameters.Add("p_PersonId", OracleDbType.Int64, Global.CurrentPerson.person_id, ParameterDirection.Input);

                    try
                    {
                        // Execute the queries and auto map the results to models
                        objConn.Open();
                        var seasonsAdapter = new OracleDataAdapter(seasonsCommand);
                        seasonsAdapter.Fill(seasonsTable);
                        seasons = Mapper.DynamicMap<IDataReader, List<Season>>(seasonsTable.CreateDataReader());
                    }
                    catch (Exception)
                    {
                        Response.Redirect("Index.aspx");
                    }

                    objConn.Close();
                }

                // Fill list dropdowns with data from the database
                if (seasons.Count > 0)
                {
                    var seasonsWithEvents = seasons.GroupBy(s => s.season_id).Select(season => new Season()
                    {
                        season_id = season.First().season_id,
                        name = season.First().name,
                        price = season.First().price,
                        ticket_count = season.First().ticket_count,
                        event_names = seasons.Where(ev => ev.season_id == season.First().season_id).Select(en => en.event_name).ToList()
                    }).ToList();

                    SeasonDropDown.DataTextField = "name";
                    SeasonDropDown.DataValueField = "season_id";
                    SeasonDropDown.DataSource = seasonsWithEvents;
                    SeasonDropDown.DataBind();

                    SeasonListView.DataSource = seasonsWithEvents;
                    SeasonListView.DataBind();
                }
                if (Request.QueryString["Success"] != null)
                {
                    Error.Text = "Successfully purchased season ticket!";
                    Error.Visible = true;
                }
            }
        }

        protected void Submit_Click(object sender, EventArgs e)
        {
            bool failed = false;

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                var insertPersonSeason = new OracleCommand("TICKETS_API.insertPersonSeason", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                insertPersonSeason.Parameters.Add("p_SeasonId", OracleDbType.Int32, int.Parse(SeasonDropDown.SelectedValue), ParameterDirection.Input);
                insertPersonSeason.Parameters.Add("p_PersonId", OracleDbType.Int32, Global.CurrentPerson.person_id, ParameterDirection.Input);

                try
                {
                    objConn.Open();
                    insertPersonSeason.ExecuteNonQuery();
                }
                catch (Exception)
                {
                    failed = true;
                }

                objConn.Close();
            }

            if (!failed)
                Response.Redirect("BuySeasonTickets.aspx?Success=1");
            else
            {
                Error.Text = "Could not buy season ticket, try again later.";
                Error.Visible = true;
            }
        }
    }
}