<%@ Page Title="Review Tickets" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="ReviewTickets.aspx.cs" Inherits="Aphro_WebForms.Student.ReviewTickets" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>You have tickets for <asp:Label ID="Event" runat="server"></asp:Label></h1>

    <div class="col-md-6">
        <h3 ID="Date" runat="server"></h3>
        <h4 ID="Section" runat="server"></h4>
        <h4 ID="Location" runat="server"></h4>
        <h4 ID="Door" runat="server"></h4>
    </div>

    <% if (!string.IsNullOrEmpty(LeaderName)) { %>
    <div class="col-md-6">
        <h4>Group:</h4>
        <h3>Leader: <%= LeaderName %></h3>
        <div id="GroupRequestContainer" runat="server">
            <% if (GuestTickets > 0) { %>
            <p><%= GuestTickets %> Guest Tickets</p>
            <hr />
            <% } %>
            <asp:ListView ID="GroupList" runat="server">
                <LayoutTemplate>
                    <div id="itemPlaceholder" runat="server"></div>
                </LayoutTemplate>
                <EmptyItemTemplate>
                    <p>No group members to show (This is an error).</p>
                </EmptyItemTemplate>
                <ItemTemplate>
                    <li class="clearfix request-list">
                        <p class="group-member"><%# Eval("firstname") + " " + Eval("lastname") %></p>
                    </li>
                </ItemTemplate>
            </asp:ListView>
        </div>
    </div>
    <% } %>
</asp:Content>