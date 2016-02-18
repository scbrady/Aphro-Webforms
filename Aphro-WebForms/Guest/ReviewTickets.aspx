<%@ Page Title="Review Tickets" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="ReviewTickets.aspx.cs" Inherits="Aphro_WebForms.Guest.ReviewTickets" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>You have tickets for this event.</h1>

    <h4>Ticket Row:</h4>
    <asp:Label ID="TicketRow" runat="server" Text="Label"></asp:Label>

    <h4>Ticket Seat Number:</h4>
    <asp:Label ID="TicketNumber" runat="server" Text="Label"></asp:Label>
</asp:Content>