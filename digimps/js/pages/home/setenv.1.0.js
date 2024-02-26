$(function () {

    $('#modalLoginForm').on('hide.bs.modal', function () {
        $('#defaultForm-login').val('');
        $('#defaultForm-pass').val('');
    });
    $( "#btnlogin" ).click(function() {
        login(settinglink);
    });

});

function fill_control(){

        var plantid = $("#plantid").val();
        var controldropdown =  $("#controlid");

        var data = {
                plantid : plantid,
                items : 'control'
        }

        $.ajax({
                type:'POST',
                url:'./ajax/getlistitem.asp',
                data: data,
                success:function(data){
                        data = JSON.parse(data);
                        if(data["status"] == "OK") {
                                datamap = data["listitem"];
                                controldropdown.empty();
                                controldropdown.append('<option selected="true" disabled="disabled">W&auml;hlen Sie das Control-Device aus</option>');
                                controldropdown.prop('selectedIndex', 0);
                                $.each(datamap, function (key, entry) {

                                    if (entry.enabled == "0") {
                                      controldropdown.append($('<option disabled="disabled"></option>').attr('value', entry.id).text(entry.name));
                                    } else {
                                      controldropdown.append($('<option></option>').attr('value', entry.id).text(entry.name));
                                    }

                                });
                        }
                }
        });
}


function settinglink(loginsuccess) {

   $('#modalLoginForm').modal('hide');
   if (loginsuccess){
       $('#modalLinkForm').modal('show');
   } else {
       $('.warningmsg').html('Logindaten sind nicht korrekt!');
       $('#warning').modal('show');
       $('#warningbtn').click(function() {
           $('#modalLoginForm').modal('show');
       });

   }
}

function setlink() {


    /* ' reset entry values'
    $('#defaultForm-login').val('');
    $('#defaultForm-pass').val('');*/



    var plantid = $("#plantid").val();
    var controlid =  $("#controlid").val();

    var data = {
        plantid : plantid,
        controlid : controlid,
        task: 'set'
    }
    $.ajax({
        type:'POST',
        url:'./ajax/setenvlink.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
               $('#modalLinkForm').modal('hide');
               setCookie('controlid',controlid);
               window.location.reload();
            }
        }
    });
}
