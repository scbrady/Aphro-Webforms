<%@ Page Title="" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="ChooseGroup.aspx.cs" Inherits="Aphro_WebForms.Student.ChooseGroup" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="col-md-6">
        <p>Filler.</p>
    </div>
    <div class="col-md-6">
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
                    <a class="panel-heading collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapse<%#Container.DisplayIndex + 1%>" aria-expanded="false">
                        <p class="panel-title"><%# Eval("group_leader_firstname") + " " + Eval("group_leader_lastname") %></p>
                        <div class="panel-buttons">
                            <button>Accept</button>
                            <button>Reject</button>
                        </div>
                        <div class="clearfix"></div>
                    </a>
                    <div id="collapse<%#Container.DisplayIndex + 1%>" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
                        <asp:ListView ID="GroupRequestsList" runat="server" DataSource='<%# Eval("group_requests") %>'>
                            <LayoutTemplate>
                                <div class="panel-body">
                                    <div id="itemPlaceholder" runat="server"></div>
                                </div>
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
            </ItemTemplate>
        </asp:ListView>
    </div>
</asp:Content>
