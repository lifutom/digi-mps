



$(function () {

    var myVar = setInterval(updatescreen, 5000);



    // production is running
    if ($('#isprunning').val() == 1) {
        $('#pstatus').html('Status: Running');
        $('.pwatch').show();
        $('.btnpstart').hide();
        $('.btnpstop').show();
        if ($('#isdtrunning').val() == 1) {
            $('.watch').show();
            $('.btnstart').hide();
            $('.btnstop').show();
        } else {
            $('.watch').hide();
            $('.btnstart').show();
            $('.btnstop').hide();
        }
    } else {
        // set all
        //alert('is not running');
        $('.pwatch').hide();
        $('.btnpstart').show();
        $('.btnpstop').hide();
        $('.watch').hide();
        $('.btnstart').hide();
        $('.btnstop').hide();
        $('#pstatus').html('Status: Idle');
    }

    $('#modalLoginForm').on('hide.bs.modal', function () {
        $('#defaultForm-login').val('');
        $('#defaultForm-pass').val('');
    });
});


function updatescreen() {

    var plantid = $("#plantid").val();

    var data = {
        plantid : plantid
    }

    $.ajax({
        type:'POST',
        url:'./ajax/productionrunning.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
                prun = $("#isprunning").val();
                if (data["prodisrunning"] == "0") {
                    if ($('.btnpstop').is(":visible")){
                        $('.watch').hide();
                        $('.pwatch').hide();
                        $('.btnpstart').show();
                        $('.btnstart').hide();
                        $('.btnpstop').hide();
                        $('.btnstop').hide();
                        pclockcnt.stop();
                        clockcnt.stop();
                        $('.uinnb').html('');
                        $('#pstatus').html('Status: Idle');
                    }
                } else {
                    if (prun != data["prodisrunning"]){
                        window.location.reload();
                    }
                    $('#pstatus').html('Status: Running');
                }
            }
        },
        error:function (data) {
        }
    });

}


function starting_production(){

    $("#btnpstart").prop('disabled',true);
    var plantid = $("#plantid").val();

    var data = {
        plantid : plantid
    }

    $.ajax({
        type:'POST',
        url:'./ajax/productionrunning.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
                if (data["prodisrunning"] == "1") {
                   $('.warningmsg').html('Produktion wurde bereits gestartet. Seite wird neu geladen!');
                   $('#warning').modal('show');
                   $('#warningbtn').click(function() {
                       window.location.reload();
                   });
                } else {
                   $("#btnpstart").prop('disabled',false);
                   $('#uinnb').val('');
                   $('#batchnb').val('');
                   $('#modalStartProdForm').modal('show');
                }
            }
        },
        error:function (data) {
            $("#btnpstart").prop('disabled',false);
        }
    });
}

function stoping_production(){

    if ($('.btnstop').is(":visible")){
        $('.warningmsg').html('Sie m&uumlssen erst die Downtime stoppen.');
        $('#warning').modal('show');
    } else {
        var plantid = $("#plantid").val();
        var controlid = $("#controlid").val();
        var productionid = $("#productionid").val();
        var data = {
            plantid : plantid
        }
        $.ajax({
            type:'POST',
            url:'./ajax/productionrunning.asp',
            data: data,
            success:function(data){
                data = JSON.parse(data);
                if(data["status"] == "OK") {
                   if (data["downisrunning"] > 0) {
                       $('.warningmsg').html('Es laufen noch Downtimes auf anderen Anlagenteilen.');
                       $('#warning').modal('show');
                   } else {
                        if (data["prodisrunning"] == "0") {
                           $('.warningmsg').html('Produktion wurde bereits gestoppt. Seite wird neu geladen!');
                           $('#warning').modal('show');
                           $('#warningbtn').click(function() {
                               window.location.reload();
                           });
                        } else {
                            $('#counter').val('');
                            $('#counterbad').val('');
                            $('#modalStopProdForm').modal('show');
                        }
                   }
                }
            }
        });
    }
}

function start_production(){

    $('#frmproduction').validate({
        errorElement: "em",
        errorPlacement: function( label, element ) {
                label.insertBefore( element );
        },
        submitHandler: function (form) {

            var plantid = $("#plantid").val();
            var controlid = $("#controlid").val();
            var uinnb = $('#uinnb').val().toUpperCase();
            var batchnb = $('#batchnb').val().toUpperCase();

            var data = {
                        plantid : plantid,
                        controlid : controlid,
                        uinnb: uinnb,
                        batchnb: batchnb
            }
            $.ajax({
                type:'POST',
                url:'./ajax/startproduction.asp',
                data: data,
                success:function(data){
                    data = JSON.parse(data);
                    if(data["status"] == "OK") {
                       // set time
                       $('#modalStartProdForm').modal('hide');
                       $('.uinnb').html('UIN: ' + $('#uinnb').val().toUpperCase() + '/ChargenNr: ' + $('#batchnb').val().toUpperCase());
                       $("#productionid").val(data["productionid"]);
                       $("#pstart_time").val(data["time"]);
                       $('.pwatch').show();
                       $('.btnpstart').hide();
                       $('.btnstart').show();
                       $('.btnpstop').show();
                       pclockcnt.stop();
                       pclockcnt.setTime(0);
                       pclockcnt.start();
                       $('#pstatus').html('Status: Running');
                    }
                }
            });
        }
    });
}


function stop_production() {



    var productionid = $("#productionid").val();
    var counter =  $("#counter").val();
    var counterbad =  $("#counterbad").val();
    var d = new Date();
    var endtime = isodatestr(d);



    var data = {
                productionid : productionid,
                endtime : endtime,
                counter: counter,
                counterbad: counterbad
    }

    if ($('.btnstop').is(":visible")){
       $('.warningmsg').html('Sie m&uumlssen erst die Downtime stoppen.');
       $('#warning').modal('show');
    } else {
        $.ajax({
        type:'POST',
        url:'./ajax/stopproduction.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
                // set time
                $('.pwatch').hide();
                $('.btnpstart').show();
                $('.btnstart').hide();
                $('.btnpstop').hide();
                pclockcnt.stop();
                pclockcnt.setTime(0);
                $('.uinnb').html('');
                $('#pstatus').html('Status: Idle');
                $('#modalStopProdForm').modal('hide');
                $('.successmsg').html('Produktion wurde erfolgreich beendet.');
                $('#success').modal('show');
            } else {
                $('#modalStopProdForm').modal('hide');
                $('#pstatus').html('Status: Running');
                $('.warningmsg').html('Produktion konnte nicht gestoppt werden.');
                $('#warning').modal('show');
            }
        }
    });
    }
}


function starting_downtime () {

    var plantid = $("#plantid").val();

    var data = {
        plantid : plantid
    }

    $.ajax({
        type:'POST',
        url:'./ajax/productionrunning.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
                if (data["prodisrunning"] == "0") {
                    $('.warningmsg').html('Produktion wurde bereits gestoppt. Seite wird neu geladen!');
                   $('#warning').modal('show');
                   $('#warningbtn').click(function() {
                       window.location.reload();
                   });
                } else {
                   checkrunning_downtime();
                }
            }
        },
        error:function (data) {
        }
    });

}


function checkrunning_downtime () {

    var plantid = $("#plantid").val();
    var controlid = $("#controlid").val();
    var productionid = $("#productionid").val();

    var data = {
        plantid : plantid,
        controlid : controlid,
        productionid : productionid
    }

    $.ajax({
        type:'POST',
        url:'./ajax/ctrldtrunning.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
                if (data["downtimeisrunning"] == "1") {
                   alert('Es läuft bereits eine Downtime auf dieser Control-Einheit. Seite wird neu geladen.');
                   window.location.reload();
                } else {
                   start_downtime();
                }
            } else {

            }
        },
        error:function (data) {
        }
    });
}

function start_downtime(){

    var plantid = $("#plantid").val();
    var deviceid = $("#deviceid").val();
    var controlid = $("#controlid").val();
    var productionid = $("#productionid").val();

    var d = new  Date();

    // start time must be in iso format:  YYYY-MM-DD HH:MM:SS
    $("#start_time").val(isodatestr(d));
    var start_time = $("#start_time").val();

    var data = {
                plantid : plantid,
                deviceid : deviceid,
                controlid : controlid,
                start_time: start_time,
                productionid: productionid
    }

    $.ajax({
        type:'POST',
        url:'./ajax/startdowntime.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
               // set time
               $("#downtimeid").val(data["downtimeid"]);
               $(".act_start_time").html(data["time"]);
               clockcnt.setTime(0);
               clockcnt.start();
               $('.watch').show();
               $('.btnstart').hide();
               $('.btnstop').show();

            } else {
               $('.watch').hide();
               $('.btnstart').show();
               $('.btnstop').hide();
            }
        }
    });
}

function stopping_downtime() {

     var d = new Date();
    var endtime = isodatestr(d);

    var tend = new moment(endtime, moment.ISO_8601);
    var tstart = new moment($("#start_time").val(),moment.ISO_8601);

    var  duration = moment.duration(tend.diff(tstart));

    var DiffMin = Math.round(duration.as('minutes'))+"";

    if (DiffMin == 0) {
        DiffMin = 1;
    }

    $("#end_time").val(endtime);
    $("#act_end_time").val(DiffMin);

    $("#deviceid").prop('selectedIndex', 0);
    $("#componentid").empty().append('<option selected="true" disabled="disabled">W&auml;hlen Sie die Komponente</option>');  
    $("#failureid").empty().append('<option selected="true" disabled="disabled">W&auml;hlen Sie das Fehlerbild</option>');;

    $('#modalStopForm').modal('show');

}


function save_downtimedata() {

    var deviceid = $("#deviceid").val();
    var componentid = $("#componentid").val();
    var failureid = $("#failureid").val();
    var plantid = $("#plantid").val();
    var description = $('#dtdescription').val();
    var downtimeid = $("#downtimeid").val();
    var end_time = $("#end_time").val();
    var endtime = moment(end_time, moment.ISO_8601);
    var mincnt = $("#act_end_time").val();
    var starttime = endtime.subtract(mincnt, 'minutes');
    var start_time = starttime.format('YYYY-MM-DD HH:mm:ss');
    var data = {
        downtimeid : downtimeid,
        deviceid : deviceid,
        componentid : componentid,
        failureid : failureid,
        plantid : plantid,
        description : description,
        start_time: start_time,
        end_time: end_time
    }
    $.ajax({
        type:'POST',
        url:'./ajax/savedowntime.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
               $('#modalStopForm').modal('hide');
                $('.watch').hide();
               $('.btnstart').show();
               $('.btnstop').hide();
               clockcnt.stop();
               clockcnt.setTime(0);
               $('.successmsg').html('Downtime wurde erfolgreich erfasst.');
               $('#success').modal('show');
            }
        }
    });
}

function fill_component(){

    var deviceid = $("#deviceid").val();
    var componentdropdown = $("#componentid");
    var failuredropdown = $("#failureid");

    var data = {
                deviceid : deviceid
    }

    $.ajax({
        type:'POST',
        url:'./ajax/getcomponents.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
               datamap = data["listitem"];
               failuredropdown.empty();
               failuredropdown.append('<option selected="true" disabled="disabled">W&auml;hlen Sie das Fehlerbild</option>');
               failuredropdown.prop('selectedIndex', 0);
               componentdropdown.empty();
               componentdropdown.append('<option selected="true" disabled="disabled">W&auml;hlen Sie die Komponente</option>');
               if ($("#deviceid").val() == 38 || $("#deviceid").val() == 40) {
                   componentdropdown.prop('selectedIndex', 1);
               } else {
                   componentdropdown.prop('selectedIndex', 0);
               }
               $.each(datamap, function (key, entry) {
                  componentdropdown.append($('<option></option>').attr('value', entry.componentid).text(entry.component));
               });
               if ($("#deviceid").val() == 38 || $("#deviceid").val() == 40) {
                   fill_failure();
               }
            }
        }
    });
}


function fill_failure(){

    var componentid = $("#componentid").val();
    var failuredropdown = $("#failureid");

    var data = {
                componentid : componentid
    }

    $.ajax({
        type:'POST',
        url:'./ajax/getfailures.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
                datamap = data["listitem"];
                failuredropdown.empty();
                failuredropdown.append('<option selected="true" disabled="disabled">W&auml;hlen Sie das Fehlerbild</option>');
                failuredropdown.prop('selectedIndex', 0);
                $.each(datamap, function (key, entry) {
                  failuredropdown.append($('<option></option>').attr('value', entry.failureid).text(entry.failure));
                });
            }
        }
    });
}

function fill_extfailure(){

    $.ajax({
        type:'POST',
        url:'./ajax/getextfailure.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
               // set time
            }
        }
    });
}




function clearinglink(loginsuccess) {

   $('#modalLoginForm').modal('show');
   $( "#btnlogin" ).click(function() {
        login(clearlink);
    });
}


function clearlink(loginsuccess) {

   $('#modalLoginForm').modal('hide');
   if (loginsuccess){
       $('.decisionmsg').html('Soll die Zuornung f&uuml;r diese Kontroleinheit wirklich aufgehoben werden?');
       $('#decision').modal('show');
       $('#decisionbtn').click(function() {
            window.location.href='home/clearenv';
       });
   } else {
       $('.warningmsg').html('Logindaten sind nicht korrekt!');
       $('#warning').modal('show');
       $('#warningbtn').click(function() {
            $('#modalLoginForm').modal('show');
       });
   }
}
