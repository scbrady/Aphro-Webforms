$('.sub-qty').css("opacity", ".5");
$('.subfaculty').css("opacity", ".5");

$('.add-qty').click(function (e) {
    // Stops the button from being a button
    e.preventDefault();
    $('.sub-qty').css("opacity", "1");
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
        $(".add-qty").removeClass("disabled");
        $("input.disabled").css("opacity", "1");
        $(".sub-qty").removeClass("disabled");
        $("input.disabled").css("opacity", "1");
        if (current_val == (max_val - 1))
        {
            $(".add-qty").addClass("disabled");
            $("input.disabled").css("opacity", ".5");
            $(".addfaculty").addClass("disabled");
            $("input.disabled").css("opacity", ".5");
        }
        $('#' + field_name).val(current_val + 1);
    } else if (current_val == max_val) {
        $(".add-qty").addClass("disabled");
        $("input.disabled").css("opacity", ".5");
        $('#' + field_name).val(max_val);
    } else {
        // Just in case something goes wrong, you get 0. Sorry bud
        $('#' + field_name).val(0);
    }
});

$(".sub-qty").click(function (e) {
    // Stops the button from being a button
    e.preventDefault();
    $('.add-qty').css("opacity", "1");

    // Set the needed variables
    field_name = $(this).attr('field');
    var min_val = 0;
    if (!$("#MainContent_GroupSize").length)
        min_val = 1;
    var current_val = parseInt($('#' + field_name).val());

    // Make sure counter can't go lower than min_val
    if (!isNaN(current_val) && current_val > min_val) {
        $(".sub-qty").removeClass("disabled");
        $("input.disabled").css("opacity", "1");
        $(".add-qty").removeClass("disabled");
        $("input.disabled").css("opacity", "1");
        if (current_val == (min_val + 1))
        {
            $(".sub-qty").addClass("disabled");
            $("input.disabled").css("opacity", ".5");
        }
        $('#' + field_name).val(current_val - 1);
    } else {
        $(".sub-qty").addClass("disabled");
        $("input.disabled").css("opacity", ".5");
        $('#' + field_name).val(min_val);
    }
});

$('.addfaculty').click(function (e) {
    // Stops the button from being a button
    e.preventDefault();
    $('.subfaculty').css("opacity", "1");
    // Set the needed variables
    field_name = $(this).attr('field');
    var max_val = 10;
    var group_size = 0;
    if (!isNaN(group_size = parseInt($("#MainContent_GroupSize").text(), 10)) ||
        !isNaN(group_size = parseInt($("#MainContent_GroupSize").val(), 10)))
        max_val = 10 - group_size;
    var current_val = parseInt($('#' + field_name).val());

    // Fixes for Employee Portal
    if ($("#MainContent_FacultyTicketsSize").length) {
        if (field_name === "MainContent_GuestTicketsSize") {
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
        $(".addfaculty").removeClass("disabled");
        $("input.disabled").css("opacity", "1");
        $(".subfaculty").removeClass("disabled");
        $("input.disabled").css("opacity", "1");
        if (current_val == (max_val - 1)) {
            $(".addfaculty").addClass("disabled");
            $("input.disabled").css("opacity", ".5");
            $(".add-qty").addClass("disabled");
            $("input.disabled").css("opacity", ".5");
        }
        $('#' + field_name).val(current_val + 1);
    } else if (current_val == max_val) {
        $(".addfaculty").addClass("disabled");
        $("input.disabled").css("opacity", ".5");
        $('#' + field_name).val(max_val);
    } else {
        // Just in case something goes wrong, you get 0. Sorry bud
        $('#' + field_name).val(0);
    }
});
$(".subfaculty").click(function (e) {
    // Stops the button from being a button
    e.preventDefault();
    $('.addfaculty').css("opacity", "1");

    // Set the needed variables
    field_name = $(this).attr('field');
    var min_val = 0;
    if (!$("#MainContent_GroupSize").length)
        min_val = 1;
    var current_val = parseInt($('#' + field_name).val());

    // Make sure counter can't go lower than min_val
    if (!isNaN(current_val) && current_val > min_val) {
        $(".subfaculty").removeClass("disabled");
        $("input.disabled").css("opacity", "1");
        $(".addfaculty").removeClass("disabled");
        $("input.disabled").css("opacity", "1");
        if (current_val == (min_val + 1)) {
            $(".subfaculty").addClass("disabled");
            $("input.disabled").css("opacity", ".5");
        }
        $('#' + field_name).val(current_val - 1);
    } else {
        $(".subfaculty").addClass("disabled");
        $("input.disabled").css("opacity", ".5");
        $('#' + field_name).val(min_val);
    }
});