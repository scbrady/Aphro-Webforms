<%@ Page Title="" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="AcceptedGroup.aspx.cs" Inherits="Aphro_WebForms.Student.AcceptedGroup" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="EventName" runat="server"></h1>
    <div class="col-md-6">
        <div class="event-summary">
            Summary: 
            <asp:Label ID="EventDescription" runat="server"></asp:Label>
        </div>
        <div class="event-location">
            Location: 
            <asp:Label ID="EventLocation" runat="server"></asp:Label>
        </div>
        <div class="event-summary">
            Event Dates: 
            <asp:ListView ID="EventDateList" runat="server">
                <LayoutTemplate>
                    <div id="EventDates" runat="server">
                        <div id="itemPlaceholder" runat="server"></div>
                    </div>
                </LayoutTemplate>
                <ItemTemplate>
                    <p><%# Eval("event_datetime")%></p>
                </ItemTemplate>
            </asp:ListView>
        </div>
    </div>
    <div class="col-md-6">
        <h4>Group:</h4>
        <asp:Label ID="GroupLeaderName" runat="server"></asp:Label>
        <asp:ListView ID="GroupList" runat="server">
            <LayoutTemplate>
                <div id="GroupRequestContainer" runat="server">
                    <div id="itemPlaceholder" runat="server"></div>
                </div>
            </LayoutTemplate>
            <EmptyItemTemplate>
                <p>No group members to show (This is an error).</p>
            </EmptyItemTemplate>
            <ItemTemplate>
                <div class="clearfix">
                    <p class="group-member"><%# Eval("requested_firstname") + " " + Eval("requested_lastname") %></p>
                    <p class="group-status"><%# Eval("has_accepted").Equals(0) ? "Pending" : "Accepted" %></p>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </div>
</asp:Content>
