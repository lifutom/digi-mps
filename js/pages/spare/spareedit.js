/*  Version 1.4:   2021-02-04 */ 
/*  Version 1.3:   2020-12-06 */
/*  Version 1.2:   2020-12-01 */
/*  Version 1.1:   2020-11-23 */

var activetab;

$(function () {

    var tbllocation = $('#tbllocation').DataTable({
       "bFilter" : false,
       "paging" : false,
       "ordering" : false,
       "info" : false,
    });
    var tblsupplier = $('#tblsupplier').DataTable({
       "bFilter" : false,
       "paging" : false,
       "ordering" : false,
       "info" : false,
    });
    var tbllink = $('#tbllink').DataTable({
       "bFilter" : false,
       "paging" : false,
       "ordering" : false,
       "info" : false,
    });

    $('.dataTables_length').addClass('bs-select');

    $('#tbllocation tbody').on('dblclick', 'tr', function () {
        /*var data = tbllocation.row( this ).data();
        populateLocationform(data);*/
    });

    $('#tblsupplier tbody').on('dblclick', 'tr', function () {
        var data = tblsupplier.row( this ).data();
        populateSupplierform(data);
    });

    $('#tbllink tbody').on('dblclick', 'tr', function () {
        var data = tbllink.row( this ).data();
        populateLinkform(data);
    });

    var img = $('.file-upload').file_upload({
         messages: {
            remove: "Löschen",
        }
    });

    img.on('file_upload.afterClear', function(event, element) {
        var data = {
            item : 'delimg_spare',
            id : $('#id').val()
        }
        $.ajax({
                     url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
                     type: 'POST',
                     data: data
        });
    });

    $('#moduleid').select2({
        dropdownParent: $('#editLink')
    });


    $('#moduleid').change(function() {
        fill_linklist(this.value);
    });

    $('#myTab').on('shown.bs.tab', function (e) {
        //e.target // newly activated tab
        activetab = e.target;
        //e.relatedTarget // previous active tab
    });

    activetab = $('#myTab a[href="#location"]');

    $('#boxid').blur(function() {
        prepareForm();
    });

    $('#boxid').select2({
        dropdownParent: $('#editLocation')
    });

    $('#boxid').change(function() {
        prepareForm();
    });

    if (!$('#targetorder').is(":checked")) {
        $('.ordertarget').parent().hide();
    };

    $('#targetorder').change(function(){
        if ($('#targetorder').is(":checked")) {
            $('.ordertarget').parent().show();
        } else {
            $('#orderdate').val('');
            $('#orderlevel').val('0');
            $('#intervall').val('0');
            $('#intervalltyp').val('year');
            $('.ordertarget').parent().hide();
        }
    });

});


function prepareForm() {

    var boxid = $("#boxid").val();
    var sparepartid = $("#id").val();

    if (boxid == 0) {
        return;
    }

    var data = {
        id: boxid,
        key: boxid,
        sparepartid: sparepartid,
        item: 'spareloc'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/checkitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            $('#errmsg').html(data["errmsg"]);
            if (data["status"] == 'NOTOK') {
               $("#boxid").focus();
            }
            if (data["data"] == 1) {
                var location = data["location"];
                $("#warehouseid").val(location.warehouseid);
                $("#warehouseid").prop( "disabled", true );
                $("#locationid").val(location.locationid);
                $("#locationid").prop( "disabled", true );
                $("#shelfid").val(location.shelfid);
                $("#shelfid").prop( "disabled", true );
                $("#compid").val(location.compid);
                $("#compid").prop( "disabled", true );

            } else {

                $("#warehouseid").prop( "disabled", false );
                $("#warehouseid").val(0);
                $("#locationid").prop( "disabled", false );
                $("#locationid").val(-1);
                $("#shelfid").prop( "disabled", false );
                $("#shelfid").val(0);
                $("#compid").prop( "disabled", false );
                $("#compid").val(0);
            }
        },
        failure: function () {
        }
    });
}


/*******************************************************/
function refresh_data() {
    window.location.reload();
}

function form_submit() {
    searchform.submit();
    //window.opener.find_row($("#idx").val());
}

function window_close() {
    window.close();
}





/******************************************************/
/*** Location *****************************************/
function emptyLocationform() {
    $('#locationid').val('-1');
    $('#warehouseid').val('-1');
    $("#shelfid").val('');
    $('#compid').val('');
    $('#boxid').val('');
    $('#actval').val('');
    $('#actval').attr('disabled', false);
    show_location();
}

function populateLocationform(data) {

    $('#locationid').val(data[0]);
    $('#warehouseid').val(data[1]);
    $("#shelfid").val(data[2]);
    $('#compid').val(data[3]);
    $('#boxid').val(data[4]);
    $('#actval').val(parseFloat(data[7]));
    $('#actval').attr('disabled', true);
    show_location();
}

function show_location() {

    $('#editLocation').modal('show');

}

/******************************************************/
/*** Supplier *****************************************/

function emptySupplierform() {
    $('#supplierid').val('-1');
    $('#supplierid').attr('disabled', false);
    $('#sparenb').val('');
    $("#isdefault").prop( "checked", false );
    $('#price').val('');
    show_supplier();
}

function populateSupplierform(data) {

    $('#supplierid').val(data[0]);
    $('#supplierid').attr('disabled', true);
    $('#sparenb').val(data[2]);
   
    if (data[3] == 'Ja') {
        $("#isdefault").prop( "checked", true );
    } else {
        $("#isdefault").prop( "checked", false );
    }
    $('#price').val(data[4]);
    show_supplier();
}

function show_supplier() {

    $('#editSupplier').modal('show');

}


function saveSpare_data() {

    if (!$('#formSpare')[0].checkValidity()) {
        $('#formSpare').find('input[type="submit"]').click();
        return false;
    }
    var sparepartid = $('#id').val();
    var sparepartnb = $('#sparepartnb').val();
    var sparepart = $('#sparepart').val();
    var snb = $('#snb').val();

    var minlevel = $('#minlevel').val();
    var actlevel = $('#actlevel').val();
    var minorderlevel = $('#minorderlevel').val();
    var defsupplierid = $('#defsupplierid').val();
    var active = $('#active').val();
    var sparepartnborg = $('#sparepartnborg').val();

    var targetorder = $('#targetorder').is(":checked") ? '1' : '';
    var intervall = $('#intervall').val();
    var intervalltyp = $('#intervalltyp').val();
    var startdate = $('#startdate').val();
    var orderlevel = $('#orderlevel').val();
    var catid = $('#catid').val();

    var spareimage = $('#spareimage')[0].files[0];


    var formData = new FormData();
    formData.append('id',sparepartid);
    formData.append('nb',sparepartnb);
    formData.append('name',sparepart);
    formData.append('snb',snb);
    formData.append('minlevel',minlevel);
    formData.append('actlevel',actlevel);
    formData.append('minorderlevel',minorderlevel);
    formData.append('defsupplierid',defsupplierid);
    formData.append('active',active);
    formData.append('sparepartnborg',sparepartnborg);

    formData.append('targetorder', targetorder);
    formData.append('intervall',intervall);
    formData.append('intervalltyp',intervalltyp);
    formData.append('startdate',startdate);
    formData.append('orderlevel',orderlevel);
    formData.append('catid',catid);

    formData.append('spareimage',spareimage);
    formData.append('item','spare');
   
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/mpfsaveitem.asp",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href='/digiadmin/spare/edit/?partial=yes&id=' + data["id"] + '&idx=' + $('#idx').val() + '&tab=location-tab';
            } else {
                $('.danger-info').html(data["errmsg"]);
                $('#danger').modal('show');
            }
        },
        failure: function () {
             alert('error');
        }
    });
}


function saveSupplier_data() {

    if (!$('#formSupplier')[0].checkValidity()) {
        $('#formSupplier').find('input[type="submit"]').click();
        return false;
    }

    var supplierid = $('#supplierid').val();
    var sparenb = $('#sparenb').val();

    if ($('#isdefault').prop("checked")) {
        isdefault = 1;
    } else {
        isdefault = 0;
    }
    var sparepartid = $('#id').val();
    var price = $('#price').val();

    var data = {
        id: supplierid,
        sparepartid: sparepartid,
        sparenb: sparenb,
        isdefault: isdefault,
        price : price,
        active: 1,
        item: 'spare_supplier'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href='/digiadmin/spare/edit/?partial=yes&id=' + $('#id').val() + '&idx=' + $('#idx').val() + '&tab=' + activetab.id;
            }
        },
        failure: function () {

        }
    });
}

function saveLocation_data() {


    if (!$('#formLocation')[0].checkValidity()) {
        $('#formLocation').find('input[type="submit"]').click();
        return false;
    }

    var sparepartid = $('#id').val();
    var locationid = $('#locationid').val();
    var warehouseid = $('#warehouseid').val();
    var shelfid = $('#shelfid').val();
    var compid = $('#compid').val();
    var boxid = $('#boxid').val();
    var actval = $('#actval').val();

    var data = {
        id: locationid,
        sparepartid: sparepartid,
        warehouseid: warehouseid,
        shelfid: shelfid,
        compid: compid,
        boxid: boxid,
        act: actval,
        item: 'spare_location'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);

            if (data["status"] == "OK") {
               window.location.href='/digiadmin/spare/edit/?partial=yes&id=' + $('#id').val() + '&idx=' + $('#idx').val()  + '&tab=' + activetab.id;
            }
        },
        failure: function () {

        }
    });
}





function deleteLocation (id) {

    $('#question-ok').unbind();

    $('#question-ok').click({id: id}, deleteLoc);

    $('.question-info').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#question').modal('show');

}

function deleteLoc (event) {

    var sparepartid = $('#id').val();

    var data = {
        id: event.data.id,
        sparepartid : sparepartid,
        item: 'spare_location'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href='/digiadmin/spare/edit/?partial=yes&id=' + $('#id').val() + '&idx=' + $('#idx').val()  + '&tab=' + activetab.id;
            }
        },
        failure: function () {

        }
    });

}

function deleteSupplier (id) {

    $('#question-ok').unbind();
    $('#question-ok').click({id: id}, deleteSupp);

    $('.question-info').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#question').modal('show');

}


function deleteSupp (event) {

    var sparepartid = $('#id').val();

    var data = {
        id: event.data.id,
        sparepartid: sparepartid,
        item: 'spare_supplier'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href='/digiadmin/spare/edit/?partial=yes&id=' + $('#id').val() + '&idx=' + $('#idx').val() + '&tab=' + activetab.id;
            }
        },
        failure: function () {

        }
    });

}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/* relation to module                                                              */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

function fill_linklist(id) {

    var linkdropdown = $("#mlinkid");

    var data = {
        id: id,
        list: 'module_link'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            linkdropdown.empty();
            linkdropdown.append('<option selected="true" value="">--Auswahl Zuordnung--</option>');
            $.each(data['module_link'], function (key, entry) {

                linkdropdown.append($('<option></option>').attr('value', entry.linkid).text(entry.plant + ' --> ' + entry.device));
            });
            linkdropdown.prop('selectedIndex', 0);
        },
        failure: function () {
        }
    });
}


/******************************************************/
/*** Links *****************************************/
function emptyLinkform() {
    $('#linkid').val('-1');
    $("#mlinkid").empty();
    $("#mlinkid").append('<option selected="true" value="" disabled>--Auswahl einer Zuordnung--</option>');
    $('#mlinkid').prop('selectedIndex', 0);
    $('#moduleid').val('').trigger('change');
    show_link();
}

function show_link() {

    $('#editLink').modal('show');

}


function saveLink_data() {


    if (!$('#formLink')[0].checkValidity()) {
        $('#formLink').find('input[type="submit"]').click();
        return false;
    }

    var sparepartid = $('#id').val();
    var id = $('#mlinkid').val();

    var data = {
        id: id,
        sparepartid: sparepartid,
        item: 'spare_link'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href='/digiadmin/spare/edit/?partial=yes&id=' + $('#id').val() + '&idx=' + $('#idx').val() + '&tab=' + activetab.id;
            }
        },
        failure: function () {

        }
    });
}


function deleteLink (id) {

    $('#question-ok').unbind();
    $('#question-ok').click({id: id}, deleteLnk);

    $('.question-info').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#question').modal('show');

}

function deleteLnk (event) {

    var sparepartid = $('#id').val();

    var data = {
        id: event.data.id,
        sparepartid: sparepartid,
        item: 'spare_link'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href='/digiadmin/spare/edit/?partial=yes&id=' + $('#id').val() + '&idx=' + $('#idx').val() + '&tab=' + activetab.id;
            }
        },
        failure: function () {

        }
    });

}

