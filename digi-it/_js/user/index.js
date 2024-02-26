/* Version 1.1 2021-11-19*/
/* Version 1.0 2021-08-10*/
var dtlist;
var adtlist;
var curRow;
var deldtlist;
$(function () {

    dtlist = $('#dtlist').DataTable({
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
       "order": [[ 1, "asc" ]]
    });
    adtlist = $('#adtlist').DataTable({
        "columns" : [
                {
                  data: 'accesstype'
                },
                {
                  data: 'accessitem'
                },
                {
                  data: 'accessright'
                }
        ],
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
       "bFilter" : false,
       "bInfo": false,
       "bLengthChange": false,
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


    deldtlist = $('#deldtlist').DataTable({
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
    });

    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( $(this) ).data();
        var curRow = dtlist.row( $(this) ).index();
        populateform(data,curRow);
        $('#editForm').modal('show');
    });

    $('#dtlist tbody').on('click', '.btnedit', function () {
        var data = dtlist.row($(this).parents('tr')).data();
        var curRow = dtlist.row($(this).parents('tr')).index();
        populateform(data,curRow);
        $('#editForm').modal('show');
    });

    $('#dtlist tbody').on('click', '.btnaddaccess', function () {

        var data = dtlist.row($(this).parents('tr')).data();
        PopupCenter('user/accessmaint?id=' + data[1] + '&partial=yes', 'Benutzer-Rechte', 900, 700);
    });


    $('#refresh').click(function() {
        window.location.reload();
    });

    $('#export').click(function() {
        getListXLSX('user-xls');
    });

    $('#printreport').click(function() {
        getListPDF('user-pdf');
    });

    $('.search-drowdown').select2({
        dropdownParent: $('#editForm')
    });

    if ($('#IsAdmin').val() == 0) {
        $('#departmentid').prop('disabled', true);
        $('#roomid').prop('disabled', true);
        $('#btnSubmit').hide();
    } else {
        $('#departmentid').prop('disabled', false);
        $('#roomid').prop('disabled', false);
        $('#btnSubmit').show();
    }

});


function emptyform() {
    $('#currow').val('');
    $('#isid').val('');
    $('#lastname').val('');
    $('#firstname').val('');
    $('#displayname').val('');
    $('#email').val('');
    $('#addepartment').val('');
    $('#departmentid').prop('selectedIndex', 0);
    $('#roomid').prop('selectedIndex', 0);
    adtlist.clear();
}

function populateform(data,curRow) {

    emptyform();
    $('#currow').val(curRow);
    $('#isid').val(data[1]);
    $('#lastname').val(data[3]);
    $('#firstname').val(data[4]);
    $('#displayname').val(data[2]);
    $('#email').val(data[6]);
    $('#addepartment').val(data[7]);

    if(data[10] == '' || data[10] == -1) {
        $('#departmentid').val('').trigger('change');
    } else {
        $('#departmentid').val(data[10]).trigger('change');
    }

    if(data[11] == '' || data[11] == -1) {
        $('#roomid').val('').trigger('change');
    } else {
        $('#roomid').val(data[11]).trigger('change');
    }

    var data = {
        id:  $('#isid').val(),
        list: 'isid_accessitems'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            adtlist.clear();
            $.each(data['accessitem'], function (key, entry) {
              adtlist.row.add({
                  accesstype: entry.accesstype,
                  accessitem: entry.accessitem,
                  accessright: entry.accessright
              }).draw(false);
            });
            deldtlist.clear();
            $.each(data['delegates'], function (key, entry) {
                deldtlist.row.add([
                    entry.isid,
                    entry.lastname,
                    entry.firstname
                    ]
                ).draw(false);
            });
        },
        failure: function () {
        }
    });
}


function saveData() {

    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    var row = $('#currow').val();

    var data = {
        id: $('#isid').val(),
        departmentid: $('#departmentid').val(),
        roomid: $('#roomid').val() == null || $('#roomid').val() == '' ? -1 : $('#roomid').val(),
        row: curRow,
        item: 'aduser'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $('#editForm').modal('hide');

            if (data["status"] == "OK") {
                if (row) {
                    dtlist.cell(row,5).data(data["room"]).draw();
                    dtlist.cell(row,8).data(data["department"]).draw();
                    dtlist.cell(row,10).data(data["departmentid"]).draw();
                    dtlist.cell(row,11).data(data["roomid"]).draw();
                }
                $('#successbtn').unbind();
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


