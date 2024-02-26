/* Version 1.1:    2020-12-06*/

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
       "order": [[ 8, "desc" ]]
    });
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#plantid').change(function() {
        fill_devicelist();
    });


    $('#searchlink').click(function() {
       refresh_datatable();
    });

    $('#delfilter').click(function() {
        $("#todo").val('del');
        refresh_datatable();
    });

    $('#dtslist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        openOrderProp(data);
    });

});

function fill_devicelist() {

    var devicedropdown = $("#deviceid");
    var moduledropdown = $("#moduleid");
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

            moduledropdown.empty();
            moduledropdown.append('<option selected="true" value="-1">--Alle--</option>');
            moduledropdown.prop('selectedIndex', 0);
            $.each(data['module'], function (key, entry) {
                moduledropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
        },
        failure: function () {
        }
    });
}

function refresh_datatable() {

    $('#searchform').submit();

}



function openOrderProp(idata) {


    if (idata[11] > 0) {
        return;
    }

    var supplierdropdown = $("#ordsupplierid");
    var idata = {
        id: idata[0],
        list: 'orderprop_item'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: idata,
        success: function (data) {
            data = JSON.parse(data);

            $('#ordid').val(data['orderid']);
            $('#ordactval').val(parseFloat(data['act']).toFixed(2));
            $('#ordsparepartid').val(data['sparepartid']);
            $('#ordsparepartnb').val(data['sparepartnb']);
            $('#ordsparepart').val(data['sparepart']);
            $('#ordact').val(parseFloat(data['orderqty']).toFixed(2));

            supplierdropdown.empty();
            $.each(data["suppliers"], function (key, entry) {
                supplierdropdown.append($('<option></option>').attr('value', entry.supplierid).text(entry.name + ' BestNr: ' + entry.nb + '  Preis: ' + parseFloat(entry.price).toFixed(2)));
            });
            supplierdropdown.val(data['supplierid']);
            $('#orderSpare').modal('show');
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
    var sparepartid = $('#ordsparepartid').val();

    var data = {
        id: id,
        sparepartid: sparepartid,
        act : act,
        supplierid: supplierid,
        item: 'ordereditspare'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               refresh_datatable();
            }
        },
        failure: function () {
        }
    });
}

function deleteItemQue(id) {

    $('#decisionbtn').click({id: id}, deleteItem);

    $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#decision').modal('show');

}



function deleteItem (event) {

    var data = {
        id: event.data.id,
        item: 'orderprop'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                refresh_datatable();
            }
        },
        failure: function () {

        }
    });
}




