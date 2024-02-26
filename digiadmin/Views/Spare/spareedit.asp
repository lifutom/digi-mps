<%
    Dim vwDDSupplierList : Set vwDDSupplierList = ViewData("suplist")
    Dim vwDDWHList : Set vwDDWHList = ViewData("whlist")
    Dim vwItem  : Set vwItem = ViewData("spare")
    Dim vwLines : Set vwLines = ViewData("lines")
    Dim vwDDModuleList : Set vwDDModuleList = ViewData("modlist")
    Dim vwDDCatList : Set vwDDCatList = ViewData("catlist")
    Dim vwBoxList : Set vwBoxList = ViewData("boxlist")
    Dim vwTab : vwTab = ViewData("tab")
    Dim vwDDItem
%>
<!-- Modal Edit Location Form -->
<div class="modal fade" id="editLocation" tabindex="-1" role="dialog" aria-labelledby="EditLocation" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Lagerort</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="formLocation" name="formLocation" action="javascript:saveLocation_data();">
                    <input id="locationid" name="locationid" type="hidden" value="-1">
                    <input name="active-tab" type="hidden" value="location-tab"/>
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Box:
                                </td>
                                <td>
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

                            <tr>
                                <td>
                                    Bestand:
                                </td>
                                <td>
                                    <input id="actval" name="actval" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" value="" required="required">
                                </td>
                            </tr>

                            <tr height="30">
                                <td colspan="2" valign="bottom">
                                     <div class="text-danger" id="errmsg"></div>
                                </td>
                            </tr>

                        </table>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <input type="submit" style="display:none;"/>
                        <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                        <button type="submit" class="btn btn-cyan sendbtn" id="sendbtn">Speichern</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Location Form -->
<!-- Modal Edit Supplier Form -->
<div class="modal fade" id="editSupplier" tabindex="-1" role="dialog" aria-labelledby="EditSupplier" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Lieferant</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="formSupplier" action="javascript:saveSupplier_data();">
                    <input name="active-tab" type="hidden" value="supplier-tab"/>
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Lieferant:
                                </td>
                                <td>
                                    <select id="supplierid" name="supplierid" class="browser-default custom-select">
                                        <% For Each vwDDItem In vwDDSupplierList.Items %>
                                                <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    BestellNr:
                                </td>
                                <td>
                                    <input id="sparenb" name="sparenb" type="text" size="20" maxlength="30" value="" required>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Standardlieferant:
                                </td>
                                <td valign="top">
                                    <label class="switch mt-2">
                                        <input class="mt-1"type="checkbox" name="isdefault" id="isdefault">
                                        <span class="slider round"></span>
                                    </label>

                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Preis:
                                </td>
                                <td valign="top">
                                    <input id="price" name="price" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" value="" required>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer d-flex justify-content-center">
                            <input type="submit" style="display:none;"/>
                            <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                            <button type="submit" class="btn btn-cyan sendbtn" id="sendbtn">Speichern</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Supplier Form -->
<!-- Modal Edit Link Form -->
<div class="modal fade" id="editLink" tabindex="-1" role="dialog" aria-labelledby="EditLink" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Zuordnung</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="formLink" action="javascript:saveLink_data();">
                    <input name="active-tab" type="hidden" value="link-tab"/>
                    <input id="linkid" name="linkid" type="hidden" value=""/>
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Baugruppe:
                                </td>
                                <td valign="top">
                                    <select id="moduleid" name="moduleid" style="width: 350px;" class="browser-default custom-select">
                                        <option value="">--Auswahl einer Baugruppe--</option>
                                        <%
                                            For Each DDItem In vwDDModuleList.Items
                                                %><option value="<%=DDItem.Value%>"><%=DDItem.Name%></option><%
                                            Next
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Zuordnung:
                                </td>
                                <td>
                                    <select id="mlinkid" name="mlinkid" class="browser-default custom-select" required>
                                        <option value="" disabled>--Auswahl einer Zuordnung--</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer d-flex justify-content-center">
                            <input type="submit" style="display:none;"/>
                            <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                            <button type="submit" class="btn btn-cyan sendbtn" id="sendbtn">Speichern</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Link Form -->
<!--Section: Main panel-->
<form id="formSpare" name="formSpare" class="multip" action="javascript:saveSpare_data();" enctype="multipart/form-data">
    <input type="hidden" id="item" name="item" value="spare"/>
    <input type="hidden" id="id" name="id" value="<%=vwItem.ID%>"/>
    <input type="hidden" id="idx" name="idx" value="<%=ViewData("idx")%>"/>
    <input id="active" name="active" type="hidden" required value="1">
    <input id="submitlink" name="submitlink" type="hidden" value="<%=curRootFile%>/spare/editpost/?partial=yes">
    <input id="sparepartnborg" name="sparepartnborg" type="hidden" required value="<%=vwItem.SparepartNb%>">
    <input name="active-tab" type="hidden" value="location-tab"/>
    <section class="mb-5">
        <% If partial <> "" Then %>
              <h4>&nbsp;</h4>
        <% End If %>
        <!--Card-->
        <div class="card card-cascade narrower">
            <!--Card header-->
            <div class="view view-cascade py-3 gradient-card-header cyan mx-4 d-flex justify-content-between align-items-center">
                <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Ersatzteil&nbsp;</a>
                <div class="float-right">
                    <a class="white-text" href="javascript: refresh_data();"><i class="fas fa-sync"></i></a>
                </div>
            </div>
            <!--Card content-->
            <div class="card-body">
                <div class="col-12">
                    <div class="table-responsive">
                        <table>
                            <tr>

                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Nummer:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="sparepartnb" name="sparepartnb" type="text" size="25" maxlength="25" required value="<%=vwItem.SparepartNb%>">
                                </td>
                                <td valign="top" rowspan="7">
                                    <!--Footer-->
                                    <div class="text-center">
                                        <button  type="submit" id="successbtn" class="btn btn-cyan waves-effect">Speichern</Button><br>
                                        <a href="javascript:window_close();" type="button" id="dangerbtn" class="btn btn-danger waves-effect">Schlieﬂen</a>
                                    </div>
                                </td>
                                <td valign="top" align="center" rowspan="7">
                                    <div class="file-upload-wrapper">
                                        <input type="file" id="spareimage"
                                        accept="image/png, image/jpeg, image/jpg"
                                        name="spareimage"
                                        class="file-upload"      
                                        data-max-file-size="5M"
                                        data-default-file="<%=vwItem.ImageName%>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Bezeichnung:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="sparepart" name="sparepart" type="text" size="50" maxlength="255" value="<%=vwItem.Sparepart%>" required>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Serienbezeichnung:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="snb" name="snb" type="text" size="50" maxlength="255" value="<%=vwItem.SpareNb%>">
                                </td>
                            </tr>
                             <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Kategorie:
                                </td>
                                <td style="font-size: 8pt;">
                                    <select style="height: 30px;" id="catid" name="catid" class="browser-default custom-select">
                                        <option value="0">-- keine Zuordnung --</option>
                                    <%
                                        For Each DDItem In vwDDCatList.Items
                                            %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value)=CInt(vwItem.CatID),"selected","")%>><%=DDItem.Name%></option><%
                                        Next
                                    %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Mindesbestand:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="minlevel" name="minlevel" type="text" size="10" required value="<%=vwItem.MinLevel%>">&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    &nbsp;
                                </td>
                                <td style="font-size: 8pt;">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" class="custom-control-input" id="targetorder" name="targetorder" value="1" <%=IIf(vwItem.TargetOrder=1,"checked","")%>>
                                        <label class="custom-control-label" for="targetorder">Ziel-Bestellung</label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="ordertarget"  style="font-size: 8pt;" valign="top" align="left">
                                    Start-Datum:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="startdate" name="startdate" type="date" value="<%=vwItem.StartDate%>">
                                </td>
                            </tr>
                            <tr>
                                <td class="ordertarget"  style="font-size: 8pt;" valign="top" align="left">
                                    Wiederholen alle:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="intervall" name="intervall" type="number" value="<%=vwItem.Intervall%>">&nbsp;
                                    <select style="height: 30px;" id="intervalltyp" name="intervalltyp"class="browser-default custom-select">
                                        <option value="year">Jahr(e)</option>
                                        <option value="monate">Monat(e)</option>
                                        <option value="day">Tag(e)</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="ordertarget" style="font-size: 8pt;" valign="top" align="left">
                                    Bestellmenge:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="orderlevel" name="orderlevel" type="number" pattern="[0-9]+([\.,][0-9]+)?" step="0.01" value="<%=vwItem.OrderLevel%>" required>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    aktueller Bestand:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="actlevel" name="actlevel" type="text" size="10" required value="<%=vwItem.ActLevel%>" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Mindest-Bestellmenge:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input id="minorderlevel" name="minorderlevel" type="text" size="10" required value="<%=vwItem.MinOrderLevel%>">
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Vorschlag/Bestellt/Offen:
                                </td>
                                <td style="font-size: 8pt;">
                                    <%=vwItem.PropQty & "/" & vwItem.OrderQty & "/" & vwItem.OpenQty%>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Standard-Lieferant:
                                </td>
                                <td style="font-size: 8pt;">
                                    <select style="height: 25px;" id="defsupplierid" name="defsupplierid"class="browser-default custom-select" disabled>
                                        <option value="-1">-- N/A --</option>
                                    <%
                                        For Each DDItem In vwDDSupplierList.Items
                                            %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value)=CInt(vwItem.DefSupplierID),"selected","")%>><%=DDItem.Name%></option><%
                                        Next
                                    %>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <%  If vwItem.ID > 0 Then %>

                    <ul class="nav nav-tabs mt-3" id="myTab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link <%=IIf( vwTab = "location-tab", "active","")%>" id="location-tab" data-toggle="tab" href="#location" role="tab" aria-controls="location"
                                aria-selected="true">Lagerorte</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%=IIf( vwTab = "supplier-tab", "active","")%>" id="supplier-tab" data-toggle="tab" href="#supplier" role="tab" aria-controls="supplier"
                                aria-selected="false">Lieferant</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%=IIf( vwTab = "links-tab", "active","")%>" id="links-tab" data-toggle="tab" href="#links" role="tab" aria-controls="links"
                                aria-selected="false">Zuordnung</a>
                        </li>
                    </ul>
                    <div class="tab-content" id="myTabContent">
                        <div class="tab-pane fade <%=IIf( vwTab = "location-tab", "show active","")%>" id="location" role="tabpanel" aria-labelledby="location-tab">
                            <div class="table-responsive mt-2 teal bg-light">
                                <table id="tbllocation" name="tbllocation" class="table table-striped table-hover row-cursor">
                                    <thead>
                                        <tr>
                                            <th style="display: none;">
                                                LocationID
                                            </th>
                                            <th style="display: none;">
                                                WarehouseID
                                            </th>
                                            <th style="display: none;">
                                                ShelfID
                                            </th>
                                            <th style="display: none;">
                                                CompID
                                            </th>
                                            <th style="display: none;">
                                                BoxID
                                            </th>
                                            <th style="font-size: 8pt; width: 100px;">
                                                <b>Lager</b>
                                            </th>
                                            <th style="font-size: 8pt; width: 100px;">
                                                <b>Lagerort</b>
                                            </th>
                                            <th style="display: none;">
                                                Bestand-Format
                                            </th>
                                            <th style="font-size: 8pt;" align="right">
                                                <b>Box</b>
                                            </th>
                                            <th style="font-size: 8pt;" align="right">
                                                <b>Bestand</b>
                                            </th>
                                            <th style="font-size: 8pt; width: 100px;" align="right">
                                                <button type="button" id="addlocationbtn" class="btn btn-sm btn-cyan" title="Lagerplatz hinzuf&uuml;gen" alt="Lagerplatz hinzuf&uuml;gen" onclick="emptyLocationform();"><i class="fas fa-plus-circle"></i></button>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% For Each DDItem In vwItem.Locations.Items %>
                                        <tr>
                                            <td style="display: none;">
                                                <%=DDItem.LocationID%>
                                            </td>
                                            <th style="display: none;">
                                                <%=DDItem.WarehouseID%>
                                            </th>
                                            <th style="display: none;">
                                                <%=DDItem.ShelfID%>
                                            </th>
                                            <th style="display: none;">
                                                <%=DDItem.CompID%>
                                            </th>
                                            <th style="display: none;">
                                                <%=DDItem.BoxID%>
                                            </th>
                                            <td style="font-size: 8pt; width: 100px;">
                                                <%=DDItem.Warehouse%>
                                            </td>
                                            <td style="font-size: 8pt; width: 100px;">
                                                <%=DDItem.Name%>
                                            </td>
                                            <td style="display: none;">
                                                <%=DBFormatNumber(DDItem.Act)%>
                                            </td>
                                            <td style="font-size: 8pt; width: 100px;">
                                                <%=DDItem.BoxName%>
                                            </td>
                                            <td style="font-size: 8pt; width: 100px;">
                                                <%=FormatNumber(DDItem.Act,2)%>
                                            </td>
                                            <td>
                                                <a href="javascript:deleteLocation(<%=DDItem.LocationID%>)" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                            </td>
                                        </tr>
                                    <% Next %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="tab-pane fade <%=IIf( vwTab = "supplier-tab", "show active","")%>" id="supplier" role="tabpanel" aria-labelledby="supplier-tab">
                            <div class="table-responsive mt-2 teal lighten-5">
                                <table id="tblsupplier" name="tblsupplier" class="table table-hover row-cursor" width="100%">
                                    <thead>
                                        <tr>
                                            <th style="display: none;">
                                                <b>SupplierID</b>
                                            </th>
                                            <th style="font-size: 8pt;">
                                                <b>Lieferant</b>
                                            </th>
                                            <th style="font-size: 8pt;">
                                                <b>BestellNr</b>
                                            </th>
                                            <th style="font-size: 8pt; width: 100px;" align="right">
                                                <b>Standard</b>
                                            </th>
                                            <th style="font-size: 8pt;" align="right">
                                                <b>Preis</b>
                                            </th>
                                            <th style="font-size: 8pt; width: 100px;" align="right">
                                                <button type="button" id="addsupplierbtn" class="btn btn-sm btn-cyan" title="Lieferant hinzuf&uuml;gen" alt="Lieferant hinzuf&uuml;gen" onclick="emptySupplierform();"><i class="fas fa-plus-circle"></i></button>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% For Each DDItem In vwItem.Suppliers.Items %>
                                        <tr>
                                            <td style="display: none;">
                                                <%=DDItem.SupplierID%>
                                            </td>
                                            <td style="font-size: 8pt;">
                                                <%=DDItem.Supplier%>
                                            </td>
                                            <td style="font-size: 8pt;" valign="top" align="left">
                                                <%=DDItem.SpareNb%>
                                            </td>
                                            <td style="font-size: 8pt;" valign="top" align="left">
                                                <%=IIf(DDItem.IsDefault=1,"Ja", "Nein")%>
                                            </td>
                                            <td style="font-size: 8pt;" valign="top" align="right">
                                                <%=DBFormatNumber(DDItem.Price)%>
                                            </td>
                                            <td>
                                                <a href="javascript:deleteSupplier(<%=DDItem.SupplierID%>)" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                            </td>
                                        </tr>
                                    <% Next %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="tab-pane fade <%=IIf( vwTab = "links-tab", "show active","")%>" id="links" role="tabpanel" aria-labelledby="links-tab">
                            <div class="table-responsive mt-2 teal lighten-5">
                                <table id="tbllink" name="tbllink" class="table table-hover row-cursor" width="100%">
                                    <thead>
                                        <tr>
                                            <th style="display: none;">
                                                <b>LinkID</b>
                                            </th>
                                            <th style="display: none;">
                                                <b>PlantID</b>
                                            </th>
                                            <th style="display: none;">
                                                <b>DeviceID</b>
                                            </th>
                                            <th style="display: none;">
                                                <b>ModulID</b>
                                            </th>
                                            <th style="font-size: 8pt;">
                                                <b>Linie</b>
                                            </th>
                                            <th style="font-size: 8pt;">
                                                <b>Anlage</b>
                                            </th>
                                            <th style="font-size: 8pt; width: 100px;" align="right">
                                                <b>Baugruppe</b>
                                            </th>
                                            <th style="font-size: 8pt;">
                                                <b>zuletzt ge‰ndert am</b>
                                            </th>
                                            <th style="font-size: 8pt;">
                                                <b>zuletzt ge‰ndert von</b>
                                            </th>
                                            <th style="font-size: 8pt; width: 100px;" align="right">
                                                <button type="button" id="addlinkbtn" class="btn btn-sm btn-cyan" title="Linie/Anlage zuordnen" alt="Linie/Anlage zuordnen" onclick="emptyLinkform();"><i class="fas fa-plus-circle"></i></button>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% For Each DDItem In vwItem.PlantLinks.Items %>
                                        <tr>
                                            <td style="display: none;">
                                                <%=DDItem.LinkID%>
                                            </td>
                                            <td style="display: none;">
                                                <%=DDItem.PlantID%>
                                            </td>
                                            <td style="display: none;">
                                                <%=DDItem.DeviceID%>
                                            </td>
                                            <td style="display: none;">
                                                <%=DDItem.ModuleID%>
                                            </td>
                                            <td style="font-size: 8pt;">
                                                <%=DDItem.Plant%>
                                            </td>
                                            <td style="font-size: 8pt;" valign="top" align="left">
                                                <%=DDItem.Device%>
                                            </td>
                                            <td style="font-size: 8pt;" valign="top" align="left">
                                                <%=DDItem.Module%>
                                            </td>
                                            <td style="font-size: 8pt;" valign="top" align="left">
                                                <%=DBFormatDateTime(DDItem.LastEdit)%>
                                            </td>
                                            <td style="font-size: 8pt;" valign="top" align="left">
                                                <%=DDItem.UserID%>
                                            </td>
                                            <td>
                                                <a href="javascript:deleteLink(<%=DDItem.LinkID%>)" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                            </td>
                                        </tr>
                                    <% Next %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                <% End If %>
            </div>
        </div>
        <!--/.Card-->
    </section>
 </form>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/spare/spareedit.js?v=1.4"></script>