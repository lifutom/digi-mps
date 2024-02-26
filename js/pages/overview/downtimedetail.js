$(function () {

    var myVar = setInterval(updatelist, 5000);

    /*$('#dtdowntime thead tr').clone(true).appendTo( '#dtdowntime thead' );
    $('#dtdowntime thead tr:eq(1) th').each( function (i) {
        var title = $(this).text();
        $(this).html( '<input type="text" placeholder="Search '+title+'" />' );

        $( 'input', this ).on( 'keyup change', function () {
            if ( table.column(i).search() !== this.value ) {
                table
                    .column(i)
                    .search( this.value )
                    .draw();
            }
        } );
    } );

    var dtdowntime = $('#dtdowntime').DataTable({
           "processing": true,
           "serverSide": true,
           "ajax": {
                "url": $('#CurRootFile').val() + "/ajax/downtime.asp",
                "type": "POST",
                "data" :
           },
           "orderCellsTop": true,
           "fixedHeader": true,
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
           "order": [[ 1, "desc" ]]
        });
        $('.dataTables_length').addClass('bs-select');
});


function updatelist () {

    if (!$('#auto').is(':checked')) {
        return;
    } else {
        window.location.href = $('#CurRootFile').val() + '/overview/downtimebyid/?partial=yes&id=' + $('#prodid').val() + '&auto=true';
    }

}
