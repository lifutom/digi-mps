/* version 1.0 */
var roomnbChanged = false;
var dtsvplist;

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
    dtsvplist = $('#dtsvplist').DataTable({
       "paging":   false,
       "ordering": false,
       "info":     false,
       "searching": false,
       columns: [
                    {
                        'data' : 'regionid',
                        'visible' : false
                    },
                    {'data' : 'userid'},
                    {
                        'data' : 'name'
                    },
                    {
                        'data' : 'status',
                        render: function ( data, type, row ) {
                                    return '<a href="#" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>';
                                }
                    },
                    {
                        'data' : 'active',
                        'visible' : false
                    },
                ]
    });

    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        populateform(data);
        refresh_svpdata(data[0]);
    });

    $('#addbtn').click(function () {
        emptyform();
        $('#editForm').modal('show');
    });

    $('#nb').on("input",function() {
        roomnbChanged=true;
    });

    $('#addsvpbtn').click(function () {
        add_item();
    });

});


function toggleitem(id) {

    var data = {
        id: id,
        item: 'region_toggle'
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

    $('#regionid').val(data[0]);
    $('#nb').val(data[1]);
    $('#name').val(data[2]);
    if (data[6] == 0) {
       $('#active').prop('checked',false);
    } else {
       $('#active').prop('checked',true);
    }
    $('#defvalue').val(data[1]);
    roomnbChanged=false;
     $('#regionsvp').show();
}

function refresh_svpdata(id) {

    var data = {
       list: 'regionsvp',
       id: id
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            dtsvplist.clear().draw();
            if (data['svp'].length > 0) {

                dtsvplist.rows.add(data['svp']).draw();

                $('#dtsvplist .deletelink').unbind();

                $('#dtsvplist .deletelink').on('click', function () {

                    var td = $(this).parent();
                    var tr = td.parent();

                    var datam = dtsvplist.row( tr).data();

                    delete_item(datam['regionid'], datam['userid']);
                });
            }
            // svp liste
            var dropdown = $('#svpuserid');
            dropdown.empty();
            $.each(data['svplist'], function (key, entry) {
                dropdown.append($('<option></option>').attr('value', entry.userid).text(entry.name));
            });
            $('#editForm').modal('show');
        },
        failure: function () {

        }
    });
}

function delete_item(regionid, userid) {

    var data = {
       item: 'regionsvp',
       id: regionid,
       userid: userid
    }


    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            refresh_svpdata(regionid);
        },
        failure: function () {

        }
    });

}

function add_item() {

    var userid = $('#svpuserid').val();
    var regionid = $('#regionid').val();

    var data = {
       item: 'regionsvp',
       id: regionid,
       userid: userid
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               refresh_svpdata(regionid);
            }
        },
        failure: function () {

        }
    });
}



function emptyform() {

    $('#regionid').val(0);
    $('#nb').val('');
    $('#name').val('');
    $('#defvalue').val('');
    $('#active').prop('checked',true);
    roomnbChanged=false;
    $('#regionsvp').hide();

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

    var regionid = $('#regionid').val();
    var nb = $('#nb').val();
    var name = $('#name').val();
    var active = $('#active').is(':checked') ? 1 : 0;

    var data = {
        id: regionid,
        nb: nb,
        name: name,
        active: active,
        item: 'region'
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
            item: 'region'
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



