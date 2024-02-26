$(function () {

    $('.btn-book').click(function () {
        var id=$('#shoppingid').val();
        $('#question-ok').click({id: id}, bookCart);
        $('.question-info').html('Sollen die Ersatzteile gebucht werden?');
        $('#question').modal('show');
    });
});

function deleteCartItemQue (id, locationid, sparepartid) {

    $('#question-ok').click({id: id, locationid: locationid, sparepartid: sparepartid}, deleteCartItem);
    $('.question-info').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#question').modal('show');

}


function deleteCartItem (event) {

    var data = {
        id: event.data.id,
        locationid: event.data.locationid,
        sparepartid: event.data.sparepartid,
        item: 'cartitem'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                window.location.href='/digispare/home/mycart';
            }
        },
        failure: function () {

        }
    });
}


function bookCart (event) {

    var data = {
        id: event.data.id,
        userid: $('#CurLogin').val(),
        item: 'cartbook'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href=$('#CurRootFile').val() + '/home/spareindex';
            }
        },
        failure: function () {

        }
    });
}