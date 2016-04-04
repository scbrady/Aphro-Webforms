using Aphro_WebForms.Models;
using AutoMapper;
using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Net;
using System.Web;

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

            try
            {
                // If a search term is passed, return the people that match the search term
                var searchResults = getSearchedData(term);

                json = JsonConvert.SerializeObject(searchResults);
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
            }
            catch (Exception)
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "text/plain";
                context.Response.End();
            }
        }

        private List<SearchResponse> getSearchedData(String term)
        {
            DataTable searchTable = new DataTable();
            List<SearchResponse> searchResults = new List<SearchResponse>();

            using (OracleConnection objConn = new OracleConnection(Global.ConnectionString))
            {
                // Set up the searchPeople command
                var searchCommand = new OracleCommand("TICKETS_QUERIES.searchStudents", objConn) { BindByName = true, CommandType = CommandType.StoredProcedure };
                searchCommand.Parameters.Add("p_Return", OracleDbType.RefCursor, ParameterDirection.ReturnValue);
                searchCommand.Parameters.Add("p_SearchText", OracleDbType.Varchar2, term, ParameterDirection.Input);

                // Execute the query and auto map the results to models
                objConn.Open();
                var searchAdapter = new OracleDataAdapter(searchCommand);
                searchAdapter.Fill(searchTable);
                searchResults = Mapper.DynamicMap<IDataReader, List<SearchResponse>>(searchTable.CreateDataReader());

                objConn.Close();
            }

            return searchResults;
        }

        public bool IsReusable
        {
            get { throw new NotImplementedException(); }
        }
    }
}