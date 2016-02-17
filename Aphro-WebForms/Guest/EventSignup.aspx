﻿<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Guest.EventSignup" %>
<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<div id="eventSignup">
    <asp:Label ID="EventName" runat="server"></asp:Label>

    <div class="Description">
        <h3>Event Description: </h3>
        <asp:Label ID="EventDescription" runat="server"></asp:Label>
    </div>

    <div class="Location">
        <h3>Event Location: </h3>
        <asp:Label ID="EventLocation" runat="server"></asp:Label>
    </div>

    <div class="Price">
        <h3>Seating Price: 
            <asp:Label ID="EventPrice" runat="server"></asp:Label>
            (Prime: <asp:Label ID="EventPrimePrice" runat="server"></asp:Label>)</h3>
    </div>

    <div class="dropdown" id="Dates">
        <h3>Event Dates: </h3>
        <asp:DropDownList ID="EventDateDropDown" runat="server"></asp:DropDownList> 
    </div>
    
    <asp:HiddenField ID="BuildingKeyField" runat="server"/>
    <asp:HiddenField ID="SeriesIdField" runat="server"/>
    <asp:HiddenField ID="SelectedSection" runat="server" />
    <asp:HiddenField ID="SelectedSubsection" runat="server" />
    <asp:HiddenField ID="SelectedRow" runat="server" />

    <h3>Current Group Size: </h3>
    <asp:Label ID="GroupSize" runat="server"></asp:Label>

    <h3 id="ticketNumber">Number of Tickets: </h3>
    <asp:TextBox TextMode="Number" ID="TicketQuantity" runat="server" min="0" max="9" step="1" value="0"></asp:TextBox>
    <asp:RangeValidator runat="server" ID="TicketQuantityRangeValidator" ValidationGroup="buyTicketsValidator" Type="Integer" MinimumValue="0" MaximumValue="1" ControlToValidate="TicketQuantity"  ErrorMessage="You can only have 10 people in your group!" />
    <asp:Button ID="GetExtraTickets" runat="server" Text="Buy Extra Tickets" OnClick="GetExtraTickets_Click"></asp:Button>
    
    <div class="interactiveMap" id="container"></div>
    <asp:Button ID="Submit" runat="server" OnClick="GetTickets_Click" Text="Get Tickets" />
    <button onclick='balcony = true; refreshMap(); return false;'>balcony</button>
</div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/highmaps") %> 
    <%: Scripts.Render("~/bundles/map") %>
</asp:Content>
