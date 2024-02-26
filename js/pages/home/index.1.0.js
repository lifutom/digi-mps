$(function () {
        var tblPlant = $('#dtplant').DataTable({
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
           }
        });

        var tblDowneTime = $('#dtdowntime').DataTable({
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
           }
        });
        $('.dataTables_length').addClass('bs-select');

        $('#dtplant tbody').on('dblclick', 'tr', function () {
            var data = tblPlant.row( this ).data();
            PopupCenter('overview/downtimebyid/?partial=yes&id=' + data[0],'Downtimes', 1024, 680);
        });

        $('#dtplant tbody').on('click', 'tr', function () {
            var data = tblPlant.row( this ).data();
            tblDowneTime.clear();
            PopulateDownTimeTable(tblDowneTime, data[0]);
            $('.actproduction').html(data[1] + ' UIN:' + data[2] + ' Batch:' + data[3]);

        });
        $('#dtdowntime tbody').on('click', 'tr', function () {
            var data = tblDowneTime.row( this ).data();
        });


});


function PopulateDownTimeTable(myTable, id) {

        var data = {
            list : 'downbyprodid',
            id : id
        }

        $.ajax({
            type: "POST",
            url: "ajax/getlist.asp",
            data: data,
            success: function (data) {
                var jsonObject = JSON.parse(data);
                var result = jsonObject.map(function (item) {
                    var result = [];
                    result.push(item.status);
                    result.push(item.start_time);
                    result.push(item.end_time);
                    result.push(item.controlid);
                    result.push(item.device);
                    result.push(item.component);
                    result.push(item.failure);
                    result.push(item.minutesdowntime);
                    result.push(item.downtimeid);
                    return result;
                });
                myTable.rows.add(result);
                myTable.column(8).visible(false);
                myTable.draw();
            },
            failure: function () {
                myTable.append(" Error when fetching data please contact administrator");
            }
        });
    }


