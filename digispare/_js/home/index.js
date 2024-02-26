/* Version 1.0 */
$(function () {

    $('#sparepart').click(function() {
        location.href = $('#CurRootFile').val() + '/home/spareindex';
    });

    $('#warehouse').click(function() {
        location.href = $('#CurRootFile').val() + '/spare';
    });


});