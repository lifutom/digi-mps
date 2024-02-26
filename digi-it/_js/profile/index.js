/* Version 1.1 2021-11-19*/
/* Version 1.0 2021-08-10*/

var deldtlist;

$(function () {

    var adtlist = $('#adtlist').DataTable({
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
       "bFilter" : true,
       "language": {
          "info": "Seite _PAGE_ von _PAGES_",
          "infoEmpty":      "Seite 0 von 0",
          "search": "Suchen:",
          "lengthMenu": "Zeige _MENU_ Eintr&auml;ge",
          "paginate": {
              first:    '<i class="fa fa-fast-backward"></i>',
              previous: '<i class="fa fa-backward"></i>',
              next:     '<i class="fa fa-forward"></i>',
              last:     '<i class="fa fa-fast-forward"></i>'
          },
       },
    });
    deldtlist = $('#deldtlist').DataTable({
       "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "Alle"]],
       "pagingType": "full_numbers",
       "bFilter" : true,
       "language": {
          "info": "Seite _PAGE_ von _PAGES_",
          "infoEmpty":      "Seite 0 von 0",
          "search": "Suchen:",
          "lengthMenu": "Zeige _MENU_ Eintr&auml;ge",
          "paginate": {
              first:    '<i class="fa fa-fast-backward"></i>',
              previous: '<i class="fa fa-backward"></i>',
              next:     '<i class="fa fa-forward"></i>',
              last:     '<i class="fa fa-fast-forward"></i>'
          },
          "columns" : [
                {
                  data: 'isid'
                },
                {
                  data: 'lastname'
                },
                {
                  data: 'firstname'
                },
                {
                    render: function (data,type) {
                        return '<i class="fas fa-trash-alt btndel"></i>';
                    }
                }
        ],
       },
    });

    $('.dataTables_length').addClass('bs-select');


    $('#refresh').click(function() {
        window.location.reload();
    });

    $('.search-drowdown').select2();


    $('#btnAdd').click(function() {
        saveDelegate();
    });

    $('#deldtlist tbody').on('click', '.btndel', function () {
        var data = deldtlist.row( $(this).parents('tr') ).data();

        $('.question-info').html('Datensatz löschen');

        $('#question-ok').unbind();
        $('#question-ok').click(function() {
            $('#question').modal('hide');
            delDelegate(data);
        });

        $('#question').modal('show');

    });

});


function saveData() {

    if (!$('#form')[0].checkValidity()) {
        $('#form').find('input[type="submit"]').click();
        return false;
    }

    var id=$('#isid').val();
    var roomid= $('#roomid').val() == '' ? -1 : $('#roomid').val();
    var lang = $('#CurLang').val();

    var data = {
        item: 'user-profile',
        id: id,
        roomid: roomid,
        lang: lang
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                $('.successmsg').html(data["errmsg"]);
                $('#success').modal('show');
            } else {
                $('.warningmsg').html(data["errmsg"]);
                $('#warning').modal('show');
            }
        },
        failure: function () {

        }
    });
}


function saveDelegate() {

    if (!$('#delegateform')[0].checkValidity()) {
        $('#delegateform').find('input[type="submit"]').click();
        return false;
    }

    var isid=$('#isid').val();
    var delegate=$('#delegateisid').val();
    var lang = $('#CurLang').val();
    var data = {
        item: 'user-delegate-add',
        id: isid,
        delegate: delegate,
        lang: lang
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
                /*deldtlist.row.add(
                [
                  data["isid"],
                  data["lastname"],
                  data["firstname"],
                  '<i class="fas fa-trash-alt btndel"></i>'
                ]
                ).draw(false); */

                $("#delegateisid option[value='"+ data["isid"] + "']").remove();
                $("#delegateisid").prop('selectedIndex', 0);
                $('#successbtn').unbind();
                $('#successbtn').click(function () {
                    updateDelList(data['id']);
                });

                $('.successmsg').html(data["errmsg"]);
                $('#success').modal('show');
            } else {
                $('.warningmsg').html(data["errmsg"]);
                $('#warning').modal('show');
            }
        },
        failure: function () {

        }
    });
}

function delDelegate(data) {

    var isid=$('#isid').val();
    var delegate=data[0];

    var lang = $('#CurLang').val();
    var data = {
        item: 'user-delegate-del',
        id: isid,
        delegate: delegate,
        lang: lang
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/saveitem.asp",
        data: data,
        success: function (data) {
            var mydata = JSON.parse(data);
            if (mydata["status"] == "OK") {
                $("#delegateisid option[value='"+ mydata["isid"] + "']").remove();
                $("#delegateisid").prop('selectedIndex', 0);
                $('#successbtn').unbind();
                $('#successbtn').click(function () {
                    updateDelList(mydata['id']);
                });
                $('.successmsg').html(mydata["errmsg"]);
                $('#success').modal('show');
            } else {
                $('.warningmsg').html(mydata["errmsg"]);
                $('#warning').modal('show');
            }
        },
        failure: function () {

        }
    });
}

function updateDelList(isid) {

    var lang = $('#CurLang').val();
    var data = {
        list: 'user-delegate',
        id: isid,
        lang: lang
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlist.asp",
        data: data,
        success: function (data) {
            var mydata = JSON.parse(data);

            deldtlist.clear().draw(true);

            if (mydata["status"] == "OK") {

                var list = mydata["user-delegate"];

                $.each(list, function (key, entry) {
                    deldtlist.row.add([
                      entry.isid,
                      entry.lastname,
                      entry.firstname,
                      '<i class="fas fa-trash-alt btndel"></i>'
                    ]).draw(true);
                });
            } else {

            }
        },
        failure: function () {

        }
    });
}




