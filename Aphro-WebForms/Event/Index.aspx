<%@ Page Title="Create Event" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%--Event Type--%>
    <h1>Create Event</h1>
    <div class="dropdown">
        <h3>Event Type:</h3>
        <asp:DropDownList ID="EventType" runat="server">
        </asp:DropDownList>
    </div>

    <%--Event Name--%>
    <div class='name'>
        <h3>Event Name:</h3>
        <asp:TextBox ID="EventName" runat="server"></asp:TextBox>
    </div>

    <%--Description--%>
    <div class='description'>
        <h3>Description:</h3>
        <asp:TextBox ID="Description" TextMode="multiline" runat="server"></asp:TextBox>
    </div>

    <%--Image Upload--%>
    <div class='image'>
        <h3>Image:</h3>
        <asp:FileUpload ID="imageUpload" runat="server" />
        <asp:Button ID="uploadButton" runat="server" Text="Upload" OnClick="Upload" />
        <hr />
    </div>

    <%--Location--%>
    <div class='dropdown'>
        <h3>Location: </h3>
        <asp:DropDownList ID="LocationDropDown" runat="server">
        </asp:DropDownList>
    </div>

    <%-- Event Date(s)--%>
    <div id="EventDates" class='Event-Dates' style="position: relative">
        <h3>Event Date(s):</h3>
        <asp:TextBox ID="EventDate" runat="server" CssClass="datepicker-field"></asp:TextBox>
    </div>

    <asp:Button ID="Button1" runat="server" OnClientClick="javascript:AddDate(); return false;" Text="Add Date" />
    <asp:HiddenField ID="HiddenField1" runat="server" />

    <%-- Seating Prices (both regular and prime) --%>
    <div class='Seat-Price'>
        <h3>Regular Seating Price:</h3>
        <asp:TextBox ID="RegularPrice" runat="server"></asp:TextBox>
        <h3>Prime Seating Price:</h3>

        <asp:TextBox ID="PrimePrice" runat="server"></asp:TextBox>
    </div>

    <asp:Button ID="Button2" runat="server" Text="Submit" OnClientClick="javascript:AppendDates();" OnClick="Submit_Click" />
    <div style="display: none;">
        <asp:Button ID="Button3" runat="server" Text="Submit" OnClick="Submit_Click" />
    </div>

    <script>
        $(function () {
            $('.datepicker-field').datetimepicker({
                format: 'DD-MMM-YY hh:mm A'
            });
        });

        dateCount = 0;

        function AddDate() {
            //Create an input type dynamically.
            var element = document.createElement("input");

            //Assign different attributes to the element.
            element.setAttribute("type", "text");
            element.setAttribute("runat", "server");
            element.setAttribute("class", "datepicker-field");
            element.setAttribute("id", "date" + dateCount);

            // div id, where new fields are to be added
            var ExtraDates = document.getElementById("EventDates");

            //Append the element in page.
            ExtraDates.appendChild(element);

            $('.datepicker-field').datetimepicker({
                format: 'DD-MMM-YY hh:mm A'
            })

            dateCount += 1;
        }

        function AppendDates() {
            var test = $("#MainContent_EventDate").val();

            for (var x = 0; x < dateCount; x++) {
                test = test + "," + $("#date" + x).val();
            }

            $("#MainContent_HiddenField1").val(test);

            var button = document.getElementById("MainContent_Button3");
            button.click();
        }
    </script>
</asp:Content>