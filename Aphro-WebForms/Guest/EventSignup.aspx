<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Guest.EventSignup" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderSection" runat="server">
    <%: Styles.Render("~/Content/map-css") %>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="eventSignup">
        <h1 class="eName"><asp:Label ID="EventName" runat="server"></asp:Label></h1>
        <asp:Label ID="Error" runat="server" Text="Those seats are no longer available. Please pick new seats." Visible="false" />
        <div class="row">
            <div class="col-md-7">
                <div class="Description">
                    <h3>Description: </h3>
                    <asp:Label ID="EventDescription" runat="server"></asp:Label>
                </div>
            </div>

            <div class="event-side-info col-md-5">
                <div class="Location">
                    <h3>Location: </h3>
                    <asp:Label ID="EventLocation" runat="server"></asp:Label>
                </div>

                <div class="Price">
                    <h3>Price:</h3>
                    <asp:Label ID="EventPrice" runat="server"></asp:Label>
                    (Prime:
                <asp:Label ID="EventPrimePrice" runat="server"></asp:Label>)
                </div>

                <h3>Dates: </h3>
                <asp:DropDownList ID="EventDateDropDown" runat="server"></asp:DropDownList>

                <asp:HiddenField ID="BuildingKeyField" runat="server" />
                <asp:HiddenField ID="SeriesIdField" runat="server" />
                <asp:HiddenField ID="SelectedSection" runat="server" />
                <asp:HiddenField ID="SelectedSubsection" runat="server" />
                <asp:HiddenField ID="SelectedRow" runat="server" />

                <h3 id="ticketNumber">Number of Tickets:</h3>
                <input type='button' value='-' class='sub-qty ticket-number-btn' field='MainContent_GroupSize' />
                <asp:TextBox TextMode="Number" CssClass="ticket-number" ID="GroupSize" runat="server" min="1" max="10" step="1" value="1"></asp:TextBox>
                <input type='button' value='+' class='add-qty ticket-number-btn' field='MainContent_GroupSize' />
            </div>
        </div>

        <button type="button" id='choose-seats' data-toggle="modal" data-target="#myModal">Choose Seats</button>
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="interactiveMap" id="map"></div>
                        <button class="balcony" id="mapSwitch" onclick="changeBalcony(event)">Balcony</button>
                        <p>Price: $<span id="priceField"></span></p>
                        <asp:Button class="getTickets" ID="GetTicketsForEvent" runat="server" OnClick="GetTickets_Click" Text="Get Tickets" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/highmaps") %>
    <%: Scripts.Render("~/bundles/map") %>
    <script>
        $('.add-qty').click(function (e) {
            // Stops the button from being a button
            e.preventDefault();

            // Set the needed variables
            field_name = $(this).attr('field');
            var max_val = 10;
            var current_val = parseInt($('#' + field_name).val());

            // Make sure counter can't go higher than max_val
            if (!isNaN(current_val) && current_val < max_val) {
                $('#' + field_name).val(current_val + 1);
            } else if (current_val == max_val) {
                $('#' + field_name).val(max_val);
            } else {
                // Just in case something goes wrong, you get 0. Sorry bud
                $('#' + field_name).val(0);
            }
        });
        $(".sub-qty").click(function (e) {
            // Stops the button from being a button
            e.preventDefault();

            // Set the needed variables
            field_name = $(this).attr('field');
            var min_val = 1;
            var current_val = parseInt($('#' + field_name).val());

            // Make sure counter can't go lower than min_val
            if (!isNaN(current_val) && current_val > min_val) {
                $('#' + field_name).val(current_val - 1);
            } else {
                $('#' + field_name).val(min_val);
            }
        });
    </script>
</asp:Content>