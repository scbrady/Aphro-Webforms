<%@ Page Title="Login" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Aphro_WebForms.Guest.Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>login</h1>
    <div class="content-wrapper">
        <asp:Label ID="labelMessage" runat="server"></asp:Label>
        <h3>Email</h3>
        <div class="inner-addon left-addon">
            <asp:TextBox ID="email" runat="server" class="form-control"></asp:TextBox>
        </div>
        <h3>Password</h3>
        <div class="inner-addon left-addon">
            <asp:TextBox ID="password" runat="server" class="form-control" TextMode="Password"></asp:TextBox>
        </div>
        <asp:Button ID="LoginButton" runat="server" OnClick="LoginButton_Click" Text="Login" />
        <asp:HyperLink ID="CreateAccount" href="Register.aspx" runat="server">Create account</asp:HyperLink>
    </div>
</asp:Content>