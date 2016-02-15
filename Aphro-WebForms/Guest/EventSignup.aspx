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
            <asp:Label ID="EventName" runat="server"></asp:Label>
            <br />

            <div class="Description">
                <h3>Event Description: 
                    <asp:Label ID="EventDescription" runat="server"></asp:Label></h3>
            </div>

            <div class="Location">
                <h3>Event Location: 
                    <asp:Label ID="EventLocation" runat="server"></asp:Label></h3>
            </div>

            <div class="Price">
                <h3>Seating Price: 
                    <asp:Label ID="EventPrice" runat="server"></asp:Label>
                    (Prime: <asp:Label ID="EventPrimePrice" runat="server"></asp:Label>)</h3>
            </div>

            <div class="dropdown" id="Dates">
                <h3>Event Dates:
                        <asp:DropDownList ID="EventDateDropDown" runat="server">
                        </asp:DropDownList> </h3>
            </div>
    
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
        <h3>Number of Tickets:
        <asp:TextBox TextMode="Number" ID="TicketQuantity" runat="server" min="0" max="9" step="1" value="0"></asp:TextBox>
        <asp:Button ID="GetExtraTickets" runat="server" Text="Buy Extra Tickets" OnClick="GetExtraTickets_Click"></asp:Button></h3>
    
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
