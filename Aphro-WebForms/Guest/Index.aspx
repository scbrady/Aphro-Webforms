<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/GuestPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Guest.Index" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="header"></div>
<asp:Label ID="GuestName" runat="server" Text="Label"></asp:Label>
<div class="wrapper">
<div class="shadow">
</div>
	<div class="mainPane">
		<h1 id="label">Select an Event to Purchase Tickets</h1>
			
		<div id="navigation">
			<button class="previous"data-increment="-1"><</button>
			<button class="next" data-increment="1">></button>
			<section class="selector">

				<div id="carousel" class=" panels-backface-invisible">
                    <asp:ListView ID="EventListview" runat="server">
                        <LayoutTemplate>         
                            <div id="EventContainer" runat="server">              
                                <div id="itemPlaceholder" runat="server">              
                                </div>         
                            </div>      
                        </LayoutTemplate>

                        <EmptyDataTemplate>         
                            <div id="EventContainer" runat="server">              
                                <div id="itemPlaceholder" runat="server">                 
                                    No Upcoming Events.             
                                </div>
                            </div>      
                        </EmptyDataTemplate>

                        <ItemTemplate>
                            <asp:HyperLink runat="server" ID="EventLink" NavigateUrl='<%# "EventSignup.aspx?Series="+ Eval("series_id") %>' Text='<%# Eval("name") %>'></asp:HyperLink>
                            <br/>
                        </ItemTemplate>
                    </asp:ListView>
				</div>
            </section>
        </div>
    </div>
</div>

<section id="options">
    <p>
	    <label for="panel-count"></label>
	    <input type="range" id="panel-count" value="5" min="1" max="10"/>
	    <span class=" range-display"></span>
    </p>
</section>
</asp:Content>
