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
       "order": [[ 3, "asc" ]]
    });
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        populateform(data);
        $('#editForm').modal('show');
    });

    $('#addbtn').click(function () {
        $('#editForm').on('show.bs.modal', function () {
            emptyform();
        });
        $('#editForm').modal('show');
    });

    $('#warehousename').change(function() {
        checkdoubles();
    });

});

function populateform(data) {


    $('#active').val(data[0]);
    $('#warehouseid').val(data[1]);
    $('#siteid').val(data[2]);
    $('#warehousename').val(data[3]);
    $('#defvalue').val(data[3]);

}



function emptyform() {

    $('#warehouseid').val('-1');
    $('#siteid').val('-1');
    $("#warehousename").val('');
    $('#defvalue').val('');
    $('#active').val(1);

}


function save_data() {

    //this is <a> click event:
    if (!$('#whform')[0].checkValidity()) {
        $('#whform').find('input[type="submit"]').click();
        return false;
    }

    var warehouseid = $('#warehouseid').val();
    var siteid = $('#siteid').val();
    var name = $('#warehousename').val();
    var active = $('#active').val();

    var data = {
        id: warehouseid,
        siteid : siteid,
        name: name,
        active: active,
        item: 'warehouse'
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

    var data = {
        id: id,
        item: 'warehouse_toggle'
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

    var name = $('#warehousename').val();

    var data = {
        id: name,
        item: 'warehouse'
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
                   $('#warehousename').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });

            }
        },
        failure: function () {
        }
    });
}



