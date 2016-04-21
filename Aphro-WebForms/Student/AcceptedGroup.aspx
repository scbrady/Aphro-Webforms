<%@ Page Title="" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="AcceptedGroup.aspx.cs" Inherits="Aphro_WebForms.Student.AcceptedGroup" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="EventName" runat="server"></h1>
    <div class="row">
        <div class="col-md-6">
            <div class="event-summary">
                Summary:
                <asp:Label ID="EventDescription" runat="server"></asp:Label>
            </div>
            <div class="event-location">
                Location:
                <asp:Label ID="EventLocation" runat="server"></asp:Label>
            </div>
            <div class="event-date">
                Event Dates:
                <asp:ListView ID="EventDateList" runat="server">
                    <LayoutTemplate>
                        <div id="EventDates" runat="server">
                            <div id="itemPlaceholder" runat="server"></div>
                        </div>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <p>&bull; <%# ((DateTime)Eval("event_datetime")).ToString("dddd, MMMM d - h:mm tt")%></p>
                    </ItemTemplate>
                </asp:ListView>
            </div>
        </div>
        <div class="col-md-6">
            <h4>Group:</h4>
            <h3>Leader:
                <asp:Label ID="GroupLeaderName" runat="server"></asp:Label></h3>
            <div id="GroupRequestContainer" runat="server">
                <% if (GuestTickets > 0)
                    { %>
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
                            <p class="group-member"><%# Eval("requested_firstname") + " " + Eval("requested_lastname") %></p>
                            <p class="group-status <%# Eval("has_accepted").Equals(0) ? "pending-status" : "accepted-status" %>" data-user-id="<%# Eval("requested_id") %>" data-group-id="<%# Eval("group_id") %>"></p>
                        </li>
                    </ItemTemplate>
                </asp:ListView>
            </div>
        </div>
    </div>
</asp:Content>