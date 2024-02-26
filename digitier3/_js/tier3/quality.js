$(function () {
    updatechart();
});


function updatechart() {
    setchart('quality','tier3', 'all', $('#dateid').val());
    setoverchart('quality_over','tier3', 'all', $('#dateid').val());
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
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                    precision: 0,
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
                        title: {
                            display: true,
                            text: 'LROT - Liste'
                        },
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                    precision: 0,
                                }
                            }]
                        },
                    }
                });
                myChart1.render();
            },
            failure: function () {
            }
        });

}