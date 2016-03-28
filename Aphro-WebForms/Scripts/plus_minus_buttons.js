﻿$('.add-qty').click(function (e) {
    // Stops the button from being a button
    e.preventDefault();

    // Set the needed variables
    field_name = $(this).attr('field');
    var max_val = 10;
    var group_size = 0;
    if (!isNaN(group_size = parseInt($("#MainContent_GroupSize").text(), 10)) ||
        !isNaN(group_size = parseInt($("#MainContent_GroupSize").val(),  10)))
        max_val = 10 - group_size;
    var current_val = parseInt($('#' + field_name).val());

    // Fixes for Employee Portal
    if ($("#MainContent_FacultyTicketsSize").length)
    {
        if (field_name === "MainContent_GuestTicketsSize")
        {
            var faculty_ticket_size;
            if (!isNaN(faculty_ticket_size = parseInt($("#MainContent_FacultyTicketsSize").val(), 10)))
                max_val = 10 - group_size - faculty_ticket_size;
        }
        else if (field_name === "MainContent_FacultyTicketsSize") {
            var guest_ticket_size;
            if (!isNaN(guest_ticket_size = parseInt($("#MainContent_GuestTicketsSize").val(), 10)))
                max_val = 10 - group_size - guest_ticket_size;
        }
    }

    // Make sure counter can't go higher than max_val
    if (!isNaN(current_val) && current_val < max_val) {
        $('#' + field_name).val(current_val + 1);
    } else if (current_val == max_val) {
        $('#' + field_name).val(max_val);
    } else {
        // Just in case something goes wrong, you get 0. Sorry bud
        $('#' + field_name).val(0);
    }
});
$(".sub-qty").click(function (e) {
    // Stops the button from being a button
    e.preventDefault();

    // Set the needed variables
    field_name = $(this).attr('field');
    var min_val = 0;
    if (!$("#MainContent_GroupSize").length)
        min_val = 1;
    var current_val = parseInt($('#' + field_name).val());

    // Make sure counter can't go lower than min_val
    if (!isNaN(current_val) && current_val > min_val) {
        $('#' + field_name).val(current_val - 1);
    } else {
        $('#' + field_name).val(min_val);
    }
});