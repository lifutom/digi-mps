var dtlist;

$(function () {

    Date.prototype.toDateInputValue = (function() {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0,10);
    });

    dtlist = $('#dtlist').DataTable({
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
       "ordering" : true,
       "order": [[ 1, "desc" ]]
    });

    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function (e) {

        var data = dtlist.row( this ).data();
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


    $('#addbtn').click(function () {
        emptyform();
        $('#editForm').modal('show');
    });

    $('#dateid').val(new Date().toDateInputValue());
    $('#start').val(new Date().toDateInputValue());

});

function populateform(data) {

    $('#id').val(data[0]);
    $('#dateid').val(data[1]);
    $('#tierlevel').val(data[2]);
    $('#description').val(data[3]);
    $('#start').val(data[4]);
    $('#closed3').val(data[5]);
    $('#longdescription').val(data[6]);

}

function emptyform() {

    $('#id').val('');
    $('#dateid').val(new Date().toDateInputValue());
    $('#tierlevel').val('tier3');
    $('#description').val('');
    $('#start').val(new Date().toDateInputValue());
    $('#closed3').val('');
    $('#longdescription').val('');

}

function save_data() {

    //this is <a> click event:
    if (!$('#editform')[0].checkValidity()) {
        $('#editform').find('input[type="submit"]').click();
        return false;
    }
    var id = $('#id').val();
    var dateid = $('#dateid').val();
    var tierlevel = $('#tierlevel').val();
    var description = $('#description').val();
    var start = $('#start').val();
    var closed3 = $('#closed3').val();
    var longdescription = $('#longdescription').val();

    var data = {
        id: id,
        dateid: dateid,
        tierlevel: tierlevel,
        description: description,
        start: start,
        closed3: closed3,
        longdescription: longdescription,
        item: 'tier3_safetyissue'
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
        item: 'tier_safetyissue'
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





