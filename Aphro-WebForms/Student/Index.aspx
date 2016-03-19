<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Student.Index" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderSection" runat="server">
    <%:Styles.Render("~/Content/slick") %>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="label">Select an Event to Purchase Tickets</h1>

    <asp:ListView ID="EventListview" runat="server">
        <LayoutTemplate>
            <div id="carousel" class=" panels-backface-invisible">
                <div id="itemPlaceholder" runat="server">
                </div>
            </div>
        </LayoutTemplate>

        <EmptyDataTemplate>
            <div id="itemPlaceholder" runat="server">
                No Upcoming Events.
            </div>
        </EmptyDataTemplate>

        <ItemTemplate>
            <a class="carousel-item" href='<%# "EventSignup.aspx?Series="+ Eval("series_id") %>'>
                <span style="background-image: url('<%# "../Content/pictures/"+ Eval("event_picture") %>')"></span>
                <h2><%# Eval("name") %></h2>
            </a>
        </ItemTemplate>
    </asp:ListView>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/slick") %>
</asp:Content>