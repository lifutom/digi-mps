$(function () {
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


    $('#supplierid').change(function() {
        filldetail();
    });

    opener.location.reload();

});


function filldetail() {

    var supplierid = $("#supplierid").val();
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
            table.column(3).visible(false);


            $.each(data["details"], function (key, entry) {

                var chkBox;
                var EditBox;
                chkBox = '<div class="text-center custom-control custom-checkbox"><input type="checkbox" class="custom-control-input" name="orderid" id="orderid_' + entry.orderid.toString() + '" value="' +  entry.orderid.toString() + '" checked><label class="custom-control-label" for="orderid_' + entry.orderid.toString() +'"></label></div>';
                EditBox = '<input name="qty_' + entry.orderid.toString() + '" id="qty_' + entry.orderid.toString() + '" type="number" value="' + entry.orderqty.toString() + '" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" required></input>';

                var row = $('#dtlist').DataTable().row.add([chkBox, entry.detailid, entry.orderid, entry.sparepartid, entry.suppliernb, entry.sparepartnb, entry.sparepart, EditBox,'']).draw(false).node();
            });
        },
        failure: function () {
        }
    });
}