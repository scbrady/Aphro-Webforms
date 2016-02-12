<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/StudentPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Student.Index" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="StudentName" runat="server" Text="Label"></asp:Label>
    <asp:ListView ID="EventListview" runat="server">
        <LayoutTemplate>         
            <div id="EventContainer" runat="server">              
                <div ID="itemPlaceholder" runat="server">              
                </div>         
            </div>      
        </LayoutTemplate>

        <EmptyDataTemplate>         
            <div id="EventContainer" runat="server">              
                <div ID="itemPlaceholder" runat="server">                 
                    No Upcoming Events.             
                </div>
            </div>      
        </EmptyDataTemplate>

        <ItemTemplate>
            <asp:HyperLink runat="server" ID="EventLink" NavigateUrl='<%# "EventSignup.aspx?Series="+ Eval("series_id") %>' Text='<%# Eval("name") %>'></asp:HyperLink>
            <br/>
        </ItemTemplate>
    </asp:ListView>
</asp:Content>