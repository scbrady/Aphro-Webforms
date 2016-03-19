<%@ Page Title="Review Tickets" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="ReviewTickets.aspx.cs" Inherits="Aphro_WebForms.Guest.ReviewTickets" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>You have tickets for this event.</h1>

    <h3 ID="Date" runat="server"></h3>
    <h4 ID="Section" runat="server"></h4>
    <h4 ID="Location" runat="server"></h4>
    <h4 ID="Door" runat="server"></h4>
</asp:Content>