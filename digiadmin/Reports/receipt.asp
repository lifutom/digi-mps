<!--#include virtual="/Utils/utils.asp" -->
<!--#include virtual="/models/models.asp" -->
<%

    Dim ID : ID = Request("id")
    Dim Typ : Typ = Request("typ")

    Dim rItem
    Dim sItem : Set sItem = New Supplier

    Select Case Typ
        Case "quote"
            MandantID = ReturnFromRecord("verkauf","verkaufid=" & ID, "mandantid")
            Set rItem = New Quote
            rItem.ID = ID
            TitleLabel = "Anfrage-Nr"
            TitleField = rItem.QuoteNb
            TitleDate = rItem.QuoteDate
            TitleDesc = rItem.Description
        Case "order"
            Set rItem = New Order
            rItem.ID = ID
            TitleLabel = "Bestell-Nr"
            TitleField = rItem.OrderNb
            TitleDate = rItem.OrderDate
            TitleDesc = rItem.Description
    End Select

    sItem.Init(rItem.SupplierID)

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
            background-color: #CCCCCC;
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


</head>
<body>
    <table width="100%">
    <tr>
        <td>
            <table>
                <tr heigth="40">
                    <td colspan="2">
                         &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <img class="logo" src="../Images/msd.png" width="120" height="auto" alt="">
                    </td>
                    <td>
                        <h4>Intervet GesmbH</h4>
                    </td>
                </tr>
            </table>
        </td>
        <td align="right">
            <table>
                <tr>
                    <td align="right">

                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr height="40px">
        <td colspan="2">
            &nbsp;
        </td>
    </tr>
    <tr height="40px">
        <td colspan="2" align="center">
            <h1><%=TitleLabel%>:&nbsp;<%=TitleField%></h1>
        </td>
    </tr>
    <tr>
       <td valign="top">
           An Firma<br>
           <%=sItem.Name%><br>
           <%=sItem.MainContact%><br>
           <%=sItem.Street%><br>
           <%=sItem.Country & "-" & sItem.Zip & " " & sItem.City%><br>
       </td>
       <td valign="top" align="right">
            <table>
                <tr>
                    <td width="120px">
                        <%=TitleLabel%>:
                    </td>
                    <td align="right">
                        <b><%=TitleField%></b>
                    </td>
                </tr>
                <tr>
                    <td>
                        KundenNr:
                    </td>
                    <td align="right">

                    </td>
                </tr>
                <tr>
                    <td>
                        Datum:
                    </td>
                    <td align="right">
                        <b><%=TitleDate%></b>
                    </td>
                </tr>
            </table>
       </td>
    </tr>
    <tr height="40px">
        <td colspan="2">

        </td>
    </tr>
    <tr>
        <td colspan="2">
             <p><%=TitleDesc%></p>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="left">
            <table width="100%" class="detail">
                <thead>
                    <tr class="trheader">
                        <th align="left">
                            Bestell-Nr
                        </th>
                        <th align="left">
                            Bezeichnung
                        </th>
                        <th align="left">
                            Ersatzteil-Nr
                        </th>
                        <th align="right">
                            Anzahl
                        </th>
                        <% If Typ="order" Then %>
                            <th align="right">
                                Preis/Einheit
                            </th>
                            <th align="right">
                                Summe
                            </th>
                        <% End If %>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Dim Summe : Summe = 0.00
                    Dim dItem

                    For Each dItem In rItem.Details.Items %>

                        <tr>
                            <th align="left">
                                <%=dItem.SupplierNb%>
                            </th>

                            <th align="left">
                                <%=dItem.Sparepart%>
                            </th>

                            <th align="left">
                                <%=dItem.SparepartNb%>
                            </th>

                            <th align="right">
                                    <%=IIf(dItem.Qty > 0 ,FormatNumber(dItem.Qty,2) , "")%>
                            </th>

                            <% If Typ="order" Then %>
                                <th align="right">
                                    <%=IIf(dItem.Price > 0 ,FormatNumber(dItem.Price,2) , "")%>
                                </th>
                                <th align="right">
                                    <%=IIf(dItem.Price > 0 ,FormatNumber(dItem.Price * dItem.Qty,2) , "")%>
                                </th>
                            <% End If %>

                        </tr>
                        <%
                        Summe = Summe + (dItem.Price * dItem.Qty)
                    Next
                    %>
                </tbody>
                <tfoot>
                        <tr>
                            <th colspan="<%=IIf(Typ="order",6,4)%>">
                                <hr>
                            </th>
                        </tr>
                        <% If Typ="order" Then %>
                            <tr>
                                <th colspan="4">

                                </th>
                                <th align="right">
                                    <b>Netto:</b>
                                </th>
                                <th align="right">
                                    <b><%=FormatNumber(Summe,2)%></b>
                                </th>
                            </tr>
                        <% End If %>
                </tfoot>
            </table>
        </td>
    </tr>
    </table>
</body>
</html>