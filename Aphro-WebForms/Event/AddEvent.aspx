<%@ Page Title="Create Event" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="AddEvent.aspx.cs" Inherits="Aphro_WebForms.Event.AddEvent" EnableEventValidation="false" %>

<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="Content" ContentPlaceHolderID="HeaderSection" runat="server">
    <%: Styles.Render("~/Content/datepicker") %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%--Event Type--%>
    <h1>Create Event</h1>
    <asp:ValidationSummary CssClass="error-summary" HeaderText="You have errors, please fix them before creating the event." ID="ErrorSummary" ValidationGroup="EventCreation" runat="server" />

    <div class="content-wrapper">
        <h3>Event Type:</h3>
        <asp:RequiredFieldValidator CssClass="validator-error" ValidationGroup="EventCreation" runat="server" ControlToValidate="EventType" Text="Required Field." Display="Dynamic" />
        <asp:DropDownList ID="EventType" runat="server"></asp:DropDownList>

        <%--Event Name--%>
        <div class='name'>
            <h3>Event Name:</h3>
            <asp:RequiredFieldValidator CssClass="validator-error" ValidationGroup="EventCreation" runat="server" ControlToValidate="EventNameInput" Text="Required Field." Display="Dynamic" />
            <asp:RegularExpressionValidator CssClass="validator-error" ControlToValidate="EventNameInput" ValidationGroup="EventCreation" ValidationExpression="^[\s\S]{1,20}$" runat="server" Text="Minimum of 1 character and Maximum of 20 characters." Display="Dynamic"></asp:RegularExpressionValidator>
            <asp:TextBox ID="EventNameInput" runat="server"></asp:TextBox>
        </div>

        <%--Description--%>
        <div class='description'>
            <h3>Description:</h3>
            <asp:RequiredFieldValidator CssClass="validator-error" ValidationGroup="EventCreation" runat="server" ControlToValidate="DescriptionInput" Text="Required Field." Display="Dynamic" />
            <asp:RegularExpressionValidator CssClass="validator-error" ControlToValidate="DescriptionInput" ValidationGroup="EventCreation" ValidationExpression="^[\s\S]{1,800}$" runat="server" Text="Minimum of 1 character and Maximum of 800 characters." Display="Dynamic"></asp:RegularExpressionValidator>
            <asp:TextBox ID="DescriptionInput" TextMode="multiline" runat="server"></asp:TextBox>
        </div>

        <%--Image Upload--%>
        <div class="image_upload">
            <img src="../Content/images/noImage.png" id="imagePreview" />
            <div class="fileUpload btn btn-primary">
                <span>Upload</span>
                <asp:FileUpload runat="server" ID="uploadBtn" CssClass="upload" />
            </div>
        </div>

        <%--Location--%>
        <div class='eventCreation'>
            <h3>Location: </h3>
            <asp:RequiredFieldValidator CssClass="validator-error" ValidationGroup="EventCreation" runat="server" ControlToValidate="LocationDropDown" Text="Required Field" Display="Dynamic" />
            <asp:DropDownList ID="LocationDropDown" runat="server"></asp:DropDownList>
        </div>

        <%--Season--%>
        <div class='eventCreation'>
            <h3>Season: </h3>
            <asp:DropDownList ID="SeasonDropDown" runat="server"></asp:DropDownList>
        </div>

        <%-- Event Date(s)--%>
        <div id="EventDates" class='Event-Dates' style="position: relative">
            <h3>Event Date(s):</h3>
            <asp:RequiredFieldValidator CssClass="validator-error" ValidationGroup="EventCreation" runat="server" ControlToValidate="EventDate" Text="Required Field." Display="Dynamic" />
            <asp:TextBox ID="EventDate" runat="server" CssClass="datepicker-field"></asp:TextBox>
        </div>
        <button onclick="AddDate(event)">Add Date</button>
        <asp:HiddenField ID="Dates" runat="server" />

        <%-- Seating Prices (both regular and prime) --%>
        <div class='Seat-Price'>
            <h3>Regular Seating Price:</h3>
            <asp:RequiredFieldValidator CssClass="validator-error" ValidationGroup="EventCreation" runat="server" ControlToValidate="RegularPrice" Text="Required Field." Display="Dynamic" />
            <asp:RegularExpressionValidator CssClass="validator-error" ValidationGroup="EventCreation" runat="server" ControlToValidate="RegularPrice" ValidationExpression="^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$" Text="Must be a valid currency amount." Display="Dynamic"></asp:RegularExpressionValidator>
            <asp:TextBox ID="RegularPrice" runat="server" placeholder="XX.XX"></asp:TextBox>

            <h3>Prime Seating Price:</h3>
            <asp:RequiredFieldValidator CssClass="validator-error" ValidationGroup="EventCreation" runat="server" ControlToValidate="PrimePrice" Text="Required Field." Display="Dynamic" />
            <asp:RegularExpressionValidator CssClass="validator-error" ValidationGroup="EventCreation" ControlToValidate="PrimePrice" ValidationExpression="^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$" runat="server" Text="Must be a valid currency amount." Display="Dynamic"></asp:RegularExpressionValidator>
            <asp:TextBox ID="PrimePrice" runat="server" placeholder="XX.XX"></asp:TextBox>
        </div>

        <asp:Button ID="Submit" runat="server" Text="Submit"
            UseSubmitBehavior="false"
            ValidationGroup="EventCreation"
            OnClientClick="submitEvent()"
            OnClick="Submit_Click" />

        <%-- Add Season Modal --%>
        <div class="modal fade" id="addSeason" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Add A New Season</h4>
                    </div>
                    <div class="modal-body">
                        <p class="error">Could Not Add Season</p>
                        <label for="season-name">Name:</label>
                        <input type="text" id="season-name-input" />
                        <label for="season-price">Price:</label>
                        <input type="text" id="season-price-input" placeholder="XX.XX" />
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" onclick="addSeason(event)">Add Season</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsSection" runat="server">
    <%: Scripts.Render("~/bundles/event_creation") %>
</asp:Content>