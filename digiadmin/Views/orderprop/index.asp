<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwItem
   Dim DDItem

   Dim vwDDModuleList : Set vwDDModuleList = ViewData("modlist")
   Dim vwDDSupplierList : Set vwDDSupplierList = ViewData("suplist")
   Dim vwLines : Set vwLines = ViewData("lines")
   Dim vwDevices : Set vwDevices = ViewData("devices")
   Dim vwSearch : Set vwSearch = ViewData("search")
%>
<!-- ./Modal Add Sparepart to Cart Form -->
<!-- Edit Article in Orderlist -->
<div class="modal fade" id="orderSpare" tabindex="-1" role="dialog" aria-labelledby="orderSpare" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-shipping-fast"></i>&nbsp;&nbsp;Bestellung</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="formOrderSpare" action="javascript:saveSpareOrder_data();">
                    <input type="hidden" id="ordid" name="ordid" value="" />
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Ersatzteil-Nr:
                                </td>
                                <td>
                                    <input id="ordsparepartnb" name="ordsparepartnb" type="text" size="20" value="" disabled>
                                    <input type="hidden" id="ordsparepartid" name="ordsparepartid" value="" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Bezeichnung:
                                </td>
                                <td>
                                    <input id="ordsparepart" name="ordsparepart" type="text" size="30" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Verfügbar:
                                </td>
                                <td>
                                    <input id="ordactval" name="ordactval" type="text" size="10" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lieferant:
                                </td>
                                <td>
                                    <select id="ordsupplierid" name="ordsupplierid" class="browser-default custom-select" required>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Anzahl:
                                </td>
                                <td>
                                    <input id="ordact" name="ordact" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" value="" required>
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
                            <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                            <button type="submit" class="btn btn-cyan orderbtn" id="orderbtn"><i class="far fa-save"></i>&nbsp;Speichern</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- ./Modal Edit Sparepart to Cart Form -->

<!--Section: Table OrderProp-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <div>
                <a href="" class="white-text text-center mx-3"><i class="fa fa-shipping-fast"></i>&nbsp;Bestellvorschlagsliste</a>
            </div>
            <div>
                <form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/orderprop/indexpost">
                    <input type="hidden" id="todo" name="todo" value=""/>
                        <table>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Lieferant&nbsp;
                                    <select style="height: 30px;" id="supplierid" name="supplierid" class="browser-default custom-select">
                                        <option style="height: 20px;" value="-1">--Alle--</option>
                                        <%
                                            For Each DDItem In vwDDSupplierList.Items
                                                %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.SupplierID),"selected","")%>><%=DDItem.Name%></option><%
                                            Next
                                        %>
                                    </select>&nbsp;&nbsp;
                                </td>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Linie&nbsp;
                                    <select style="height: 30px;" id="plantid" name="plantid" class="browser-default custom-select">
                                        <option style="height: 20px;" value="-1">--Alle--</option>
                                        <%
                                            For Each DDItem In vwLines.Items
                                                %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.PlantID),"selected","")%>><%=DDItem.Name%></option><%
                                            Next
                                        %>
                                    </select>
                                </td>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Anlage&nbsp;
                                    <select style="height: 30px;" id="deviceid" name="deviceid" class="browser-default custom-select">
                                        <option style="height: 20px;" value="-1">--Alle--</option>
                                        <%
                                            For Each DDItem In vwDevices.Items
                                                %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.DeviceID),"selected","")%>><%=DDItem.Name%></option><%
                                            Next
                                        %>
                                    </select>
                                </td>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Baugruppe&nbsp;
                                    <select style="height: 30px;" id="moduleid" name="moduleid" class="browser-default custom-select">
                                        <option style="height: 20px;" value="-1">--Alle--</option>
                                        <%
                                            For Each DDItem In vwDDModuleList.Items
                                                %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.ModuleID),"selected","")%>><%=DDItem.Name%></option><%
                                            Next
                                        %>
                                    </select>
                                </td>
                                <td>
                                    <a class="btn btn-sm btn-cyan" id="searchlink" name="searchlink" title="Suchen" alt="Suchen"><span style="font-size: 14px" class="glyphicon glyphicon-eye-open"></span></a>
                                </td>
                                <td>
                                    <a class="btn btn-sm btn-cyan" title="Filter l&ouml;schen" alt="Filter l&ouml;schen" id="delfilter" name="delfilter"><span style="font-size: 14px"class="glyphicon glyphicon-eye-close"></span></a>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" valign="top" style="font-size: 8pt;" colspan="2">
                                    Textsuche:&nbsp;<input type="text" id="searchtxt" name="searchtxt" value="<%=vwSearch.SearchTxt%>"/>
                                </td>
                                <td align="left" style="font-size: 8pt;" colspan="4">
                                    <table>
                                        <tr>
                                             <td style="font-size: 8pt;">Datum von:</td>
                                             <td style="font-size: 8pt;"><input type="date" id="start" name="start" value="<%=vwSearch.StartDate%>" placeholder="Start"/></td>
                                        </tr>
                                        <tr>
                                             <td style="font-size: 8pt;">Datum bis:</td>
                                             <td style="font-size: 8pt;"><input type="date" id="end" name="end" value="<%=vwSearch.EndDate%>" placeholder="Start"/></td>
                                        </tr>
                                    </table>
                                </td>

                            </tr>
                        </table>

                </form>
            </div>
            <div class="float-right">

            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body col-12">
            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtslist" name="dtslist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">OrderID</th>
                            <th class="th-sm">Ersatzteil-Nr</th>
                            <th class="th-sm">Ersatzteil</th>
                            <th class="th-sm">Vorschlag</th>
                            <th class="th-sm">Verfügbar</th>
                            <th class="th-sm">Lieferant</th>
                            <th class="th-sm">BestellNr</th>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">Erstellt am</th>
                            <th class="th-sm">von</th>
                            <th>&nbsp;</th>
                            <th style="display:none">StateID</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    If Not vwList Is Nothing Then
                        For Each vwItem In vwList.Items
                             %><tr>
                                <td style="display:none"><%=vwItem.OrderID%></td>
                                <td nowrap><%=vwItem.SparepartNb%></td>
                                <td><%=vwItem.Sparepart%></td>
                                <td><%=FormatNumber(vwItem.OrderQty,2)%></td>
                                <td><%=FormatNumber(vwItem.Act,2)%></td>
                                <td><%=vwItem.Supplier%></td>
                                <td><%=vwItem.OrderNb%></td>
                                <td><%=vwItem.OrderState%></td>
                                <td><%=DBFormatDateTime(vwItem.Created)%></td>
                                <td><%=vwItem.CreatedBy%></td>
                                <td>
                                    <% If vwItem.StateID = 0 Then %>
                                        <a href="javascript:deleteItemQue(<%=vwItem.OrderID%>);" title="L&ouml;schen"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                    <% End If %>
                                </td>
                                <td style="display:none"><%=vwItem.StateID%></td>
                            </tr><%
                        Next
                    End If
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>
<!--Section: Table OrderProp-->

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/orderprop/index.js?v1.1"></script>
