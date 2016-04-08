<%@ Page Title="Review Tickets" Language="C#" MasterPageFile="~/EmployeePortal.Master" AutoEventWireup="true" CodeBehind="ReviewTickets.aspx.cs" Inherits="Aphro_WebForms.Employee.ReviewTickets" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>You have tickets for
        <asp:Label ID="Event" runat="server"></asp:Label></h1>

    <div class="col-md-6">
        <h4 id="Date" runat="server"></h4>
        <h4 id="Section" runat="server"></h4>
        <h4 id="Location" runat="server"></h4>
        <h4 id="Door" runat="server"></h4>
    </div>

    <% if (!string.IsNullOrEmpty(LeaderName))
        { %>
    <div class="col-md-6">
        <h4>Group:</h4>
        <p>Leader: <%= LeaderName %></p>
        <div id="GroupRequestContainer" runat="server">
            <% if (GuestTickets > 0)
                { %>
            <p><%= GuestTickets %> Guest Tickets</p>
            <% }
                if (FacultyTickets > 0)
                { %>
            <p><%= FacultyTickets %> Faculty Tickets</p>
            <% } %>
            <hr ID="Divider" runat="server" Visible="false"/>
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
    <asp:Button runat="server" CssClass="back" OnClick="back_Click" Text="&lt; Get Tickets for Another Event"></asp:Button>
    <div class="clearfix"></div>
</asp:Content>