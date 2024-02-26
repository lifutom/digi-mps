$(function () {

    var dtfailurelist = $('#dtfailurelist').DataTable({
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
       }
    });
    myTable = dtfailurelist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtfailurelist tbody').on('dblclick', 'tr', function () {
        var data = dtfailurelist.row( this ).data();
        populateform(data);
        $('#editForm').modal('show');
    });

    $('#addbtn').click(function () {
        $('#editForm').on('show.bs.modal', function () {
            emptyform();
        });
        $('#editForm').modal('show');
    });

    $('#failure').change(function() {
        checkdoubles();
    });

});

function populateform(data) {




    $('#failureid').val(data[0]);
    $('#failure').val(data[2]);
    $('#defvalue').val(data[2]);
    $('#description').val(data[3]);
    $('#active').val(data[1]);

}



function emptyform() {

    $('#failureid').val('0');
    $('#failure').val('');
    $('#description').val('');
    $('#active').val('1');
    $('#defvalue').val('');

}


function save_failuredata() {

    //this is <a> click event:
    if (!$('#failureform')[0].checkValidity()) {
        $('#failureform').find('input[type="submit"]').click();
        return false;
    }

    var failureid = $('#failureid').val();
    var failure = $('#failure').val();
    var description = $('#description').val();
    var active = $('#active').val(); ;

    var data = {
        id: failureid,
        failure: failure,
        description: description,
        active: active,
        item: 'failurelist'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
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


function toggleitem(id) {

    //this is <a> click event:

    var data = {
        id: id,
        item: 'failureitem_toggle'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
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


function checkdoubles() {

    var failure = $('#failure').val();

    var data = {
        id: failure,
        item: 'failureitem'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/checkitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               $('#editForm').modal('hide');
               $('.warningmsg').html(data["errmsg"]);
               $('#warning').modal('show');
               $('#warningbtn').click(function() {
                   $('#failure').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });

            }
        },
        failure: function () {

        }
    });

}



