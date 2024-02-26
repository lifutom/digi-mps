$(function () {

    var dtuserlist = $('#dtlist').DataTable({
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
       "order": [[ 2, "asc" ]]
    });
    myTable = dtuserlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtuserlist.row( this ).data();
        if (data[3] != SysAdm) {
           populateform(data);
           $('#editForm').modal('show');
        }
    });

    $('#addbtn').click(function () {
        $('#editForm').on('show.bs.modal', function () {
            emptyform();
        });
        $('#editForm').modal('show');
    });

    $('#name').change(function() {
        checkdoubles();
    });

});

function populateform(data) {


    $('#active').val(data[0]);
    $('#moduleid').val(data[1]);
    $('#name').val(data[2]);
    $('#defvalue').val(data[2]);

}



function emptyform() {

    $('#moduleid').val('-1');
    $("#name").val(' ');
    $('#defvalue').val(' ');
    $('#active').val(1);

}


function save_data() {

    //this is <a> click event:
    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#moduleid').val();
    var name = $('#name').val();
    var active = $('#active').val();

    var data = {
        id: id,
        name: name,
        active: active,
        item: 'categorie'
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
        item: 'categorie_toggle'
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

    var name = $('#name').val();

    var data = {
        id: name,
        item: 'categorie'
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
                   $('#name').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });

            }
        },
        failure: function () {
        }
    });
}



