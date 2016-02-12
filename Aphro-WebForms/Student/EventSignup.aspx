<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Student.EventSignup" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="EventName" runat="server"></asp:Label>
    <br />
    <asp:Label ID="EventDescription" runat="server"></asp:Label>
    <br />
    <asp:Label ID="EventLocation" runat="server"></asp:Label>
    <br />
    <asp:Label ID="EventPrice" runat="server"></asp:Label>
    <br />
    <asp:Label ID="EventPrimePrice" runat="server"></asp:Label>
    
    <div class="dropdown">
        <asp:Label ID="TypeLabel" runat="server" Text="Event Dates:"></asp:Label>
        <asp:DropDownList ID="EventDateDropDown" runat="server">
        </asp:DropDownList>
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

    <input type="hidden" value="<%= SeriesId %>" id="seriesid" />
    <input type="hidden" value="<%= BuildingKey %>" id="buildingkey" />
    <asp:HiddenField ID="SelectedSection" runat="server" />
    <asp:HiddenField ID="SelectedSubsection" runat="server" />
    <asp:HiddenField ID="SelectedRow" runat="server" />
    <asp:TextBox TextMode="Number" ID="TicketQuantity" runat="server" min="0" max="9" step="1" value="0"/>
    <asp:Button ID="GetExtraTickets" runat="server" Text="Buy Extra Tickets" OnClick="GetExtraTickets_Click" />

    <div class="ui-widget">
        <label for="group-request">Name or ID: </label>
        <input id="group-request">
        <input type="hidden" id="group-request-id" />
        <input type="hidden" id="group-request-type" />
    </div>
    <button onclick="addToGroup(event);">Add To Group</button>
    
    <div id="container" style="max-width: 1000px"></div>
    <asp:Button ID="Submit" runat="server" OnClick="GetTickets_Click" Text="Get Tickets" />
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/highmaps") %>
    <%: Scripts.Render("~/bundles/map") %>
    <%: Scripts.Render("~/bundles/jquery-ui") %>

<script>
    $(function() {
        $("#group-request").autocomplete({
            source: "../Shared/Search.ashx",
            minLength: 2,
            focus: function (event, ui) {
                $("#group-request").val(ui.item.firstname + " " + ui.item.lastname);
                $("#group-request-id").val(ui.item.id);
                $("#group-request-type").val(ui.item.student);
                return false;
            },
            select: function( event, ui ) {
                $("#group-request").val(ui.item.firstname + " " + ui.item.lastname);
                $("#group-request-id").val(ui.item.id);
                $("#group-request-type").val(ui.item.student);
                return false;
            }
        })
        .autocomplete( "instance" )._renderItem = function( ul, item ) {
            return $( "<li>" )
              .append(item.firstname + " " + item.lastname + "<br>" + item.id)
              .appendTo( ul );
        };
    });

    function addToGroup(e)
    {
        e.preventDefault();
 
        $.post("../Shared/AddToGroup.ashx", { personId: $('#group-request-id').val(), personType: $('#group-request-type').val(), seriesId: $('#seriesid').val() })
            .done(function (data) {
                alert("added Person");
            })
            .fail(function () {
                alert("error");
            });
    }
</script>
</asp:Content>
