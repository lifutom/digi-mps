<!--#include virtual="/Utils/utils.asp" -->
<!--#include virtual="/models/models.asp" -->
<%

    Dim ID : ID = Request("id")
    Dim curRootFile : curRootFile = "/" & Application("root")

    Dim oNear : Set oNear = New NearMiss
    oNear.Init(ID)

%>
<!DOCTYPE HTML>

<html>
<head>
    <title><%=GetLable(TitleLabel, Session("Lang"))%>&nbsp;<%=TitleField%></title>
    <style>
        body, html{
            font-family: arial;
            font-size: 16px;
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

        .detail {
            font-size: 14px;
            border-spacing: 0;
        }
        .trheader {
            /*background-color: #CCCCCC;*/
            height: 35px;
        }

        .detail th {
            font-weight: normal;
            padding-left: 5px;
            padding-right: 5px;
        }

        .detail td {
            font-weight: normal;
            padding-left: 5px;
            padding-right: 5px;
        }
        hr {
            border:none;
            height: 1px;
            color: black;
            background-color: black;
        }
    </style>
    <!-- Font Awesome -->
    <!--<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">-->
    <link rel="stylesheet" href="<%=CurRootFile%>/font/fontawesome-5.8.2-web/css/all.css">


    <!-- Ionicons -->
    <link rel="stylesheet" href="<%=CurRootFile%>/font/Ionicons/css/ionicons.css">

    <!-- glyphicons -->
    <link rel="stylesheet" href="<%=CurRootFile%>/font/glyphicons/glyphicon.css">


    <!-- Bootstrap core CSS -->
    <link href="<%=CurRootFile%>/css/bootstrap.min.css" rel="stylesheet">

    <!-- Material Design Bootstrap -->
    <link href="<%=CurRootFile%>/css/mdb.css" rel="stylesheet">

    <!-- Material Design Bootstrap -->
    <link href="<%=CurRootFile%>/css/style.css" rel="stylesheet">

</head>
<body>
    <table width="100%" bgcolor="#FFFFFF">
        <tr style="height: 100px">
            <td>
                <table width="100%">
                    <tr>
                        <td align="left" width="20%">
                            <img src="../Images/target-0.png" width="225" height="137" alt="">
                        </td>
                        <td width="60%" class="text-center">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <font color="#33CC99" size="+3">
                                            TARGET 0 - VORFALLSMELDUNG
                                        </font>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="40">
                                        <font size="+2" color="#FFFFFF" style="background-color: #CC0000;">
                                            &nbsp;Tag Nummer:&nbsp;<%=oNear.NearNb%>&nbsp;
                                        </font>
                                    </td>
                                </tr>
                            </table>

                        </td>
                        <td align="right" width="20%">
                            <img src="../Images/target-0-form.png" width="89" height="119" alt="">
                            <img src="../Images/msd-logo.png" width="68" height="66" alt="">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <% For Each vwDDItem In oNear.CategorieList.Items%>

                            <td width="10%" style="height: 70px; border-color: black; border-style: solid; border-width: 1px;">

                                    <div class="text-center">
                                        <img style="height: 50px; width: 50px;" class="card-img-bottom" src="<%=CurRootFile & "/images/" & vwDDitem.IconClass%>" alt="<%=vwDDItem.Name%>" title="<%=vwDDItem.Name%>">
                                    </div>

                            </td>

                        <% Next %>
                    </tr>
                    <tr bgcolor="#CCFFCC">
                        <% For Each vwDDItem In oNear.CategorieList.Items%>

                            <td width="10%" class="text-center" style="border-color: black; border-style: solid; border-width: 1px;">
                                <font size="+2">
                                    <%=IIf(vwDDItem.Active=1,"X","")%>
                                </font>
                            </td>

                        <% Next %>
                    </tr>


                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td width="45%" style=" height: 300px; border-color: black; border-style: solid; border-width: 1px;">
                            <% If  oNear.VirtualPath <> "" Then %>
                                <div>
                                    <img src="<%=curRootFile & "/" & oNear.VirtualPath%>" class="img-fluid" alt="<%=oNear.NearNb%>"/>
                                </div>
                            <% End If %>
                        </td>
                        <td width="10%">

                        </td>
                        <td width="45%" style="height: 300px; border-color: black; border-style: solid; border-width: 1px;" >
                            <% If  oNear.VirtualTaskPath <> "" Then %>
                                <div>
                                    <img src="<%=curRootFile & "/" & oNear.VirtualTaskPath%>" style="max-width: auto; max-height: 300px" alt="<%=oNear.NearNb%>"/>
                                </div>
                            <% End If %>
                        </td>
                    </tr>
                    <tr height="20">
                        <td colspan="3" style="border-style: none;">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="45%">
                            <font size="+2">Beschreibung:</font>
                            <p><%=oNear.Description%></p>
                        </td>
                        <td width="10%">

                        </td>
                        <td width="45%">
                            <font size="+2">Sofortmassnahmen:</font>
                            <p><%=oNear.Task%></p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

    </table>
</body>
</html>