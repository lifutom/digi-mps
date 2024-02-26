<%

%>
<!DOCTYPE HTML>

<html>
<head>
    <title>Testprint</title>
    <!-- Bootstrap v4.0.0-beta -->
    <!--<link rel="stylesheet" href="<%=Application("https")%>/assets/vendor_components/bootstrap/dist/css/bootstrap.css">-->
    <style>
        body, html{
            font-family: verdana;
            font-size: 12px;
        }

        /* Custom node styling */
        h4 {
            font-size: 16px;
        }

        .small {
           font-size: 8px;
        }

        .logo {
            margin-right: 20px;
            margin-bottom: 12px;
        }

        table.detail {
            font-size: 12px;
            border-spacing: 0;
        }
        table.detail thead tr {
            height: 35px;
            background-color: #FFF;
        }

        table.detail thead tr.param {
            height: 20px;
            background-color: #FFF;
            font-size: 10px;
        }

        table.detail th {
            font-weight: normal;
            padding-left: 5px;
            padding-right: 5px;
        }

        table.detail td {
            font-weight: normal;
            padding-left: 5px;
            padding-right: 5px;
        }

        table.detail thead tr.header {
            background: #000;
            font-weight: bold;
            color: white;

        }

        /*table.detail tbody tr:nth-child(even) {background: #CCC}
        table.detail tbody tr:nth-child(odd) {background: #FFF}*/

        hr {
            border:none;
            height: 1px;
            color: black;
            background-color: black;
        }

    </style>
    <script>

        var pdfInfo = {};
        var x = document.location.search.substring(1).split('&');
            for (var i in x) {
                var z = x[i].split('=', 2);
                pdfInfo[z[0]] = unescape(z[1]);
            }

        function subst() {
            var page = pdfInfo.page || 1;
            var pageCount = pdfInfo.topage || 1;

            document.getElementById('pdfkit_page_current').textContent = page;
            document.getElementById('pdfkit_page_count').textContent = pageCount;

            if (page < pageCount && pageCount > 1) {
                document.getElementById("pdfFooter").style.display = "none";
            }
        }
    </script>
</head>
<body onload="subst()">
    <table width="100%" class="detail">
        <thead>
            <tr class="header">
                <th align="left">
                    Test1
                </th>
                <th align="left">
                    Test2
                </th>
                <th align="left">
                     Test3
                </th>
                <th align="right">
                    Test4
                </th>
            </tr>
        </thead>
        <tbody>

        </tbody>
    </table>
</body>
</html>
<%

%>