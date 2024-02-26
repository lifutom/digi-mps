/* Version 1.0 2021-09-03*/

$(function () {

    $('#btnlogout').click(function() {
        window.location.href=$('#CurRootFile').val() + '/home/logout';
    });

    $('#btngrant').click(function() {
        window.location.href=$('#CurRootFile').val() + '/request/formgrant/?partial=yes';
    });

    $('#btnrevoke').click(function() {
        window.location.href=$('#CurRootFile').val() + '/request/formrevoke/?partial=yes';
    });

    $('#btnadmin').click(function() {
        window.location.href=$('#CurRootFile').val() + '/dash';
    });

});
