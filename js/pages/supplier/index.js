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
       "order": [[ 2, "asc" ]]
    });
    myTable = dtlist;
    $('.dataTables_length').addClass('bs-select');

    $('#dtlist tbody').on('dblclick', 'tr', function () {
        var data = dtlist.row( this ).data();
        if (data[3] != SysAdm) {
           populateform(data);
           $('#editForm').modal('show');
        }
    });

    $('#addbtn').click(function () {
        $('#editForm').on('show.bs.modal', function () {
            emptyform();
        });
        $('#editForm').modal('show');
    });

    $('#sitename').change(function() {
        checkdoubles();
    });

});

function populateform(data) {


    $('#active').val(data[0]);
    $('#supplierid').val(data[1]);
    $('#name').val(data[2]);
    $('#defvalue').val(data[2]);
    $('#country').val(data[3]);
    $('#zip').val(data[4]);
    $('#city').val(data[5]);
    $('#street').val(data[6]);
    $('#phone').val(data[7]);
    $('#mobile').val(data[8]);
    $('#maincontact').val(data[9]);
    $('#email').val(data[10]);
}



function emptyform() {

    $('#supplierid').val('-1');
    $('#active').val(1);
    $("#name").val('');
    $('#defvalue').val('');
    $('#country').val('');
    $('#zip').val('');
    $('#city').val('');
    $('#street').val('');
    $('#phone').val('');
    $('#mobile').val('');
    $('#maincontact').val('');
    $('#email').val('');
}


function save_data() {

    //this is <a> click event:
    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    var id = $('#supplierid').val();
    var name = $('#name').val();
    var active = $('#active').val();
    var country = $('#country').val();
    var zip = $('#zip').val();
    var city = $('#city').val();
    var street = $('#street').val();
    var phone = $('#phone').val();
    var mobile = $('#mobile').val();
    var maincontact = $('#maincontact').val();
    var email = $('#email').val();

    var data = {
        id: id,
        name: name,
        active: active,
        country: country,
        zip: zip,
        city: city,
        street: street,
        phone: phone,
        mobile: mobile,
        maincontact: maincontact,
        email: email,
        item: 'supplier'
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


function toggleitem(id) {

    var data = {
        id: id,
        item: 'supplier_toggle'
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


function checkdoubles() {

    var name = $('#name').val();

    var data = {
        id: name,
        item: 'supplier'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/checkitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               $('#editForm').modal('hide');
               $('.warningmsg').html(data["errmsg"]);
               $('#warning').modal('show');
               $('#warningbtn').click(function() {
                   $('#sitename').val($('#defvalue').val());
                   $('#editForm').modal('show');
               });

            }
        },
        failure: function () {
        }
    });
}



