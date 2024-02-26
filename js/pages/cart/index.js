$(function () {

    var dtuserlist = $('#dtlist').DataTable({
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
       "order": [[ 2, "desc" ]]
    });
    myTable = dtuserlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtuserlist.row( this ).data();
        openCart(data[0]);
    });

    $('#addbtn').click(function () {
        $('#editForm').on('show.bs.modal', function () {
            //emptyform();
        });
        $('#editForm').modal('show');
    });
});


function deleteCartQue (id) {


    $('#decisionbtn').click({id: id}, deleteCart);

    $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#decision').modal('show');

}

function deleteCart (event) {

    var data = {
        id: event.data.id,
        item: 'cart'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href='/digiadmin/cart';
            }
        },
        failure: function () {

        }
    });
}

function openCart(id) {

    $('#id').val(id);
    $('#frmcart').submit();

}


