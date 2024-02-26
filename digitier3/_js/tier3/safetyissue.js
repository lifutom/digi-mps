function changeitem(id, itemtype) {

        var data = {
                id:  id,
                item: itemtype
        }
        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/saveclose.asp",
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