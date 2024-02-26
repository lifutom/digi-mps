/* Version 1.1:  2020-12-14*/ 
/* Version 1.0*/

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
        populateform(data);
        $('#edittask').modal('show');
    });

    $('#assignedto').select2();

    $('#cmdresetfilter').click(function(){
        $('#typ').val(-1);
        $('#tstate').val(3);
        $('#assignedto').val('').trigger('change');
        $('#tdatefrom').val('');
        $('#tdateto').val('');
        $('#nearnb').val('');
        $('#ttasknb').val('');
    });
});


function populateform(data) {

    $('#taskid').val(data[0]);
    $('#nearid').val(data[1]);
    $("#tasktypeid").val(data[2]);
    $('#rstate').val(data[3]);
    $('#tasknb').val(data[4]);
    $('#description').val(data[6]);
    $('#created').val(data[7]);
    $('#tassignedto').val(data[9]);
    $('#duedate').val(data[12]);
    $('#comments').val(data[13]);

}

function viewnearMiss(id) {
    PopupInTab('near/view/?partial=yes&id=' + id + '&idx=0');
}

