<%@ Page Title="Event Signup" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EventSignup.aspx.cs" Inherits="Aphro_WebForms.Guest.EventSignup" %>
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
    
    <asp:ListView ID="EventDateListview" runat="server">
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
    </asp:ListView>
</asp:Content>
