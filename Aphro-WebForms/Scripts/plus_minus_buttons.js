$('.add-qty').click(function (e) {
    // Stops the button from being a button
    e.preventDefault();

    // Set the needed variables
    field_name = $(this).attr('field');
    var max_val = 10;
    var group_size;
    if ((group_size = parseInt($("#MainContent_GroupSize").val(), 10)) != null)
        max_val = 10 - group_size;
    var current_val = parseInt($('#' + field_name).val());

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
    var current_val = parseInt($('#' + field_name).val());

    // Make sure counter can't go lower than min_val
    if (!isNaN(current_val) && current_val > min_val) {
        $('#' + field_name).val(current_val - 1);
    } else {
        $('#' + field_name).val(min_val);
    }
});