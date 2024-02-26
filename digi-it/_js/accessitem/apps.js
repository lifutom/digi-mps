/* Version 1.1 2021-11-21*/
/* Version 1.0 2021-08-10*/

var dtlistuseraccess;

$(function () {

    var dtlist = $('#dtlist').DataTable({
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

    dtlistuseraccess = $('#dtlistuseraccess').DataTable({
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
       }
    });


    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        alert(data[3]);
        /*populateform(data);
        $('#editForm').modal('show');*/
    });

    $('#dtlist tbody').on('click', '.btnview', function () {
        var data = dtlist.row( $(this).parents('tr') ).data();
        populateAccessList(data);
    });


    $('#refresh').on('click', function()
    {
        updateshares();
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


    function centerModal() {
        $(this).css('display', 'block');
        var $dialog  = $(this).find(".modal-dialog"),
        offset       = ($(window).height() - $dialog.height()) / 2,
        bottomMargin = parseInt($dialog.css('marginBottom'), 10);

        // Make sure you don't hide the top part of the modal w/ a negative margin if it's longer than the screen height, and keep the margin equal to the bottom margin of the modal
        if(offset < bottomMargin) offset = bottomMargin;
        $dialog.css("margin-top", offset);
    }

    $(document).on('show.bs.modal', '.modal', centerModal);
    $(window).on("resize", function () {
        $('.modal:visible').each(centerModal);
    });

});


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


function populateAccessList(data) {

    var id = data[1];

    var data = {
        list: "accessitem-user",
        id: id
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                dtlistuseraccess.clear();
                $.each(data['accessitem-user'], function (key, entry) {
                    dtlistuseraccess.row.add([
                        entry.isid
                        ,entry.displayname
                        ,entry.accessitem
                        ,entry.accessright
                    ]
                    ).draw(false);
                });

                $('#listAccess').modal('show');

            } else {
                $('.warningmsg').html(data["errmsg"]);
                $('#warning').modal('show');
            }
        },
        failure: function () {

        }
    });

}


function updateshares() {

    var data = {
        item: 'shares'
    }
    $('#viewspinner').modal('show');
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/updatead.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                // open modal spinner
                window.location.reload();
            } else {
                //close modal spinner
                $('#viewspinner').modal('hide');
            }
        },
        failure: function () {
            $('#viewspinner').modal('hide');
        }
    });

}

function toggleitem(id) {

    var data = {
        id: id,
        item: 'share_toggle'
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


