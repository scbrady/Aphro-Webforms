<%@ Page Title="Review Tickets" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="ReviewTickets.aspx.cs" Inherits="Aphro_WebForms.Guest.ReviewTickets" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>You have tickets for
        <asp:Label ID="Event" runat="server"></asp:Label></h1>

    <h3 id="Date" runat="server"></h3>
    <h4 id="Section" runat="server"></h4>
    <h4 id="Location" runat="server"></h4>
    <h4 id="Door" runat="server"></h4>

    <asp:Button runat="server" CssClass="back" OnClick="back_Click" Text="< Get Tickets for Another Event"></asp:Button>
</asp:Content>