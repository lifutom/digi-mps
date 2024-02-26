/* Version 1.3 2022-04-23*/
/* Version 1.2 2022-04-13*/
/* Version 1.1 2021-09-14*/
/* Version 1.0 2021-08-10*/
var dtlist;

$(function () {

    dtlist = $('#dtlist').DataTable({
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
       "order": [[ 13, "desc" ]]
    });
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();


        if (data[24] == 30) {
            populateUploadform(data);
            $('#uploadForm').modal('show');
        } else {
            populateform(data);
            $('#editForm').modal('show');
        }


    });

    $('#dtlist tbody').on('click', '.btnedit', function () {

        var data = dtlist.row( $(this).parents('tr') ).data();
        if (data[24] == 30) {
            populateUploadform(data);
            $('#uploadForm').modal('show');
        } else {
            populateform(data);
            $('#editForm').modal('show');
        }
    });


    $('#btnDone').click(function() {
        doRequest('workitem-done');
    });

    $('#btnNotDone').click(function() {
        doRequest('workitem-notdone');
    });

    $('#btnUploadNotDone').click(function() {
        doUploadRequest('task-notdone');
    });

    $('#btnUpload').click(function() {
        doUploadRequest('task-uaf');
    });

    $('#refresh').click(function() {
        window.location.reload();
    });

    $('#export').click(function() {
        getListXLSX('worklist-open-xls');
    });

    $('#printreport').click(function() {
        getListPDF('worklist-open-pdf');
    });


    $('.search-drowdown').select2({
        dropdownParent: $('#editForm')
    });

    $('#dtlist tbody').on('click', '.btnwfstate', function () {
        var data = dtlist.row($(this).parents('tr')).data();

        PopupCenter('profile/workflowstate?id=' + data[2] + '&taskid=' + data[1]  + '&aid=' + data[4] + '&arid=' + data[5] + '&partial=yes', 'Workflowstate_' + data[9] , 900, 700);
    });

});

function emptyform() {
    $('#id').val('-1');
    $('#taskid').val('-1');
    $('#reqtype').html('');
    $('#tasknb').val('');
    $('#reqnb').val('');
    $('#displayname').val('');
    $('#accesstype').val('');
    $('#accessitem').val('');
    $('#accessright').val('');
    $('#description').val('');
    $('#elognb').val('');
    $('#isgxp').prop("checked", false);
}

function populateform(data) {
    $('#id').val(data[1]);
    $('#taskid').val(data[21]);
    $('#reqtype').html(data[22] + ':' + data[23]);
    $('#reqnb').val(data[9]);
    $('#tasknb').val(data[11]);
    $('#displayname').val(data[14]);
    $('#accesstype').val(data[17]);
    $('#accessitem').val(data[18]);
    $('#accessright').val(data[19]);
    $('#description').val(data[20]);
    $('#elognb').val(data[26]);
    if (data[27] == 1) {
       $('#isgxp').prop("checked", true);
    } else {
       $('#isgxp').prop("checked", false);
    }
}


function populateUploadform(data) {
    $('#uid').val(data[1]);
    $('#utaskid').val(data[21]);
    $('#ureqtype').html(data[22] + ':' + data[23]);
    $('#ureqnb').val(data[9]);
    $('#utasknb').val(data[11]);
    $('#udisplayname').val(data[14]);
    $('#uaccesstype').val(data[17]);
    $('#uaccessitem').val(data[18]);
    $('#uaccessright').val(data[19]);
    $('#udescription').val(data[20]);
}


function doUploadRequest(item) {


    var uafform = $('#uaf')[0].files[0];
    var taskid = $('#utaskid').val();
    var id = $('#uid').val();

    var formData = new FormData();
    formData.append('id',id);
    formData.append('taskid',taskid);
    formData.append('comment','')
    formData.append('item',item);
    formData.append('uaf',uafform);

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/mpfsaveitem.asp",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data) {
            data = JSON.parse(data);
            $('#spinnerupload').html('')
            $('#uploadForm').modal('hide');
            if (data["status"] == "OK") {
                $('#successbtn').unbind();
                $('#successbtn').click(function() {
                    window.location.reload();
                });
                $('.successmsg').html(data["errmsg"]);
                $('#success').modal('show');
            } else {
                $('.warningmsg').html(data["errmsg"]);

                $('#warningbtn').unbind();
                $('#warningbtn').click(function() {
                   $('#uploadForm').modal('show');
                });
                $('#warning').modal('show');
            }
        },
        failure: function () {
            $('#spinnerupload').html('');
        }
    });
}


function doRequest(item) {


    if ($('#comment').val() == '' && item=='workitem-notdone') {
        $('#comment').prop('required',true);
        $('#btnSubmit').click();
        return false;
    } else {
        $('#comment').prop('required',false);
    }

    $('#spinner-' + item).html('<span class="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>');

    var id = $('#id').val();
    var taskid = $('#taskid').val();

    var data = {
        id: id,
        taskid: taskid,
        comment: $('#comment').val(),
        item: item
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $('#spinnerreject').html('');
            $('#spinnerapprove').html('');
            $('#editForm').modal('hide');
            if (data["status"] == "OK") {
                $('#successbtn').unbind();
                $('#successbtn').click(function() {
                    window.location.reload();
                });
                $('.successmsg').html(data["errmsg"]);
                $('#success').modal('show');
            } else {
                $('.warningmsg').html(data["errmsg"]);

                $('#warningbtn').unbind();
                $('#warningbtn').click(function() {
                   $('#editForm').modal('show');
                });
                $('#warning').modal('show');
            }
        },
        failure: function () {
            $('#spinnerreject').html('');
            $('#spinnerapprove').html('');
        }
    });
}




