/* Version 1.0:  2020-11-23 */

$(function () {

    $('#send').click(function() {
        sendmail();
    });
    $("#body").mdbWYSIWYG({

    });

});


function sendmail() {
    //this is <a> click event:
    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }


    $('#send').html('<span class="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>Senden...').addClass('disabled');
    $('#close').addClass('disabled');
    var sendcopy = $("#sendcopy").is(':checked') ? 1 : 0

    var data = {
        typ: 'quote',
        id: $('#id').val(),
        toname: $('#toname').val(),
        email: $('#email').val(),
        ccemail: sendcopy == 1 ? $('#ccemail').val() : '',
        cctoname: sendcopy == 1 ? $('#cctoname').val() : '',
        subject: $('#subject').val(),
        body: $('#body').val()
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/mail.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data['errnb'] == 0) {

                $('.info-info').html('E-Mail wurder versendet.')
                $('#info-ok').click(function() {
                    window.close();
                });
                $('#info').modal('show');

            } else {

                $('.danger-info').html('E-Mail konnte nicht versendet werden!\n\n' + data['errmsg']);
                $('#danger-ok').click(function() {
                    $('#close').removeClass('disabled');
                    $('#send').html('Senden').removeClass('disabled');
                });
                $('#danger').modal('show');


            }
        },
        failure: function () {
        }
    });
}