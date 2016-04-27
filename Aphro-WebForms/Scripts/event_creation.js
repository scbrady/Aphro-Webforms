dateCount = 0;

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
        if (pickedValue === 'Add New Season') {
            $('#addSeason').modal('show');
        }
    });
});

function submitEvent() {
    if (Page_ClientValidate('EventCreation')) {
        $('#MainContent_Submit').prop("disabled", true);
        AppendDates();
    }
}

function AddDate(e) {
    e.preventDefault();
    //Create an input type dynamically.
    var element = document.createElement("input");
    var newButton = document.createElement("button");

    //Assign different attributes to the element.
    var newElementId = "date" + dateCount;
    element.setAttribute("type", "text");
    element.setAttribute("class", "datepicker-field event-date");
    element.setAttribute("id", newElementId);

    newButton.setAttribute("class", "delete-date");
    newButton.setAttribute("id", "delete" + dateCount);
    newButton.setAttribute("onclick", "DeleteDate(event," + dateCount + ")");
    newButton.innerHTML = "x";

    // div id, where new fields are to be added
    var ExtraDates = document.getElementById("EventDates");

    //Append the element in page.
    ExtraDates.appendChild(element);
    ExtraDates.appendChild(newButton);

    addCalendar($('#' + newElementId).get(0));

    dateCount += 1;
}

function AppendDates() {
    var dates = $("#MainContent_EventDate").val();

    for (var i = 0; i < dateCount; i++) {
        if ($("#date" + i).length > 0 && $("#date" + i).val() != "")
            dates = dates + "," + $("#date" + i).val();
    }

    $("#MainContent_Dates").val(dates);
}

function DeleteDate(e, date) {
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
    var seasonName = $('#season-name-input').val();
    var seasonPrice = $('#season-price-input').val();
    $.post("InsertSeason.ashx", { seasonName: seasonName, seasonPrice: seasonPrice })
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