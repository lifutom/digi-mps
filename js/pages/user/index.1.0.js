/*  Version 1.2 */
$(function () {

    var dtuserlist = $('#dtuserlist').DataTable({
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

    $('#dtuserlist tbody').on('dblclick', 'tr', function () {
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

    $('#userid').change(function() {
        checkdoubles();
    });

});

function populateform(data) {

    $('#userid').val(data[3]);
    $('#groupid').val(data[1].split(','));
    $('#departmentid').val(data[2]);
    $('#active').val(data[0]);
     $('#defvalue').val(data[3]);

}



function emptyform() {

    $('#userid').val('');
    $("#groupid").prop('selectedIndex', 0);
    $("#departmentid").prop('selectedIndex', 0);
    $('#defvalue').val('');
    $('#active').val(1);

}


function save_data() {

    //this is <a> click event:
    if (!$('#userform')[0].checkValidity()) {
        $('#userform').find('input[type="submit"]').click();
        return false;
    }

    var groupid = $('#groupid').val();
    var departmentid = $('#departmentid').val();
    var userid = $('#userid').val();
    var active = $('#active').val();

    var data = {
        id: userid,
        groupid: groupid,
        departmentid: departmentid,
        active: active,
        item: 'user'
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
        item: 'user_toggle'
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

    var userid = $('#userid').val();

    var data = {
        id: userid,
        item: 'user'
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
                   $('#userid').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });

            }
        },
        failure: function () {

        }
    });

}



