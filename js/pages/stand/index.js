/* Version: 1.0: 2023-04-05 */

var dtlist;
var finit;

$(function () {

        finit=false;

        dtlist = $('#dtlist').DataTable({
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
            "pagingType": "full_numbers",
            "processing" : true,
            "serverSide" : true,
            "ajax" : {
                        type: "POST",
                        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
                        data: function(d) {
                            d.plantid = $('#search_plantid').val();
                            d.deviceid = $('#search_deviceid').val();
                            d.moduleid= $('#search_moduleid').val();
                            d.categoryid = $('#search_categoryid').val();
                            d.datefrom = $('#datefrom').val();
                            d.dateto = $('#dateto').val();
                            d.list = 'stand-list';
                        },
                     },
            "columns" : [
                    {
                        data: 'id',
                        visible: false
                    },
                    {
                        data: 'line',
                    },
                    {
                        data: 'plant',
                    },
                    {
                        data: 'module',
                    },
                    {
                        data: 'category',
                    },
                    {
                        data: 'startdate',
                    },
                    {
                        data: 'duration',
                    },
                    {
                        data: 'createdby',
                    },
                    {
                        data: 'description',
                    },
                    {
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return row.id;
                            }
                            if ($('#CurUserID').val() == row.createdby || $('#CurUserID').val() == 'True' || $('#CurUserID').val() == $('#SysAdm').val()) {
                                return '<i class="far fa-edit btnedit"></i>&nbsp;<i class="fas fa-trash-alt btndel"></i>';
                            } else {
                               return '<i class="fas fa-eye btnview"></i>';
                            }
                        }
                    }
            ],
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

        $('#dtlist tbody').on('dblclick', 'tr', function () {
            var data = dtlist.row( this ).data();
            updateItemForm(data['id']);
        });


        $('#dtlist tbody').on('click', '.btnedit', function () {

            var data = dtlist.row( $(this).parents('tr') ).data();
            updateItemForm(data['id']);
        });

        $('#dtlist tbody').on('click', '.btnview', function () {

            var data = dtlist.row( $(this).parents('tr') ).data();
            updateItemForm(data['id']);
        });

        $('#dtlist tbody').on('click', '.btndel', function () {

            var data = dtlist.row( $(this).parents('tr') ).data();
            //alert('del: ' + data['id']);

            $('.decisionmsg').html('Wollen Sie den Eintrag<br>' + data['line'] + '/' + data['plant'] + '/' + data['module'] + '/' + data['category'] + '<br>löschen')

            $('#decisionbtn').unbind();

            $('#decisionbtn').click(function() {
                deleteItem(data['id']);
            });
            $('#decision').modal('show');


        });


        $('#refreshbtn').click(function () {
            location.href=$('#CurRootFile').val() + '/stand';
        });

        $('#addbtn').click(function () {
            addItem();
        });

        $('.search-drowdown').select2({
            dropdownParent: $('#editForm')
        });

        $('.search-drowdown-index').select2();

        $('#plantid').change(function () {
            if ($('#plantid').val() != '' && !finit) {
                fillDeviceList('', $('#plantid').val(), this.value);
            }
        });

        $('#deviceid').change(function () {
            if ($('#deviceid').val() != '' && !finit) {
                fillModuleList('',$('#deviceid').val());
            }
        });

        $('#search_plantid').change(function () {
            if ($('#search_plantid').val() != '') {
                fillDeviceList('search_', $('#search_plantid').val());
            }
            dtlist.ajax.reload();
        });

        $('#search_deviceid').change(function () {
            if ($('#search_deviceid').val() != '') {
                fillModuleList('search_',$('#search_deviceid').val());
            }
            dtlist.ajax.reload();
        });

        $('#search_moduleid').change(function () {
            dtlist.ajax.reload();
        });

        $('#search_categoryid').change(function () {
            dtlist.ajax.reload();
        });

        $('#datefrom').change(function () {
            dtlist.ajax.reload();
        });

        $('#dateto').change(function () {
            dtlist.ajax.reload();
        });


});

function fillDeviceList(fld,id) {

    //alert('fill-device');

    devicedropdown = $('#' + fld + 'deviceid');
    var moduledd = $('#' + fld + 'moduleid');
    var plantid=$('#' + fld + 'plantid').val();

    var data = {
        id: id,
        list: 'device_dd'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            devicedropdown.find('option').remove().end();
            devicedropdown.append($('<option></option>').attr('value', '').text('-- Auswahl --'));
            $.each(data['device'], function (key, entry) {
                devicedropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });

        },
        failure: function () {

        }
    });
}

function fillModuleList(fld, id) {


    var moduledd = $('#' + fld + 'moduleid');

    var deviceid=id;
    var plantid=$('#' + fld + 'plantid').val();

    var data = {
        id: plantid,
        deviceid: id,
        list: 'stand-module-dd'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            moduledd.find('option').remove().end();
            moduledd.append($('<option></option>').attr('value', '').text('-- Auswahl --'));
            $.each(data['stand-module-dd'], function (key, entry) {
                moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });

        },
        failure: function () {

        }
    });

}



function addItem() {
    emptyItemForm();
    $('#createdby').val($('#CurUserID').val());

    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
    $('#created').val(today);
    unlockForm();
    $('#btnSave').unbind();
    $('#btnSave').click(function() {
        saveItem($('#id').val());
    });
    $('#editForm').modal('show')
}

function emptyItemForm() {
    $('#id').val('-1');
    $('#standnb').val('<new>');
    $('#created').val('');
    $('#createdby').val('');
    $('#deviceid').empty();
    $('#moduleid').empty();
    $('#startdate').val('');
    $('#durationmin').val('0');
    $('#durationhour').val('0');
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
    $('#description').prop('readonly', true);
    $('#btnSave').prop('disabled', true);
    $('#durationmin').prop('disabled', true);
    $('#durationhour').prop('disabled', true);

}


function unlockForm() {

    $('#plantid').prop('disabled', false);
    $('#deviceid').prop('disabled', false);
    $('#moduleid').prop('disabled', false);
    $('#categoryid').prop('disabled', false);
    $('#startdate').prop('readonly', false);
    $('#description').prop('readonly', false);
    $('#btnSave').prop('disabled', false);
    $('#durationmin').prop('disabled', false);
    $('#durationhour').prop('disabled', false);

}

function fillItemForm( data ) {

    //$('#plantid').unbind();
    //$('#deviceid').unbind();

    finit = true;

    $('#id').val(data['id']);
    $('#standnb').val(data['standnb']);
    $('#created').val(data['created']);
    $('#createdby').val(data['createdby']);
    $('#description').val(data['description']);
    $('#startdate').val(data['startdate']);
    $('#durationmin').val(data['durationmin']);
    $('#durationhour').val(data['durationhour']);
    $('#plantid').val(data['plantid']);
    $('#plantid').change();

    var devicedropdown = $('#deviceid');
    var moduledd = $('#moduleid');
    var catdropdown = $('#categoryid');


    devicedropdown.find('option').remove().end();
    devicedropdown.append('<option selected="true" value="-1">--Alle--</option>');
    $.each(data['device-list'], function (key, entry) {
        devicedropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
    });
    devicedropdown.val(data['deviceid']);

    moduledd.find('option').remove().end();
    moduledd.append('<option selected="true" value="-1">--Alle--</option>');
    $.each(data['module-list'], function (key, entry) {
        moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
    });

    moduledd.val(data['moduleid']);

    /*devicedropdown.find('option').remove().end();
    devicedropdown.append('<option selected="true" value="-1">--Alle--</option>');
    $.each(data['device-list'], function (key, entry) {
        devicedropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
    });

    alert(moduledd.val());

    devicedropdown.val(data['deviceid']);
    devicedropdown.trigger('change');



    moduledd.find('option').remove().end();
    moduledd.append('<option selected="true" value="-1">--Alle--</option>');
    $.each(data['module-list'], function (key, entry) {
        moduledd.append($('<option></option>').attr('value', entry.value).text(entry.name));
    });

    alert(moduledd.val());

    moduledd.val(data['moduleid']);
    //moduledd.trigger('change');

     */
    catdropdown.val(data['categoryid']).change();

    if ($('#CurUserID').val() == data['createdby'] || $('#CurUserID').val() == 'True' || $('#CurUserID').val() == $('#SysAdm').val()) {
        // enable edit mode
       unlockForm();
    } else {
        lockForm();
    }
    finit = false;
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
        lasteditby : $('#CurUserID').val(),
        plantid : $('#plantid').val(),
        deviceid : $('#deviceid').val(),
        moduleid : $('#moduleid').val(),
        categoryid : $('#categoryid').val(),
        description : $('#description').val(),
        startdate : $('#startdate').val(),
        durationmin : $('#durationmin').val(),
        durationhour : $('#durationhour').val(),
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


function deleteItem(id) {

    var data = {
        item : 'stand-item',
        id: id,
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
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


