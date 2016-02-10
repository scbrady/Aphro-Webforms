using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using Aphro_WebForms.Models;
using AutoMapper;
using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;

namespace Aphro_WebForms.Shared
{
    /// <summary>
    /// Summary description for Search
    /// </summary>
    public class Search : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string json = "";
            string term = "";

            if (!string.IsNullOrEmpty(context.Request["term"]))
                term = context.Request["term"];
            else
                context.Response.End();

            // If a search term is passed, return the people that match the search term
            var searchResults = getSearchedData(term);

            json = JsonConvert.SerializeObject(searchResults);
            context.Response.ContentType = "text/json";
            context.Response.Write(json);
        }

        private List<SearchResponse> getSearchedData(String term)
        {
            DataTable searchTable = new DataTable();
            List<SearchResponse> searchResults = new List<SearchResponse>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the searchPeople command
                var eventCommand = new OracleCommand("TICKETS_QUERIES.searchPeople", objConn);
                eventCommand.BindByName = true;
                eventCommand.CommandType = CommandType.StoredProcedure;
                eventCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                eventCommand.Parameters.Add("p_SearchText", OracleDbType.Varchar2, term, ParameterDirection.Input);

                try
                {
                    // Execute the query and auto map the results to models
                    objConn.Open();
                    var eventAdapter = new OracleDataAdapter(eventCommand);
                    eventAdapter.Fill(searchTable);
                    searchResults = Mapper.DynamicMap<IDataReader, List<SearchResponse>>(searchTable.CreateDataReader());
                }
                catch (Exception ex)
                {
                    //Todo: handle exception
                    throw (ex);
                }

                objConn.Close();
            }

            return searchResults;
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