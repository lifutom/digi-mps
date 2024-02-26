/* Version 1.0 */
/* Version 1.1  2020-11-18 */
$(function () {

    var dtlist = $('#dtlist').DataTable({
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
       "bFilter" : false,
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
       "order": [[ 2, "asc" ]]
    });
    $('.dataTables_length').addClass('bs-select');

    $('#searchboxid').select2();

    $('#delfilter').click(function() {
        location.href = $('#CurRootFile').val() + '/spare/clear'
    });

    $('#searchlink').click(function() {
        $('#formSearch').submit();
    });

    $('#movebtn').click(function() {
        $('#warehouseidnew').prop("required",true);
        $('#shelfidnew').prop("required",true);
        $('#compidnew').prop("required",true);
        $('#moveBox').modal('show');
    });

    $('#mvboxid').select2({
        dropdownParent: $('#moveBox')
    });


    $('#mvboxid').change(function() {
        getBoxData()
    });

    $('#boxid').select2({
        dropdownParent: $('#moveSpare')
    });

    $('#boxid').change(function() {
        prepareMovForm();
    });

});

function checkActNumber() {

    var sparepartid = $("#movid").val();
    var movlocationid = $("#movlocationid").val()
    var act = $("#movact").val()

    var data = {
        id: movlocationid,
        sparepartid: sparepartid,
        act: act,
        item: 'spareloc_act'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/checkitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $('#errmsg1').html(data["errmsg"]);
            if (data["status"] == 'NOTOK') {
               $("#movact").focus();
            }
        },
        failure: function () {
        }
    });
}

function prepareMovForm() {

    var boxid = $("#boxid").val();
    var sparepartid = $("#movid").val();
    var movlocationid = $("#movlocationid").val()

    if (boxid == 0) {
        $("#warehouseid").prop( "disabled", false );
        $("#shelfid").prop( "disabled", false );
        $("#compid").prop( "disabled", false );
        $("#warehouseid").val('');
        $("#shelfid").val('');
        $("#compid").val('');
        return;
    }


    var data = {
        id: boxid,
        key: boxid,
        sparepartid: sparepartid,
        movid: movlocationid,
        item: 'spareloc'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/checkitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $('#errmsg').html(data["errmsg"]);
            if (data["status"] == 'NOTOK') {
               $("#boxid").focus();
               $("#warehouseid").prop( "disabled", false );
               $("#shelfid").prop( "disabled", false );
               $("#compid").prop( "disabled", false );
            }
            if (data["data"] == 1) {
                var location = data["location"];
                $("#warehouseid").val(location.warehouseid);
                $("#warehouseid").prop( "disabled", true );
                $("#mov2locationid").val(location.locationid);
                $("#shelfid").val(location.shelfid);
                $("#shelfid").prop( "disabled", true );
                $("#compid").val(location.compid);
                $("#compid").prop( "disabled", true );
            } else {
                $("#warehouseid").prop( "disabled", false );
                $("#shelfid").prop( "disabled", false );
                $("#compid").prop( "disabled", false );
                $("#mov2locationid").val(-1);
            }
        },
        failure: function () {
        }
    });
}


function getBoxData()  {

    var boxid=$('#mvboxid').val()

    if (boxid=='') return;

    var data = {
        id: boxid,
        list: 'boxdetail'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $('#warehouseid').val(data['warehouseid']);
            $('#locationid').val(data['locationid']);
            $('#shelfid').val(data['shelfid']);
            $('#compid').val(data['compid']);
            $('#boxname').val(data['boxname']);
            $('#location').val(data['location']);
            $('#warehouse').val(data['warehouse']);
            $('#shelfidnew').val('');
            $('#compidnew').val('');
            $('#warehouseidnew').val('');
        },
        failure: function () {
        }
    });

    $('#warehouseidnew').prop("required",true);
    $('#shelfidnew').prop("required",true);
    $('#compidnew').prop("required",true);

    $('#moveBox').modal('show');
}

function saveBoxMove_data() {

    //this is <a> click event:
    if (!$('#formBox')[0].checkValidity()) {
        $('#formBox').find('input[type="submit"]').click();
        return false;
    }

    if ($('#mvboxid').val() == '') {
        return false;
    }

    $('#warehouseidnew').prop("required",false);
    $('#shelfidnew').prop("required",false);
    $('#compidnew').prop("required",false);
    $('#moveBox').modal('hide');
    // 1. Check location param
    if ($('#warehouseid').val() == $('#warehouseidnew').val() && $('#shelfid').val() == $('#shelfidnew').val() && $('#compid').val() == $('#compidnew').val()) {
        $('.warningmsg').html('Sie haben den aktuellen Lagerort angegeben!');
        $('#warningbtn').unbind();
        $('#warningbtn').click(function () {
            $('#warning').modal('hide');
            $('#warehouseidnew').prop("required",true);
            $('#shelfidnew').prop("required",true);
            $('#compidnew').prop("required",true);
            $('#moveBox').modal('show');
        });
        $('#warning').modal('show');
        return;
    }
    $('.question-info').html('Box auf neuen Lagerort umlagern?');
    $('#decisionbtn').unbind();
    $('#question-ok').click(function () {
        $('#question').modal('hide');
        saveBox_data();
    });
    $('#question').modal('show');
}


function saveBox_data() {

    var boxid = $('#mvboxid').val();
    var locationid = $('#locationid').val();
    var warehouseid = $('#warehouseidnew').val();
    var shelfid = $('#shelfidnew').val();
    var compid = $('#compidnew').val();

    var data = {
        id: boxid,
        locationid: locationid,
        warehouseid: warehouseid,
        shelfid: shelfid,
        compid: compid,
        item: 'boxmove'
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

function orderSpare(id, actval, sparepartnb,sparepart)  {

    $('#ordid').val(id);
    $('#ordactval').val(actval);
    $('#ordsparepartnb').val(sparepartnb);
    $('#ordsparepart').val(sparepart);

    $('#ordact').val(0.00);

    var supplierdropdown = $("#ordsupplierid");

    var data = {
        id: id,
        userid: $('#CurUserID').val(),
        list: 'supplier_spare'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            supplierdropdown.empty();
            supplierdropdown.prop('selectedIndex', 0);
            $.each(data["suppliers"], function (key, entry) {
                supplierdropdown.append($('<option></option>').attr('value', entry.supplierid).text(entry.name + ' BestNr: ' + entry.nb + '  Preis: ' + parseFloat(entry.price).toFixed(2)));
            });
            $('#ordact').val(parseFloat(0).toFixed(2));
        },
        failure: function () {
        }
    });
    $('#orderSpare').modal('show');

}

function saveSpareOrder_data() {

    //this is <a> click event:
    if (!$('#formOrderSpare')[0].checkValidity()) {
        $('#formOrderSpare').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#ordid').val();
    var act = $('#ordact').val();
    var supplierid = $('#ordsupplierid').val();

    var data = {
        id: id,
        act : act,
        supplierid: supplierid,
        item: 'orderspare'
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


function move2loc(id, actval, sparepartnb,sparepart)  {

    $('#movid').val(id);
    $('#movactval').val(actval);
    $('#movsparepartnb').val(sparepartnb);
    $('#movsparepart').val(sparepart);

    $('#movact').val(0);
    $('#boxid').val('');
    $('#shelfid').val('');
    $('#compid').val('');

    var locationdropdown = $("#movlocationid");

    var data = {
        id: id,
        userid: $('#CurUserID').val(),
        list: 'location_spare'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            locationdropdown.empty();
            locationdropdown.prop('selectedIndex', 0);
            $.each(data["location"], function (key, entry) {
                locationdropdown.append($('<option></option>').attr('value', entry.locationid).text(entry.warehouse + ':' + entry.name + '  Verfügbar: ' + parseFloat(entry.act).toFixed(2)));
            });
            $('#movact').val(parseFloat(0).toFixed(2));
        },
        failure: function () {
        }
    });
    $('#moveSpare').modal('show');
}

function saveSpareMove_data() {

    //this is <a> click event:
    if (!$('#formMoveSpare')[0].checkValidity()) {
        $('#formMoveSpare').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#movlocationid').val();
    var newid = $('#mov2locationid').val();
    var act = $('#movact').val();
    var sparepartid = $('#movid').val();
    var boxid = $('#boxid').val();
    var shelfid = $('#shelfid').val();
    var compid = $('#compid').val();
    var warehouseid = $('#warehouseid').val();
    var data = {
        id: id,
        newid: newid,
        act : act,
        sparepartid: sparepartid,
        boxid: boxid,
        shelfid: shelfid,
        compid: compid,
        warehouseid: warehouseid,
        item: 'movespare'
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



