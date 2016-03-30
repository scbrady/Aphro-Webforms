var groupSize;
$(function () {
    groupSize = parseInt($("#MainContent_GroupSize").val(), 10);

    $("li .pending-status").each(function () {
        resolvePendingRequest(this);
    });

    $("#group-request").autocomplete({
        source: "../Shared/Search.ashx",
        minLength: 1,
        focus: function (event, ui) {
            $("#group-request").val(ui.item.firstname + " " + ui.item.lastname);
            $("#group-request-id").val(ui.item.xid);
            return false;
        },
        select: function (event, ui) {
            $("#group-request").val(ui.item.firstname + " " + ui.item.lastname);
            $("#group-request-id").val(ui.item.xid);
            return false;
        }
    })
    .autocomplete("instance")._renderItem = function (ul, item) {
        return $("<li>")
          .append(item.firstname + " " + item.lastname + "<br>" + item.xid)
          .appendTo(ul);
    };
});

function validateSize(oSrc, args) {
    args.IsValid = parseInt((args.Value), 10) + groupSize <= 10;
}

function addToGroup(e) {
    e.preventDefault();

    $('#student-request-error').hide();
    if (groupSize >= 10) {
        $('#student-group-error').show();
        return;
    } else
        $('#student-group-error').hide();

    var requestedId = $('#group-request-id').val();
    var requestedName = $('#group-request').val();

    // Clear the fields
    $('#group-request-id').val('');
    $('#group-request').val('');

    $.post("../Shared/AddToGroup.ashx", { personId: requestedId, seriesId: $('#MainContent_SeriesIdField').val() })
        .done(function (data) {
            $('#student-placeholder').remove();
            groupSize += 1;
            $('#MainContent_TicketQuantityRangeValidator').maximumvalue = groupSize > 10 ? 0 : 10 - groupSize;
            $("#MainContent_GroupSize").val(groupSize);

            var newRequest = $("<li />").addClass("clearfix request-list").append("\
                        <p class='group-member'>" + requestedName + "</p>\
                        <p class='group-status pending-status' data-user-id='" + data.requested_id + "' data-group-id='" + data.group_id + "'></p>");

            $('#MainContent_GroupRequestContainer').append(newRequest);
            resolvePendingRequest(newRequest.children('.pending-status'));
            $('#student-request-error').hide();
        })
        .fail(function () {
            $('#student-request-error').show();
        });
}

function resolvePendingRequest(request) {
    var requestedId = $(request).data("user-id");
    var requestedGroup = $(request).data("group-id");

    setTimeout(function () {
        $.post("../Shared/PendingAcceptReject.ashx", { personId: requestedId, groupId: requestedGroup })
        .done(function (data) {
            if (data === "True") {
                $(request).removeClass("pending-status");
                $(request).addClass("accepted-status");
            } else {
                groupSize -= 1;
                $('#MainContent_TicketQuantityRangeValidator').maximumvalue = groupSize > 10 ? 0 : 10 - groupSize;
                $("#MainContent_GroupSize").val(groupSize);
                $(request).removeClass("pending-status");
                $(request).addClass("rejected-status");
            }
        })
        .fail(function () {
            // Don't worry about it, they will just stay pending
        });
    }, 5000);
}