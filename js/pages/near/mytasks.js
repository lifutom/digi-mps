/* Version 1.1:  2020-12-11 */
$(function () {

    var dtlist = $('#dtlist').DataTable({
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
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
       "order": [[ 1, "desc" ]]
    });
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        populateform(data);
        $('#edittask').modal('show');
    });


    $('#dtlist .deletelink').on('click', function () {

                var td = $(this).parent();
                var tr = td.parent();

                var data = dtlist.row( tr ).data();

                $('#decisionbtn').click({id: data[0]}, function (e) {
                    delete_item(e.data.id);
                });
                $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
                $('#decision').modal('show');
                return false;

            });

});


function delete_item(id) {

    var data = {
        id: id,
        item: 'task'
    }


        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
            data: data,
            success: function (data) {
                data = JSON.parse(data);
                if (data["status"] == "OK") {
                   window.location.reload();
                }
            },
            failure: function () {

            }
        });
}


function populateform(data) {

    $('#taskid').val(data[0]);
    $('#nearid').val(data[1]);
    $("#tasktypeid").val(data[2]);
    $('#state').val(data[3]);
    $('#tasknb').val(data[4]);
    $('#description').val(data[6]);
    $('#duedate').val(data[11]);
    $('#comments').val(data[14]);

}

function viewnearMiss(id) {
    PopupInTab('near/view/?partial=yes&id=' + id + '&idx=0');
}
