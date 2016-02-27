<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Guest.EventSignup" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    function changeBalcony(event) {
        event.preventDefault();
        balcony = (balcony ? false : true);
        refreshMap();
    }
</script>

    <div id="eventSignup">
        <h1 class="eName"><asp:Label ID="EventName" runat="server"></asp:Label></h1>

        <div class="Description">
            <h3>Description: 
                <asp:Label ID="EventDescription" runat="server"></asp:Label>
            </h3>
        </div>

        <div class="Location">
            <h3>Location: 
                <asp:Label ID="EventLocation" runat="server"></asp:Label>
            </h3>
        </div>

        <div class="Price">
            <h3>Price:
                <asp:Label ID="EventPrice" runat="server"></asp:Label>
                    (Prime:
                <asp:Label ID="EventPrimePrice" runat="server"></asp:Label>)
            </h3>
        </div>

        <div class="dropdown" id="Dates">
            <h3>Dates: </h3>
                <asp:DropDownList ID="EventDateDropDown" runat="server"></asp:DropDownList>
            
        </div>

        <asp:HiddenField ID="BuildingKeyField" runat="server" />
        <asp:HiddenField ID="SeriesIdField" runat="server" />
        <asp:HiddenField ID="SelectedSection" runat="server" />
        <asp:HiddenField ID="SelectedSubsection" runat="server" />
        <asp:HiddenField ID="SelectedRow" runat="server" />

        <h3>Current Group Size: 
            <asp:Label ID="GroupSize" runat="server"></asp:Label>
        </h3>

        <h3 id="ticketNumber">Number of Tickets:
            <asp:TextBox TextMode="Number" ID="TicketQuantity" runat="server" min="0" max="9" step="1" value="0"></asp:TextBox>
            <asp:RangeValidator runat="server" ID="TicketQuantityRangeValidator" ValidationGroup="buyTicketsValidator" Type="Integer" MinimumValue="0" MaximumValue="1" ControlToValidate="TicketQuantity" ErrorMessage="You can only have 10 people in your group!" />
            <asp:Button ID="GetExtraTickets" runat="server" ValidationGroup="buyTicketsValidator" Text="Buy Extra Tickets" OnClick="GetExtraTickets_Click"></asp:Button>
        </h3>

        <button class="balcony" id="mapSwitch" onclick="changeBalcony(event)">Balcony</button>
            <div class="interactiveMap" id="map"></div>
        <asp:Label ID="Error" runat="server" Text="You need to pick seats." Visible="false" />
        <asp:Button ID="Submit" runat="server" OnClick="GetTickets_Click" Text="Get Tickets" />
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/highmaps") %>
    <%: Scripts.Render("~/bundles/map") %>
</asp:Content>

