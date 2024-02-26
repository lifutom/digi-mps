/* Version 1.0 2022-04-11*/
var dtlist;
var curRow;

$(function () {

    dtlist = $('#dtlist').DataTable({
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
       "bFilter" : false,
       "ordering" : true,
       "paging" : true,
       "info" : true,
       "processing": true,
       "serverSide": true,
       "ajax": {
            "url": $('#CurRootFile').val() + "/ajax/getlist.asp",
            "type": "POST",
            "data" : {
                "list" : "isid_accessitems_reload",
                "id": $("#isid").val()
            }
        },
        "columns": [
            { "data": "accessitemtype"},
            { "data": "accessitem" },
            { "data": "accessright" },
            { "data": "accessitemtypeid", "visible": false },
            { "data": "accessitemid", "visible": false },
            { "data": "accessrightid", "visible": false },
            { "data": "manual",
                "render" : function(data, type, row) {
                            if (data == 1) {
                                return '<i class="fa fa-hand-paper" title="manuell"></i>';

                            } else {
                                return '';
                            }
                        }
            },
            {
                "data": "manual",
                "render" : function(data, type, row) {
                            if (data == 1) {
                                return '<i class="fa fa-trash btn-edit"></i>';

                            } else {
                                return '';
                            }
                        }
            }
        ],
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
    });

    $('.dataTables_length').addClass('bs-select');

    $('.search-drowdown').select2({
        dropdownAutoWidth : true
    });

    $('#btnAdd').click(function() {
        if (setAddBtn()) {
            addItem();
        }
    });

    $('#refresh').click(function() {
        dtlist.ajax.reload();
    });




    var typedropdown = $('#accessitemtypeid');
    var itemdropdown = $('#accessitemid');
    var rightdropdown = $('#accessrightid');

    typedropdown.prop('selectedIndex', 0).change();
    itemdropdown.prop('selectedIndex', 0).change();
    rightdropdown.prop('selectedIndex', 0).change();

    $('#btnAdd').addClass('btn-secondary');

    $('#accessitemtypeid').change(function() {
        if ($('#accessitemtypeid').val() != null) {
            fillAccessItem($('#accessitemtypeid').val());
        }
        $('#btnAdd').removeClass('btn-primary');
        $('#btnAdd').removeClass('btn-secondary');
        $('#btnAdd').addClass('btn-secondary');
    });

    $('#accessitemid').change(function() {
        if ($('#accessitemid').val() != null) {
            fillAccessItemRight($('#accessitemid').val());
        }
        setAddBtn();
    });

    $('#accessrightid').change(function() {
        setAddBtn();
    });

    $('#dtlist tbody').on('click', '.btn-edit', function () {
        var data = dtlist.row($(this).parents('tr')).data();
        var curRow = dtlist.row($(this).parents('tr')).index();
        askForDelete(data);
    });

});


function askForDelete(data) {

    $('#question-ok').unbind();
    $('#question-ok').click(function() {
        $('#question').modal('hide');
        deleteAccessItem(data);
    });
    $('.question-info').html($('#queDataDelete').val());
    $('#question').modal('show');

}


function setAddBtn() {

    if ($('#accessitemtypeid').val() != null && $('#accessitemid').val() != null && $('#accessrightid').val() != null ) {
        $('#btnAdd').removeClass('btn-secondary');
        $('#btnAdd').removeClass('btn-primary');
        $('#btnAdd').addClass('btn-primary');
        return true;
    } else {
        $('#btnAdd').removeClass('btn-primary');
        $('#btnAdd').removeClass('btn-secondary');
        $('#btnAdd').addClass('btn-secondary');
        return false;
    }
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
                rightdropdown.append('<option selected="true" value="" disabled>-- ' + $('#lblselect').val() + ' --</option>');
                itemdropdown.empty();
                itemdropdown.append('<option selected="true" value="" disabled>-- ' + $('#lblselect').val() + ' --</option>');
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
                rightdropdown.append('<option selected="true" value="" disabled>-- ' + $('#lblselect').val() + ' --</option>');
                $.each(data['accessitemright'], function (key, entry) {
                    rightdropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
                });
                rightdropdown.prop('selectedIndex', 0);
        },
        failure: function () {
        }
    });
}


function addItem() {

    var data = {
        id: $('#isid').val(),
        accessitemid: $('#accessitemid').val(),
        accessrightid: $('#accessrightid').val(),
        manual: 1,
        item: 'accessitem-manual',
        lang: $('#curLang').val()
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                $('#successbtn').unbind();
                $('#successbtn').click(function() {
                    dtlist.ajax.reload();
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

function deleteAccessItem(rowdata) {

    var data = {
        id: $('#isid').val(),
        accessitemid: rowdata['accessitemid'],
        accessrightid: rowdata['accessrightid'],
        manual: 1,
        item: 'accessitem-manual',
        lang: $('#curLang').val()
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                $('#successbtn').unbind();
                $('#successbtn').click(function() {
                    dtlist.ajax.reload();
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






