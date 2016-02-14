<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Guest.EventSignup" %>
<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<div class="header" />
<div class="wrapper">
    <div class="shadow"></div>
    <div class="mainPane" id="guestSignup">
        <div id="eventSignup">
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <asp:Label ID="EventName" runat="server"></asp:Label>

            <h1>Event Description: </h1>
            <asp:Label ID="EventDescription" runat="server"></asp:Label>
            <br />

            <h1>Event Location: 
            <asp:Label ID="EventLocation" runat="server"></asp:Label></h1>

            <h1>Regular Seating Price: 
            <asp:Label ID="EventPrice" runat="server"></asp:Label></h1>

            <h1>Prime Seating Price: 
            <asp:Label ID="EventPrimePrice" runat="server"></asp:Label></h1>

            <h1>Event Dates: </h1>
                <div class="dropdown">
                    <asp:DropDownList ID="EventDateDropDown" runat="server">
                    </asp:DropDownList>
                </div>
            
        </div>
        <br />
    
        <%--<asp:ListView ID="EventDateListview" runat="server">
            <LayoutTemplate>         
                <div id="EventDateContainer" runat="server">              
                    <div ID="itemPlaceholder" runat="server">              
                    </div>         
                </div>      
            </LayoutTemplate>
            <ItemTemplate>
                <asp:HyperLink runat="server" ID="EventDateLink" NavigateUrl='<%# "#"+ Eval("event_id") %>' Text='<%# Eval("event_datetime") %>'></asp:HyperLink>
                <br/>
            </ItemTemplate>
        </asp:ListView>--%>

        <input type="hidden" value="<%= SeriesId %>" id="eventid" />
        <input type="hidden" value="<%= BuildingKey %>" id="buildingkey" />
        <asp:HiddenField ID="SelectedSection" runat="server" />
        <asp:HiddenField ID="SelectedSubsection" runat="server" />
        <asp:HiddenField ID="SelectedRow" runat="server" />
        <h1 id="ticketNumber">Number of Tickets</h1>
        <asp:TextBox TextMode="Number" ID="TicketQuantity" runat="server" min="1" max="9" step="1"/>
        <asp:RangeValidator runat="server" ID="TicketQuantityRangeValidator" ValidationGroup="buyTicketsValidator" Type="Integer" MinimumValue="0" MaximumValue="1" ControlToValidate="TicketQuantity"  ErrorMessage="You can only have 10 people in your group!" />
        <asp:Button ID="GetExtraTickets" runat="server" ValidationGroup="buyTicketsValidator" Text="Buy Extra Tickets" OnClick="GetExtraTickets_Click" />
    
        <div id="container" style="max-width: 1000px"></div>
        <asp:Button ID="Submit" runat="server" OnClick="GetTickets_Click" Text="Get Tickets" />
    </div>
</div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/highmaps") %> 
    <%: Scripts.Render("~/bundles/map") %>
</asp:Content>
