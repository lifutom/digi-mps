

$(function () {
    $('input[type=radio][name=listname]').change(function () {
            updatechart();
    });

    updatechart();
});


function updatechart() {

    var listname = $("input[name='listname']:checked").val();
    var deviceid = $("#deviceid").val();
    var level = '0';

    if (deviceid != '0') {
       level = '1';
    }

    setchart(listname, level, deviceid);

}


function setchart(list, level, levelid) {

        var id = $('#prodid').val();
        var data = {
                list:  list,
                id: id,
                level: level,
                levelid: levelid
        }

        $.ajax({
            type: "POST",
            url: $('#CurRootFile').val() + "/ajax/getchartdata.asp",
            data: data,
            success: function (data) {
                data = JSON.parse(data);
                $('#prodbarchart').remove(); // this is my <canvas> element
                $('#chartdiv').append('<canvas id="prodbarchart"><canvas>');
                var ctx = document.getElementById("prodbarchart").getContext('2d');
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





