<%@ Page Title="Event List" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="headerUpcomingEventList">Upcoming Event List</h1>
    <a href="AddEvent.aspx">+Add an Event</a>
    <asp:ListView ID="EventListview" runat="server">
        <LayoutTemplate>
            <div class="row">
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
            <div class="col-md-4 col-xs-6 event-item">
                <h4><%# Eval("name") %></h4>
                <asp:LinkButton CssClass="deleteButton" runat="server" CommandArgument='<%# Eval("series_id") + "," +Eval("event_picture")%>' Text="X" OnClick="Delete_Event" />
                <p><%# ((DateTime)Eval("event_datetime")).ToString("g") %></p>
                <a class="editButton" href='<%# "EditEvent.aspx?Series="+ Eval("series_id") %>'>Edit</a>
            </div>
        </ItemTemplate>
    </asp:ListView>
    <br />

    <br />
</asp:Content>