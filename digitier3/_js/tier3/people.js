/* people.js:  10.05.2019 Version 1.1 */

$(function () {
    updatechart();
});


function updatechart() {
    setchart('people','tier3', 'all',$('#dateid').val());
    setoverchart('people_over','tier3', 'all',$('#dateid').val());
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
                //$('#linechart').remove(); // this is my <canvas> element
                //$('#chartdiv').append('<canvas id="linechart"><canvas>');
                var ctx1 = document.getElementById("linechart1").getContext('2d');
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