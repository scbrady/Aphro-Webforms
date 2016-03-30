<%@ Page Title="Buy Season Tickets" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="BuySeasonTickets.aspx.cs" Inherits="Aphro_WebForms.Guest.BuySeasonTickets" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="season-header">Buy Season Tickets</h1>

    <div class="row">
        <div class="col-md-6">
            <asp:DropDownList ID="SeasonDropDown" runat="server"></asp:DropDownList>
        </div>
        <div class="col-md-6">
            <asp:ListView ID="SeasonListView" runat="server">
                <LayoutTemplate>
                    <div id="itemPlaceholder" runat="server">
                    </div>
                </LayoutTemplate>
                <ItemTemplate>
                    <div id="summary-<%# Eval("season_id") %>" class="season-summary">
                        <h4>Price: $<%# Eval("price") %></h4>
                        <h4>Already Purchased: <%# Eval("ticket_count") %></h4>
                        <h4>Events in this season:</h4>
                        <asp:ListView ID="GroupRequestsList" runat="server" DataSource='<%# Eval("event_names") %>'>
                            <LayoutTemplate>
                                <div id="itemPlaceholder" runat="server"></div>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <li><%# Container.DataItem.ToString() %></li>
                            </ItemTemplate>
                        </asp:ListView>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </div>
    </div>
    <asp:Button ID="Submit" runat="server" Text="Buy" OnClick="Submit_Click" />
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <script>
        $(function () {
            refreshSummaryList($("#MainContent_SeasonDropDown").val());

            $("#MainContent_SeasonDropDown").change(function () {
                var selected_id = $(this).val();
                refreshSummaryList(selected_id);
            });
        });

        function refreshSummaryList(selected_id)
        {
            $(".season-summary").hide();
            $("#summary-" + selected_id).show();
        }
    </script>
</asp:Content>
