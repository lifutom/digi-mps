/* Version 1.0 */
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
    
    if ($('#resfresh').val() == 1)
    {
        opener.location.reload();
    }

});


function createBookQue() {



    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    $('#question-ok').unbind();
    $('#question-ok').click(createBook);

    $('.question-info').html('Eingänge buchen?');
    $('#question').modal('show');

}


function createBook() {

    $('#form')[0].action=$('#CurRootFile').val() + '/order/receiptpost';
    $('#resfresh').val(1);
    $('#form')[0].submit();

}