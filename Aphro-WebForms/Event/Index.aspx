<%@ Page Title="Event List" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="headerUpcomingEventList">Upcoming Event List</h1>
    <asp:ListView ID="EventListview" runat="server">
        <LayoutTemplate>
            <div id="eventList">
                <div id="itemPlaceholder" runat="server">
                </div>
            </div>
        </LayoutTemplate>

        <EmptyDataTemplate>
            <div id="itemPlaceholder" runat="server">
                <h3>No Upcoming Events.</h3>
            </div>
        </EmptyDataTemplate>

        <ItemTemplate>
            <div id="eventListName">
                <div class="table-responsive">
                    <h4><%# Eval("name") %> - <%# ((DateTime)Eval("event_datetime")).ToString("g") %></h4>
                    <asp:LinkButton CssClass="deleteButton" runat="server" CommandArgument='<%# Eval("series_id") + "," +Eval("event_picture")%>' Text="X" OnClick="Delete_Event"/>
                </div>
            </div>
        </ItemTemplate>
    </asp:ListView>
    <br />
    <a href="AddEvent.aspx">Add an Event</a>
    <br />
</asp:Content>