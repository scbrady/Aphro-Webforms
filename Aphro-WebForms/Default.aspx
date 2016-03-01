<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Aphro_WebForms.Default" %>

<%@ Import Namespace="System.Web.Optimization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/jquery") %>
        <%: Scripts.Render("~/bundles/bootstrap") %>
        <%: Scripts.Render("~/bundles/datepicker") %>
        <%: Styles.Render("~/Content/css") %>
        <%: Styles.Render("~/Content/home") %>
        <%: Styles.Render("~/Content/guest-css") %>
    </asp:PlaceHolder>
    <title><%: Page.Title %></title>
</head>
<body>
<div class="header"></div>
    <div class="shadow">
        <div class="mainPane">
            <form id="form1" runat="server">
                <img id="projectLogo" src="Content/fastickets.png" />
                <div class="links">
                    <asp:HyperLink runat="server" CssClass="websites" href="Event/Homepage.aspx">Event Creation</asp:HyperLink>
                    <asp:HyperLink runat="server" CssClass="websites" href="Guest/Index.aspx">Guest Dashboard</asp:HyperLink>
                    <asp:HyperLink runat="server" CssClass="websites" href="Student/Index.aspx">Student Dashboard</asp:HyperLink>
                </div>
            </form>
        </div>
    </div>
</body>
</html>