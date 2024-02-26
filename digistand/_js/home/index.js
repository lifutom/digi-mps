var dtlist

$(function () {

        /*dtlist = $('#dtlist').DataTable({
            "lengthMenu": [[5], [5]],
            "processing" : true,
            "serverSide" : true,
            "bFilter" : false,
            "bInfo" : false,
            "bPaginate": false,
            "bLengthChange": false,
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

        $('.dataTables_length').addClass('bs-select');   */


        $('#refreshbtn').click(function () {
            location.reload();
        });

        $('#btnReset').click(function () {
            location.reload();
        });

        $('#btnLogout').click(function () {
            location.href=$('#CurRootFile').val() + '/logout.asp'
        });

        $('.search-drowdown').select2();

        $('#plantid').change(function () {
        fillDeviceList();
        });

        $('#deviceid').change(function () {
            fillModuleList();
        });

});

function fillDeviceList() {
    devicedropdown = $('#deviceid');
    var moduledd = $('#moduleid');
    devicedropdown.empty();
    moduledd.empty();
    var plantid=$('#plantid').val();


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
            $.each(data['device'], function (key, entry) {
                devicedropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
            devicedropdown.change();

        },
        failure: function () {

        }
    });
}

function fillModuleList() {

    var devicedropdown = $('#deviceid');
    var moduledd = $('#moduleid');

    var deviceid=devicedropdown.val();
    var plantid=$('#plantid').val();

    var data = {
        id: plantid,
        deviceid: deviceid,
        list: 'stand-module-dd'
    }


    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            moduledd.empty();
            $.each(data['stand-module-dd'], function (key, entry) {
                moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });

        },
        failure: function () {

        }
    });

}


function deleteItem(id) {


    var data = {
        id: id,
        item: 'stand-item'
    }


    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            location.href=$('#CurRootFile').val()+'/home';
        },
        failure: function () {

        }
    });

}


function editItem(id) {

   $('#fillid').val(id);
   $('#appfill').submit();   

}



function addItem() {
    alert('save');
   saveItem($('#id').val());
}

function emptyItemForm() {
    $('#id').val('-1');
    $('#standnb').val('<new>');
    $('#created').val('');
    $('#createdby').val('');
    $('#deviceid').empty();
    $('#moduleid').empty();
    $('#startdate').val('');
    $('#duration').val('');
    $('#description').val('');
    $('#plantid').prop('selectedIndex', 0);
    $('#plantid').change();
}


function lockForm() {

    $('#plantid').prop('disabled', true);
    $('#deviceid').prop('disabled', true);
    $('#moduleid').prop('disabled', true);
    $('#categoryid').prop('disabled', true);
    $('#startdate').prop('readonly', true);
    $('#duration').prop('readonly', true);
    $('#description').prop('readonly', true);
    $('#btnSave').prop('disabled', true);

}


function unlockForm() {

    $('#plantid').prop('disabled', false);
    $('#deviceid').prop('disabled', false);
    $('#moduleid').prop('disabled', false);
    $('#categoryid').prop('disabled', false);
    $('#startdate').prop('readonly', false);
    $('#duration').prop('readonly', false);
    $('#description').prop('readonly', false);
    $('#btnSave').prop('disabled', false);

}

function fillItemForm( data ) {

    //$('#plantid').unbind();
    //$('#deviceid').unbind();

    $('#id').val(data['id']);
    $('#standnb').val(data['standnb']);
    $('#created').val(data['created']);
    $('#createdby').val(data['createdby']);
    $('#description').val(data['description']);
    $('#startdate').val(data['startdate']);
    $('#duration').val(data['duration']);
    var devicedropdown = $('#deviceid');
    var moduledd = $('#moduleid');
    var plantdropdown = $('#plantid');
    var catdropdown = $('#categoryid');

    devicedropdown.empty();
    //devicedropdown.append('<option selected="true" value="-1">--Alle--</option>');
    //devicedropdown.prop('selectedIndex', 0);

    $.each(data['device-list'], function (key, entry) {
        devicedropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
    });
    moduledd.empty();
    //moduledd.append('<option selected="true" value="-1">--Alle--</option>');
    //moduledd.prop('selectedIndex', 0);
    $.each(data['module-list'], function (key, entry) {
        moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
    });
    devicedropdown.val(data['deviceid']).change();
    moduledd.val(data['moduleid']).change();
    plantdropdown.val(data['plantid']).change();
    catdropdown.val(data['categoryid']).change();

    if ($('#CurUserID').val() == data['createdby']) {
        // enable edit mode
       unlockForm();
    } else {
        lockForm();
    }
    /*$('#plantid').change(function () {
        fillDeviceList();
    });
    $('#deviceid').change(function () {
        fillModuleList();
    }); */
}

function updateItemForm( id ) {

    var data = {
        id: id,
        item: 'stillstand-item'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            emptyItemForm();

            $('#btnSave').unbind();
            $('#btnSave').click(function() {
                saveItem(data['id']);
            });

            fillItemForm(data);

            $('#editForm').modal('show')

        },
        failure: function () {

        }
    });
}

function saveItem(id) {

    var data = {
        id: id,
        nb : $('#nb').val(),
        lasteditby : $('#lasteditby').val(),
        plantid : $('#plantid').val(),
        deviceid : $('#deviceid').val(),
        moduleid : $('#moduleid').val(),
        categoryid : $('#categoryid').val(),
        description : $('#description').val(),
        startdate : $('#startdate').val(),
        duration : $('#duration').val(),
        item: 'stillstand-item'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            emptyItemForm();

            $('#btnSave').unbind();
            $('#btnSave').click(function() {
                saveItem(data['id']);
            });

            //fillItemForm(data);

            $('#editForm').modal('hide');
            dtlist.ajax.reload();    


        },
        failure: function () {

        }
    });

}


function ShowItemForm() {



}


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


