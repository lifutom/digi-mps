/* Version 1.2:  2023-03-29 */
/* Version 1.1:  2020-12-05 */

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

    var dtlinklist = $('#tblLink').DataTable({
        "columnDefs": [
            {
                "targets": [ 0 ],
                "visible": false,
                "searchable": false
            }
        ],
        "bPaginate": false,
        "bFilter": false,
        "bInfo": false ,
        "fnInitComplete": function () {
           $('.dataTables_scrollBody').css({
                            'overflow-y': 'scroll',
                            'overflow-x': 'hidden',
                            'border': 'none'
           });
        }
    });




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

    $('#plantid').change(function() {
        fill_devicelist(this.value, -1);
    });

    $('#sendlinkbtn').click(function () {
        saveLink_data();
    });

});

function populateform(data) {


    $('#active').val(data[0]);
    $('#moduleid').val(data[1]);
    $('#name').val(data[2]);
    $('#defvalue').val(data[2]);
    if (data[7] == 1) {
       $('#isinstand').prop("checked", true);
    } else {
       $('#isinstand').prop("checked", false);
    }
}



function emptyform() {

    $('#moduleid').val('-1');
    $("#name").val(' ');
    $('#defvalue').val(' ');
    $('#active').val(1);
    $('#isinstand').prop("checked", false);

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
    var isinstand;

    if ($('#isinstand').is(":checked")) {
        isinstand = 1;
    } else {
        isinstand = 0;
    }

    var data = {
        id: id,
        name: name,
        active: active,
        isinstand: isinstand,
        item: 'module'
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
        item: 'module_toggle'
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

function togglestanditem(id) {

    var data = {
        id: id,
        item: 'module_toggle_isinstand'
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
        item: 'module'
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
/*****************************************************************/
/* working with links                                            */
/*****************************************************************/
function links (id) {

    $('#plantid').prop('selectedIndex', 0);
    $('#deviceid').prop('selectedIndex', 0);
    $('#lmoduleid').val(id);

    var table = $('#tblLink').DataTable();
    table.clear().draw();

    // fill table with new rows
    var data =  {
        id: id,
        list: 'module_link'
    }
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $.each(data['module_link'], function (key, entry) {
                table.row.add ([entry.linkid, entry.plant, entry.device, '<a href="javascript:linksDeleteQue(' + entry.linkid + ');"><i class="fas fa-trash-alt"></i></a>']).draw();
            });
            $('#editLinkForm').modal('show');
        },
        failure: function () {
        }
    });
}


function fill_devicelist(id, devid ) {

    var devicedropdown = $("#deviceid");
    var plantid = id;

    var data = {
        id: plantid,
        list: 'device_dd'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            devicedropdown.empty();
            devicedropdown.append('<option selected="true" value="">--Auswahl Anlage--</option>');

            $.each(data['device'], function (key, entry) {
                devicedropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
            devicedropdown.prop('selectedIndex', 0);
        },
        failure: function () {
        }
    });
}

function saveLink_data() {


    //this is <a> click event:
    if (!$('#linkform')[0].checkValidity()) {
        $('#linkform').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#lmoduleid').val();
    var plantid = $('#plantid').val();
    var deviceid = $('#deviceid').val();

    var table = $('#tblLink').DataTable();

    var data = {
        id: id,
        plantid: plantid,
        deviceid: deviceid,
        item: 'module_link'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                var entry = data["module_link"];
                if (entry.linkid != -1) {
                    table.row.add ([entry.linkid, entry.plant, entry.device, '<a href="javascript:linksDeleteQue(' + entry.linkid + ');"><i class="fas fa-trash-alt"></i></a>']).draw();
                }
            }
        },
        failure: function () {

        }
    });
}


function linksDeleteQue(id) {

    /*else {
               $('#editForm').modal('hide');
               $('.warningmsg').html(data["errmsg"]);
               $('#warning').modal('show');
               $('#warningbtn').click(function() {
                   $('#sparepartnb').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });
            } */
    $('#editLinkForm').modal('hide');
    $('.warningmsg').html('Wollen Sie diese Zornung wirklich löschen? Es werden die Zuordnungen aller Ersatzteile ebenfalls entfernt.');
    $('#warning').modal('show');
    $('#warningbtn').unbind();
    $('#warningbtn').click(function() {
         $('#editLinkForm').modal('show');
         linksDelete(id);
    });
}

function linksDelete(id) {


    var table = $('#tblLink').DataTable();

    var data = {
        id: id,
        item: 'module_link'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                var linkid = data["id"];
                var rowIndex = [];
                table.rows( function ( idx, data, node ) {
                    if(data[0] === linkid){
                        rowIndex.push(idx);
                    }
                    return false;
                });
                table.row(rowIndex[0]).remove().draw();
            }
        },
        failure: function () {

        }
    });
}






