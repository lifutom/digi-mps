/* Version 1.1:  2020-10-20 */
/* Version 1.2:  2020-11-18 */
/* Version 1.3:  2020-11-26 */
/* Version 1.4:  2020-12-03 */
/* Version 1.5:  2020-12-06 */

$(function () {

    var dtlist = $('#dtslist').DataTable({
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
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtslist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        PopupCenter('spare/edit/?partial=yes&id=' + data[1] + '&idx=' + dtlist.row( this ).index(),'Spareparts', 800, 650);
    });

    $('#addbtn').click(function () {
        PopupCenter('spare/edit/?partial=yes&id=0&idx=0','Spareparts', 800, 650);
    });

    /*$('#sparepartnb').change(function() {
        checkdoubles();
    });*/

    $('#plantid').change(function() {
        fill_devicelist();
    });

    $('#deviceid').change(function() {
        fill_modulelist();
    });

    /*$('#moduleid').change(function() {
       refresh_datatable();
    }); */

    $('#spareview').click(function() {
        if ($('#vwview').val() == 'list') {
            $('#vwview').val('kachel');
        } else {
             $('#vwview').val('list');
        }
        refresh_datatable();
    });

    $('#searchlink').click(function() {
       refresh_datatable();
    });

    $('#delfilter').click(function() {
        $('#plantid').prop('selectedIndex', 0);
        $('#srcsupplierid').prop('selectedIndex', 0);
        $('#catid').prop('selectedIndex', 0);
        $('#deviceid').empty();
        $("#deviceid").append('<option selected="true" value="-1">--Alle--</option>');
        $("#searchboxid").val('').trigger('change');
        $('#searchwarehouseid').prop('selectedIndex', 0);
        $('#searchtxt').val('');
        $('#searchshelfid').val('');
        $('#searchcompid').val('');


        var moduledd = $("#moduleid");
        var data = {
            id: -1,
            list: 'module_list'
        }

        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/getlist.asp",
            data: data,
            success: function (data) {
                data = JSON.parse(data);
                moduledd.empty();
                moduledd.append('<option selected="true" value="-1">--Alle--</option>');
                $.each(data['module_list'], function (key, entry) {
                    moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
                });
                moduledd.prop('selectedIndex', 0);
            },
            failure: function () {
            }
        });
    });



    $('#sendbtn').click(function() {
        addCartItem();
    });


    $('#boxid').change(function() {
        prepareMovForm();
    });

    $('#movact').blur(function() {
        checkActNumber();
    });

    $('#searchboxid').select2();
    $('#boxid').select2({
        dropdownParent: $('#moveSpare')
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

    if (boxid == 0) {
        $("#warehouseid").prop( "disabled", false );
        $("#shelfid").prop( "disabled", false );
        $("#compid").prop( "disabled", false );
        $("#warehouseid").val('');
        $("#shelfid").val('');
        $("#compid").val('');
        return;
    }

    var sparepartid = $("#movid").val();
    var movlocationid = $("#movlocationid").val()

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



function populateform(data) {

    $('#active').val(data[0]);
    $('#sparepartid').val(data[1]);
    $('#defvalue').val(data[2]);
    $('#sparepartnb').val(data[2]);
    $('#sparepart').val(data[3]);
    $('#sparenb').val(data[4]);
    $('#minlevel').val(data[5]);
    $('#actlevel').val(data[6]);
    $('#minorderlevel').val(data[7]);
    $('#defsupplierid').val(data[8]);
}



function emptyform() {

    $('#sparepartid').val('-1');
    $('#active').val(1);
    $("#sparepartnb").val(' ');
    $('#defvalue').val(' ');
    $('#sparepart').val(' ');
    $('#sparenb').val(' ');
    $('#minlevel').val(' ');
    $('#actlevel').val(' ');
    $('#minorderlevel').val(' ');
    $('#defsupplierid').val('-1');
}


function save_data() {

    //this is <a> click event:
    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#sparepartid').val();
    var active = $('#active').val();
    var nb = $('#sparepartnb').val();
    var name = $('#sparepart').val();
    var snb = $('#sparenb').val();
    var minlevel = $('#minlevel').val();
    var actlevel = $('#actlevel').val();
    var minorderlevel = $('#minorderlevel').val();
    var defsupplierid = $('#defsupplierid').val();

    var data = {
        id: id,
        active: active,
        nb: nb,
        name: name,
        snb: snb,
        minlevel: minlevel,
        actlevel: actlevel,
        minorderlevel: minorderlevel,
        defsupplierid: defsupplierid,
        item: 'spare'
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


function toggleitem(id) {

    var data = {
        id: id,
        item: 'spare_toggle'
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


function checkdoubles() {

    var name = $('#sparepartnb').val();

    var data = {
        id: name,
        item: 'spare'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/checkitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               $('#editForm').modal('hide');
               $('.warningmsg').html(data["errmsg"]);
               $('#warning').modal('show');
               $('#warningbtn').click(function() {
                   $('#sparepartnb').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });

            }
        },
        failure: function () {
        }
    });
}

function fill_devicelist() {

    var devicedropdown = $("#deviceid");
    var moduledd = $("#moduleid");
    var plantid = $("#plantid").val();

    var data = {
        id: plantid,
        list: 'device_dd'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            devicedropdown.empty();
            devicedropdown.append('<option selected="true" value="-1">--Alle--</option>');
            devicedropdown.prop('selectedIndex', 0);
            $.each(data['device'], function (key, entry) {
                devicedropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
            moduledd.empty();
            moduledd.append('<option selected="true" value="-1">--Alle--</option>');
            moduledd.prop('selectedIndex', 0);
            $.each(data['module'], function (key, entry) {
                moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
        },
        failure: function () {
        }
    });
}

function fill_modulelist() {

    var moduledd = $("#moduleid");
    var deviceid = $("#deviceid").val();

    var data = {
        id: deviceid,
        list: 'module_dd'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            moduledd.empty();
            moduledd.append('<option selected="true" value="-1">--Alle--</option>');
            moduledd.prop('selectedIndex', 0);
            $.each(data, function (key, entry) {
                moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
        },
        failure: function () {
        }
    });
}


function refresh_datatable() {

    $('#searchform').submit();

}

function edit_spare(id) {
    PopupCenter('spare/edit/?partial=yes&id=' + id + '&idx=0','Spareparts', 800, 650);
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

    var warehouseid = $('#searchwarehouseid').val();

    var data = {
        id: id,
        warehouseid: warehouseid,
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
                if (entry.warehouseid == warehouseid) {
                    locationdropdown.append($('<option selected></option>').attr('value', entry.locationid).text(entry.warehouse + ':' + entry.name + '  Verfügbar: ' + parseFloat(entry.act).toFixed(2)));
                } else {
                    locationdropdown.append($('<option></option>').attr('value', entry.locationid).text(entry.warehouse + ':' + entry.name + '  Verfügbar: ' + parseFloat(entry.act).toFixed(2)));
                }
            });

            var firstloc = data["firstloc"];
            if (firstloc.locationid != -1) {
                $("#boxid").val(firstloc.boxid).trigger('change');
            }

            $('#movact').val(parseFloat(0).toFixed(2));
        },
        failure: function () {
        }
    });
    $('#moveSpare').modal('show');


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



function add2cart(id, actval, sparepartnb,sparepart)  {

    $('#id').val(id);
    $('#actval').val(actval);
    $('#sparepartnb').val(sparepartnb);
    $('#sparepart').val(sparepart);
    $('#act').val(1);

    var locationdropdown = $("#locationid");

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


            if (data["cart"].length == 0) {
               $('#shoppingid').val(-1);
               $('#name').val('--Neu--');
            } else {
               $('#shoppingid').val(data["cart"][0].shoppingid);
               $('#name').val(data["cart"][0].name);
            }
        },
        failure: function () {
        }
    });
    $('#editCart').modal('show');

}

function addCartItem()  {

    var shoppingid = $('#shoppingid').val();
    var id = $('#id').val();
    var locationid = $('#locationid').val();
    var act = $('#act').val();


    var data = {
        shoppingid: shoppingid,
        id: id,
        locationid: locationid,
        act: act,
        userid: $('#CurUserID').val(),
        item: 'cartitem'
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


function storespare(id, actval, sparepartnb,sparepart)  {

    $('#stid').val(id);
    $('#stactval').val(actval);
    $('#stsparepartnb').val(sparepartnb);
    $('#stsparepart').val(sparepart);
    $('#stact').val(1);

    var locationdropdown = $("#stlocationid");

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
        },
        failure: function () {
        }
    });
    $('#storeSpare').modal('show');

}

function saveStoreSpare_data() {

    //this is <a> click event:
    if (!$('#formStoreSpare')[0].checkValidity()) {
        $('#formStoreSpare').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#stid').val();
    var locationid = $('#stlocationid').val();
    var act = $('#stact').val();

    var data = {
        id: id,
        locationid: locationid,
        act: act,
        item: 'spare_store'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                $('#storeSpare').modal('hide');
                $('.successmsg').html(data['errmsg']);
                $('#success').modal('show');
            } else {
                $('#storeSpare').modal('hide');
                $('.warningmsg').html(data['errmsg']);
                $('#warningbtn').unbind();
                $('#warningbtn').click(function() {
                    $('#storeSpare').modal('show'); 
                });
                $('#warning').modal('show');
            }
        },
        failure: function () {
        }
    });
}











