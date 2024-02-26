var dtlist;

$(function () {

    Date.prototype.toDateInputValue = (function() {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0,10);
    });


    $('#addbtn').click(function () {
        $('#editForm').on('show.bs.modal', function () {
            emptyform();
        });
        $('#editForm').modal('show');
    });

    $('#dateid').val(new Date().toDateInputValue());

    var data = {
        fu: 'list'
    }
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deliverypack.asp",
        data: data,
        //dataType: 'json',
        success: function (data) {

            data = JSON.parse(data);

            dtlist = $('#dtlist').DataTable({
                data: data,
                columns: [
                    {
                        'data' : 'deliverypackid',
                        'visible' : false
                    },
                    {'data' : 'dateid'},
                    {
                        'data' : 'plantid',
                        'visible' : false
                    },
                    {'data' : 'plant'},
                    {
                        'data' : 'oeevalue',
                        'render' : function(data,type,row) {
                            return parseFloat(data).toLocaleString();
                        }
                    },
                    {'data' : 'outputcnt'},
                    {'data' : 'lastedit'},
                    {'data' : 'userid'},
                    {
                      'data' : 'deliverypackid',
                      'render' : function(data,type,row) {
                          return '<a href="javascript:delete_item(\'' + data + '\')" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>';
                      }
                    }
                ],
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
               "order": [[ 1, "desc" ],[ 3, "asc" ]]
            });
            myTable = dtlist;
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

                $('#decisionbtn').click({id: data['deliverypackid']}, function (e) {
                    delete_item(e.data.id);
                });
                $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
                $('#decision').modal('show');
                return false;

            });

        },
        failure: function () {
        }
    });

});

function populateform(data) {

    $('#deliverypackid').val(data['deliverypackid']);
    $('#dateid').val(data['dateid']);
    $('#pplantid').val(data['plantid']);
    $('#oeevalue').val(parseFloat(data['oeevalue']).toLocaleString());
    $('#outputcnt').val(data['outputcnt']);

}



function emptyform() {

    $('#deliverypackid').val('');
    $('#dateid').val(new Date().toDateInputValue());
    $('#pplantid').val('');
    $('#oeevalue').val('');
    $('#outputcnt').val('');

}

function save_data() {

    //this is <a> click event:
    if (!$('#eForm')[0].checkValidity()) {
        $('#eForm').find('input[type="submit"]').click();

        return false;
    }
    var id = $('#deliverypackid').val();
    var dateid = $('#dateid').val();
    var plantid = $('#pplantid').val();
    var oeevalue = $('#oeevalue').val();
    var outputcnt = $('#outputcnt').val();

    var data = {
        id: id,
        dateid: dateid,
        plantid: plantid,
        oeevalue: oeevalue,
        outputcnt: outputcnt,
        item: 'tier1_delivery_pack'
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
        item: 'tier1_delivery_pack'
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





