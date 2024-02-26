/* Version 1.0:  2020-12-09 */


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
       "order": [[ 2, "asc" ]]
    });
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#plantid').change(function() {
        fill_devicelist();
    });

    $('#deviceid').change(function() {
        fill_modulelist();
    });

    $('#searchlink').click(function() {
       refresh_datatable();
    });

    $('#delfilter').click(function() {
        $('#plantid').prop('selectedIndex', 0);
        $('#srcsupplierid').prop('selectedIndex', 0);
        $('#catid').prop('selectedIndex', 0);
        $('#deviceid').empty();
        $("#deviceid").append('<option selected="true" value="-1">--Alle--</option>');
        $('#searchwarehouseid').prop('selectedIndex', 0);
        $('#start').val('');
        $('#end').val('');
       
        var moduledd = $("#moduleid");
        var data = {
            id: -1,
            list: 'module_list'
        }

        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/getlist.asp",
            data: data,
            success: function (data) {
                data = JSON.parse(data);
                moduledd.empty();
                moduledd.append('<option selected="true" value="-1">--Alle--</option>');
                $.each(data['module_list'], function (key, entry) {
                    moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
                });
                moduledd.prop('selectedIndex', 0);
            },
            failure: function () {
            }
        });
    });

});

function fill_devicelist() {

    var devicedropdown = $("#deviceid");
    var moduledd = $("#moduleid");
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
            moduledd.empty();
            moduledd.append('<option selected="true" value="-1">--Alle--</option>');
            moduledd.prop('selectedIndex', 0);
            $.each(data['module'], function (key, entry) {
                moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
        },
        failure: function () {
        }
    });
}

function fill_modulelist() {

    var moduledd = $("#moduleid");
    var deviceid = $("#deviceid").val();

    var data = {
        id: deviceid,
        list: 'module_dd'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            moduledd.empty();
            moduledd.append('<option selected="true" value="-1">--Alle--</option>');
            moduledd.prop('selectedIndex', 0);
            $.each(data, function (key, entry) {
                moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
        },
        failure: function () {
        }
    });
}


function refresh_datatable() {

    $('#searchform').submit();

}















