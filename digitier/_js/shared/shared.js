/* shared.js:  10.05.2019 Version 1.1 */

$(function () {
    $('#btntier2_solida').click({board: 'tier2_solida'},function(e) {
        set_tier(e.data.board);
    });
    $('#btntier2_chews').click({board: 'tier2_chews'},function(e) {
        set_tier(e.data.board);
    });
    $('#btntier1').click({board: 'tier1'},function(e) {
        set_tier(e.data.board);
    });
    $('#btntier3').click({board: 'tier3'},function(e) {
        set_tier(e.data.board);
    });
    $('#btnhome').click({board: ''},function(e) {
        set_tier(e.data.board);
    });
});

function set_tier(tierboard) {
    var data = {
        item: tierboard
    }
    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/settierboard.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               window.location.href=$('#CurRootFile').val() + '/' + data['tierboard'];
            }
        },
        failure: function () {
        }
    });
}