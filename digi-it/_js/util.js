function getlabel(labelname, lang) {

    var data = {
        label: labelname,
        lang: lang
    }
    $.ajax({
        type:'POST',
        url: $('#CurRootFile').val() + '/ajax/getlabel.asp',
        data: data,
        success:function(data){
            data = JSON.parse(data);
            if(data['status'] == 'OK') {
                return data['msg']
            } else {
               return 'n/a'
            }
        }
    });
}