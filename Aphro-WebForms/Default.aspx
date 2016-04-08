<%@ Page Title="Home" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Aphro_WebForms.Default" %>

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
    </asp:PlaceHolder>
    <link rel="shortcut icon" href="~/Content/images/fasticketsSymbol.ico" />
    <title><%: Page.Title %></title>
</head>
<body>
    <div class="shadow">
        <div class="mainPane">
            <form id="form1" runat="server">
                <div class="spotlight"></div>
                <img id="projectLogo" src="Content/images/fastickets.png" />
                <div class="row">
                    <div class="col-sm-4">
                        <asp:HyperLink runat="server" CssClass="websites" NavigateUrl="~/Guest/Index.aspx">
                            <div class="module">
                                <div class="inner_mod">
                                    Buy Tickets as a Guest
                                </div>
                            </div>
                        </asp:HyperLink>
                    </div>
                    <div class="col-sm-4">
                        <asp:HyperLink runat="server" CssClass="websites" NavigateUrl="~/Student/Index.aspx">
                            <div class="module">
                                <div class="inner_mod">
                                    Buy Tickets as a Student
                                </div>
                            </div>
                        </asp:HyperLink>
                    </div>
                    <div class="col-sm-4">
                        <asp:HyperLink runat="server" CssClass="websites" NavigateUrl="~/Employee/Index.aspx">
                            <div class="module">
                                <div class="inner_mod">
                                    Buy Tickets as an Employee
                                </div>
                            </div>
                        </asp:HyperLink>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <!-- SEI back button -->
    <div class="back-effect">
        <a href="http://cslinux.studentnet.int/" class="back-effect">
            <asp:Image runat="server" ImageUrl="~/Content/images/se_logo_min.png" />
            <span>sei home</span>
        </a>
    </div>
</body>
</html>