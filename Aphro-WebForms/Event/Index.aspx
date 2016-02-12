<%@ Page Title="Create Event" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="header" />
<div class="wrapper">
    <div class="shadow"></div>
	<div class='mainPane'>
        	
        <%--Event Type--%>
        <h1>Create Event</h1>
        <div class="dropdown">
            <h3>Event Type:</h3>
            <asp:DropDownList ID="EventType" runat="server">
            </asp:DropDownList>
        </div>

        <%--Event Name--%>
		<div class='name'>
			<h3>Event Name:</h3>
            <asp:TextBox ID="EventName" runat="server"></asp:TextBox>
		</div>

        <%--Description--%>
		<div class='description'>
			<h3>Description:</h3>
            <asp:TextBox ID="Description" TextMode="multiline" runat="server"></asp:TextBox>
        </div>

        <%--Location--%>
		<div class='dropdown'>
				<h3>Location: </h3>
            <asp:DropDownList ID="LocationDropDown" runat="server">
            </asp:DropDownList>  
		</div>

        <%-- Event Date(s)--%>
		<div class='Event-Dates' style="position: relative">
				<h3>Event Date(s):</h3>
            <asp:TextBox ID="EventDate" runat="server" cssclass="datepicker-field"></asp:TextBox>
        </div>

        <%-- Seating Prices (both regular and prime) --%>
		<div class='Seat-Price'>
			<h3>Regular Seating Price:</h3>
            <asp:TextBox ID="RegularPrice" runat="server"></asp:TextBox>
			<h3>Prime Seating Price:</h3>

            <asp:TextBox ID="PrimePrice" runat="server"></asp:TextBox>
        </div>

        <asp:Button ID="Submit" runat="server" Text="Submit" OnClick="Submit_Click"/>
    </div>
</div>
    <script>
        $('.datepicker-field').datetimepicker({
            format: 'DD-MMM-YY hh:mm A'
        })
    </script>
</asp:Content>
