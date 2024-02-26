/* Version 1.3 2022-06-07*/
/* Version 1.3 2022-05-04*/
/* Version 1.2 2022-04-25*/
/* Version 1.1 2021-11-21*/
/* Version 1.0 2021-08-10*/

var dtlist;
var dtlistaccess;
var dtlistaccesstask;
var dtlistuseraccess;
var editor;

var times = {1: 36, 2:66, 3:41}

$(function () {

    dtlist = $('#dtlist').DataTable({
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
       "bFilter" : true,
       "bEdit": true,
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


    dtlistaccess = $('#dtlistaccess').DataTable({
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
                  data: 'workflowid',
                  visible: false
                },
                {
                  data: 'accessitem'
                },
                {
                  data: 'accessright'
                },
                {
                  data: 'workflow'
                },
                {
                    render: function (data,type) {
                        //return'<button type="button" class="btn-sm"><i class="fas fa-trash-alt"></i></button>'
                        return'<i class="fas fa-trash-alt btndel"></i>'
                    }
                }
       ],
    });


    $('.dataTables_length').addClass('bs-select');


    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        var rowid = dtlist.row( this ).id();
        //alert(rowid);
        populateForm(data, rowid);
    });

    $('#dtlist tbody').on('click', '.btnedit', function () {
        var data = dtlist.row( $(this).parents('tr') ).data();
        populateForm(data);

    });

    $('#dtlist tbody').on('click', '.btnaccess', function () {
        var data = dtlist.row( $(this).parents('tr') ).data();
        populateAccessForm(data);
    });

    $('#dtlist tbody').on('click', '.btnview', function () {
        var data = dtlist.row( $(this).parents('tr') ).data();
        populateAccessList(data);
    });

    $('#dtlist tbody').on('click', '.btnworkflow', function () {
        var data = dtlist.row( $(this).parents('tr') ).data();
        PopupCenter('/accessitem/itemworkflow?id=' + data[1] + '&typ=' + $('#vwaccesstypeid').val() + '&partial=yes', 'Workflow', 900, 700)
    });


    $('#refresh').on('click', function()
    {
        window.location.reload();
    });

    $('#export').click(function() {
        var listtyp;
        switch($('#defaccesstypeid').val()) {
            case '1':
                listtyp = 'share-xls';
                break;
            case '2':
                listtyp = 'app-xls';
                break;
        }
        getListXLSX(listtyp);
    });

    $('#printreport').click(function() {
        var listtyp;
        switch($('#defaccesstypeid').val()) {
            case '1':
                listtyp = 'share-pdf';
                break;
            case '2':
                listtyp = 'app-pdf';
                break;
        }
        getListPDF(listtyp,2);
    });

    $('#add').click(function() {
        emptyForm();
    });


    $('#btnSubmit').click(function() {
        saveData();
    });

    $('.search-drowpdown').select2({
        dropdownParent: $('#editForm')
    });

    $('.search-drowpdown-access').select2({
        dropdownParent: $('#editAccessForm')
    });

    $('#btnAdd').click(function() {
        $('#rid').val(-1);
        saveAccessRight();
    });

    $(document).on('show.bs.modal', '.modal', centerModal);
    $(window).on("resize", function () {
        $('.modal:visible').each(centerModal);
    });

});


function emptyForm() {

    var accesstypeid = $('#defaccesstypeid').val();

    $('#id').val(-1);
    $('#accesstypeid').val(accesstypeid).trigger('change');
    $('#isgmp').prop("checked", false);
    $('#active').prop("checked", true);
    $('#name').val('');
    $('#sysowner').val('').trigger('change');

    setView();

    $('#editForm').modal('show');

}

function populateForm(data,id) {


    $('#rowid').val(id);
    $('#id').val(data[1]);
    $('#accesstypeid').val(data[2]).trigger('change');
    if (data[3] == 1) {
       $('#active').prop("checked", true);
    } else {
       $('#active').prop("checked", false);
    }
    if (data[7] == 1) {
       $('#isgmp').prop("checked", true);
    } else {
       $('#isgmp').prop("checked", false);
    }
    $('#sysowner').val(data[8]).trigger('change');
    $('#name').val(data[4]);

    setView();

    $('#editForm').modal('show');

}

function setView() {

    var accesstypeid = $('#defaccesstypeid').val();


     if ($('#IsAdmin').val() == 0 && $('#IsKeyUser').val() == 0) {
        $('#name').prop('readonly', true);
        $('#active').prop('disabled', true);
        $('#isgmp').prop('disabled', true);
        $('#sysowner').prop('disabled', true);
        $('#btnSubmit').hide();
    } else {
        $('#name').prop('readonly', false);
        $('#active').prop('disabled', false);
        /*if (accesstypeid == 2) {
            $('#isgmp').prop('disabled', false);
            $('#sysowner').prop('disabled', false);
            $('.app').show();
          } else {
            $('#isgmp').prop('disabled', true);
            $('#sysowner').prop('disabled', true);
            $('.app').hide();
        }*/
 	$('#isgmp').prop('disabled', false);
        $('#sysowner').prop('disabled', false);
        $('.app').show();
        $('#btnSubmit').show();
    }
}


function populateAccessForm(data) {

    var list = "accessitem-right-access";
    var aid = data[1];
    $('#aid').val(aid);

    var lang = $('#CurLang').val();

    var data = {
        list: list,
        id: aid,
        lang: lang
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {


                $('#accessright').val('');

                dtlistaccess.clear();

                var accessitem = data["accessitem"];
                var accessright = accessitem["accessright"]

                $.each(accessright, function (key, entry) {
                    dtlistaccess.row.add(
                    {
                      accessitemid: entry.accessitemid,
                      accessrightid: entry.id,
                      workflowid: entry.workflowid,
                      accessitem: entry.accessitem,
                      accessright: entry.accessright,
                      workflow: entry.workflow
                    }).draw(false);

                });

                var dd_workflowid = $('#workflowid');
                dd_workflowid.empty();

                var workflow = accessitem["workflow"];
                $.each(workflow, function (key, entry) {
                    if (entry.value == "") {
                       dd_workflowid.append('<option selected="true" value="" disabled>-- ' + entry.name + ' --</option>');
                    } else {
                       dd_workflowid.append($('<option></option>').attr('value', entry.workflowid).text(entry.workflow));
                    }
                });
                dd_workflowid.prop('selectedIndex', 0);


                $('#editAccessForm').modal('show');

            } else {
                $('.warningmsg').html(data["errmsg"]);
                $('#warning').modal('show');
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

function saveAccessRight() {

    if (!$('#arform')[0].checkValidity()) {
        $('#arform').find('input[type="submit"]').click();
        return false;
    }

    var accessitemid=$('#aid').val();
    var rid=$('#rid').val();
    var workflowid=$('#workflowid').val();
    var accessright = $('#accessright').val();
    var lang = $('#CurLang').val();
    var data = {
        item: 'accessright',
        id: rid,
        accessright: accessright,
        accessitemid: accessitemid,
        workflowid: workflowid,
        lang: lang
    }
    $('#editAccessForm').modal('hide');
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                $('#accessright').val('');
                dtlistaccess.row.add(
                {
                  accessitemid: data["accessitemid"],
                  accessrightid: data["accessrightid"],
                  workflowid: data["workflowid"],
                  accessitem: data["accessitem"],
                  accessright: data["accessright"],
                  workflow: data["workflow"]
                }).draw(false);

                $('#successbtn').click(function(){
                    $('#editAccessForm').modal('show');
                });
                $('.successmsg').html(data["errmsg"]);
                $('#success').modal('show');
            } else {
                $('.warningmsg').html(data["errmsg"]);
                $('#warning').modal('show');
            }
        },
        failure: function () {

        }
    });
}



function saveData() {

    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    var id=$('#id').val();
    var accesstypeid=$('#accesstypeid').val();
    var active=$("#active").is(':checked') ? 1 : 0;
    var isgmp=$('#isgmp').is(':checked') ? 1 : 0;
    var sysowner=$('#sysowner').val();
    var name=$('#name').val();

    var data = {
        item: 'accessitem',
        id: id,
        name: name,
        accesstypeid: accesstypeid,
        active: active,
        isgmp: isgmp,
        sysowner: sysowner
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                $('#successbtn').click(function(){
                    window.location.reload();
                });
                $('#editForm').modal('hide');
                $('.successmsg').html(data["errmsg"]);
                $('#success').modal('show');
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

    var msg = $('#msg').val();

    var data = {
        item: 'shares'
    }

    $('.spinnermsg').html(msg);
    $('#viewspinner').modal('show');
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/updatead.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                // open modal spinner
                $('#viewspinner').modal('hide');
                $('#successbtn').click(function(){
                    window.location.reload();
                });
                 $('.spinnermsg').html(msg);
                $('#success').modal('show');

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


