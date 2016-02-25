<%@ Page Title="Create Event" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Aphro_WebForms.Event.Index" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%--Event Type--%>
    <h1>Create Event</h1>
    <div class="eventCreation">
        <h3>Event Type:</h3>
        <asp:DropDownList ID="EventType" runat="server">
        </asp:DropDownList>
        <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="EventType" Text="Required Field" Display="Dynamic"/>
    </div>

    <%--Event Name--%>
    <div class='name'>
        <h3>Event Name:</h3>
        <asp:TextBox ID="EventName" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="EventName" Text="Required Field." Display="Dynamic"/>
        <asp:RegularExpressionValidator ControlToValidate="EventName" ValidationGroup="EventCreation" ValidationExpression ="^[\s\S]{1,20}$" runat="server" Text="Minimum of 1 character and Maximum of 20 characters." Display="Dynamic"></asp:RegularExpressionValidator>
    </div>

    <%--Description--%>
    <div class='description'>
        <h3>Description:</h3>
        <asp:TextBox ID="Description" TextMode="multiline" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="Description" Text="Required Field." Display="Dynamic"/>
        <asp:RegularExpressionValidator ControlToValidate="Description" ValidationGroup="EventCreation" ValidationExpression ="^[\s\S]{1,200}$" runat="server" Text="Minimum of 1 character and Maximum of 200 characters." Display="Dynamic"></asp:RegularExpressionValidator>
    </div>

    <%--Image Upload--%>
    <div class='image'>
        <h3>Image:</h3>
        <asp:FileUpload ID="imageUpload" runat="server" />
        <hr />
    </div>

    <%--Location--%>
    <div class='eventCreation'>
        <h3>Location: </h3>
        <asp:DropDownList ID="LocationDropDown" runat="server">
        </asp:DropDownList>
        <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="LocationDropDown" Text="Required Field" Display="Dynamic"/>
    </div>

    <%-- Event Date(s)--%>
    <div id="EventDates" class='Event-Dates' style="position: relative">
        <h3>Event Date(s):</h3>
        <asp:TextBox ID="EventDate" runat="server" CssClass="datepicker-field"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="EventDate" Text="Required Field." Display="Dynamic"/>
    </div>

    <asp:Button ID="Button1" runat="server" OnClientClick="javascript:AddDate(); return false;" Text="Add Date" />
    <div id="DeleteDate" class='Event-Dates' style="position: relative"></div>
    <asp:HiddenField ID="HiddenField1" runat="server" />

    <%-- Seating Prices (both regular and prime) --%>
    <div class='Seat-Price'>
        <h3>Regular Seating Price:</h3>
        <asp:TextBox ID="RegularPrice" runat="server" placeholder="XX.XX"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="RegularPrice" Text="Required Field." Display="Dynamic"/>
        <asp:RegularExpressionValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="RegularPrice" ValidationExpression ="^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$" Text="Must be a valid currency amount." Display="Dynamic"></asp:RegularExpressionValidator>
        <h3>Prime Seating Price:</h3>

        <asp:TextBox ID="PrimePrice" runat="server" placeholder="XX.XX"></asp:TextBox>
        <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="PrimePrice" Text="Required Field." Display="Dynamic"/>
        <asp:RegularExpressionValidator ValidationGroup="EventCreation" ControlToValidate="PrimePrice"  ValidationExpression ="^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$" runat="server" Text="Must be a valid currency amount." Display="Dynamic"></asp:RegularExpressionValidator>
    </div>

    <asp:Button ID="Button2" runat="server" Text="Submit" OnClientClick="javascript:AppendDates(); return false;"/>
    <div style="display: none;">
        <asp:Button ID="Button3" ValidationGroup="EventCreation" runat="server" Text="Submit" OnClick="Submit_Click"/>
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
            var element   = document.createElement("input");
            var newButton = document.createElement("button");

            //Assign different attributes to the element.
            element.setAttribute("type", "text");
            element.setAttribute("runat", "server");
            element.setAttribute("class", "datepicker-field");
            element.setAttribute("id", "date" + dateCount);

            newButton.setAttribute("value", "Delete");
            newButton.setAttribute("Class", "deleteButton");
            newButton.setAttribute("id", "delete" + dateCount);
            newButton.setAttribute("onclick", "DeleteDate(" + dateCount + "); return false;");
            newButton.innerHTML="x";

            // div id, where new fields are to be added
            var ExtraDates = document.getElementById("EventDates");

            //Append the element in page.
            ExtraDates.appendChild(element);
            ExtraDates.appendChild(newButton);

            $('.datepicker-field').datetimepicker({
                format: 'DD-MMM-YY hh:mm A'
            })

            dateCount += 1;
        }

        function AppendDates() {
            var test = $("#MainContent_EventDate").val();

            for (var x = 0; x < dateCount; x++) {
                if ($("#date" + x).length > 0 && $("#date" + x).val() != "")
                    test = test + "," + $("#date" + x).val();
            }

            $("#MainContent_HiddenField1").val(test);

            var button = document.getElementById("MainContent_Button3");
            button.click();
        }

        function DeleteDate(date)
        {
            $('#date' + date).remove();
            $('#delete' + date).remove();
        }
    </script>
</asp:Content>