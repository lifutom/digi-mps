<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwDDModuleList : Set vwDDModuleList = ViewData("modlist")
   Dim vwDDSupplierList : Set vwDDSupplierList = ViewData("suplist")
   Dim vwLines : Set vwLines = ViewData("lines")
   Dim vwDevices : Set vwDevices = ViewData("devices")
   Dim vwSearch : Set vwSearch = ViewData("search")
   Dim ListItem
   Dim DDItem
   Dim vwDDWHList : Set vwDDWHList = ViewData("warehouse")
   Dim vwDDCatList : Set vwDDCatList = ViewData("catlist")
   Dim vwDDItem
%>
<!--Section: Table User-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <div>
                <a href="" class="white-text text-center mx-3"><i class="fa fa-truck"></i>&nbsp;Ersatzteil Auswertung</a>
            </div>
            <div>
                <form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/stat/sparepost">
                        <table>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Kategorie&nbsp;
                                    <select style="height: 30px;" id="catid" name="catid" class="browser-default custom-select">
                                        <option style="height: 20px;" value="0">--Alle--</option>
                                        <%
                                            For Each DDItem In vwDDCatList.Items
                                                %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.CatID),"selected","")%>><%=DDItem.Name%></option><%
                                            Next
                                        %>
                                    </select>&nbsp;&nbsp;
                                </td>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Standard-Lieferant&nbsp;
                                    <select style="height: 30px;" id="srcsupplierid" name="srcsupplierid" class="browser-default custom-select">
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
                                <td>

                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="font-size: 8pt;" colspan="3">
                                     Lager:&nbsp;
                                    <select style="height: 30px;" id="searchwarehouseid" name="searchwarehouseid" class="browser-default custom-select">
                                        <option style="height: 20px;" value="-1">--Alle--</option>
                                        <% For Each DDItem In vwDDWHList.Items %>
                                                <option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.WarehouseID),"selected","")%>><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>&nbsp;&nbsp;
                                </td>
                                <td colspan="3">
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
            <div class="card-header text-right">
                <h4>Lagerwert:&nbsp;€<%=FormatNumber(vwList.Amount,2)%>&nbsp;&nbsp;Ausgang:&nbsp;€<%=FormatNumber(vwList.Remove,2)%>&nbsp;&nbsp;Eingang:&nbsp;€<%=FormatNumber(vwList.Receive,2)%></h4>
            </div>
            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtslist" name="dtslist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">SparepartID</th>
                            <th class="th-sm">Nummer</th>
                            <th class="th-sm">Bezeichnung</th>
                            <th class="th-sm">Type-Nr</th>
                            <th class="th-sm">Bestand</th>
                            <th class="th-sm">Preis/EH</th>
                            <th class="th-sm">Wert</th>
                            <th class="th-sm">Entnahme</th>
                            <th class="th-sm">Bewegungen</th>
                            <th class="th-sm">Wert</th>
                            <th class="th-sm">Zugang</th>
                            <th class="th-sm">Bewegungen</th>
                            <th class="th-sm">Wert</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    If Not vwList Is Nothing Then
                        For Each ListItem In vwList.List.Items
                             %><tr>
                                <td style="display:none"><%=ListItem.SparepartID%></td>
                                <td nowrap><%=ListItem.SparepartNb%></td>
                                <td><%=ListItem.Sparepart%></td>
                                <td><%=ListItem.SpareNb%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.Act,2)%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.Price,2)%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.Amount,2)%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.actRemove + ListItem.actDelete,2)%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.cntRemove + ListItem.cntDelete,2)%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.amountRemove  + ListItem.amountDelete ,2)%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.actReceive + ListItem.actAdd,2)%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.cntReceive + ListItem.cntAdd,2)%></td>
                                <td class="text-right"><%=FormatNumber(ListItem.amountReceive + ListItem.amountAdd,2)%></td>
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
<!--Section: Table Plant-->

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/stat/spare.js?v1.0"></script>
