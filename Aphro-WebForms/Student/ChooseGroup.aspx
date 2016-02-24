<%@ Page Title="" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="ChooseGroup.aspx.cs" Inherits="Aphro_WebForms.Student.ChooseGroup" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
        <div class="event-dates">
            Event Dates: 
            <asp:ListView ID="EventDateList" runat="server">
                <LayoutTemplate>
                    <div id="EventDates" runat="server">
                        <div id="itemPlaceholder" runat="server"></div>
                    </div>
                </LayoutTemplate>
                <ItemTemplate>
                    <p><%# Eval("event_datetime")%></p>
                </ItemTemplate>
            </asp:ListView>
        </div>
    </div>
    <div class="col-md-6">
        <h4>Group Requests:</h4>
        <asp:ListView ID="GroupsList" runat="server">
            <LayoutTemplate>
                <div id="GroupsContainer" runat="server">
                    <div class="panel-group" id="accordion">
                        <div id="itemPlaceholder" runat="server"></div>
                    </div>
                </div>
            </LayoutTemplate>
            <EmptyItemTemplate>
                <p>No groups to show (This is an error).</p>
            </EmptyItemTemplate>
            <ItemTemplate>
                <div class="panel panel-default">
                    <div class="panel-heading collapsed">
                        <p class="panel-title"><%# Eval("group_leader_firstname") + " " + Eval("group_leader_lastname") %></p>
                        <div class="panel-buttons">
                            <asp:Button ID="AcceptButton" runat="server" CommandArgument='<%# Eval("group_id")%>' Text="Accept" OnClick="AcceptButton_Click"/>
                            <asp:Button ID="RejectButton" runat="server" CommandArgument='<%# Eval("group_id")%>' Text="Reject" OnClick="RejectButton_Click"/>
                        </div>
                        <div class="clearfix" data-toggle="collapse" data-parent="#accordion" href="#collapse<%#Container.DisplayIndex + 1%>" aria-expanded="false"></div>
                    </div>
                    <div id="collapse<%#Container.DisplayIndex + 1%>" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
                        <div class="panel-body">
                            <%# (int)Eval("guests") == 0 ? "" : "<p>" + Eval("guests") + " Guest Tickets" + "</p>" %>
                            <asp:ListView ID="GroupRequestsList" runat="server" DataSource='<%# Eval("group_requests") %>'>
                                <LayoutTemplate>
                                    <div id="itemPlaceholder" runat="server"></div>
                                </LayoutTemplate>
                                <EmptyItemTemplate>
                                    <p>No requests (This is an error).</p>
                                </EmptyItemTemplate>
                                <ItemTemplate>
                                    <div class="clearfix">
                                        <p class="group-member"><%# Eval("requested_firstname") + " " + Eval("requested_lastname") %></p>
                                        <p class="group-status"><%# Eval("has_accepted").Equals(0) ? "Pending" : "Accepted" %></p>
                                    </div>
                                </ItemTemplate>
                            </asp:ListView>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>

        <asp:HiddenField ID="SeriesIdField" runat="server" />
    </div>
</asp:Content>
