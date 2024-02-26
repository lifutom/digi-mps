/* Version 1.3 2022-04-23*/
/* Version 1.2 2022-04-13*/
/* Version 1.1 2021-09-14*/
/* Version 1.0 2021-08-10*/

$(function () {

    var dtlist = $('#dtlist').DataTable({
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
       "bFilter" : true,
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
       "order": [[ 13, "desc" ]]
    });
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        populateform(data);
        $('#editForm').modal('show');
    });

    $('#dtlist tbody').on('click', '.btnview', function () {
        var data = dtlist.row( $(this).parents('tr') ).data();
        populateform(data);
        $('#editForm').modal('show');
    });

    $('#refresh').click(function() {
        window.location.reload();
    });

    $('#export').click(function() {
        getListXLSX('worklist-history-xls');
    });

    $('#printreport').click(function() {
        getListPDF('worklist-closed-pdf');
    });

    $('#dtlist tbody').on('click', '.btnwfstate', function () {
        var data = dtlist.row($(this).parents('tr')).data();
        PopupCenter('profile/workflowstate?id=' + data[2] + '&taskid=' + data[1]  + '&aid=' + data[4] + '&arid=' + data[5] + '&partial=yes', 'Workflowstate_' + data[9] , 900, 700);
    });
});


function emptyform() {
    $('#id').val('-1');
    $('#reqnb').val('');
    $('#reqtype').html('');
    $('#displayname').val('');
    $('#accesstype').val('');
    $('#accessitem').val('');
    $('#accessright').val('');
    $('#description').val('');
    $('#comment').val('');
    $('#tasknb').val('');
    $('#elognb').val('');
    $('#isgxp').prop("checked", false);
}

function populateform(data) {
    $('#id').val(data[1]);
    $('#reqtype').html(data[22] + ':' + data[23]); 
    $('#reqnb').val(data[9]);
    $('#tasknb').val(data[11]);
    $('#displayname').val(data[14]);
    $('#accesstype').val(data[17]);
    $('#accessitem').val(data[18]);
    $('#accessright').val(data[19]);
    $('#description').val(data[20]);
    $('#comment').val(data[21]);
    $('#elognb').val(data[25]);
    if (data[26] == 1) {
       $('#isgxp').prop("checked", true);
    } else {
       $('#isgxp').prop("checked", false);
    }
}








