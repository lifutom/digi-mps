/* version v1.4 */

var dtlist;

$(function () {

    Date.prototype.toDateInputValue = (function() {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0,10);
    });


    $('#addbtn').click(function () {        
        emptyform();    
        $('#editForm').modal('show');
    });

    $('#dateid').val(new Date().toDateInputValue());

    var data = {
        fu: 'list'
    }
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/safety.asp",
        data: data,
        //dataType: 'json',
        success: function (data) {

            data = JSON.parse(data);

            dtlist = $('#dtlist').DataTable({
                data: data,
                columns: [
                    {
                        'data' : 'safetyid',
                        'visible' : false
                    },
                    {'data' : 'dateid'},
                    {
                        'data' : 'departmentid',
                        'visible' : false
                    },
                    {'data' : 'department'},
                    {'data' : 'accidentcnt'},
                    {'data' : 'nearaccidentcnt'},
                    {'data' : 'incidentcnt'},
                    {'data' : 'lastedit'},
                    {'data' : 'userid'},
                    {
                      'data' : 'safetyid',
                      'render' : function(data,type,row) {
                          return '<a href="javascript:delete_item(\'' + data + '\')" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>';
                      }
                    }
                ],
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
               "ordering" : true,
               "order": [[ 1, 'desc' ],[3,'asc']]
            });
            myTable = dtlist;
            $('.dataTables_length').addClass('bs-select');
            $('#dtlist tbody').on('dblclick', 'tr', function (e) {

                var data = dtlist.row( this ).data();
                populateform(data);
                $('#editForm').modal('show');

            });

            $('#dtlist .deletelink').on('click', function () {

                var td = $(this).parent();
                var tr = td.parent();

                var data = dtlist.row( tr ).data();

                $('#decisionbtn').click({id: data['safetyid']}, function (e) {
                    delete_item(e.data.id);
                });
                $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
                $('#decision').modal('show');
                return false;

            });

        },
        failure: function () {
        }
    });

});

function populateform(data) {

    $('#safetyid').val(data['safetyid']);
    $('#dateid').val(data['dateid']);
    $('#departmentid').val(data['departmentid']);
    $('#accidentcnt').val(data['accidentcnt']);
    $('#nearaccidentcnt').val(data['nearaccidentcnt']);
    $('#incidentcnt').val(data['incidentcnt']);

    var nmDate = new Date($('#dateid').val());
    var nmChkDate = new Date('2020-06-08');
    $('#goodcatch').show();
    /*if (nmDate < nmChkDate) {
        $('#goodcatch').show();
    } else {
        $('#goodcatch').hide();
    } */

}



function emptyform() {

    $('#safetyid').val('');
    $('#dateid').val(new Date().toDateInputValue());
    $('#departmentid').val($('#userdepartmentid').val());
    $('#accidentcnt').val('');
    $('#nearaccidentcnt').val('');
    $('#incidentcnt').val('');
    //$('#goodcatch').hide();
    $('#goodcatch').show();

}

function save_data() {

    //this is <a> click event:
    if (!$('#eForm')[0].checkValidity()) {
        $('#eForm').find('input[type="submit"]').click();

        return false;
    }
    var id = $('#safetyid').val();
    var dateid = $('#dateid').val();
    var departmentid = $('#departmentid').val();
    var accidentcnt = $('#accidentcnt').val();

    var nmDate = new Date($('#dateid').val());
    var nmChkDate = new Date('2020-06-08');

    if (nmDate < nmChkDate) {
	var nearaccidentcnt = $('#nearaccidentcnt').val();
    } else {	
    	var nearaccidentcnt = 0;
    }
    var incidentcnt = $('#incidentcnt').val();

    var data = {
        id: id,
        dateid: dateid,
        departmentid: departmentid,
        accidentcnt: accidentcnt,
        nearaccidentcnt: nearaccidentcnt,
        incidentcnt: incidentcnt,
        item: 'tier1_safety'
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


function delete_item(id) {

    var data = {
        id: id,
        item: 'tier1_safety'
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





