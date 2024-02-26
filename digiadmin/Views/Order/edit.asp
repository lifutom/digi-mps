<%

    Dim vwItem : Set vwItem = ViewData("item")
    Dim DDItem

    Dim vwDDSupplierList : Set vwDDSupplierList = ViewData("suplist")

%>

<!--Section: Main panel-->
<section class="mb-5 mt-5">
    <form id="form" name="form" method="post" action="/<%=CurRoot%>/order/editpost">
        <input type="hidden" id="id" name="id" value="<%=vwItem.OrderID%>" />
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
                        <input type="date" id="orderdate" name="orderdate" value="<%=vwItem.OrderDate%>" required/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Bemerkung:
                    </td>
                    <td>
                        <input id="description" name="description" type="text" size="40" value="<%=vwItem.Description%>">
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
                                    <th style="display:none">ID</th>
                                    <th style="display:none">OrderID</th>
                                    <th style="display:none">SparepartID</th>
                                    <th class="th-sm">Lieferanten-Nr</th>
                                    <th class="th-sm">Nummer</th>
                                    <th class="th-sm">Bezeichnung</th>
                                    <th class="th-sm">Anzahl</th>
                                    <th class="th-sm">Preis</th>
                                    <th>&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% For Each DDItem In vwItem.Details.Items %>
                                    <tr>
                                        <td style="display:none"><input type="text" name="orderid" value="<%=DDItem.ID%>"  /></td>
                                        <td style="display:none"><%=DDItem.OrderID%></td>
                                        <td style="display:none"><%=DDItem.SparepartID%></td>
                                        <td><%=DDItem.SupplierNb%></td>
                                        <td><%=DDItem.SparepartNb%></td>
                                        <td><%=DDItem.Sparepart%></td>
                                        <td><input id="qty_<%=DDItem.OrderID%>" name="qty_<%=DDItem.OrderID%>" value="<%=DBFormatNumber(DDItem.Qty)%>" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" required/></td>
                                        <td><input id="price_<%=DDItem.OrderID%>" name="price_<%=DDItem.OrderID%>" value="<%=DBFormatNumber(DDItem.Price)%>" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" required/></td>
                                        <td></td>
                                    </tr>
                                <% Next %>
                            </tbody>
                        </table>
                    </td>
                </tr>

                <!--<tr>
                    <td>
                        Anzahl:
                    </td>
                    <td>
                        <input id="ordact" name="ordact" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" value="" required>
                    </td>
                </tr>-->
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
                <button type="submit" class="btn btn-cyan orderbtn" id="orderbtn"><i class="far fa-save"></i>&nbsp;Speichern</button>
            </div>
        </div>
    </form>
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/quote/edit.js?v=1.0"></script>