var roomnbChanged = false;

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
       "order": [[ 1, "asc" ]]
    });
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        populateform(data);
        $('#editForm').modal('show');
    });

    $('#addbtn').click(function () {
        emptyform();
        $('#editForm').modal('show');
    });

    /*$('#nb').change(function() {
        checkdoubles();
    });*/

    $('#nb').on("input",function() {
        roomnbChanged=true;
    });


});


function toggleitem(id) {

    var data = {
        id: id,
        item: 'room_toggle'
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

function populateform(data) {


    $('#roomid').val(data[0]);
    $('#nb').val(data[2]);
    $('#name').val(data[3]);
    $('#regionid').val(data[1]);
    $('#buildingid').val(data[10]);
    if (data[9] == 0) {
       $('#active').prop('checked',false);
    } else {
       $('#active').prop('checked',true);
    }
    $('#defvalue').val(data[2]);
    roomnbChanged=false;
}



function emptyform() {

    $('#roomid').val(0);
    $('#nb').val('');
    $('#name').val('');
    $("#regionid").prop('selectedIndex', 0);
    $("#buildingid").prop('selectedIndex', 0)
    $('#defvalue').val('');
    $('#active').prop('checked',true);
    roomnbChanged=false;

}


function save_data(status, msg) {

    if (status == "OK") {
       $('#editForm').modal('hide');
       $('.warningmsg').html( msg);
       $('#warning').modal('show');
       $('#warningbtn').click(function() {
           $('#nb').val($('#defvalue').val());
           roomnbChanged=false;
           $('#editForm').modal('show');
       });
    } else {

       save_datatodb();
    }
}



function save_datatodb() {

    //this is <a> click event:
    if (!$('#editform')[0].checkValidity()) {
        $('#editform').find('input[type="submit"]').click();
        return false;
    }

    var roomid = $('#roomid').val();
    var nb = $('#nb').val();
    var name = $('#name').val();
    var regionid = $('#regionid').val();
    var buildingid = $('#buildingid').val();
    var active = $('#active').is(':checked') ? 1 : 0;

    var data = {
        id: roomid,
        nb: nb,
        name: name,
        regionid: regionid,
        buildingid: buildingid,
        active: active,
        item: 'room'
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


function checkdoublescb() {


    if (!roomnbChanged) {
        save_datatodb();
    } else {
        var id = $('#nb').val();

        var data = {
            id: id,
            item: 'room'
        }

        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/checkitem.asp",
            data: data,
            success: function (data) {
                data = JSON.parse(data);
                save_data(data["status"],data["errmsg"]);
            },
            failure: function () {
                save_data("OK","Fehler in der AJAX funktion");
            }
        });
    }
}


function checkdoubles() {

    var id = $('#nb').val();

    var data = {
        id: id,
        item: 'room'
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
                   $('#nb').val($('#defvalue').val());
                   roomnbChanged=false;
                   $('#editForm').modal('show');
               });
            }
        },
        failure: function () {

        }
    });

}



