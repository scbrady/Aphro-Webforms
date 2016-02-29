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
                <img id="projectLogo" src="Content/Project-Logo.png" />
                <h4>Choose a website</h4>
                <div class="table-responsive">
                        <asp:HyperLink runat="server" CssClass="Website" id="Event" href="Event/Index.aspx">Create An Event</asp:HyperLink>
                        <br />
                        <asp:HyperLink runat="server" CssClass="Website" id="Guest" href="Guest/Index.aspx">Guest Dashboard</asp:HyperLink>
                        <br />
                        <asp:HyperLink runat="server" CssClass="Website" id="Student" href="Student/Index.aspx">Student Dashboard</asp:HyperLink>
                        <br />
                </div>
            </form>
        </div>
    </div>
</body>
</html>