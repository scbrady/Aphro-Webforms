<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <form id="EventCreation" runat="server">
        <h3>Create Event Form</h3>
        <asp:Label ID="NameLabel" runat="server" Text="Event Name:"></asp:Label>
        <asp:TextBox ID="EventName" runat="server"></asp:TextBox>

        <br />
        <asp:Label ID="DescriptionLabel" runat="server" Text="Description:"></asp:Label>
        <asp:TextBox ID="Description" runat="server"></asp:TextBox>

        <br />
        <asp:Label ID="LocationLabel" runat="server" Text="Location:"></asp:Label>
        <asp:DropDownList ID="LocationDropDown" runat="server"/>

        <br />
        <asp:Label ID="Label1" runat="server" Text="Location:"></asp:Label>
        <asp:DropDownList ID="EventDropDown" runat="server"></asp:DropDownList>

        <br />
        <asp:Label ID="Label2" runat="server" Text="Location:"></asp:Label>
        <asp:DropDownList ID="SeasonDropDown" runat="server"></asp:DropDownList>

        <br />
        <asp:Label ID="StartDateLabel" runat="server" Text="Start Date:"></asp:Label>
        <asp:TextBox ID="StartDate" runat="server"></asp:TextBox>

        <br />
        <asp:Label ID="EndDateLabel" runat="server" Text="End Date:"></asp:Label>
        <asp:TextBox ID="EndDate" runat="server"></asp:TextBox>

        <br />
        <asp:Label ID="RegularPriceLabel" runat="server" Text="Regular Seating Price:"></asp:Label>
        <asp:TextBox ID="RegularPrice" runat="server"></asp:TextBox>

        <br />
        <asp:Label ID="PrimePriceLabel" runat="server" Text="Prime Seating Price:"></asp:Label>
        <asp:TextBox ID="PrimePrice" runat="server"></asp:TextBox>

        <br />
        <asp:Button ID="Submit" runat="server" Text="Submit"/>
    </form>
</asp:Content>
