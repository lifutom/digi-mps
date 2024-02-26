$(function () {

    var dtuserlist = $('#dtsitelist').DataTable({
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
       "order": [[ 0, "asc" ]]
    });
    myTable = dtuserlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtsitelist tbody').on('dblclick', 'tr', function () {
        var data = dtuserlist.row( this ).data();
        populateform(data);
        $('#editForm').modal('show');
    });

    $('#name').change(function() {
        checkdoubles();
    });

});

function populateform(data) {

    $('#boxid').val(data[0]);
    $('#name').val(data[1]);
    $('#defvalue').val(data[1]);

}



function emptyform() {

    $('#boxid').val('-1');
    $("#name").val('');
    $('#defvalue').val('');

}


function save_data() {

    //this is <a> click event:
    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#boxid').val();
    var name = $('#name').val();


    var data = {
        id: id,
        name: name,
        item: 'box'
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
        item: 'box'
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

function move2loc(boxid)  {

    var data = {
        id: boxid,
        list: 'boxdetail'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $('#boxid').val(data['boxid']);
            $('#warehouseid').val(data['warehouseid']);
            $('#locationid').val(data['locationid']);
            $('#shelfid').val(data['shelfid']);
            $('#compid').val(data['compid']);
            $('#boxname').val(data['boxname']);
            $('#location').val(data['location']);
            $('#warehouse').val(data['warehouse']);
            $('#shelfidnew').val('');
            $('#compidnew').val('');
            $('#warehouseidnew').val('');
        },
        failure: function () {
        }
    });

    $('#moveBox').modal('show');
}


function saveBoxMove_data() {

    //this is <a> click event:
    if (!$('#formBox')[0].checkValidity()) {
        $('#formBox').find('input[type="submit"]').click();
        return false;
    }
    $('#moveBox').modal('hide');
    // 1. Check location param
    if ($('#warehouseid').val() == $('#warehouseidnew').val() && $('#shelfid').val() == $('#shelfidnew').val() && $('#compid').val() == $('#compidnew').val()) {
        $('.warningmsg').html('Sie haben den aktuellen Lagerort angegeben!');
        $('#warningbtn').unbind();
        $('#warningbtn').click(function () {
            $('#warning').modal('hide');
            $('#moveBox').modal('show');
        });
        $('#warning').modal('show');
        return;
    }

    $('.decisionmsg').html('Box auf neuen Lagerort umlagern?');
    $('#decisionbtn').unbind();
    $('#decisionbtn').click(function () {
        $('#decision').modal('hide');
        saveBox_data();
    });
    $('#decision').modal('show');
}

function saveBox_data() {

    var boxid = $('#boxid').val();
    var locationid = $('#locationid').val();
    var warehouseid = $('#warehouseidnew').val();
    var shelfid = $('#shelfidnew').val();
    var compid = $('#compidnew').val();

    var data = {
        id: boxid,
        locationid: locationid,
        warehouseid: warehouseid,
        shelfid: shelfid,
        compid: compid,
        item: 'boxmove'
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



