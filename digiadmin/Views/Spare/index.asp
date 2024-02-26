<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwDDModuleList : Set vwDDModuleList = ViewData("modlist")
   Dim vwDDSupplierList : Set vwDDSupplierList = ViewData("suplist")
   Dim vwLines : Set vwLines = ViewData("lines")
   Dim vwDevices : Set vwDevices = ViewData("devices")
   Dim vwSearch : Set vwSearch = ViewData("search")
   Dim vwView : vwView = ViewData("view")
   Dim ListItem
   Dim DDItem
   Dim vwDDWHList : Set vwDDWHList = ViewData("warehouse")
   Dim vwBoxList : Set vwBoxList = ViewData("boxlist")
   Dim vwDDCatList : Set vwDDCatList = ViewData("catlist")
   Dim vwDDItem
   Dim vwOrderWh : vwOrderWh = GetAppSettings("receiptwh")

%>
<!-- Modal Add Sparepart to Cart Form -->
<div class="modal fade" id="editCart" tabindex="-1" role="dialog" aria-labelledby="EditCart" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Warenkorb</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="formAdd2Cart" action="javascript:saveSpare_data();">
                    <input type="hidden" id="id" name="id" value="" />
                    <div class="table-responsive">
                        <table>
                             <tr>
                                <td>
                                    Warenkorb:
                                </td>
                                <td>
                                    <input id="shoppingid" name="shoppingid" type="hidden" value="">
                                    <input id="name" name="name" type="test" value="" size="20" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Ersatzteil-Nr:
                                </td>
                                <td>
                                    <input id="sparepartnb" name="sparepartnb" type="text" size="20" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Bezeichnung:
                                </td>
                                <td>
                                    <input id="sparepart" name="sparepart" type="text" size="30" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Verfügbar:
                                </td>
                                <td>
                                    <input id="actval" name="actval" type="text" size="10" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lagerort:
                                </td>
                                <td>
                                    <select id="locationid" name="locationid" class="browser-default custom-select">
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Entnehmen:
                                </td>
                                <td>
                                    <input id="act" name="act" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" value="" required>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer d-flex justify-content-center">
                            <input type="submit" style="display:none;"/>
                            <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                            <button type="submit" class="btn btn-cyan sendbtn" id="sendbtn"><i class="fas fa-cart-plus"></i>&nbsp;Hinzufügen</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- ./Modal Add Sparepart to Cart Form -->
<!-- Modal Store Sparepart -->
<div class="modal fade" id="storeSpare" tabindex="-1" role="dialog" aria-labelledby="storeSpare" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Einlagern</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="formStoreSpare" action="javascript:saveStoreSpare_data();">
                    <input type="hidden" id="stid" name="stid" value="" />
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Ersatzteil-Nr:
                                </td>
                                <td>
                                    <input id="stsparepartnb" name="stsparepartnb" type="text" size="20" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Bezeichnung:
                                </td>
                                <td>
                                    <input id="stsparepart" name="stsparepart" type="text" size="30" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Verfügbar:
                                </td>
                                <td>
                                    <input id="stactval" name="stactval" type="text" size="10" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lagerort:
                                </td>
                                <td>
                                    <select id="stlocationid" name="stlocationid" class="browser-default custom-select">
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Einlagern:
                                </td>
                                <td>
                                    <input id="stact" name="stact" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" value="" required>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer d-flex justify-content-center">
                            <input type="submit" style="display:none;"/>
                            <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                            <button type="submit" class="btn btn-cyan" id="storebtn"><i class="far fa-hand-paper"></i>&nbsp;Buchen</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- ./Modal Store Sparepart-->


<!-- Modal Add Sparepart to Cart Form -->
<div class="modal fade" id="moveSpare" tabindex="-1" role="dialog" aria-labelledby="moveSpare" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-warehouse"></i>&nbsp;&nbsp;Umlagern</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="formMoveSpare" action="javascript:saveSpareMove_data();">
                    <input type="hidden" id="movid" name="movid" value="" />
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Ersatzteil-Nr:
                                </td>
                                <td>
                                    <input id="movsparepartnb" name="movsparepartnb" type="text" size="20" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Bezeichnung:
                                </td>
                                <td>
                                    <input id="movsparepart" name="movsparepart" type="text" size="30" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Verfügbar:
                                </td>
                                <td>
                                    <input id="movactval" name="movactval" type="text" size="10" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lagerort:
                                </td>
                                <td>
                                    <select id="movlocationid" name="movlocationid" class="browser-default custom-select">
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Umlagern:
                                </td>
                                <td>
                                    <input id="movact" name="movact" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" value="" required>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Box:
                                </td>
                                <td>
                                    <input id="mov2locationid" name="mov2locationid" type="hidden" value="">
                                    <select id="boxid" name="boxid" class="search-drowdown form-control" style="width: 100%" required>
                                        <option value="0">nicht in Box</option>
                                        <% For Each vwDDItem In vwBoxList.Items %>
                                                <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lager:
                                </td>
                                <td>
                                    <select id="warehouseid" name="warehouseid" class="browser-default custom-select" required="required">
                                        <% For Each vwDDItem In vwDDWHList.Items
                                            If vwDDItem.Value <> 3 Then
                                                %><option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option><%
                                            End If
                                        Next %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Regal:
                                </td>
                                <td>
                                    <input id="shelfid" name="shelfid" type="number" min="1" value="" required="required">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Fach:
                                </td>
                                <td>
                                    <input id="compid" name="compid" type="number" min="1" value="" required="required">
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
                            <button type="submit" class="btn btn-cyan bookbtn" id="bookbtn"><i class="fas fa-warehouse"></i>&nbsp;Umlagern</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- ./Modal Add Sparepart to Cart Form -->
<!-- Add Article to Orderlist -->
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
                            <button type="submit" class="btn btn-cyan orderbtn" id="orderbtn"><i class="fas fa-shipping-fast"></i>&nbsp;Bestellen</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- ./Modal Add Sparepart to Cart Form -->

<!--Section: Table User-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <div>
                <a href="" class="white-text text-center mx-3"><i class="fa fa-truck"></i>&nbsp;Ersatzteilliste</a>
            </div>
            <div>
                <form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/spare/indexpost">
                        <input type="hidden" id="vwview" name="vwview" value="<%=vwView%>" />
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
                                    <a class="btn btn-sm btn-cyan" title="<%=IIf(vwView="list", "Kacheln","Liste")%>" alt="<%=IIf(vwView="list", "Kacheln","Liste")%>" id="spareview" name="spareview"><span style="font-size: 14px"class="glyphicon <%=IIf(vwView="list","glyphicon-th","glyphicon-align-justify")%>"></span></a>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="font-size: 8pt;" colspan="2">
                                    Textsuche:&nbsp;<input type="text" id="searchtxt" name="searchtxt" value="<%=vwSearch.SearchTxt%>"/>
                                </td>
                                <td align="left" style="font-size: 8pt;" colspan="2">
                                     Lager:&nbsp;
                                    <select style="height: 30px;" id="searchwarehouseid" name="searchwarehouseid" class="browser-default custom-select">
                                        <option style="height: 20px;" value="-1">--Alle--</option>
                                        <% For Each DDItem In vwDDWHList.Items %>
                                                <option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.WarehouseID),"selected","")%>><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>&nbsp;&nbsp;
                                </td>
                                <td align="left" style="font-size: 8pt;" colspan="3">
                                    &nbsp;&nbsp;Regal:&nbsp;<input type="numeric" id="searchshelfid" name="searchshelfid" value="<%=IIf(vwSearch.ShelfID <> -1, vwSearch.ShelfID, "")%>" size="5"/>&nbsp;&nbsp;
                                    Fach:&nbsp;<input type="numeric" id="searchcompid" name="searchcompid" value="<%=IIf(vwSearch.CompID <> -1, vwSearch.CompID, "")%>" size="5"/>&nbsp;&nbsp;
                                    &nbsp;<select id="searchboxid" name="searchboxid" class="search-drowdown form-control" style="width: 100%" required>
                                        <option value="" selected>--Box--</option>
                                        <% For Each vwDDItem In vwBoxList.Items %>
                                                <option value="<%=vwDDItem.Value%>" <%=IIf(CInt(vwSearch.BoxID) = CInt(vwDDItem.Value),"selected", "")%>><%=vwDDItem.Name%></option>
                                        <% Next %>
                                    </select>&nbsp;&nbsp;
                                </td>
                            </tr>
                        </table>

                </form>
            </div>
            <div class="float-right">
                 <% If 1=0 Then %>
                    <button id="addbtn" class="btn btn-sm btn-cyan" title="Artikel hinzuf&uuml;gen" alt="Artikel hinzuf&uuml;gen"><i class="fas fa-shopping-cart"></i></button>&nbsp;
                 <% End If %>
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Artikel hinzuf&uuml;gen" alt="Artikel hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
            </div>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body col-12">


            <% If vwView = "list"  Then %>

                <div class="table-responsive">
                    <!-- Material Design Bootstrap -->
                    <table id="dtslist" name="dtslist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th style="display:none">Active</th>
                                <th style="display:none">SparepartID</th>
                                <th class="th-sm">Nummer</th>
                                <th class="th-sm">Bezeichnung</th>
                                <th class="th-sm">Type-Nr</th>
                                <th class="th-sm">MinBestand</th>
                                <th class="th-sm">Bestand</th>
                                <th class="th-sm">MinBest</th>
                                <th style="display:none">DefSupplierID</th>
                                <th class="th-sm">Lieferant</th>
                                <th class="th-sm">Kategorie</th>
                                <th class="th-sm">Vorsch/Best/Offen</th>
                                <th class="th-sm">Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                        If Not vwList Is Nothing Then
                            For Each ListItem In vwList.Items
                                 %><tr>
                                    <td style="display:none"><%=ListItem.Active%></td>
                                    <td style="display:none"><%=ListItem.ID%></td>
                                    <td nowrap><%=ListItem.SparepartNb%></td>
                                    <td><%=ListItem.Sparepart%></td>
                                    <td><%=ListItem.SpareNb%></td>
                                    <td><%=FormatNumber(ListItem.MinLevel,2)%></td>
                                    <td><%=FormatNumber(ListItem.ActLevel,2)%></td>
                                    <td><%=FormatNumber(ListItem.MinOrderLevel,2)%></td>
                                    <td style="display:none"><%=ListItem.DefSupplierID%></td>
                                    <td><%=ListItem.Supplier%></td>
                                    <td><%=ListItem.Categorie%></td>
                                    <td><%=IIf(ListItem.OrderQty > 0 Or ListItem.PropQty > 0, ListItem.PropQty & "/" & ListItem.OrderQty & "/" & ListItem.OpenQty,"")%></td>
                                    <td><a href="javascript:toggleitem('<%=ListItem.ID%>');"><%=IIf(ListItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a></td>
                                    <td nowrap>
                                        <% If CInt(vwSearch.WarehouseID) <> CInt(vwOrderWh) Then %>
                                           <a href="javascript:orderSpare(<%=ListItem.ID%>,<%=ListItem.ActLevel%>,'<%=ListItem.SparepartNb%>','<%=ListItem.Sparepart%>');"><i class="fas fa-shipping-fast" title="Bestellvorschlag erstellen"></i></a>&nbsp;
                                        <% End If %>
                                        <a href="javascript:move2loc(<%=ListItem.ID%>,<%=ListItem.ActLevel%>,'<%=ListItem.SparepartNb%>','<%=ListItem.Sparepart%>');"><i class="fas fa-warehouse" title="Umlagern"></i></a>
                                        <% If CInt(vwSearch.WarehouseID) <> CInt(vwOrderWh)  Then
                                            If ListItem.ActLevel > 0 Then
                                                %>&nbsp;<a href="javascript:add2cart(<%=ListItem.ID%>,<%=ListItem.ActLevel%>,'<%=ListItem.SparepartNb%>','<%=ListItem.Sparepart%>');"><i class="fas fa-cart-arrow-down" title="Ersatzteilentnahme"></i></a><%
                                            End If
                                            If CInt(ListItem.LocationCnt) > 0 Then
                                                %>&nbsp;<a href="javascript:storespare(<%=ListItem.ID%>,<%=ListItem.ActLevel%>,'<%=ListItem.SparepartNb%>','<%=ListItem.Sparepart%>');"><i class="fas fa-hand-paper" title="Einlagern"></i></a><%
                                            End If
                                        End If %>
                                        <!--<i class="fas fa-shipping-fast"></i>
                                        <i class="fas fa-shuttle-van"></i>
                                        <i class="fas fa-box"></i>
                                        <i class="fas fa-box-open"></i>
                                        <i class="fas fa-warehouse"></i>
                                        <i class="fas fa-hand-lizard"></i>
                                        <i class="far fa-hand-paper"></i>-->
                                    </td>
                                </tr><%
                             Next
                        End If
                        %>
                        </tbody>
                    </table>
                </div>

            <% Else

                If Not vwList Is Nothing Then
                    Dim startRow : startRow = True
                    Dim startCard : startCard = 4
                    Dim pictPath
                    For Each ListItem In vwList.Items

                        If startCard = 4 Then
                           startCard = 0
                           %><div class="row mb-2"><%
                        End If
                        startCard = startCard + 1
                        %>

                            <div class="col-3">
                                <div class="box box-default">

                                    <!-- Card -->
                                    <div class="card promoting-card">

                                        <!-- Card content -->
                                        <div class="card-body d-flex flex-row">
                                            <!-- Content -->
                                            <div>

                                                <!-- Title -->
                                                <h5 class="card-title font-weight-bold mb-2"><%=ListItem.Sparepart%></h5>
                                                <!-- Subtitle -->
                                                <p class="card-text">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                Artikel-Nr:
                                                            </td>
                                                            <td align="right">
                                                                <%=ListItem.SparepartNb%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                aktueller Lagerstand:
                                                            </td>
                                                            <td align="right">
                                                                <%=FormatNumber(ListItem.ActLevel,2)%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Vorschlag/Bestellt/Offen:
                                                            </td>
                                                            <td align="right">
                                                                <%=ListItem.PropQty & "/" & ListItem.OrderQty & "/" & ListItem.OpenQty%>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </p>

                                            </div>

                                        </div>

                                        <!-- Card image -->
                                        <div class="view overlay">
                                            <img class="card-img-top rounded-1" src="<%=IIf(ListItem.PhysicalImagePath = "", curRootFile & "/images/nopicture.png", ListItem.ImageName) %>" alt="<%=ListItem.SparepartNb%>">
                                            <a href="javascript:edit_spare(<%=ListItem.ID%>);">
                                                <div class="mask rgba-white-slight"></div>
                                            </a>
                                        </div>

                                        <!-- Card content -->
                                        <div class="card-body">

                                            <div class="collapse-content">

                                                <!-- Text -->
                                                <p class="card-text">
                                                    <table  width="100%">
                                                        <tr>
                                                            <td>
                                                                Serienbezeichnung:
                                                            </td>
                                                            <td align="right">
                                                                <%=ListItem.SpareNb%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <table width="100%">
                                                                    <tr>
                                                                        <td colspan="3">
                                                                            Lagerorte
                                                                        </td>
                                                                    </tr>
                                                                    <%
                                                                        Dim locItem : Set locItem = New Spare

                                                                        locItem.InitLocations ListItem.ID

                                                                        For Each DDItem In locItem.Locations.Items %>
                                                                            <tr>
                                                                                <td>
                                                                                    <%=DDItem.Warehouse%>
                                                                                </td>
                                                                                <td>
                                                                                    <%=DDItem.Name%>
                                                                                </td>
                                                                                <td align="right">
                                                                                    <%=FormatNumber(DDItem.Act,2)%>
                                                                                </td>
                                                                            </tr>
                                                                        <% Next %>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <% If ListItem.ActLevel > 0 Then %>
                                                        <button class="btn btn-primary" onclick="javascript:add2cart(<%=ListItem.ID%>,<%=ListItem.ActLevel%>,'<%=ListItem.SparepartNb%>','<%=ListItem.Sparepart%>');"><i class="fas fa-shopping-cart"></i>&nbsp;in den Warenkorb</button>
                                                    <% End If %>
                                                </p>
                                            </div>

                                        </div>

                                    </div>
                                    <!-- Card -->


                                </div>
                            </div>
                        <%
                        If startCard = 4 Then
                            %></div><%
                        End If
                    Next
                    If startCard <> 4 Then
                        %></div><%
                    End If
                End If
            End If  %>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>
<!--Section: Table Plant-->

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/spare/index.js?v1.5"></script>
