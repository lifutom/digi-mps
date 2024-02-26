/* Version 1.2:  2020-12-11 */
/* Version 1.1:  2020-12-11 */
/* Version 1.0 */

$(function () {

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
       "order": [[ 1, "desc" ]]
    });
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        viewNear(data[0]);
    });

    $('#regionid').select2();
    $('#assignedtosvp').select2();

    $('#cmdresetfilter').click(function(){
        $('#typ').val(-1);
        $('#state').val(3);
        $('#buildingid').val(-1);
        $('#assignedtosvp').val('').trigger('change');
        $('#regionid').val('-1').trigger('change');
        $('#datefrom').val('');
        $('#dateto').val('');
        $('#nearnb').val('');
        $('#istarget0').prop('checked', false);

    });




});

function viewNear(id) {
    PopupInTab('near/view/?partial=yes&id=' + id + '&idx=0');
}




