<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/EmployeePortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Employee.EventSignup" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderSection" runat="server">
    <%: Styles.Render("~/Content/map-css") %>
    <%: Styles.Render("~/Content/group-requests") %>
    <%: Styles.Render("~/Content/group-removals") %>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="EventName" runat="server"></h1>
    <asp:Label ID="Error" runat="server" Visible="false" />
    <div class="row">
        <div class="col-md-6">
            <h4>Group:</h4>
            <div id="GroupRequestContainer" runat="server">
                <% if (GuestTickets > 0)
                    { %>
                <p><%= GuestTickets %> Guest Tickets</p>
                <hr />
                <% }
                    if (FacultyTickets > 0)
                    { %>
                <p><%= FacultyTickets %> Faculty Tickets</p>
                <hr />
                <% } %>
                <asp:ListView ID="GroupList" runat="server">
                    <LayoutTemplate>
                        <div id="itemPlaceholder" runat="server"></div>
                    </LayoutTemplate>
                    <EmptyDataTemplate>
                        <p id="student-placeholder">Start Adding Students To Your Group</p>
                    </EmptyDataTemplate>
                    <ItemTemplate>
                        <li class="clearfix request-list">
                            <p class="group-member"><%# Eval("requested_firstname") + " " + Eval("requested_lastname") %></p>
                            <p class="group-status <%# Eval("has_accepted").Equals(0) ? "pending-status" : "accepted-status" %>" data-user-id="<%# Eval("requested_id") %>" data-group-id="<%# Eval("group_id") %>"></p>
                        </li>
                    </ItemTemplate>
                </asp:ListView>
            </div>
            <div class="tab-content">
                <!-- Student Request -->
                <label for="group-request">Request Student: </label>
                <p id="student-request-error" class="error">This student already has tickets or is in another group.</p>
                <p id="student-error" class="error">This is not a current student. Please choose a student from the dropdown.</p>
                <p id="student-group-error" class="error">You cannot have more than 10 people in your group (even if they are pending).</p>
                <div>
                    <input type="text" id="group-request" class="ui-autocomplete-input" autocomplete="off" />
                    <input type="submit" onclick="addToGroup(event);" value="Add to Group" />
                </div>
                <input type="hidden" id="group-request-id" />

                <!-- Guest Request -->
                <label id="ticketNumber" for="MainContent_GuestTicketsSize">Number of Guest Tickets:</label>
                <div>
                    <input type='button' value='-' class='sub-qty ticket-number-btn' field='MainContent_GuestTicketsSize' />
                    <asp:TextBox TextMode="Number" CssClass="ticket-number" ID="GuestTicketsSize" runat="server" step="1" value="0"></asp:TextBox>
                    <input type='button' value='+' class='add-qty ticket-number-btn' field='MainContent_GuestTicketsSize' />
                </div>
                <!-- Faculty Request -->
                <label id="facultyTicketNumber" for="MainContent_FacultyTicketsSize">Number of Faculty Tickets:</label>
                <div>
                    <input type='button' value='-' class='sub-qty ticket-number-btn' field='MainContent_FacultyTicketsSize' />
                    <asp:TextBox TextMode="Number" CssClass="ticket-number" ID="FacultyTicketsSize" runat="server" step="1" value="0"></asp:TextBox>
                    <input type='button' value='+' class='add-qty ticket-number-btn' field='MainContent_FacultyTicketsSize' />
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="event-detail">
                <h3>Summary:</h3>
                <asp:Label ID="EventDescription" runat="server"></asp:Label>
            </div>
            <div class="event-detail">
                <h3>Location:</h3>
                <asp:Label ID="EventLocation" runat="server"></asp:Label>
            </div>
            <div class="event-detail">
                <h3>Price:</h3>
                <asp:Label ID="EventPrice" runat="server"></asp:Label>
                <span>(Prime:
                    <asp:Label ID="EventPrimePrice" runat="server"></asp:Label>)</span>
            </div>
            <div class="event-detail">
                <h3>Event Dates:</h3>
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

    <button type="button" class="btn btn-primary btn-lg choose-seats" data-toggle="modal" data-target="#myModal">Choose Seats</button>

    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="interactiveMap" id="map"></div>
                    <button class="balcony" id="mapSwitch" onclick="changeBalcony(event)">Balcony</button>
                    <h4 id="priceText">Price: $<span id="priceField"></span></h4>
                    <%if (seasonTicketsAmount > 0) { %>
                    <p style="text-align: center;">Season Tickets: <span id="seasonTicketAmount"><%= seasonTicketsAmount %></span></p>
                    <% } %>
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
</asp:Content>