/* Version 1.1: 2021-09-14 */

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

function PopupCenter(url, title, w, h) {
    // Fixes dual-screen position                         Most browsers      Firefox
    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : window.screenY;

    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var systemZoom = width / window.screen.availWidth;
    var left = (width - w) / 2 / systemZoom + dualScreenLeft
    var top = (height - h) / 2 / systemZoom + dualScreenTop
    var newWindow = window.open($('#CurRootFile').val() + '/' + url, '_blank', 'scrollbars=yes, width=' + w / systemZoom + ', height=' + h / systemZoom + ', top=' + top + ', left=' + left);
    newWindow.title = title;
    // Puts focus on the newWindow
    if (window.focus) newWindow.focus();
}

function PopupInTab(url) {
    var newWindow = window.open($('#CurRootFile').val() + '/' + url, '_blank');
}


function openwindow(url, wtitle) {


    PopupCenter(url, wtitle, 800, 700);

}


function OpenWindowWithPost(url, windowoption, name, params)
{
    var form = document.createElement("form");
    form.setAttribute("method", "post");
    form.setAttribute("action", url);
    form.setAttribute("target", name);

    for (var i in params) {
        if (params.hasOwnProperty(i)) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = i;
            input.value = params[i];
            form.appendChild(input);
        }
    }

    document.body.appendChild(form);

    //note I am using a post.htm page since I did not want to make double request to the page
   //it might have some Page_Load call which might screw things up.
    window.open("post.htm", name, windowoption);

    form.submit();

    document.body.removeChild(form);
}

function getListXLSX(list)  {

    var data = {
        list: list
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlistheader.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               var workbook = createXLSX(data['tabs']);
               workbook.saveAsync(data["filename"] + '.xlsx');
            }
        },
        failure: function () {
        }
    });
}

function createXLSX(xlstabs) {

    var wjcXlsx = wijmo.xlsx;
    var book = new wjcXlsx.Workbook();
    var dateFormat = wjcXlsx.Workbook.toXlsxDateFormat('dd.mm.yyyy');
    var stdNumWidth = 85;

    var simpleCaptionStyle = new wjcXlsx.WorkbookStyle();
    simpleCaptionStyle.hAlign = wjcXlsx.HAlign.Right;

    var accentCaptionStyle = new wjcXlsx.WorkbookStyle();
    accentCaptionStyle.font = new wjcXlsx.WorkbookFont();
    accentCaptionStyle.font.color = '#808097';

    var totalCaptionStyle = new wjcXlsx.WorkbookStyle();
    totalCaptionStyle.basedOn = simpleCaptionStyle;
    totalCaptionStyle.font = new wjcXlsx.WorkbookFont();
    totalCaptionStyle.font.bold = true;
    totalCaptionStyle.hAlign = wjcXlsx.HAlign.Right;

    var valueStyle = new wjcXlsx.WorkbookStyle();
    valueStyle.font = new wjcXlsx.WorkbookFont();
    valueStyle.font.family = 'Arial';

    var highlightedValueStyle = new wjcXlsx.WorkbookStyle();
    highlightedValueStyle.basedOn = valueStyle;
    highlightedValueStyle.fill = new wjcXlsx.WorkbookFill();
    highlightedValueStyle.fill.color = '#e1e1e1';

    var tableHeaderStyle = new wjcXlsx.WorkbookStyle();
    tableHeaderStyle.font = new wjcXlsx.WorkbookFont();
    tableHeaderStyle.font.bold = true;
    tableHeaderStyle.font.color = '#ffffff';
    tableHeaderStyle.fill = new wjcXlsx.WorkbookFill();
    tableHeaderStyle.fill.color = '#000000';

    var tableFooterCurrencyStyle = new wjcXlsx.WorkbookStyle();
    tableFooterCurrencyStyle.basedOn = tableHeaderStyle;
    tableFooterCurrencyStyle.format = wjcXlsx.Workbook.toXlsxNumberFormat('c2');
    tableFooterCurrencyStyle.hAlign = wjcXlsx.HAlign.Right;

    var tableValueStyle = new wjcXlsx.WorkbookStyle();
    tableValueStyle.fill = new wjcXlsx.WorkbookFill();
    tableValueStyle.fill.color = '#f4b19b';

    var tableDateStyle = new wjcXlsx.WorkbookStyle();
    tableDateStyle.format = wjcXlsx.Workbook.toXlsxDateFormat('d');

    var tableCurrencyStyle = new wjcXlsx.WorkbookStyle();
    tableCurrencyStyle.format = wjcXlsx.Workbook.toXlsxNumberFormat('c2');

    var tableIntegerStyle = new wjcXlsx.WorkbookStyle();
    //tableIntegerStyle.basedOn = tableValueStyle;
    tableIntegerStyle.format = wjcXlsx.Workbook.toXlsxNumberFormat('00');

    var sheet, xlsheader, xlsdata, rows

    $.each(xlstabs, function (key, tabs) {
        sheet = new wjcXlsx.WorkSheet();
        rows = sheet.rows;
        book.sheets.push(sheet);
        sheet.name = tabs.tabname;
        rows[0] = new wjcXlsx.WorkbookRow();
        rows[0].style = new wjcXlsx.WorkbookStyle();
        rows[0].style.hAlign = wjcXlsx.HAlign.Left;

        xlsheader = tabs['header'];
        xlsdata = tabs['datalist'];

        $.each(xlsheader, function (key, entry) {
            rows[0].cells[entry.id - 1] = new wjcXlsx.WorkbookCell();
            rows[0].cells[entry.id - 1].value = entry.description;
            rows[0].cells[entry.id - 1].style = tableHeaderStyle;
        });
        var row=1;
        $.each(xlsdata, function (key, data) {
            rows[row] = new wjcXlsx.WorkbookRow();
            $.each(xlsheader, function (key, entry) {
                rows[row].cells[entry.id - 1] = new wjcXlsx.WorkbookCell();
                rows[row].cells[entry.id - 1].value = data[entry.valuename];
                switch (entry.typ) {
                    case 1:
                        rows[row].cells[entry.id - 1].style = tableIntegerStyle;
                        break;
                    case 2:
                        rows[row].cells[entry.id - 1].style = tableDateStyle;
                        break;
                    case 3:
                        rows[row].cells[entry.id - 1].style = tableValueStyle;
                        break;
                    case 4:
                        break;
                }
            });
            row++;
        });
    });
    return book;
}


function getListPDF(list, layout = 1)  {

    var data = {
        list: list
    }

    $.ajax({
        type: "POST",
        url: $('#CurRootFile').val() + "/ajax/getlistheader.asp",
        data: data,
        success: function (data) {
            data = JSON.parse(data);
            if (data["status"] == "OK") {
               createPDF(data, layout);
            }
        },
        failure: function () {
        }
    });
}


function createPDF(data, layout)  {

    var filename = data['filename'] + '.pdf'
    if (data['tabs'].length > 0) {
        var tab = data['tabs'][0];
        var pdf = wijmo.pdf;
        var doc = new pdf.PdfDocument({
            header: {
                    declarative: {
                        text: 'DigiMPS ' + tab['tabname'],
                        font: new pdf.PdfFont('helvetica', 18),
                        brush: '#bfc1c2'
                    }
                },
            footer: {
                    declarative: {
                        text: 'DigiMPS ' + tab['tabname'] + '\t&[Page]\\&[Pages]' + '\t' + (new Date()).toLocaleDateString() + ' ' + (new Date()).toLocaleTimeString() + ' by ' + data['isid'],
                        font: new pdf.PdfFont('helvetica', 8),
                        brush: '#bfc1c2'
                    }
                },
            pageSettings: {
                    margins: {
                        left: 10,
                        right: 10,
                        top: 36,
                        bottom: 36
                    },
                    layout: layout==1 ? pdf.PdfPageOrientation.Landscape : pdf.PdfPageOrientation.Portrait
                },
            ended: (sender, args) => pdf.saveBlob(args.blob, filename)
        });

        var header = tab['header'];
        var datalist = tab['datalist'];
        var colWidth = 100;
        var rowHeight = 18;
        var y = 0;

        $.each(datalist, function (key, item) {
            if (y == 0) {
                drawheader(doc, header,colWidth, rowHeight);
                y += rowHeight;
            }
            var x=0;
            $.each(header, function (key, entry) {
                doc.drawText(item[entry.valuename] + '', x + 2, y + 2, {
                font: new pdf.PdfFont('helvetica', 8),
                height: rowHeight,
                width: entry.colwidth
                });
                x +=  entry.colwidth;
            });
            y += rowHeight;
            if (y >= doc.height) {
                y = 0;
                doc.addPage();
            }
        });
        doc.end();
    }

}

function drawheader(doc, header,colWidth, rowHeight) {
    var x = 0;
    $.each(header, function (key, entry) {
        var y = 0;
        doc.drawText(entry.description + '', x + 2, y + 2, {
        font: new wijmo.pdf.PdfFont('helvetica', 8,'normal','bold'),
        height: rowHeight,
        width: entry.colwidth
        });
         x +=  entry.colwidth;
    });
}


function checkLineAvailable(doc) {
    if (doc.height - doc.y < doc.lineHeight() + doc.lineGap) {
        doc.addPage();
    }
}
//
function renderRow(doc, y, values, valueGetter, formatGetter, font, brush) {
    values.forEach((v, idx) => {
        let x = idx * colWidth;
        //
        doc.paths
            .rect(x, y, colWidth, rowHeight)
            .fill(brush || '#f4b19b');
        //
        let value = valueGetter != null ? valueGetter(v) : v || '';
        let format = formatGetter != null ? formatGetter(v) : '';
        //
        if (value !== 'Total') {
            value = wijmo.changeType(value, wijmo.DataType.String, format);
        }
        //
        doc.drawText(value, x + 3, y + 5, {
            font: font,
            height: rowHeight,
            width: colWidth
        });
    });
}

function centerModal() {
        $(this).css('display', 'block');
        var $dialog  = $(this).find(".modal-dialog"),
        offset       = ($(window).height() - $dialog.height()) / 2,
        bottomMargin = parseInt($dialog.css('marginBottom'), 10);

        // Make sure you don't hide the top part of the modal w/ a negative margin if it's longer than the screen height, and keep the margin equal to the bottom margin of the modal
        if(offset < bottomMargin) offset = bottomMargin;
        $dialog.css("margin-top", offset);
}







