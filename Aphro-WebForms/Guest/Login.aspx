<%@ Page Title="Login" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Aphro_WebForms.Guest.Login" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h1>login</h1>
    <asp:Label ID="labelMessage" runat="server"></asp:Label>
    <br />
    <br />
    <asp:Label ID="email_label" runat="server" Text="Email"></asp:Label>
    <br />
    <div class="inner-addon left-addon">
        <i class="glyphicon glyphicon-user"></i>
        <asp:TextBox ID="email" runat="server" class="form-control"></asp:TextBox>
    </div>
    <br />
    <asp:Label ID="password_label" runat="server" Text="Password"></asp:Label>
    <br />
    <div class="inner-addon left-addon">
        <i class="glyphicon glyphicon-lock"></i>
        <asp:TextBox ID="password" runat="server" class="form-control" TextMode="Password"></asp:TextBox>
    </div>
    <br />
    <asp:Button ID="LoginButton" runat="server" OnClick="LoginButton_Click" Text="Login" />
    <div>
    <asp:HyperLink ID="CreateAccount" href="Register.aspx" runat="server">Create account</asp:HyperLink>
    </div>

</asp:Content>