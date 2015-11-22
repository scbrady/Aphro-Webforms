﻿<%@ Page Title="Create Event" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<div class="container"/>

<div class="wrapper">
	<div class='create'>

        <%--Event Type--%>
        <div class="dropdown">
            <asp:Label ID="TypeLabel" runat="server" Text="Event Type:"></asp:Label>
            <asp:DropDownList ID="EventType" runat="server">
                <asp:ListItem Selected>Fine Arts</asp:ListItem>
                <asp:ListItem>Dramatic Production</asp:ListItem>
                <asp:ListItem>Commencement</asp:ListItem>
                <asp:ListItem>Recital</asp:ListItem>
            </asp:DropDownList>
        </div>
        <br />

        <%--Event Name--%>
		<div class='name'>
            <asp:Label ID="NameLabel" runat="server" Text="Event Name:"></asp:Label>
            <asp:TextBox ID="EventName" runat="server"></asp:TextBox>
		</div>

        <br />

        <%--Description--%>
		<div class='description'>
            <asp:Label ID="DescriptionLabel" runat="server" Text="Description:"></asp:Label>
            <asp:TextBox ID="Description" TextMode="multiline" runat="server"></asp:TextBox>
        </div>

        <br />

        <%--Location--%>
		<div class='dropdown'>
            <asp:Label ID="LocationLabel" runat="server" Text="Location:"></asp:Label>
            <asp:DropDownList ID="LocationDropDown" runat="server">
                    <asp:ListItem Selected>Crowne Centre</asp:ListItem>
                    <asp:ListItem>Dale Horton Auditorium</asp:ListItem>
                    <asp:ListItem>Experimental Theater</asp:ListItem>
                    <asp:ListItem>Mullenix Chapel</asp:ListItem>
            </asp:DropDownList>  
		</div>

        <br />

        <%-- Event Date(s)--%>
		<div class='Event-Dates'>
            <asp:Label ID="StartDateLabel" runat="server" Text="Start Date:"></asp:Label>
            <asp:TextBox ID="StartDate" runat="server"></asp:TextBox>

            
        <br />
        <br />
        <asp:Label ID="EndDateLabel" runat="server" Text="End Date:"></asp:Label>
        <asp:TextBox ID="EndDate" runat="server"></asp:TextBox>
        </div>

        <br />

        <%-- Seating Prices (both regular and prime) --%>
		<div class='Seat-Price'>
            <asp:Label ID="RegularPriceLabel" runat="server" Text="Regular Seating Price:"></asp:Label>
            <asp:TextBox ID="RegularPrice" runat="server"></asp:TextBox>

            <br />
            <br />
            <asp:Label ID="PrimePriceLabel" runat="server" Text="Prime Seating Price:"></asp:Label>
            <asp:TextBox ID="PrimePrice" runat="server"></asp:TextBox>
        </div>

        <br />
        <asp:Button ID="Submit" runat="server" Text="Submit"/>
    </div>
    <div class="map"></div>
</div>
</asp:Content>
