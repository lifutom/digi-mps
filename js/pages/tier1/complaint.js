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
        url: $('#CurRootFile').val() + "/ajax/complaint.asp",
        data: data,
        //dataType: 'json',
        success: function (data) {

            data = JSON.parse(data);

            dtlist = $('#dtlist').DataTable({
                data: data,
                columns: [
                    {
                        'data' : 'cid',
                        'visible' : false
                    },
                    {'data' : 'dateid'},
                    {'data' : 'cnb'},
                    {'data' : 'cnumber'},
                    {'data' : 'cproduct'},
                    {
                        'data' : 'cdescription',
                        'render' : function(data,type,row){
                            if (data.length > 30) {
                                return  data.slice(0,30) + '...';
                            } else {
                                return data;
                            }
                        }
                    },
                    {'data' : 'ccountry'},
                    {
                        'data' : 'creason',
                        'render' : function(data,type,row){
                            if (data.length > 30) {
                                return  data.slice(0,30) + '...';
                            } else {
                                return data;
                            }
                        }
                    },
                    {'data' : 'lastedit'},
                    {'data' : 'userid'},
                    {
                      'data' : 'cid',
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
               "order": [[ 2, "asc" ]]
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

                $('#decisionbtn').click({id: data['cid']}, function (e) {
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

    $('#cid').val(data['cid']);
    $('#dateid').val(data['dateid']);
    $('#cnb').val(data['cnb']);
    $('#cnumber').val(data['cnumber']);
    $('#cproduct').val(data['cproduct']);
    $('#cdescription').val(data['cdescription']);
    $('#ccountry').val(data['ccountry']);
    $('#creason').val(data['creason']);

}



function emptyform() {

    $('#cid').val('');
    $('#dateid').val(new Date().toDateInputValue());
    $('#cnb').val('');
    $('#cnumber').val('');
    $('#cproduct').val('');
    $('#cdescription').val('');
    $('#ccountry').val('');
    $('#creason').val('');

}

function save_data() {

    //this is <a> click event:
    if (!$('#editform')[0].checkValidity()) {
        $('#editform').find('input[type="submit"]').click();

        return false;
    }
    var id = $('#cid').val();
    var dateid = $('#dateid').val();
    var cnb = $('#cnb').val();
    var cnumber = $('#cnumber').val();
    var cproduct = $('#cproduct').val();
    var cdescription = $('#cdescription').val();
    var ccountry = $('#ccountry').val();
    var creason = $('#creason').val();

    var data = {
        id: id,
        dateid: dateid,
        cnb: cnb,
        cnumber: cnumber,
        cproduct: cproduct,
        cdescription: cdescription,
        ccountry: ccountry,
        creason: creason,
        item: 'tier1_complaint'
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
        item: 'tier1_complaint'
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





