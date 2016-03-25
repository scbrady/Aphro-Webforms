<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Student.EventSignup" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderSection" runat="server">
    <%: Styles.Render("~/Content/map-css") %>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="EventName" runat="server"></h1>
    <div class="row">
        <div class="col-md-6">
            <h4>Group:</h4>
            <div id="GroupRequestContainer" runat="server">
                <% if (GuestTickets > 0)
                    { %>
                <p><%= GuestTickets %> Guest Tickets</p>
                <hr />
                <% } %>
                <asp:ListView ID="GroupList" runat="server">
                    <LayoutTemplate>
                        <div id="itemPlaceholder" runat="server"></div>
                    </LayoutTemplate>
                    <EmptyDataTemplate>
                        <div id="GroupRequestContainer" runat="server">
                            <p id="student-placeholder">Start Adding Students To Your Group</p>
                        </div>
                    </EmptyDataTemplate>
                    <ItemTemplate>
                        <li class="clearfix request-list">
                            <p class="group-member"><%# Eval("requested_firstname") + " " + Eval("requested_lastname") %></p>
                            <p class="group-status <%# Eval("has_accepted").Equals(0) ? "pending-status" : "accepted-status" %>" data-user-id="<%# Eval("requested_id") %>" data-group-id="<%# Eval("group_id") %>"></p>
                        </li>
                    </ItemTemplate>
                </asp:ListView>
            </div>
            <ul class="nav nav-pills nav-justified">
                <li class="active"><a data-toggle="pill" href="#studentsTab">Invite Students</a></li>
                <li><a data-toggle="pill" href="#guestsTab">Buy Guest Tickets</a></li>
            </ul>
            <div class="tab-content">
                <div id="studentsTab" class="tab-pane fade in active">
                    <div class="ui-widget">
                        <label for="group-request">Name or ID: </label>
                        <p id="student-request-error" class="error">You cannot request this student.</p>
                        <p id="student-group-error" class="error">You cannot have more than 10 people in your group (even if they are pending).</p>
                        <div>
                            <input type="text" id="group-request" class="ui-autocomplete-input" autocomplete="off" />
                            <input type="submit" onclick="addToGroup(event);" value="Add to Group" />
                        </div>
                        <input type="hidden" id="group-request-id" />
                    </div>
                </div>
                <div id="guestsTab" class="tab-pane fade">

                    <span class="pull-left">Regular Price:
                        <asp:Label ID="EventPrice" runat="server"></asp:Label></span>
                    <span class="pull-right">Prime Price:
                        <asp:Label ID="EventPrimePrice" runat="server"></asp:Label></span>
                    <br />
                    <label id="ticketNumber" for="MainContent_TicketQuantity">Number of Tickets:</label>
                    <input type='button' value='-' class='sub-qty ticket-number-btn' field='MainContent_TicketQuantity' />
                    <asp:TextBox TextMode="Number" CssClass="ticket-number" ID="TicketQuantity" runat="server" min="0" max="9" step="1" value="0"></asp:TextBox>
                    <input type='button' value='+' class='add-qty ticket-number-btn' field='MainContent_TicketQuantity' />
                    <asp:CustomValidator ID="TicketQuantityRangeValidator" ValidationGroup="buyTicketsValidator" runat="server" ControlToValidate="TicketQuantity" ErrorMessage="You can only have 10 people in your group!" ClientValidationFunction="validateSize"></asp:CustomValidator>
                    <asp:Button Style="display: block; margin: 10px auto 0; width: 50%" ID="Button1" runat="server" ValidationGroup="buyTicketsValidator" Text="Buy Extra Tickets" OnClick="GetExtraTickets_Click"></asp:Button>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="event-summary">
                Summary:
            <asp:Label ID="EventDescription" runat="server"></asp:Label>
            </div>
            <div class="event-location">
                Location:
            <asp:Label ID="EventLocation" runat="server"></asp:Label>
            </div>
            <div class="event-date">
                Event Dates:
                <asp:DropDownList ID="EventDateDropDown" runat="server"></asp:DropDownList>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="BuildingKeyField" runat="server" />
    <asp:HiddenField ID="SeriesIdField" runat="server" />
    <asp:HiddenField ID="SelectedSection" runat="server" />
    <asp:HiddenField ID="SelectedSubsection" runat="server" />
    <asp:HiddenField ID="SelectedRow" runat="server" />
    <asp:HiddenField ID="GroupSize" runat="server" />

    <asp:Label ID="Error" runat="server" Text="Those seats are no longer available. Please pick new seats." Visible="false" />
    <button type="button" class="btn btn-primary btn-lg choose-seats" data-toggle="modal" data-target="#myModal">Choose Seats</button>

    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="interactiveMap" id="map"></div>
                    <button class="balcony" id="mapSwitch" onclick="changeBalcony(event)">Balcony</button>
                    <asp:Button class="getTickets" ID="GetTicketsForEvent" runat="server" OnClick="GetTickets_Click" Text="Get Tickets" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/highmaps") %>
    <%: Scripts.Render("~/bundles/map") %>
    <%: Scripts.Render("~/bundles/jquery-ui") %>
    <%: Scripts.Render("~/bundles/group_requests") %>

    <script>
        $('.add-qty').click(function (e) {
            // Stops the button from being a button
            e.preventDefault();

            // Set the needed variables
            field_name = $(this).attr('field');
            var max_val = 9;
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
            var min_val = 0;
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