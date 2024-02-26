<%
   Dim vwCart : Set vwCart = ViewData("cart")
   Dim vwList : Set vwList = ViewData("list")
   Dim vwWarehouse : Set vwWarehouse = ViewData("warehouse")
   Dim vwBoxList : Set vwBoxList = ViewData("boxlist")
   Dim vwSearch : Set vwSearch = ViewData("search")
   Dim ListItem
   Dim vwDDItem
%>
<!-- Modal Move2Location -->
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
                                    <select id="boxid" name="boxid" class="search-drowdown form-control" style="width: 150px; height: 40px;">
                                        <option value="0" selected>nicht in Box</option>
                                        <% For Each DDItem In vwBoxList.Items %>
                                            <option value="<%=DDItem.Value%>"><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                    <input id="mov2locationid" name="mov2locationid" type="hidden" value="">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lager:
                                </td>
                                <td>
                                    <select id="warehouseid" name="warehouseid" class="browser-default custom-select" required="required">
                                        <% For Each vwDDItem In vwWarehouse.Items %>
                                                <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                                        <% Next %>
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
<!-- ./Modal Move2Location -->


<!-- Modal Move Box -->
<div class="modal fade" id="moveBox" tabindex="-1" role="dialog" aria-labelledby="moveBox" aria-hidden="true">
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
                <form id="formBox" action="javascript:saveBoxMove_data();">
                    <input type="hidden" id="movid" name="movid" value="" />
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Box:
                                </td>
                                <td>
                                    <select id="mvboxid" name="mvboxid" class="search-drowdown form-control" style="width: 150px; height: 40px;">
                                        <option value="" selected>--Box--</option>
                                        <% For Each DDItem In vwBoxList.Items %>
                                            <option value="<%=DDItem.Value%>" <%=IIf(CInt(vwSearch.BoxID) = CInt(DDItem.Value),"selected", "")%>><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lager:
                                </td>
                                <td>
                                    <input id="warehouseid" name="warehouseid" type="hidden" value="">
                                    <input id="warehouse" name="warehouse" type="text" value="" disabled>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lagerort:
                                </td>
                                <td>
                                    <input id="locationid" name="locationid" type="hidden" value="">
                                    <input id="shelfid" name="shelfid" type="hidden" value="">
                                    <input id="compid" name="compid" type="hidden" value="">
                                    <input id="location" name="location" type="text" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lager:
                                </td>
                                <td>
                                    <select id="warehouseidnew" name="warehouseidnew" class="browser-default custom-select">
                                        <option value="" disabled>--Lager--</option>
                                        <% For Each DDItem In vwWarehouse.Items %>
                                                <option value="<%=DDItem.Value%>"><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Regal:
                                </td>
                                <td>
                                    <input id="shelfidnew" name="shelfidnew" type="number" min="0" value="">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Fach:
                                </td>
                                <td>
                                    <input id="compidnew" name="compidnew" type="number" min="0" value="">
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
<!-- ./Modal MoveBox -->


<!-- Modal Add 2 Orderlist -->
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
<!-- ./Modal Add 2 Orderlist -->
<!--Section: Table-->
<section class="mb-5">

    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;DigiSpare&nbsp;<%=Application("version")%><%=IIf(Session("login") <> "", "&nbsp;(user: " & Session("login"),"")%>)</a>
            <% If vwCart.Count > 0 Then%>
                <li class="nav-item mt-2">
                    <a href="<%=curRootFile%>/home/mycart" class="nav-item" title="Warenkorb öffnen">
                        <i class="fas fa-shopping-cart pr-4"></i>
                    </a>
                    <span class="counter counter-sm"><%=vwCart.Count%></span>
                </li>
            <% End If %>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">
            <div class="col-12">
                <div class="card">
                    <div class="card-header blue font-weight-bold">
                        Ersatzteil-Verwaltung
                        <form id="formSearch" name="formSearch" method="post" action="<%=curRootFile%>/spare/searchpost">
                            <div class="row ml-2">
                                <div>
                                    <label for="searchwarehouseid">Lager:</label>
                                    <select id="searchwarehouseid" name="searchwarehouseid" class="browser-default custom-select">
                                        <option style="height: 20px;" value="-1">--Alle--</option>
                                        <% For Each DDItem In vwWarehouse.Items %>
                                                <option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.WarehouseID),"selected","")%>><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </div>
                                <div>
                                    <label for="searchshelfid">Regal:</label>
                                    <input class="form-control" type="numeric" id="searchshelfid" name="searchshelfid" value="<%=IIf(vwSearch.ShelfID <> -1, vwSearch.ShelfID, "")%>" size="5"/>&nbsp;&nbsp;
                                </div>
                                <div>
                                    <label for="searchcompid">Fach:</label>
                                    <input class="form-control" type="numeric" id="searchcompid" name="searchcompid" value="<%=IIf(vwSearch.CompID <> -1, vwSearch.CompID, "")%>" size="5"/>&nbsp;&nbsp;
                                </div>
                                <div>
                                    <label for="searchtxt">Textsuche:</label>
                                    <input class="form-control" type="text" id="searchtxt" name="searchtxt" value="<%=vwSearch.SearchTxt%>"/>
                                </div>
                                <div class="col-2">
                                    <label for="searchboxid">Box:</label><br>
                                    <select id="searchboxid" name="searchboxid" class="search-drowdown form-control" style="width: 150px; height: 40px;">
                                        <option value="" selected>--Box--</option>
                                        <% For Each DDItem In vwBoxList.Items %>
                                            <option value="<%=DDItem.Value%>" <%=IIf(CInt(vwSearch.BoxID) = CInt(DDItem.Value),"selected", "")%>><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </div>
                                <div>
                                    <a class="btn btn-sm btn-cyan" id="searchlink" name="searchlink" title="Suchen" alt="Suchen"><span style="font-size: 14px" class="glyphicon glyphicon-eye-open"></span></a>
                                    &nbsp;<a class="btn btn-sm btn-cyan" title="Filter l&ouml;schen" alt="Filter l&ouml;schen" id="delfilter" name="delfilter"><span style="font-size: 14px"class="glyphicon glyphicon-eye-close"></span></a>
                                </div>

                            </div>
                        </form>
                    </div>

                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="dtlist" name="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                                <thead>
                                    <tr>
                                        <th style="display:none">Active</th>
                                        <th style="display:none">SparepartID</th>
                                        <th class="th-sm">Nummer</th>
                                        <th class="th-sm">Bezeichnung</th>
                                        <th class="th-sm">Serienbezeichnung</th>
                                        <th class="th-sm">Bestand-Min</th>
                                        <th class="th-sm">Bestand-Akt</th>
                                        <th class="th-sm">Bestellung-Min</th>
                                        <th style="display:none">DefSupplierID</th>
                                        <th class="th-sm">Lieferant</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    If Not vwList Is Nothing Then
                                        For Each ListItem In vwList.Items  %>
                                        <tr>
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
                                            <td nowrap>
                                                <a href="javascript:orderSpare(<%=ListItem.ID%>,<%=ListItem.ActLevel%>,'<%=ListItem.SparepartNb%>','<%=ListItem.Sparepart%>');"><i class="fas fa-shipping-fast" title="Bestellvorschlag erstellen"></i></a>
                                                &nbsp;<!--<a href="javascript:move2loc(<%=ListItem.ID%>,<%=ListItem.ActLevel%>,'<%=ListItem.SparepartNb%>','<%=ListItem.Sparepart%>');"><i class="fas fa-warehouse" title="Umlagern"></i></a>-->
                                            </td>
                                        </tr>
                                        <% Next
                                    End If %>
                                </tbody>
                            </table>

                        </div>
                    </div>
                    <div class="card-footer">
                        <a class="btn btn-grey" href="<%=curRootFile & "/home/logout"%>">Logout</a>&nbsp;&nbsp;
                        <!--<a class="btn btn-primary" id="movebtn"><i class="fas fa-warehouse" title="Umlagern"></i>&nbsp;Box Umlagern</a>&nbsp;&nbsp;-->
                        <a class="btn btn-primary" href="<%=curRootFile & "/home"%>">Zurück</a>&nbsp;&nbsp;
                    </div>
                </div>
            </div>

        </div>
    </div>
    <!--/.Card-->
</section>
<!--Section: Table-->
<!-- javascript -->
<script src="<%=curRootFile%>/_js/spare/index.js?v1.1"></script>