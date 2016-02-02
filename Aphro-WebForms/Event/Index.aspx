<%@ Page Title="Create Event" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container"/>

<div class="wrapper">
	<div class='create'>

        <%--Event Type--%>
        <div class="dropdown">
            <asp:Label ID="TypeLabel" runat="server" Text="Event Type:"></asp:Label>
            <asp:DropDownList ID="EventType" runat="server"></asp:DropDownList>
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
            <asp:DropDownList ID="LocationDropDown" runat="server"></asp:DropDownList>  
		</div>

        <br />

        <%-- Event Date(s)--%>
		<div class='Event-Dates' style="position: relative">
            <asp:Label ID="EventDateLabel" runat="server" Text="Event Date:"></asp:Label>
            <asp:TextBox ID="EventDate" runat="server" cssclass="datepicker-field"></asp:TextBox>
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
        <asp:Button ID="Submit" runat="server" Text="Submit" OnClick="Submit_Click"/>
    </div>
    <div class="map"></div>
</div>
    <script>
        $('.datepicker-field').datetimepicker({
            format: 'DD-MMM-YY hh:mm A'
        })
    </script>
</asp:Content>
