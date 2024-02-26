/* Version 1.0 2021-11-30*/
var lastSendTo;

$(function () {

    dtlist = $('#dtlist').DataTable({
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
       "bFilter" : true,
       "bEdit": true,
       "language": {
          "info": "Seite _PAGE_ von _PAGES_",
          "infoEmpty":      "Seite 0 von 0",
          "search": "Suchen:",
          "lengthMenu": "Zeige _MENU_ Eintr&auml;ge",
          "paginate": {
              first:    '<i class="fa fa-fast-backward"></i>',
              previous: '<i class="fa fa-backward"></i>',
              next:     '<i class="fa fa-forward"></i>',
              last:     '<i class="fa fa-fast-forward"></i>'
          },
       },
    });
    $('.dataTables_length').addClass('bs-select');

    $("#dtlist select").on("change", function(){
        $(this).css("background-color", "#FFCC99");
    });


    $('#dtlist tbody').on('click', '.btnsave', function () {
        var data = dtlist.row( $(this).parents('tr') ).data();
        saveTask(data);
    });
});



function saveTask(data) {


    var sendto_obj = $('#sendto_' + data[1] + '_' + data[3])
    var sendto = sendto_obj.val();

    var accessrightid=data[1];
    var pos=data[3];
    var lang = $('#CurLang').val();
    var data = {
        item: 'accessright-task',
        id: accessrightid,
        pos: pos,
        sendto: sendto,
        lang: lang
    }
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                sendto_obj.css("background-color", "");
                $('.successmsg').html(data["errmsg"]);
                $('#success').modal('show');
            } else {
                $('.warningmsg').html(data["errmsg"]);
                $('#warning').modal('show');
            }
        },
        failure: function () {

        }
    });
}
