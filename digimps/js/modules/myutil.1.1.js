function isodatestr(d) {
    var mon
    mon = d.getMonth();
    mon = mon+1;
    return d.getFullYear() + '-' + ('00' + mon.toString()).slice(-2) + '-' + ('00' + d.getDate()).slice(-2) + ' ' + ('00' + d.getHours()).slice(-2) + ':' + ('00' + d.getMinutes()).slice(-2) + ':' + ('00' + d.getSeconds()).slice(-2);
}

function login(callback) {

    ' save entry values'
    var login = $('#defaultForm-login').val();
    var password = $('#defaultForm-pass').val();

    var data = {
        login : login,
        password: password
    }

    $.ajax({
        type:'POST',
        url:'./ajax/login.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data["status"] == "OK") {
                if (data["login"] == "OK") {
                   callback(true);
                } else {
                   callback(false);
                }
            }
        },
        error:function (data) {
            callback(false);
        }
    });
}