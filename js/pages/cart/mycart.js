var ismycart;

$(function () {

    ismycart = $('#ismycart').val();

    $('.btn-delete').click(function () {
        var id=$('#shoppingid').val();
        $('#decisionbtn').click({id: id}, deleteCart);
        $('.decisionmsg').html('Soll der Warenkorb wirklich gelöscht werden?');
        $('#decision').modal('show');
    });

    $('.btn-cancel').click(function () {
        if (ismycart == 1) {
            window.location.href='/digiadmin/spare';
        } else {
            window.location.href='/digiadmin/cart';
        }
    });

    $('.btn-book').click(function () {
        var id=$('#shoppingid').val();
        $('#decisionbtn').click({id: id}, bookCart);
        $('.decisionmsg').html('Sollen die Ersatzteile gebucht werden?');
        $('#decision').modal('show');
    });
});


function deleteCart (event) {

    var data = {
        id: event.data.id,
        item: 'cart'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/deleteitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                if (ismycart == 1) {
                    window.location.href='/digiadmin/spare';
                } else {
                    window.location.href='/digiadmin/cart';
                }
            }
        },
        failure: function () {

        }
    });

}


function deleteCartItemQue (id, locationid, sparepartid) {

    $('#decisionbtn').click({id: id, locationid: locationid, sparepartid: sparepartid}, deleteCartItem);
    $('.decisionmsg').html('Soll der Eintrag gel&ouml;scht werden?');
    $('#decision').modal('show');

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
                if (ismycart == 1) {
                    window.location.href='/digiadmin/cart/mycart';
                } else {
                    openCart(event.data.id);
                }
            }
        },
        failure: function () {

        }
    });
}

function openCart(id) {

    $('#id').val(id);
    $('#frmcart').submit();

}


function bookCart (event) {

    var data = {
        id: event.data.id,
        userid: $('#CurUserID').val(),
        item: 'cartbook'
    }
  
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href='/digiadmin/spare';
            }
        },
        failure: function () {

        }
    });
}