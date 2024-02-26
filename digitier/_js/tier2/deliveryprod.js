$(function () {
    updatechart();
});


function updatechart() {
    setchart('deliveryprod','tier2', $('#CurStreamType').val(), $('#dateid').val(), $('#area').val());
    //setoverchart('deliverypack_output','tier2', $('#CurStreamType').val(), $('#dateid').val(), $('#area').val());
}


function setchart(list, level, levelid, dateid, area) {

        var data = {
                list:  list,
                level: level,
                levelid: levelid,
                id: dateid,
                area: area

        }
        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/getchartdata.asp",
            data: data,
            success: function (data) {

                data = JSON.parse(data);
                var ctx = document.getElementById("prodchart").getContext('2d');
                myChart = new Chart(ctx, {
                    type: 'bar',
                    data: data,
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        }
                    }
                });
                myChart.render();
            },
            failure: function () {
            }
        });

}

function setoverchart(list, level, levelid, dateid, area) {

        var data = {
                list:  list,
                level: level,
                levelid: levelid,
                id: dateid,
                area: area
        }

        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/getchartdata.asp",
            data: data,
            success: function (data) {
                data = JSON.parse(data);
                var ctx1 = document.getElementById("outputchart").getContext('2d');
                myChart1 = new Chart(ctx1, {
                    type: 'line',
                    data: data,
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        }
                    }
                });
                myChart1.render();
            },
            failure: function () {
            }
        });

}