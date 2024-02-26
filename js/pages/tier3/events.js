var dtlist;

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
       }
    });


    Date.prototype.toDateInputValue = (function() {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0,10);
    });


    $('#addbtn').click(function () {
        emptyform();
        $('#editForm').modal('show');
    });

    $('#dateid').val(new Date().toDateInputValue());
    $('#eventstart').val(new Date().toDateInputValue());



    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function (e) {

        var data = dtlist.row(this ).data();
        populateform(data);
        $('#editForm').modal('show');

    });

    $('#dtlist .deletelink').on('click', function () {

        var td = $(this).parent();
        var tr = td.parent();

        var data = dtlist.row( tr ).data();

        $('#decisionbtn').click({id: data[0]}, function (e) {
            delete_item(e.data.id);
        });
        $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
        $('#decision').modal('show');
        return false;

    });
});

function populateform(data) {

    $('#eventid').val(data[0]);
    $('#dateid').val(data[1]);
    $('#raisedcnt').val(data[2]);
}



function emptyform() {

    $('#eventid').val('');
    $('#dateid').val(new Date().toDateInputValue());
    $('#raisedcnt').val('0');

}

function save_data() {

    //this is <a> click event:
    if (!$('#editform')[0].checkValidity()) {
        $('#editform').find('input[type="submit"]').click();

        return false;
    }
    var id = $('#eventid').val();

    var dateid = $('#dateid').val();
    var raisedcnt = $('#raisedcnt').val();
    var data = {
        id: id,
        dateid: dateid,
        raisedcnt: raisedcnt,
        item: 'tier3_events'
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


function delete_item(id) {

    var data = {
        id: id,
        item: 'tier3_events'
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
