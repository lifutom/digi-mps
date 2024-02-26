/* Version 1.0 2021-09-07*/

 var dtlist;

$(function () {

   dtlist = $('#dtlist').DataTable({
       "paging": false,
       "bFilter" : false,
       "bInfo" : false,
       "columns" : [
                {
                  data: 'accessitemid',
                  visible: false
                },
                {
                  data: 'accessrightid',
                  visible: false
                },
                {
                    data: 'select',
                    render: function ( data, type, row ) {

                        if ( type === 'display' ) {
                            var txt

                            txt = '<label class="switch mt-2">' +
                                  '<input class="mt-1 selDel" type="checkbox" name="select" id="select" value="10">' +
                                  '<span class="slider round"></span>' +
                                  '</label>'
                            //return '<input type="checkbox">';
                            return txt;
                        }
                        return data;
                     },
                     className: "dt-body-center"
                },
                {
                  data: 'accesstype'
                },
                {
                  data: 'accessitem'
                },
                {
                  data: 'accessright'
                }

       ],
       "order": [[ 3, "asc" ]]
    });

    $('.dataTables_length').addClass('bs-select');

    $('.search-drowdown').select2();

    $('#isid').change(function() {
        if ($('#isid').val() != null) {
            fillData($('#isid').val());
        }
    });

    /*$('#dtlist').on("click", ".selDel", function(){

        var data = dtlist.row($(this).parents('tr')).data();
        alert(data['accesstype']);
    });*/


    $('#dtlist').on("click", "tr", function(){
        var data = dtlist.row(this).data();

        if (typeof data != 'undefined') {
            if ($(this).find('.selDel').prop('checked')) {  //update the cell data with the checkbox state
                data.select = 1;

            } else {
                data.select = 0;
            }
        }
    });

    $('#btnlogout').click(function() {
        window.location.href=$('#CurRootFile').val() + '/request/form/?partial=yes';
    });

});


function emptyform() {
    $('#reqid').val('-1');
    $('#reqnb').val('');
    $('#isid').val('').trigger('change');
    $('#stateid').val('10');
    $('#department').val('');
    $('#departmentid').val('-1');
}

function fillData(id) {

    var data = {
        id: id,
        list: 'isid_accessitems'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);

            $('#department').val(data["department"]);
            $('#departmentid').val(data["departmentid"]);
            $.each(data['accessitem'], function (key, entry) {
                dtlist.column(0).visible(false);
                dtlist.column(1).visible(false);
                dtlist.row.add({
                    accessitemid: entry['accessitemid'],
                    accessrightid: entry['accessrightid'],
                    select: entry['select'],
                    accesstype: entry['accesstype'],
                    accessitem: entry['accessitem'],
                    accessright: entry['accessright']
                }).draw(false);
            });

        },
        failure: function () {
        }
    });
}

function saveData() {

    //this is <a> click event:



    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }


    if (dtlist.data().count() == 0) {
        $('.warningmsg').html($('#msgAccessRightAtLeastOne').val());
        $('#warning').modal('show');
        return false;
    }

    $('#showspinner').html('<span class="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>');
    //$('#spinner').html('<span class="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>Senden...').addClass('disabled');

    var data = {
        id: -1,
        createdby: $('#createdby').val(),
        reqnb: $('#reqnb').val(),
        created: $('#created').val(),
        isid : $('#isid').val(),
        stateid: $('#stateid').val(),
        departmentid: $('#departmentid').val(),
        description: $('#description').val(),
        reqtypeid: $('#reqtypeid').val(),
        item: 'request',
        count:  dtlist.data().count(),
        lang: $('#curLang').val(),
        detail: dtlist.data().toArray()
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                $('#successbtn').unbind();
                $('#showspinner').html('');
                $('#successbtn').click(function() {
                    window.location.href=$('#CurRootFile').val() + '/request/form/?partial=yes';
                });
                $('.successmsg').html(data["errmsg"]);
                $('#success').modal('show');
            } else {
                $('#showspinner').html('');
                $('.warningmsg').html(data["errmsg"]);
                $('#warning').modal('show');
            }
        },
        failure: function () {
        }
    });
}



