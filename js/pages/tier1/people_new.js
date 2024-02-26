var dtpeoplelist;

$(function () {

    Date.prototype.toDateInputValue = (function() {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0,10);
    });


    $('#addbtn').click(function () {
        $('#editForm').on('show.bs.modal', function () {
            emptyform();
        });
        $('#editForm').modal('show');
    });

    $('#dateid').val(new Date().toDateInputValue());


    dtpeoplelist = $('#dtpeoplelist').DataTable({
        processing: true,
        serverSide: true,
        rowId : 'peopleid',
        ajax: {
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/people.asp",
            'data': function (data) {
               //console.log(data);
               return data = JSON.stringify(data);
             },
        },
           //dataSrc: '',
        columns: [
            {
                'data' : 'peopleid',
                'visible' : false
            },
            {'data' : 'dateid'},
            {'data' : 'employeecnt'},
            {'data' : 'sickcnt'},
            {
                'data' : 'departmentid',
                'visible' : false
            },
            {'data' : 'department'},
            {'data' : 'lastedit'},
            {'data' : 'userid'},
            {
              'data' : 'peopleid',
              'render' : function(data,type,row) {
                  return '<a href="javascript:delete_item(\'' + data + '\')" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>';
              }
            }
        ],
       "lengthMenu": [[5,10, 25, 50, -1], [5,10, 25, 50, "Alle"]],
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
       "order": [[ 1, "asc" ]]
    });
    myTable = dtpeoplelist;
    $('.dataTables_length').addClass('bs-select');
    $('#dtpeoplelist tbody').on('dblclick', 'tr', function (e) {

        var data = dtpeoplelist.row( this ).data();
        populateform(data);
        $('#editForm').modal('show');

    });

    $('#dtpeoplelist .deletelink').on('click', function () {

        var td = $(this).parent();
        var tr = td.parent();

        var data = dtpeoplelist.row( tr ).data();

        $('#decisionbtn').click({dateid: data[0], departmentid: data[3]}, function (e) {
            delete_item(e.data.dateid, e.data.departmentid);
        });
        $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
        $('#decision').modal('show');
        return false;

    });

});

function populateform(data) {

    $('#peopleid').val(data['peopleid']);
    $('#dateid').val(data['dateid']);
    $('#departmentid').val(data['departmentid']);
    //$("#departmentid").prop('disabled', 'disabled');
    $('#employeecnt').val(data['employeecnt']);
    $('#sickcnt').val(data['sickcnt']);

}



function emptyform() {

    $('#peopleid').val('');
    $('#dateid').val(new Date().toDateInputValue());
    $('#departmentid').val('');
    //$("#departmentid").removeAttr("disabled");
    $('#employeecnt').val('');
    $('#sickcnt').val('');

}

function save_data() {

    //this is <a> click event:
    if (!$('#peopleform')[0].checkValidity()) {
        $('#peopleform').find('input[type="submit"]').click();
        return false;
    }

    var peopleid = $('#peopleid').val();
    var dateid = $('#dateid').val();
    var departmentid = $('#departmentid').val();
    var employeecnt = $('#employeecnt').val();
    var sickcnt = $('#sickcnt').val();

    var data = {
        id: peopleid,
        dateid: dateid,
        departmentid: departmentid,
        employeecnt: employeecnt,
        sickcnt: sickcnt,
        item: 'tier1_people'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
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


function delete_item(peopleid) {

    var data = {
        id: peopleid,
        item: 'tier1_people'
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





