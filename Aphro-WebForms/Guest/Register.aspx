<%@ Page Title="Register" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Aphro_WebForms.Guest.Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Sign Up</h1>

    <div class="content-wrapper">
        <asp:Label ID="labelMessage" runat="server"></asp:Label>

        <h3>First Name</h3>
        <asp:TextBox ID="first_name" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="first_name" Display="Dynamic" ErrorMessage="First name is required" ValidationGroup="AllValidators">*</asp:RequiredFieldValidator>

        <h3>Last Name</h3>
        <asp:TextBox ID="last_name" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="last_name" Display="Dynamic" ErrorMessage="Last name is required" ValidationGroup="AllValidators">*</asp:RequiredFieldValidator>

        <h3>Email</h3>
        <asp:TextBox ID="email" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="email" Display="Dynamic" ErrorMessage="Email is required" ValidationGroup="AllValidators">*</asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="email" Display="Dynamic" ErrorMessage="E-mail addresses must be in the format of name@domain.xyz." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="AllValidators">Invalid format!</asp:RegularExpressionValidator>

        <h3>Password</h3>
        <asp:TextBox ID="password" TextMode="Password" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="password" Display="Dynamic" ErrorMessage="Password is required" ValidationGroup="AllValidators">*</asp:RequiredFieldValidator>

        <h3>Confirm Password</h3>
        <asp:TextBox ID="confirm_password" TextMode="Password" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="confirm_password" Display="Dynamic" ErrorMessage="Confirm password is required" ValidationGroup="AllValidators">*</asp:RequiredFieldValidator>
        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="password" ControlToValidate="confirm_password" Display="Dynamic" ErrorMessage="Passwords do not match." ValidationGroup="AllValidators"></asp:CompareValidator>

        <asp:Button ID="RegisterButton" runat="server" OnClick="RegisterButton_Click" Text="Register" ValidationGroup="AllValidators" />

        <asp:HyperLink ID="AlreadyHaveAccount" href="login.aspx" runat="server">Already have account?</asp:HyperLink>
    </div>
</asp:Content>