<%@ Page Title="Buy Season Tickets" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="BuySeasonTickets.aspx.cs" Inherits="Aphro_WebForms.Guest.BuySeasonTickets" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderSection" runat="server">
    <%:Styles.Render("~/Content/slick") %>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="BuySeasonTickets">
        <h1 class="eName">Buy Season Tickets</h1>
        <asp:DropDownList ID="SeasonDropDown" runat="server"></asp:DropDownList>
        <asp:Button ID="Submit" runat="server" Text="Submit" OnClick="Submit_Click" />
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/slick") %>
</asp:Content>
