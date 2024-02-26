<%

%>
<!DOCTYPE html>
<html>
    <head>
        <style>
            body, html{
                font-family: arial;
                font-size: 16px;
            }
        </style>
        <script>
            var pdfInfo = {};
            var x = document.location.search.substring(1).split('&');
            for (var i in x) { var z = x[i].split('=',2); pdfInfo[z[0]] = unescape(z[1]); }
            function getPdfInfo() {
                var page = pdfInfo.page || 1;
                var pageCount = pdfInfo.topage || 1;
                document.getElementById('pdfkit_page_current').textContent = page;
                document.getElementById('pdfkit_page_count').textContent = pageCount;

                if (parseInt(page) == parseInt(pageCount)) {
                    document.getElementById("pdfSum").style.display="none";
                }
            }
        </script>
    </head>
    <body onload="getPdfInfo();">
        <table width="100%">
            <tr>
                <td colspan="3">
                    <hr>
                </td>
            </tr>
            <tr>
                <td width="33%">
                    Seite&nbsp;<span id="pdfkit_page_current"></span>/<span id="pdfkit_page_count"></span>
                </td>
                <td width="33%">
                    Druckdatum:&nbsp;<%=Now%>&nbsp;<%=Session("login")%>
                </td>
                <td align="right" width="34%">
                    MSD Austria AH
                </td>
            </tr>
        </table>
    </body>
</html>
