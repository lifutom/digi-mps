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
    $('#ccstart').val(new Date().toDateInputValue());

    var data = {
        fu: 'list'
    }
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/cc.asp",
        data: data,
        //dataType: 'json',
        success: function (data) {

            data = JSON.parse(data);

            dtlist = $('#dtlist').DataTable({
                data: data,
                columns: [
                    {
                        'data' : 'ccid',
                        'visible' : false
                    },
                    {'data' : 'dateid'},
                    {
                        'data' : 'departmentid',
                        'visible' : false
                    },
                    {'data' : 'department'},
                    {
                        'data' : 'ccnb',
                        'render' :  function(data,type,row) {
                                return 'CC-' + data;
                        }
                    },
                    {
                        'data' : 'ccdescription',
                        'render' : function(data,type,row){
                            if (data.length > 30) {
                                return  data.slice(0,30) + '...';
                            } else {
                                return data;
                            }
                        }
                    },
                    {'data' : 'ccstart'},
                    {'data' : 'ccclosed'},
                    {'data' : 'lastedit'},
                    {'data' : 'userid'},
                    {
                      'data' : 'ccid',
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

                $('#decisionbtn').click({id: data['ccid']}, function (e) {
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

    $('#ccid').val(data['ccid']);
    $('#dateid').val(data['dateid']);
    $('#departmentid').val(data['departmentid']);
    $('#ccnb').val(data['ccnb']);
    $('#ccdescription').val(data['ccdescription']);
    $('#ccstart').val(data['ccstart']);
    $('#ccclosed').val(data['ccclosed']);

}



function emptyform() {

    $('#ccid').val('');
    $('#dateid').val(new Date().toDateInputValue());
    $('#departmentid').val($('#userdepartmentid').val());
    $('#ccnb').val('');
    $('#ccdescription').val('');
    $('#ccstart').val(new Date().toDateInputValue());
    $('#ccclosed').val('');

}

function save_data() {

    //this is <a> click event:
    if (!$('#editform')[0].checkValidity()) {
        $('#editform').find('input[type="submit"]').click();

        return false;
    }
    var id = $('#ccid').val();
    var dateid = $('#dateid').val();
    var departmentid = $('#departmentid').val();
    var ccnb = $('#ccnb').val();
    var ccdescription = $('#ccdescription').val();
    var ccstart = $('#ccstart').val();
    var ccclosed = $('#ccclosed').val();

    var data = {
        id: id,
        dateid: dateid,
        departmentid: departmentid,
        ccnb: ccnb,
        ccdescription: ccdescription,
        ccstart: ccstart,
        ccclosed: ccclosed,
        item: 'tier1_cc'
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
        item: 'tier1_cc'
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





