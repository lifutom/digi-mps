$(function () {

    var tblPlant = $('#dtplant').DataTable({
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
       "order": [[ 5, "desc" ]]
    });
    $('.dataTables_length').addClass('bs-select');

    /*$('#dtplant tbody').on('dblclick', 'tr', function () {
        var data = tblPlant.row( this ).data();
        var param = { 'id' : data[0]};
          OpenWindowWithPost($('#CurRootFile').val() + '/overview/downtimepost/?partial=yes',
          "width=730,height=345,left=100,top=100,resizable=yes,scrollbars=yes",
          "Downtimes", param);
        window.open($('#CurRootFile').val() + '/overview/downtimebyid/?partial=yes&id=' + data[0], 'Downtimes','width=800,height=700,left=50,top=300,resizable=yes,scrollbars=yes');
        PopupCenter('overview/downtimebyid/?partial=yes&id=' + data[0],'Downtimes', 800, 650);
    });
    */

    $('#delfilter').click(function() {
        $('#plantid').prop('selectedIndex', 0);
        $('#start').val('');
        $('#end').val('');
        $('#batch').val('');
        $('#uin').val('');
    });

    $('#searchlink').click(function() {
       refresh_datatable();
    });

    $('#dtplant tbody').on('dblclick', 'tr', function () {
        var data = tblPlant.row( this ).data();
        PopupCenter('overview/productionedit/?partial=yes&id=' + data[0] + '&idx=' + tblPlant.row( this ).index(),'Production', 800, 600);
    });


});

function refresh_datatable() {

    $('#searchform').submit();

}

function find_row(id) {

    location.reload();
    var dtlist = $('#dtplant');
    dtlist.rows(id).select();
}


