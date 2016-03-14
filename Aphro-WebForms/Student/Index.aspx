<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Student.Index" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderSection" runat="server">
    <%:Styles.Render("~/Content/carousel") %>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1 id="label">Select an Event to Purchase Tickets</h1>

    <div id="navigation">
        <button class="previous navButton" data-increment="-1" a>&lt</button>
        <button class="next navButton" data-increment="1">&gt</button>
        <section class="selector">
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
                    <a style="background-image: url('<%# "../Content/pictures/"+ Eval("event_picture") %>')" href='<%# "EventSignup.aspx?Series="+ Eval("series_id") %>'>
                        <div><%# Eval("name") %></div>
                    </a>
                </ItemTemplate>
            </asp:ListView>
        </section>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/carousel") %>
</asp:Content>