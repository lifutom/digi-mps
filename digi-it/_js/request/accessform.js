/* Version 1.1 2021-09-03*/
/* Version 1.0 2021-08-10*/

 var dtlist;

$(function () {

   dtlist = $('#dtlist').DataTable({
       "paging": false,
       "bFilter" : false,
       "bInfo" : false,
       "columns" : [
                {
                  data: 'accesstypeid',
                  visible: false
                },
                {
                  data: 'accessitemid',
                  visible: false
                },
                {
                  data: 'accessrightid',
                  visible: false
                },
                {
                  data: 'accesstype'
                },
                {
                  data: 'accessitem'
                },
                {
                  data: 'accessright'
                },
                {
                    render: function (data,type) {
                        //return'<button type="button" class="btn-sm"><i class="fas fa-trash-alt"></i></button>'
                        return'<i class="fas fa-trash-alt btndel"></i>'
                    }
                }
       ],
       "order": [[ 3, "asc" ]]
    });

    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        alert(data[1]);
        /*populateform(data);
        $('#editForm').modal('show');*/
    });

    $('#add').click(function() {
        emptyform();
        $('#editForm').modal('show');
    });

    $('#refresh').click(function() {
        alert('refresh');
    });

    $('.search-drowdown').select2();

    $('#isid').change(function() {
        if ($('#isid').val() != null) {
            showDepartment($('#isid').val());
        }
    });

    $('#accesstypeid').change(function() {
        if ($('#accesstypeid').val() != null) {
            fillAccessItem($('#accesstypeid').val());
        }
    });

    $('#accessitemid').change(function() {
        if ($('#accessitemid').val() != null) {
            fillAccessItemRight($('#accessitemid').val());
        }
    });

    $('#btnAdd').click(function() {
        if ($('#accesstypeid').val() == null || $('#accessitemid').val() == null || $('#accessrightid').val() == null)  {
            alert($('#msgFillAllFields').val());
        } else {
            dtlist.column(0).visible(false);
            dtlist.column(1).visible(false);
            dtlist.column(2).visible(false);
            dtlist.row.add({
              accesstypeid: $('#accesstypeid').val(),
              accessitemid: $('#accessitemid').val(),
              accessrightid: $('#accessrightid').val(),
              accesstype: $( "#accesstypeid option:selected" ).text(),
              accessitem: $( "#accessitemid option:selected" ).text(),
              accessright: $( "#accessrightid option:selected" ).text()
            }
            ).draw(false);
        }
    });

    $('#btnlogout').click(function() {
        window.location.href=$('#CurRootFile').val() + '/request/form/?partial=yes';
    });

    $('#dtlist').on("click", ".btndel", function(){
        dtlist.row($(this).parents('tr')).remove().draw(false);
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


function showDepartment(isid) {

    var data = {
        id: isid,
        item: 'user_department'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getvalue.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               $('#department').val(data["department"]);
               $('#departmentid').val(data["departmentid"]);
            }
        },
        failure: function () {
        }
    });
}

function fillAccessItem(id) {

    var data = {
        id: id,
        list: 'accessitem'
    }

    var itemdropdown = $('#accessitemid');
    var rightdropdown = $('#accessrightid');

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);

                rightdropdown.empty();
                rightdropdown.append('<option selected="true" value="" disabled>-- ' + $('#lblARight').val() + ' --</option>');
                itemdropdown.empty();
                itemdropdown.append('<option selected="true" value="" disabled>-- ' + $('#lblAccessItem').val() + ' --</option>');
                $.each(data['accessitem'], function (key, entry) {
                    itemdropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
                });
                itemdropdown.prop('selectedIndex', 0);

        },
        failure: function () {
        }
    });
}

function fillAccessItemRight(id) {

    var data = {
        id: id,
        list: 'accessitemright'
    }

    var rightdropdown = $('#accessrightid');

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);

                rightdropdown.empty();
                rightdropdown.append('<option selected="true" value="" disabled>-- ' + $('#lblARight').val() + ' --</option>');
                $.each(data['accessitemright'], function (key, entry) {
                    rightdropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
                });
                rightdropdown.prop('selectedIndex', 0);
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



