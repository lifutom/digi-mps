$(function () {
    updatechart();
});


function updatechart() {
    setchart('quality','tier2', $('#CurStreamType').val(), $('#dateid').val());
    setoverchart('quality_over','tier2', $('#CurStreamType').val(), $('#dateid').val());
}


function setchart(list, level, levelid, dateid) {

        var data = {
                list:  list,
                level: level,
                levelid: levelid,
                id: dateid
        }

        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/getchartdata.asp",
            data: data,
            success: function (data) {
                data = JSON.parse(data);
                var ctx = document.getElementById("barchart").getContext('2d');
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

function setoverchart(list, level, levelid, dateid) {

        var data = {
                list:  list,
                level: level,
                levelid: levelid,
                id: dateid
        }

        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/getchartdata.asp",
            data: data,
            success: function (data) {
                data = JSON.parse(data);
                var ctx1 = document.getElementById("linechart").getContext('2d');
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