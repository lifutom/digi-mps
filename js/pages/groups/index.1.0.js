$(function () {

    var dtgrouplist = $('#dtgrouplist').DataTable({
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
    myTable = dtgrouplist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtgrouplist tbody').on('dblclick', 'tr', function () {
        var data = dtgrouplist.row( this ).data();
        if (data[1] != 'admin') {
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

    $('#groupid').change(function() {
        checkdoubles();
    });

});

function populateform(data) {


    $('#groupid').val(data[1]);
    $('#group').val(data[2]);
    $('#defvalue').val(data[1]);
    $('#active').val(data[0]);

    if (data[1] == 'admin') {
        $('#groupid').prop('readonly',true);
    } else {
       $('#groupid').prop('readonly',false);
    }

}



function emptyform() {

    $('#groupid').val('');
    $('#group').val('');
    $('#defvalue').val('');
    $('#active').val(1);

}


function save_data() {

    //this is <a> click event:
    if (!$('#groupform')[0].checkValidity()) {
        $('#groupform').find('input[type="submit"]').click();
        return false;
    }

    var groupid = $('#groupid').val();
    var group = $('#group').val();
    var active = $('#active').val();
    
    var data = {
        id: groupid,
        group: group,
        active: active,
        item: 'group'
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
        item: 'group_toggle'
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

    var groupid = $('#groupid').val();

    var data = {
        id: groupid,
        item: 'group'
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
                   $('#groupid').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });

            }
        },
        failure: function () {

        }
    });

}

function openaccess(groupid) {

    $('#actgroupid').val(groupid);
    $('#access_form').submit();

}



