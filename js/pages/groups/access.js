// Version 1.0
function toggleitem(groupid, menuid) {

    //this is <a> click event:

    var data = {
        groupid: groupid,
        menuid: menuid,
        item: 'toggle'
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/access.asp",
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