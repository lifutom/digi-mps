<%

    Dim vwItem : Set vwItem = ViewData("item")
    Dim DDItem

    Dim vwDDSupplierList : Set vwDDSupplierList = ViewData("suplist")

%>

<!--Section: Main panel-->
<section class="mb-5 mt-5">
    <form id="form" name="form" method="post" action="javascript:createBookQue();">
        <input type="hidden" id="id" name="id" value="<%=vwItem.OrderID%>" />
        <input type="hidden" id="refresh" name="refresh" value="<%=Request.Form("refresh")%>" />
        <div class="table-responsive">
            <table>
                <tr>
                    <td>
                        Lieferant:
                    </td>
                    <td>
                        <% If  vwItem.SupplierID = 0 Then %>
                            <select id="supplierid" name="supplierid" class="browser-default custom-select" required <%=IIf(CLng(vwItem.OrderID) > CLng(0),"disabled","")%>>
                                <option value="">--Lieferantenauswahl--</option>
                                <% For Each DDItem In vwDDSupplierList.Items  %>
                                       <option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwItem.SupplierID),"selected","")%>><%=DDItem.Name%></option>
                                <% Next %>
                            </select>
                        <% Else
                            For Each DDItem In vwDDSupplierList.Items
                                If CInt(DDItem.Value) = CInt(vwItem.SupplierID) Then
                                   %><input type="hidden" name="supplierid" value="<%=vwItem.SupplierID%>"/><%=DDItem.Name%><%
                                End If
                            Next
                           End If %>
                    </td>
                </tr>
                <tr>
                    <td>
                        Anfrage-Nr:
                    </td>
                    <td>
                        <input id="ordernb" name="ordernb" type="text" size="20" value="<%=vwItem.OrderNb%>" disabled>
                    </td>
                </tr>
                <tr>
                    <td>
                        Datum:
                    </td>
                    <td>
                        <input type="date" id="orderdate" name="orderdate" value="<%=vwItem.OrderDate%>" required disabled/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Bemerkung:
                    </td>
                    <td>
                        <input id="description" name="description" type="text" size="40" value="<%=vwItem.Description%>" disabled>
                    </td>
                </tr>

                <tr>
                    <td col="2" height="30px">

                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table id="dtlist" name="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <!--<th>

                                    </th>-->
                                    <th></th>
                                    <th style="display:none">OrderID</th>
                                    <th style="display:none">SparepartID</th>
                                    <th class="th-sm">Lieferanten-Nr</th>
                                    <th class="th-sm">Nummer</th>
                                    <th class="th-sm">Bezeichnung</th>
                                    <th class="th-sm">Preis</th>
                                    <th class="th-sm">Bestellt</th>
                                    <th class="th-sm">Datum</th>
                                    <th class="th-sm">Geliefert</th>

                                    <th>&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% For Each DDItem In vwItem.Details.Items %>
                                    <tr>
                                        <td>
                                            <% If DDItem.OpenQty > 0 Then %>
                                                <div class="text-center custom-control custom-checkbox"><input type="checkbox" class="custom-control-input" name="orderid" id="orderid_<%=DDItem.OrderID%>" value="<%=DDItem.OrderID%>"><label class="custom-control-label" for="orderid_<%=DDItem.OrderID%>"></label></div>
                                            <% End If %>
                                        </td>
                                        <td style="display:none"><%=DDItem.OrderID%></td>
                                        <td style="display:none"><%=DDItem.SparepartID%></td>
                                        <td><%=DDItem.SupplierNb%></td>
                                        <td><%=DDItem.SparepartNb%></td>
                                        <td><%=DDItem.Sparepart%></td>
                                        <td><%=FormatNumber(DDItem.Price,2)%></td>
                                        <td><%=FormatNumber(DDItem.Qty,2)%></td>
                                        <td>
                                            <% If DDItem.OpenQty > 0 Then %>
                                                <input type="date" id="receiptdate_<%=DDItem.OrderID%>" name="receiptdate_<%=DDItem.OrderID%>" value="<%=DBFormatDate(DDItem.ReceiptDate)%>" required/>
                                            <% End If %>
                                        </td>
                                        <td>
                                            <% If DDItem.OpenQty > 0 Then %>
                                                <input id="receiptqty_<%=DDItem.OrderID%>" name="receiptqty_<%=DDItem.OrderID%>" value="<%=DBFormatNumber(DDItem.OpenQty)%>" type="number" pattern="[0-9]+([\.,][0-9]+)?" max="<%=DDItem.OpenQty%>" step="0.01" required/>
                                            <% End If %>
                                        </td>
                                        <td></td>
                                    </tr>
                                <% Next %>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr height="30">
                    <td colspan="2" valign="bottom">
                         <div class="text-danger" id="errmsg"></div>
                    </td>
                </tr>
                <tr height="30">
                    <td colspan="2" valign="bottom">
                         <div class="text-danger" id="errmsg1"></div>
                    </td>
                </tr>
            </table>
            <div class="modal-footer d-flex justify-content-center">
                <input type="submit" style="display:none;"/>
                <button class="btn btn-danger" onclick="window.close();">Schlieﬂen</button>
                <button type="submit" class="btn btn-cyan orderbtn" id="orderbtn"><i class="far fa-save"></i>&nbsp;Buchen</button>
            </div>
        </div>
    </form>
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/order/receipt.js?v=1.0"></script>