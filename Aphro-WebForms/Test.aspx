<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="Aphro_WebForms.Test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        Welcome to visual design . . .<br />
        <br />
        <br />
        Enter Your Name:<br />
        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" Text="Display Name" OnClick="Button1_Click" />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Label" ForeColor="Tomato"></asp:Label>
    
    </div>
    </form>
</body>
</html>
