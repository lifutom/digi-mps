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
       "order": [[ 1, "desc" ]]
    });

    initDetailTable();



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

    $('#addbtn').click(function() {
        /*$("#quotesupplierid").val('');
        $('#dtlist').DataTable().clear().draw();
        $('#quoteWindow').modal('show');*/
        PopupCenter('order/edit/?partial=yes&id=0&idx=0','Spareparts', 800, 650);
    });

    $('#supplierid').change(function() {
        filldetail();
    });

});


function initDetailTable() {

    var detaillist = $('#dtlist').DataTable({
       "lengthMenu": [[5,10, -1], [5,10, "Alle"]],
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

       columnDefs: [{
          orderable: false,
          targets: 0
        }],
       "order": [[ 2, "asc" ]]
    });
    $('#dtlist').mdbEditor({
        contentEditor: true
    });
    $('.dataTables_length').addClass('bs-select');

}


function refresh_datatable() {

    $('#searchform').submit();
}



function filldetail() {

    var supplierid = $("#quotesupplierid").val();
    var table = $('#dtlist').DataTable();

    var data = {
        id: supplierid,
        list: 'orderprop_open'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            table.clear().draw();
            //table.column(0).visible(false);
            table.column(1).visible(false);
            table.column(2).visible(false);

            $.each(data["details"], function (key, entry) {

                var chkBox;

                chkBox = '<div class="text-center custom-control custom-checkbox"><input type="checkbox" class="custom-control-input" name="orderid" id="orderid_' + entry.orderid.toString() + '" value="' +  entry.orderid.toString() + '" checked><label class="custom-control-label" for="orderid_' + entry.orderid.toString() +'"></label></div>';

                var row = $('#dtlist').DataTable().row.add([chkBox, entry.orderid, entry.sparepartid, entry.suppliernb, entry.sparepartnb, entry.sparepart, entry.orderqty,'']).draw(false).node();
            });

            $('#dtlist').mdbEditor({
                contentEditor: true
            });

            $('#quoteWindow').modal('show');
        },
        failure: function () {
        }
    });
}



function openOrderProp(idata) {

    if (idata[10] == 2) {
        PopupCenter('order/edit/?partial=yes&id=' + idata[0].toString() + '&idx=0','Spareparts', 900, 750);
    }

}


function save_data() {

    //this is <a> click event:
    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#id').val();
    var supplierid = $('#quotesupplierid').val();
    var quotedate = $('#quotedate').val();

    var orderid = [];

    $('input[name=orderid]:checked').each(function () {
            orderid.push(this.value);
    });

    var data = {
        id: id,
        supplierid: supplierid,
        orderid: orderid.toString(),
        item: 'quote_edit'
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

    $('#decisionbtn').unbind();
    $('#decisionbtn').click({id: id}, deleteItem);

    $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#decision').modal('show');

}



function deleteItem (event) {

    location.href=$('#CurRootFile').val() + "/order/delete?id=" + event.data.id;

}


function createOrderQue(id) {

    $('#decisionbtn').unbind();
    $('#decisionbtn').click({id: id}, createOrder);

    $('.decisionmsg').html('Bestellung durchführen?');
    $('#decision').modal('show');

}


function createOrder(event)  {

    location.href=$('#CurRootFile').val() + "/order/createorder?id=" + event.data.id;

}


function orderReceipt (idata) {

    PopupCenter('order/receipt/?partial=yes&id=' + idata + '&idx=0','Bestelleingang', 1024, 750);

}






