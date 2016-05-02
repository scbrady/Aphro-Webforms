var groupSize;
$(function () {
    groupSize = parseInt($("#MainContent_GroupSize").val(), 10);

    $("li .pending-status").each(function () {
        resolvePendingRequest(this);
    });

    $("#MainContent_GroupRequestContainer").on("click", "li .accepted-status", function (event) {
        event.preventDefault();
        removeRequest(this);
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

function addToGroup(e) {
    e.preventDefault();

    // Hide all errors
    $('#student-request-error').hide();
    $('#student-error').hide();
    $('#student-group-error').hide();

    // Check if the group is too big
    if (groupSize >= 10) {
        $('#student-group-error').show();
        return;
    }
    
    var requestedId = $('#group-request-id').val();
    var requestedName = $('#group-request').val();

    // Check if a name was clicked on from the dropdown
    if (!requestedId) {
        $('#student-error').show();
        return;
    }

    // Clear the fields
    $('#group-request-id').val('');
    $('#group-request').val('');

    $.post("../Shared/AddToGroup.ashx", { personId: requestedId, seriesId: $('#MainContent_SeriesIdField').val() })
        .done(function (data) {
            $('#student-placeholder').remove();
            groupSize += 1;
            $("#MainContent_GroupSize").val(groupSize);

            var newRequest = $("<li />").addClass("clearfix request-list").append("\
                        <p class='group-member'>" + data.requested_firstname + " " + data.requested_lastname + "</p>\
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
                // The person accepted
                $(request).removeClass("pending-status");
                $(request).addClass("accepted-status");
            } else {
                // The person rejected
                groupSize -= 1;
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

function removeRequest(request) {
    var requestedId = $(request).data("user-id");
    var requestedGroup = $(request).data("group-id");

    $(request).removeClass("accepted-status");
    $(request).addClass("pending-delete");

    setTimeout(function () {
        $.post("../Shared/RemoveFromGroup.ashx", { personId: requestedId, groupId: requestedGroup })
        .done(function (data) {
            $(request).closest('li').remove();

            // Check if there are any more requests, if not, put placeholder text in
            if ($('#MainContent_GroupRequestContainer').children().length <= 0) {
                $('#MainContent_GroupRequestContainer').append("<p id='student-placeholder'>Start Adding Students To Your Group</p>");
            }

            groupSize -= 1;
            $("#MainContent_GroupSize").val(groupSize);
        })
        .fail(function () {
            $(request).removeClass("pending-delete");
            $(request).addClass("accepted-status");
        });
    }, 5000);
}