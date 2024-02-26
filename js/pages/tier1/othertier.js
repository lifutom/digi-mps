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
    $('#ostart').val(new Date().toDateInputValue());

    var data = {
        fu: 'list'
    }
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/othertier.asp",
        data: data,
        //dataType: 'json',
        success: function (data) {

            data = JSON.parse(data);

            dtlist = $('#dtlist').DataTable({
                data: data,
                columns: [
                    {
                        'data' : 'oid',
                        'visible' : false
                    },
                    {'data' : 'dateid'},
                    {
                        'data' : 'departmentid',
                        'visible' : false
                    },
                    {'data' : 'department'},
                    {
                        'data' : 'ocatid',
                        'visible' : false
                    },
                    {'data' : 'ocatname'},
                    {'data' : 'ostart'},
                    {
                        'data' : 'odescription',
                        'render' : function(data,type,row){
                            if (data.length > 30) {
                                return  data.slice(0,30) + '...';
                            } else {
                                return data;
                            }
                        }
                    },
                    {'data' : 'oclosed'},
                    {'data' : 'lastedit'},
                    {'data' : 'userid'},
                    {
                      'data' : 'oid',
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
               "order": [[ 1, "desc" ]]
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

                $('#decisionbtn').click({id: data['oid']}, function (e) {
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

    $('#oid').val(data['oid']);
    $('#dateid').val(data['dateid']);
    $('#departmentid').val(data['departmentid']);
    $('#ocatid').val(data['ocatid']);
    $('#odescription').val(data['odescription']);
    $('#ostart').val(data['ostart']);
    $('#oclosed').val(data['oclosed']);

}



function emptyform() {

    $('#oid').val('');
    $('#dateid').val(new Date().toDateInputValue());
    $('#departmentid').val($('#userdepartmentid').val());
    $('#ocatid').val('');
    $('#odescription').val('');
    $('#ostart').val(new Date().toDateInputValue());
    $('#oclosed').val('');

}

function save_data() {

    //this is <a> click event:
    if (!$('#editform')[0].checkValidity()) {
        $('#editform').find('input[type="submit"]').click();

        return false;
    }
    var id = $('#oid').val();
    var dateid = $('#dateid').val();
    var departmentid = $('#departmentid').val();
    var ocatid = $('#ocatid').val();
    var odescription = $('#odescription').val();
    var ostart = $('#ostart').val();
    var oclosed = $('#oclosed').val();

    var data = {
        id: id,
        dateid: dateid,
        departmentid: departmentid,
        ocatid: ocatid,
        odescription: odescription,
        ostart: ostart,
        oclosed: oclosed,
        item: 'tier1_other'
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
        item: 'tier1_other'
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
