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
        <%: Styles.Render("~/Content/guest-css") %>
    </asp:PlaceHolder>
    <link rel="shortcut icon" href="Content/fasticketsSymbol.ico"/>
    <title><%: Page.Title %></title>
</head>
<body>
    <div class="header"></div>
    <div class="shadow">
        <div class="mainPane">
            <form id="form1" runat="server">
                <img id="projectLogo" src="Content/fastickets.png" />
                <div class="rows">
                    <div class="col-sm-6">
                        <asp:HyperLink runat="server" CssClass="websites" NavigateUrl="~/Event/Index.aspx">
                            <div class="module">
                                <div class="inner_mod">
                                    Create an Event
                                </div>
                            </div>
                        </asp:HyperLink>
                    </div>

                    <div class="col-sm-6">
                        <asp:HyperLink runat="server" CssClass="websites" NavigateUrl="~/Guest/Index.aspx">
                            <div class="module">
                                <div class="inner_mod">
                                    Buy Tickets as a Guest
                                </div>
                            </div>
                        </asp:HyperLink>
                    </div>
                    <div class="col-sm-6">
                        <asp:HyperLink runat="server" CssClass="websites" NavigateUrl="~/Student/Index.aspx">
                            <div class="module">
                                <div class="inner_mod">
                                    Buy Tickets as a Student
                                </div>
                            </div>
                        </asp:HyperLink>
                    </div>
                    <div class="col-sm-6">
                        <asp:HyperLink runat="server" CssClass="websites"  NavigateUrl="~/Employee/Index.aspx">
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
</body>
</html>