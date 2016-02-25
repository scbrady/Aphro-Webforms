<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Student.EventSignup" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="EventName" runat="server"></h1>
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
            Event Dates: <asp:DropDownList ID="EventDateDropDown" runat="server"></asp:DropDownList>
        </div>
    </div>
    <div class="col-md-6">
        <h4>Group:</h4>
        <asp:ListView ID="GroupList" runat="server">
            <LayoutTemplate>
                <div id="GroupRequestContainer" runat="server">
                    <div id="itemPlaceholder" runat="server"></div>
                </div>
            </LayoutTemplate>
            <EmptyDataTemplate>
                <div id="GroupRequestContainer" runat="server">
                    <p>Start Adding People To Your Group</p>
                </div>
            </EmptyDataTemplate>
            <ItemTemplate>
                <div class="clearfix">
                    <p class="group-member"><%# Eval("requested_firstname") + " " + Eval("requested_lastname") %></p>
                    <p class="group-status"><%# Eval("has_accepted").Equals(0) ? "Pending <img class='pending' src='../Content/Pending.gif'/>" : "Accepted <img class='accepted' src='../Content/Checkmark.png' />" %></p>
                </div>
            </ItemTemplate>
        </asp:ListView>
        <ul class="nav nav-pills nav-justified">
            <li class="active"><a data-toggle="pill" href="#studentsTab">Invite Students</a></li>
            <li><a data-toggle="pill" href="#guestsTab">Buy Guest Tickets</a></li>
        </ul>
        <div class="tab-content">
            <div id="studentsTab" class="tab-pane fade in active">
                <div class="ui-widget">
                    <label for="group-request">Name or ID: </label>
                    <div>
                        <input type="text" id="group-request"/>
                    </div>
                    <button onclick="addToGroup(event);">Add To Group</button>
                    <input type="hidden" id="group-request-id" />
                </div>
                
            </div>
            <div id="guestsTab" class="tab-pane fade">
                Regular Price: <asp:Label ID="EventPrice" runat="server"></asp:Label><br />
                Prime Price: <asp:Label ID="EventPrimePrice" runat="server"></asp:Label><br />
                <label id="ticketNumber" for="MainContent_TicketQuantity">Number of Tickets:</label>
                <asp:TextBox TextMode="Number" ID="TicketQuantity" runat="server" min="0" max="9" step="1" value="0"></asp:TextBox>
                <asp:RangeValidator runat="server" ID="TicketQuantityRangeValidator" ValidationGroup="buyTicketsValidator" Type="Integer" MinimumValue="0" MaximumValue="1" ControlToValidate="TicketQuantity" ErrorMessage="You can only have 10 people in your group!" />
                <asp:Button ID="GetExtraTickets" runat="server" ValidationGroup="buyTicketsValidator" Text="Buy Extra Tickets" OnClick="GetExtraTickets_Click"></asp:Button>
            </div>
        </div> 
    </div>    

    <asp:HiddenField ID="BuildingKeyField" runat="server" />
    <asp:HiddenField ID="SeriesIdField" runat="server" />
    <asp:HiddenField ID="SelectedSection" runat="server" />
    <asp:HiddenField ID="SelectedSubsection" runat="server" />
    <asp:HiddenField ID="SelectedRow" runat="server" />
    <asp:HiddenField ID="GroupSize" runat="server" />

    <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">Chooose Seats</button>

    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-body">
                <div class="interactiveMap" id="container"></div>
                <button class="balcony" id="mapSwitch" onclick='changeBalcony(event);'></button>
                <asp:Button ID="Submit" runat="server" OnClick="GetTickets_Click" Text="Get Tickets" />
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/highmaps") %>
    <%: Scripts.Render("~/bundles/map") %>
    <%: Scripts.Render("~/bundles/jquery-ui") %>

    <script>
        $(function () {
            $("#group-request").autocomplete({
                source: "../Shared/Search.ashx",
                minLength: 2,
                focus: function (event, ui) {
                    $("#group-request").val(ui.item.firstname + " " + ui.item.lastname);
                    $("#group-request-id").val(ui.item.xid);
                    return false;
                },
                select: function (event, ui) {
                    $("#group-request").val(ui.item.firstname + " " + ui.item.lastname);
                    $("#group-request-id").val(ui.item.xid);
                    return false;
                }
            })
            .autocomplete("instance")._renderItem = function (ul, item) {
                return $("<li>")
                  .append(item.firstname + " " + item.lastname + "<br>" + item.xid)
                  .appendTo(ul);
            };
        });

        function addToGroup(e) {
            e.preventDefault();

            $.post("../Shared/AddToGroup.ashx", { personId: $('#group-request-id').val(), seriesId: $('#MainContent_SeriesIdField').val() })
                .done(function (data) {
                    alert("added Person");
                })
                .fail(function () {
                    alert("error");
                });
        }
    </script>
</asp:Content>