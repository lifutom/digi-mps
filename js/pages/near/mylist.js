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
       "order": [[ 1, "desc" ]]
    });
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        editNear(data[0]);
    });




});

function askfordelete ( id, nb ) {

    $('#decisionbtn').off('click');    
    $('#decisionbtn').click({id: id}, function (e) {
        delete_item(e.data.id);
    });
    $('.decisionmsg').html('Soll der Eintrag ' + nb + ' gel&ouml;scht werden?');
    $('#decision').modal('show');
    return false;
}




function delete_item(id) {


    var data = {
        id: id,
        item: 'near'
    }


        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
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


function editNear(id) {
    PopupInTab('near/edit/?partial=yes&id=' + id + '&idx=0');
}


/*

function populateform(data) {


    $('#active').val(data[0]);
    $('#siteid').val(data[1]);
    $('#sitename').val(data[2]);
    $('#defvalue').val(data[2]);

}



function emptyform() {

    $('#siteid').val('-1');
    $("#sitename").val('');
    $('#defvalue').val('');
    $('#active').val(1);

}


function save_data() {

    //this is <a> click event:
    if (!$('#siteform')[0].checkValidity()) {
        $('#siteform').find('input[type="submit"]').click();
        return false;
    }

    var siteid = $('#siteid').val();
    var name = $('#sitename').val();
    var active = $('#active').val();

    var data = {
        id: siteid,
        name: name,
        active: active,
        item: 'site'
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
        item: 'site_toggle'
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

    var name = $('#sitename').val();

    var data = {
        id: name,
        item: 'site'
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
                   $('#sitename').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });

            }
        },
        failure: function () {
        }
    });
}
*/



