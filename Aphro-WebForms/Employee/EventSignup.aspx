<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/EmployeePortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Employee.EventSignup" %>

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
                <li><a data-toggle="pill" href="#facultyTab">Faculty Tickets</a></li>
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
                    <span class="pull-left">Regular Price: <asp:Label ID="EventPrice" runat="server"></asp:Label></span>
                    <span class="pull-right">Prime Price: <asp:Label ID="EventPrimePrice" runat="server"></asp:Label></span>
                    <br />
                    <label id="ticketNumber" for="MainContent_TicketQuantity">Number of Tickets:</label>
                    <asp:TextBox TextMode="Number" ID="TicketQuantity" runat="server" min="0" max="9" step="1" value="0"></asp:TextBox>
                    <asp:CustomValidator ID="TicketQuantityRangeValidator" ValidationGroup="buyTicketsValidator" runat="server" Display="Dynamic" ControlToValidate="TicketQuantity" ErrorMessage="You can only have 10 people in your group!" ClientValidationFunction="validateSize" ></asp:CustomValidator>
                    <asp:Button ID="Button1" runat="server" ValidationGroup="buyTicketsValidator" Text="Buy Extra Tickets" OnClick="GetExtraTickets_Click"></asp:Button>
                </div>
                <div id="facultyTab" class="tab-pane fade">
                    <label id="facultyTicketNumber" for="MainContent_TicketQuantity">Number of Tickets:</label>
                    <asp:TextBox TextMode="Number" ID="FacultyTicketQuantity" runat="server" min="0" max="9" step="1" value="0"></asp:TextBox>
                    <asp:CustomValidator ID="FacultyTicketQuantityRangeValidator" ValidationGroup="buyFacultyTicketsValidator" runat="server" Display="Dynamic" ControlToValidate="FacultyTicketQuantity" ErrorMessage="You can only have 10 people in your group!" ClientValidationFunction="validateSize" ></asp:CustomValidator>
                    <asp:Button ID="Button2" runat="server" ValidationGroup="buyFacultyTicketsValidator" Text="Rquest Tickets" OnClick="GetExtraFacultyTickets_Click"></asp:Button>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="event-summary">
                <h4>Summary:</h4>
                <asp:Label ID="EventDescription" runat="server"></asp:Label>
            </div>
            <div class="event-location">
                <h4>Location:</h4>
                <asp:Label ID="EventLocation" runat="server"></asp:Label>
            </div>
            <div class="event-date">
                <h4>Event Dates:</h4>
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
</asp:Content>