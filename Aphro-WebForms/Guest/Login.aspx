<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Aphro_WebForms.Guest.Login" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Hello, world!</h1>
    <asp:Label ID="email_label" runat="server" Text="Email"></asp:Label>
    <br />
    <asp:TextBox ID="email" runat="server"></asp:TextBox>
    <br />
    <br />
    <asp:Label ID="password_label" runat="server" Text="Password"></asp:Label>
    <br />
    <asp:TextBox ID="password" runat="server"></asp:TextBox>
    <br />
    <br />
    <asp:Button ID="LoginButton" runat="server" OnClick="LoginButton_Click" Text="Login" />
    <br />
    <br />
    <asp:Label ID="labelMessage" runat="server"></asp:Label>
</asp:Content>