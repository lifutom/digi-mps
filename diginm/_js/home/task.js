/* Version 1.2 */
$(function () {
    $('#cmdlogout').click(function() {
        window.location.href='/diginm/home/logout';
    });

    $('#cmdback').click(function() {
         $('#formNear').attr('action',$('#CurRootFile').val() + '/home/IndexPost');
         $('#formNear').submit();
    });

    $('#cmdsave').click(function() {

        if (!$('#formNear')[0].checkValidity()) {
            $('#formNear').find('input[type="submit"]').click();
            return false;
        }
        $('#question-ok').click(function() {
            createnearmiss();
        });

        $('.question-info').html('Meldung wirklich erstellen?');
        $('#question').modal('show');
    });

    var img = $('.file-upload').file_upload({
        messages: {
            remove: "Löschen",
        }
    }
    );
    /*img.on('file_upload.beforeClear', function(event, element){
        return confirm("Are you Sure?");
    });*/
    img.on('file_upload.afterClear', function(event, element) {
        var data = {
            item : 'delimg_nm',
            id : $('#CurLogin').val(),
            filetyp : 'task'
        }
        $.ajax({
                     url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
                     type: 'POST',
                     data: data
        });
    });

    $('#regionid').change(function() {
        fill_roomlist();
    });

    $('#buildingid').change(function() {
        fill_roomlistbybuilding();
    });

    $('.search-drowdown').select2();

});


function fill_roomlistbybuilding() {

    var roomdropdown = $("#roomid");
    var regiondropdown = $("#regionid");

    var id = $("#buildingid").val();
    var regionid = $("#regionid").val();

    var data = {
        id: id,
        regionid: regionid,
        list: 'building_region_dd'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);

            regiondropdown.empty();
            regiondropdown.append('<option value="" disabled>Auswahl Bereich</option>');
            regiondropdown.prop('selectedIndex', 0);
            $.each(data["region"], function (key, entry) {
                regiondropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });


            roomdropdown.empty();
            roomdropdown.append('<option value="" disabled>-- Auswahl Raum ----------------------</option>');
            roomdropdown.prop('selectedIndex', 0);
            $.each(data["room"], function (key, entry) {
                roomdropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
        },
        failure: function () {
        }
    });
}


function fill_roomlist() {

    var roomdropdown = $("#roomid");
    var id = $("#regionid").val();
    var buildingid = $("#buildingid").val();

    var data = {
        id: id,
        buildingid: buildingid,
        list: 'room_dd'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            roomdropdown.empty();
            roomdropdown.append('<option value="" disabled>-- Auswahl Raum ----------------------</option>');
            roomdropdown.prop('selectedIndex', 0);
            $.each(data, function (key, entry) {
                roomdropdown.append($('<option></option>').attr('value', entry.value).text(entry.name));
            });
        },
        failure: function () {
        }
    });
}


function setsvp() {

    $('#formNear').attr('action',$('#CurRootFile').val() + '/home/RoomPost');
    $('#formNear').submit();

}


function createnearmiss() {

    $('#formNear').attr('action',$('#CurRootFile').val() + '/home/CreatePost');
    $('#formNear').submit();

}