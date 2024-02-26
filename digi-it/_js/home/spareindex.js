/* version 1.2 */
/* 2020-12-03: Version 1.3 */

$(function () {
    var img = $('.file-upload').file_upload({
        messages: {
            remove: "Löschen",
        }
    });
    img.on('file_upload.afterClear', function(event, element) {
        var data = {
            item : 'delimg_nm',
            id : $('#CurLogin').val(),
            filetyp : 'near'
        }
        $.ajax({
                     url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
                     type: 'POST',
                     data: data
        });
    });

    /*$('#cmdlogout').click(function() {
        window.location.href='/diginm/home/logout';
    });*/
});


function changeActivePlant(id) {

    $('#activeline').val(id);
    $('#formLine').submit();

}

function changeActiveDevice(id) {

    $('#activedevice').val(id);
    $('#formDevice').submit();

}

function listspare(id) {

    $('#catid').val(id);
    $('#form').submit();

}

function liststrspare() {

    if ($('#searchtext').val() == '') return;

    $('#searchstr').val($('#searchtext').val());
    $('#form').submit();

}






