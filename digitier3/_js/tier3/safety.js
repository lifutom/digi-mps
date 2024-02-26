$(function () {
    updatechart();
});


function updatechart() {
    setincchart('safety_inc','tier3', 'all', $('#dateid').val());
    setchart('safety','tier3', 'all', $('#dateid').val());
    setoverchart('safety_near','tier3', 'all', $('#dateid').val());
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
                //$('#linechart').remove(); // this is my <canvas> element
                //$('#chartdiv').append('<canvas id="linechart"><canvas>');
                var ctx = document.getElementById("linechart").getContext('2d');
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
                //$('#linechart1').remove(); // this is my <canvas> element
                //$('#chartdiv').append('<canvas id="linechart"><canvas>');
                var ctx1 = document.getElementById("linechart1").getContext('2d');
                myChart1 = new Chart(ctx1, {
                    type: 'line',
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
                myChart1.render();
            },
            failure: function () {
            }
        });

}


function setincchart(list, level, levelid, dateid) {

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
                //$('#linechart').remove(); // this is my <canvas> element
                //$('#chartdiv').append('<canvas id="linechart"><canvas>');
                var ctx = document.getElementById("linechart2").getContext('2d');
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