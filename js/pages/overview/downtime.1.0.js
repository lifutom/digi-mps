$(function () {


    var dtlist = $('#dtdowntime').DataTable({
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
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#searchlink').click(function() {
       refresh_datatable();
    });

    $('#delfilter').click(function() {
        $('#plantid').prop('selectedIndex', 0);
        $('#deviceid').prop('selectedIndex', 0);
        $('#start').val('');
        $('#end').val('');
        $('#batch').val('');
        $('#uin').val('');
    });

    $('#plantid').change(function() {
        fill_devicelist();
    });

    $('#dtdowntime tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        PopupCenter('overview/downtimeedit/?partial=yes&id=' + data[0] + '&idx=' + dtlist.row( this ).index(),'Downtimes', 800, 650);
    });

})

function fill_devicelist() {

    var devicedropdown = $("#deviceid");
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
            $.each(data, function (key, entry) {
                devicedropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
        },
        failure: function () {
        }
    });
}

function refresh_datatable() {

    $('#searchform').submit();

}

function find_row(id) {

    location.reload();
    var dtlist = $('#dtdowntime');
    dtlist.rows(id).select();
}

function deleteDTQue (id) {


    $('#decisionbtn').click({id: id}, deleteDT);

    $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#decision').modal('show');

}

function deleteDT (event) {

    var data = {
        id: event.data.id,
        item: 'downtime'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.reload();
            }
        },
        failure: function () {

        }
    });
}