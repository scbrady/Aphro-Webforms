<%@ Page Title="Create Event" Language="C#" MasterPageFile="~/EventPortal.Master" AutoEventWireup="true" CodeBehind="AddEvent.aspx.cs" Inherits="Aphro_WebForms.Event.AddEvent" EnableEventValidation="false" %>
<%@ Import Namespace="System.Web.Optimization" %>

<asp:Content ID="Content" ContentPlaceHolderID="HeaderSection" runat="server">
    <%: Styles.Render("~/Content/datepicker") %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%--Event Type--%>
    <h1>Create Event</h1>
    
    <div class="content-wrapper">
        <h3>Event Type:</h3>
        <asp:DropDownList ID="EventType" runat="server">
        </asp:DropDownList>
        <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="EventType" Text="Required Field" Display="Dynamic"/>

        <%--Event Name--%>
        <div class='name'>
            <h3>Event Name:</h3>
            <asp:TextBox ID="EventNameInput" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="EventNameInput" Text="Required Field." Display="Dynamic"/>
            <asp:RegularExpressionValidator ControlToValidate="EventNameInput" ValidationGroup="EventCreation" ValidationExpression ="^[\s\S]{1,20}$" runat="server" Text="Minimum of 1 character and Maximum of 20 characters." Display="Dynamic"></asp:RegularExpressionValidator>
        </div>

        <%--Description--%>
        <div class='description'>
            <h3>Description:</h3>
            <asp:TextBox ID="DescriptionInput" TextMode="multiline" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="DescriptionInput" Text="Required Field." Display="Dynamic"/>
            <asp:RegularExpressionValidator ControlToValidate="DescriptionInput" ValidationGroup="EventCreation" ValidationExpression ="^[\s\S]{1,800}$" runat="server" Text="Minimum of 1 character and Maximum of 800 characters." Display="Dynamic"></asp:RegularExpressionValidator>
        </div>

        <%--Image Upload--%>
        <div class="image_upload">
            <img src="../Content/defaultphoto_2x.png" id="imagePreview"  />
            <div class="fileUpload btn btn-primary">
                <span>Upload</span>
                <asp:FileUpload runat="server"  ID="uploadBtn"  CSSClass="upload"/> 
            </div>
        </div>

        <%--Location--%>
        <div class='eventCreation'>
            <h3>Location: </h3>
            <asp:DropDownList ID="LocationDropDown" runat="server">
            </asp:DropDownList>
            <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="LocationDropDown" Text="Required Field" Display="Dynamic"/>
        </div>

        <%--Season--%>
        <div class='eventCreation'>
            <h3>Season: </h3>
            <asp:DropDownList ID="SeasonDropDown" runat="server">
            </asp:DropDownList>
        </div>

        <%-- Event Date(s)--%>
        <div id="EventDates" class='Event-Dates' style="position: relative">
            <h3>Event Date(s):</h3>
            <div class="row">
                <asp:DropDownList CssClass="col-sm-4 month" runat="server">
                    <asp:ListItem Text="January" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="February"></asp:ListItem>
                    <asp:ListItem Text="March"></asp:ListItem>
                    <asp:ListItem Text="April"></asp:ListItem>
                    <asp:ListItem Text="May"></asp:ListItem>
                    <asp:ListItem Text="June"></asp:ListItem>
                    <asp:ListItem Text="July"></asp:ListItem>
                    <asp:ListItem Text="August"></asp:ListItem>
                    <asp:ListItem Text="September"></asp:ListItem>
                    <asp:ListItem Text="October"></asp:ListItem>
                    <asp:ListItem Text="November"></asp:ListItem>
                    <asp:ListItem Text="December"></asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList CssClass="col-sm-4 day" runat="server">
                    <asp:ListItem Text="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="2"></asp:ListItem>
                    <asp:ListItem Text="3"></asp:ListItem>
                    <asp:ListItem Text="4"></asp:ListItem>
                    <asp:ListItem Text="5"></asp:ListItem>
                    <asp:ListItem Text="6"></asp:ListItem>
                    <asp:ListItem Text="7"></asp:ListItem>
                    <asp:ListItem Text="8"></asp:ListItem>
                    <asp:ListItem Text="9"></asp:ListItem>
                    <asp:ListItem Text="10"></asp:ListItem>
                    <asp:ListItem Text="11"></asp:ListItem>
                    <asp:ListItem Text="12"></asp:ListItem>
                    <asp:ListItem Text="13"></asp:ListItem>
                    <asp:ListItem Text="14"></asp:ListItem>
                    <asp:ListItem Text="15"></asp:ListItem>
                    <asp:ListItem Text="16"></asp:ListItem>
                    <asp:ListItem Text="17"></asp:ListItem>
                    <asp:ListItem Text="18"></asp:ListItem>
                    <asp:ListItem Text="19"></asp:ListItem>
                    <asp:ListItem Text="20"></asp:ListItem>
                    <asp:ListItem Text="21"></asp:ListItem>
                    <asp:ListItem Text="22"></asp:ListItem>
                    <asp:ListItem Text="23"></asp:ListItem>
                    <asp:ListItem Text="24"></asp:ListItem>
                    <asp:ListItem Text="25"></asp:ListItem>
                    <asp:ListItem Text="26"></asp:ListItem>
                    <asp:ListItem Text="27"></asp:ListItem>
                    <asp:ListItem Text="28"></asp:ListItem>
                    <asp:ListItem Text="29"></asp:ListItem>
                    <asp:ListItem Text="30"></asp:ListItem>
                    <asp:ListItem Text="31"></asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList CssClass="col-sm-4 year" runat="server">
                    <asp:ListItem Text="2016" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="2017"></asp:ListItem>
                    <asp:ListItem Text="2018"></asp:ListItem>
                    <asp:ListItem Text="2019"></asp:ListItem>
                    <asp:ListItem Text="2020"></asp:ListItem>
                    <asp:ListItem Text="2021"></asp:ListItem>
                    <asp:ListItem Text="2022"></asp:ListItem>
                    <asp:ListItem Text="2023"></asp:ListItem>
                    <asp:ListItem Text="2024"></asp:ListItem>
                    <asp:ListItem Text="2025"></asp:ListItem>
                    <asp:ListItem Text="2026"></asp:ListItem>
                    <asp:ListItem Text="2027"></asp:ListItem>
                    <asp:ListItem Text="2028"></asp:ListItem>
                    <asp:ListItem Text="2029"></asp:ListItem>
                    <asp:ListItem Text="2030"></asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList CssClass="col-sm-4 hour" runat="server">
                    <asp:ListItem Text="1"></asp:ListItem>
                    <asp:ListItem Text="2"></asp:ListItem>
                    <asp:ListItem Text="3"></asp:ListItem>
                    <asp:ListItem Text="4"></asp:ListItem>
                    <asp:ListItem Text="5"></asp:ListItem>
                    <asp:ListItem Text="6"></asp:ListItem>
                    <asp:ListItem Text="7"></asp:ListItem>
                    <asp:ListItem Text="8"></asp:ListItem>
                    <asp:ListItem Text="9"></asp:ListItem>
                    <asp:ListItem Text="10"></asp:ListItem>
                    <asp:ListItem Text="11"></asp:ListItem>
                    <asp:ListItem Text="12" Selected="True"></asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList CssClass="col-sm-4 minute" runat="server">
                    <asp:ListItem Text="00" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="30"></asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList CssClass="col-sm-4 amPm" runat="server">
                    <asp:ListItem Text="am"></asp:ListItem>
                    <asp:ListItem Text="pm" Selected="True"></asp:ListItem>
                </asp:DropDownList>
        <button onclick="AddDate(event)">Add Date</button>
            <asp:TextBox ID="EventDate" runat="server" style="visibility:hidden" CssClass="datepicker-field"></asp:TextBox>
            <asp:RequiredFieldValidator ValidationGroup="EventCreation" runat="server" ControlToValidate="EventDate" Text="Required Field." Display="Dynamic"/>
        </div>
            </div>
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

        <asp:Button ID="Button2" runat="server" Text="Submit" OnClientClick="javascript:AppendDates(); this.disabled = true; return false;"/>
        <div style="display: none;">
            <asp:Button ID="Button3" ValidationGroup="EventCreation" runat="server" Text="Submit" OnClick="Submit_Click"/>
        </div>

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
    <%: Scripts.Render("~/bundles/datepicker") %>
    <script>
        $(function () {
            addCalendar($('#MainContent_EventDate').get(0));

            function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $('#imagePreview').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }

            $("#MainContent_uploadBtn").change(function () {
                readURL(this);
            });

            $("#MainContent_SeasonDropDown").change(function () {
                var pickedValue = this[this.selectedIndex].textContent;
                if (pickedValue === 'Add New Season')
                {
                    $('#addSeason').modal('show');
                }
            });
        });

        dateCount = 0;

        function AddDate(e) {
            e.preventDefault();
            //Create an input type dynamically.
            var element   = document.createElement("input");
            var newButton = document.createElement("button");

            //Assign different attributes to the element.
            var newElementId = "date" + dateCount;
            element.setAttribute("type", "text");
            element.setAttribute("runat", "server");
            element.setAttribute("class", "datepicker-field eventDate");
            element.setAttribute("id", "date" + dateCount);

            newButton.setAttribute("Class", "deleteDate");
            newButton.setAttribute("id", "delete" + dateCount);
            newButton.setAttribute("onclick", "DeleteDate(event," + dateCount + ")");
            newButton.innerHTML="x";

            // div id, where new fields are to be added
            var ExtraDates = document.getElementById("EventDates");

            //Append the element in page.
            ExtraDates.appendChild(element);
            ExtraDates.appendChild(newButton);

            addCalendar($('#' + newElementId).get(0));

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

        function DeleteDate(e, date)
        {
            e.preventDefault();
            $('#date' + date).remove();
            $('#delete' + date).remove();
        }

        function addCalendar(element) {
            rome(element, {
                "inputFormat": "DD-MMM-YY hh:mm A",
                "timeFormat": "hh:mm a",
                "timeInterval": 900,
                "styles": {
                    "back": "rd-back calendar-button-fix",
                    "next": "rd-next calendar-button-fix",
                    "selectedTime": "rd-time-selected time-selected",
                }
            });
        }

        function addSeason(e) {
            e.preventDefault();
            var seasonName = $('#season-name-input').val()
            $.post("InsertSeason.ashx", { seasonName: seasonName })
                .done(function (data) {
                    $('#addSeason').modal('hide');
                    $('.error').hide();

                    $('#MainContent_SeasonDropDown').append('<option value="' + data + '">' + seasonName + '</option>');
                    $("#MainContent_SeasonDropDown option[value='" + data + "']").prop('selected', true);
                })
                .fail(function () {
                    $('.error').show();
                });
        }
    </script>
</asp:Content>