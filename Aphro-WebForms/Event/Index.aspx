<%@ Page Title="Event List" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3 id="headerUpcomingEventList">Upcoming Event List</h3>
    <asp:ListView ID="EventListview" runat="server">
        <LayoutTemplate>
            <div id="eventList">
                <div id="itemPlaceholder" runat="server">
                </div>
            </div>
        </LayoutTemplate>

        <EmptyDataTemplate>
            <div id="itemPlaceholder" runat="server">
                No Upcoming Events.
            </div>
        </EmptyDataTemplate>

        <ItemTemplate>
            <div id="eventListName">
                
                <h4><%# Eval("name") %> </h4> 
                <asp:LinkButton ID="deleteButton" runat="server" CommandArgument='<%# Eval("series_id") + "," +Eval("event_picture")%>' Text="X" OnClick="Delete_Event"/>
                <br />
                <p>-- <%# Eval("event_datetime") %></p>
            </div>
        </ItemTemplate>
    </asp:ListView>
    <br />
    <a href="AddEvent.aspx">Add an Event</a>
</asp:Content>