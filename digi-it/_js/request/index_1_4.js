/* Version 1.5 2022-11-09*/
/* Version 1.4 2022-08-19*/
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
        populateform(data);
        $('#editForm').modal('show');
    });

    $('#dtlist tbody').on('click', '.btnedit', function () {
        
        var data = dtlist.row( $(this).parents('tr') ).data();
        populateform(data);
        $('#editForm').modal('show');
    });


    $('#btnApprove').click(function() {
        approveRequest('request-approve');
    });

    $('#btnReject').click(function() {
        approveRequest('request-reject');
    });

    $('#refresh').click(function() {
        window.location.reload();
    });

    $('.search-drowdown').select2({
        dropdownParent: $('#editForm')
    });

    $('#export').click(function() {
        getListXLSX('requestlist-open-xls');
    });

    $('#printreport').click(function() {
        getListPDF('requestlist-open-pdf');
    });

    $('#dtlist tbody').on('click', '.btnwfstate', function () {
        var data = dtlist.row($(this).parents('tr')).data();
        PopupCenter('profile/workflowstate?id=' + data[2] + '&taskid=' + data[1]  + '&aid=' + data[4] + '&arid=' + data[5] + '&partial=yes', 'Workflowstate_' + data[9] , 900, 700);
    });

});


function editRequest(row) {

    alert(row);

    var data = dtlist.row( row ).data();
    populateform(data);
    $('#editForm').modal('show');
}


function emptyform() {
    $('#id').val('-1');
    $('#taskid').val('-1');
    $('#accesstypeid').val('-1');
    $('#tasknb').val('');
    $('#reqnb').val('');
    $('#displayname').val('');
    $('#accesstype').val('');
    $('#accessitem').val('');
    $('#accessright').val('');
    $('#elognb').val('');
    $('#elognb').prop("required", false);
    $('#isgxp').prop("checked", false);
    $('#isgxp').prop("disabled", true);
    $('#description').val('');
}

function populateform(data) {
    $('#id').val(data[1]);
    $('#taskid').val(data[21]);
    $('#accesstypeid').val(data[3]);
    $('#reqnb').val(data[9]);
    $('#tasknb').val(data[11]);
    $('#displayname').val(data[14]);
    $('#accesstype').val(data[17]);
    $('#accessitem').val(data[18]);
    $('#accessright').val(data[19]);
    $('#description').val(data[20]);
    $('#elognb').val(data[23]);
    if (data[24] == 1) {
       $('#isgxp').prop("checked", true);
       $('#isgxp').prop("disabled", true);
       $('#elognb').prop("required", true);
       $('#elognb').prop("readonly", false);
       $('#elognb').prop("minlength", 6);
    } else {
       $('#isgxp').prop("checked", false);
       $('#isgxp').prop("disabled", true);
       $('#elognb').prop("required", false);
       $('#elognb').prop("readonly", true);
       $('#elognb').prop("minlength", 0);
    }

}




function approveRequest(item) {


    /*if ($('#comment').val() == '' && item=='request-reject') {
        $('#comment').prop('required',true);
        $('#btnSubmit').click();
        return false;
    } else {
        $('#comment').prop('required',false);
    }

    if ($('#isgxp').is(":checked")) {
        if($('#elognb').val() ==  ''6) {
            $('#btnSubmit').click();
            return false;
        }
    }
    */

    if ($('#isgxp').is(":checked")) {
        $('#elognb').prop("required", true);
        $('#elognb').prop("readonly", false);
        $('#elognb').prop("minlength", 6);
    } else {
        $('#elognb').prop("required", false);
        $('#elognb').prop("readonly", true);
        $('#elognb').prop("minlength", 0);
    }

    if (item=='request-reject') {
        $('#comment').prop('required',true);
        $('#elognb').prop("required", false);
        $('#elognb').prop("minlength", 0);
    } else {
        $('#comment').prop('required',false);
    }



    if (!$('#appform')[0].checkValidity()) {
        $('#appform').find('input[type="submit"]').click();
        return false;
    }


    $('#spinner-' + item).html('<span class="spinner-border spinner-border-sm mr-2" role="status" aria-hidden="true"></span>');

    var id = $('#id').val();
    var taskid = $('#taskid').val();

    var data = {
        id: id,
        taskid: taskid,
        comment: $('#comment').val(),
        elognb: $('#elognb').val(),
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

function isNumberKey(evt) {

    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode != 46 && charCode > 31
    && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function isNumericKey(evt)
{
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode != 46 && charCode > 31
    && (charCode < 48 || charCode > 57))
        return true;
    return false;
}



