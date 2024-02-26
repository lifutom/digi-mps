$(function () {
    updatechart();
});


function updatechart() {
    setchart('deliverypack_oee','tier2', $('#CurStreamType').val(), $('#dateid').val(), $('#area').val());
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

                $.each(data, function(index, element) {
                    var plant = element.plant;
                    var plantid = element.plantid;
                    $('.plantname_' + plantid.toString()).html('<h4>' + plant + '</h4>');
                    var ctx = document.getElementById("oeechart_" + plantid.toString()).getContext('2d');
                    myChart = new Chart(ctx, {
                        type: 'line',
                        data: element.oeedata,
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
                    // output
                    var ctx1 = document.getElementById("outputchart_" + plantid.toString()).getContext('2d');
                    myChart1 = new Chart(ctx1, {
                        type: 'line',
                        data: element.outputdata,
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
                });
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