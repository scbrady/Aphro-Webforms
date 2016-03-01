<%@ Page Title="Event List" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="Homepage.aspx.cs" Inherits="Aphro_WebForms.Event.Homepage" %>

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
                <asp:LinkButton ID="deleteButton" runat="server" CommandArgument='<%# Eval("series_id")%>' Text="X" OnClick="Delete_Event"/>
                <br />
                <p>-- <%# Eval("event_datetime") %></p>
            </div>
            <button onclick="Index.aspx"><a href="Index.aspx">Add an Event</a></button>
        </ItemTemplate>
    </asp:ListView>

</asp:Content>