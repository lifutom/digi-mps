$(function () {
    updatechart();
});


function updatechart() {
    setchart('deliverypack_oee','tier3', 'all', $('#dateid').val(), $('#area').val());
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
                    var ctx = document.getElementById("oeechart").getContext('2d');
                    myChart = new Chart(ctx, {
                            type: 'line',
                            data: data,
                            options: {
                                title: {
                                    display: true,
                                    text: 'OEE'
                                },
                                responsive: true,
                                maintainAspectRatio: false,
                                legend: {
                                    display: true,
                                },
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