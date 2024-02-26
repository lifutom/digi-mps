/* Version 1.1 2020-12-13*/
$(function () {

    /*$("#other").change(function() {
        if(this.checked) {
            $(".otherbox").
        } else {

        }
    }); */

    if ($('#todo').val() == 'forward' || $('#todo').val() == 'close' ) {
        window.opener.location.reload();
        window.close();
    } else {
        window.opener.location.reload();
    }

    var dtlist = $('#dtlist').DataTable({
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
       "order": [[ 3, "desc" ]]
    });
    //$('.dataTables_length').addClass('bs-select')

    //activeTab($('#activetab').val());

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        $('#acttab').val(e.target);
        $('#tacttab').val(e.target);
        $('#facttab').val(e.target);
    });

    $('#cmdAddTask').click(function(){
        emptyform();
        $("#edittask").modal('show');
    });

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        populateform(data);
        $('#edittask').modal('show');
    });

    $('#cmdClose').click(function(){
        closeNearMiss();
    });


    $('#other').change(function() {
        if(this.checked) {
            $('.othertxt').show();
        } else {
            $('.othertxt').hide();
            $('#othertext').val('');
        }
    });



    $('#cmdForward').click(function(){

        if (!$('#nearform')[0].checkValidity()) {
            $('#send').click();
            return false;
        }

        if ($('#queue').val() == 'svp') {
            $('.question-info').html('Wollen Sie den Eintrag an EHS weiterleiten?');
        } else {
            $('.question-info').html('Wollen Sie den Eintrag an SVP weiterleiten?');
        }

        $('#question-ok').click(function() {
            $('#todo').val('forward');
            $('#nearform').submit();
        });
        $('#question').modal('show');
    });

    if ($('[name=typ]:checked').val() > 1 )  {
        $('#cause').show();
    } else {
        $('#cause').hide();
    }

    if ($('[name=istarget0]:checked').val() > 0 )  {
        $('#target').show();
    } else {
        $('#target').hide();
    }

    $('[name=typ]').change(function() {
        if ($('[name=typ]:checked').val() > 1 )  {
            $('#cause').show();
        } else {
            $('#cause').hide();
        }
    });

    $('[name=istarget0]').change(function() {
        if ($('[name=istarget0]:checked').val() > 0 )  {
            $('#target').show();
        } else {
            $('#target').hide();
        }
    });

    bsCustomFileInput.init();

    $('.search-drowdown').select2();

    var img1 = $('#nearimage').file_upload({
        messages: {
            remove: "Löschen",
        }
    });
    img1.on('file_upload.afterClear', function(event, element) {
        var data = {
            item : 'near-image',
            id : $('#nearid').val(),
            filetyp : 'near'
        }
        $.ajax({
                     url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
                     type: 'POST',
                     data: data
        });
    });

    var img2 = $('#neartaskimage').file_upload({
        messages: {
            remove: "Löschen",
        }
    });
    img2.on('file_upload.afterClear', function(event, element) {
        var data = {
            item : 'near-image',
            id : $('#nearid').val(),
            filetyp : 'task'
        }
        $.ajax({
                     url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
                     type: 'POST',
                     data: data
        });
    });
});


function activeTab(tab){
    $('.nav-tabs a[href="#' + tab + '"]').tab('show');
};


function populateform(data) {

    $('#taskid').val(data[0]);
    $("#tasktypeid").val(data[1]);
    $('#state').val(data[2]);
    $('#tasknb').val(data[4]);
    $('#description').val(data[5]);
    $('#assignedto').val(data[7]);
    $('#duedate').val(data[8]);
    $('#comments').val(data[11]);

}

function emptyform() {

    $('#taskid').val('-1');
    $('#tasknb').val('<new>');
    $("#tasktypeid").val(0);
    $('#duedate').val('');
    $('#state').val(0);
    $('#description').val('');
    $('#comments').val('');
    $('#assignedto').val('');
}


function refresh_data() {
    window.location.reload();
}

function closeNearMiss() {


    if (!$('#nearform')[0].checkValidity()) {
        $('#send').click();
        return false;
    }

    var id = $('#nearid').val();

    var data = {
        id: id,
        item: 'near_close'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/checkitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                $('.question-info').html(data["errmsg"]);
                $('#question-ok').click(function() {
                    $('#todo').val('close');
                    $('#nearform').submit();
                });
                $('#question').modal('show');
            } else {
                $('.info-info').html(data["errmsg"]);
                $('#info').modal('show');
            }
        },
        failure: function () {

        }
    });
}

function sendNearMissMail() {

    var id = $('#nearid').val();

    var data = {
        id: id,
        item: 'nearmiss'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/sendmail.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $('.info-info').html(data["errmsg"]);
            $('#info').modal('show');
        },
        failure: function () {

        }
    });
}

function uploadFile(nid, typ) {

    switch(typ) {
        case 1:
           $('#uploadtext').html('5-Why');
           break;
        case 2:
           $('#uploadtext').html('Fish bone');
           break;
        case 4:
           $('#uploadtext').html('PDCA');
           break;
        case 3:
           $('#uploadtext').html('Dokument/Foto');
           break;
    }
    $('#unid').val($('#nearid').val());
    $('#uploadtype').val(typ);
    $('#upload').modal('show');

}

function uploadFiles(nid) {

    $('#umnid').val($('#nearid').val());
    $('#uploadmulti').modal('show');

}

function askfordelete ( id, name, typ ) {

    $('#question-ok').off('click');

    $('#question-ok').click({id: id, name: name, typ: typ}, function (e) {
        delete_item(e.data.id,e.data.name, e.data.typ);
    });
    $('.question-info').html('Soll die Datei ' + name + ' gel&ouml;scht werden?');
    $('#question').modal('show');
    return false;
}


function delete_item(id, name, typ) {

    var data = {
        id: id,
        name: name,
        typ: typ,
        item: 'near-file'
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

