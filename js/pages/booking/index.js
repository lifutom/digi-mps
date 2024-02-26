/* Version 1.1 : 2020-12-06 */

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
       "order": [[ 7, "desc" ]]
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


