$(function () {
    var min_val = 0;
    if (!$("#MainContent_GroupSize").length)
        min_val = 1;

    var max_tickets = 10;
    var at_max = false;
    disableEnableButtons();

    $('.add-qty').click(function (e) {
        // Stops the button from being a button
        e.preventDefault();

        // Set the needed variables
        var field_name = $(this).attr('field');
        var current_val = tryParseInt($('#' + field_name).val());
        didHitMax();

        // Make sure counter can't go higher than the max tickets allowed
        if (!at_max) {
            $('#' + field_name).val(current_val + 1);
        } else {
            $('#' + field_name).val(current_val);
        }

        // Disable or Enable buttons based on the new value
        disableEnableButtons();
    });

    $(".sub-qty").click(function (e) {
        // Stops the button from being a button
        e.preventDefault();

        // Set the needed variables
        var field_name = $(this).attr('field');
        var current_val = tryParseInt($('#' + field_name).val());

        // Make sure counter can't go lower than min_val
        if (current_val > min_val) {
            $('#' + field_name).val(current_val - 1);
        } else {
            $('#' + field_name).val(min_val);
        }

        // Disable or Enable buttons based on the new value
        disableEnableButtons();
    });

    function didHitMax() {
        var group_size;
        var extra_tickets = 0;

        if ((group_size = tryParseInt($("#MainContent_GroupSize").text())) == 0)
            group_size = tryParseInt($("#MainContent_GroupSize").val(), 10);

        $('.add-qty').each(function () {
            var field_name = $(this).attr('field');
            var current_val = tryParseInt($('#' + field_name).val());
            extra_tickets += current_val;
        });

        at_max = group_size + extra_tickets >= max_tickets;
    }

    function disableEnableButtons() {
        // Disable all add buttons if at the max number of tickets allowed
        // Else enable all of them
        didHitMax();
        if (at_max)
            $('.add-qty').prop("disabled", true);
        else
            $('.add-qty').prop("disabled", false);

        // Loop through all the subtract buttons
        $('.sub-qty').each(function () {
            var field_name = $(this).attr('field');
            var current_val = parseInt($('#' + field_name).val());

            // If input is equal to the min, disable button
            // Else enable it
            if (current_val <= min_val)
                $(this).prop("disabled", true);
            else
                $(this).prop("disabled", false);
        });
    }
});

function tryParseInt(number) {
    var parsed;
    parsed = parseFloat(number);
    if (!isNaN(parsed))
        return parsed;
    else
        return 0;
}