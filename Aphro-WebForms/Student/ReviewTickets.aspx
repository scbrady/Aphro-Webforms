<%@ Page Title="Review Tickets" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="ReviewTickets.aspx.cs" Inherits="Aphro_WebForms.Student.ReviewTickets" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>You have tickets for this event.</h1>

    <asp:Label ID="Section" runat="server" Text="Label"></asp:Label><br />
    Row <asp:Label ID="TicketRow" runat="server" Text="Label"></asp:Label>,
    Seat <asp:Label ID="TicketSeat" runat="server" Text="Label"></asp:Label>-<asp:Label ID="TicketSeatMax" runat="server" Text="Label"></asp:Label><br />
    Enter by door <asp:Label ID="TicketDoor" runat="server" Text="Label"></asp:Label>

    <asp:ListView ID="GroupList" runat="server">
        <LayoutTemplate>
            <div id="itemPlaceholder" runat="server"></div>
        </LayoutTemplate>
        <ItemTemplate>
            <li class="clearfix request-list">
                <p class="group-member"><%# Eval("firstname") + " " + Eval("lastname") %></p>
            </li>
        </ItemTemplate>
    </asp:ListView>
</asp:Content>