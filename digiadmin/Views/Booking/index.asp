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

<!--Section: Table User-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <div>
                <a href="" class="white-text text-center mx-3"><i class="fa fa-truck"></i>&nbsp;Buchungsliste</a>
            </div>
            <div>
                <form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/booking/indexpost">
                    <input type="hidden" id="todo" name="todo" value=""/>
                        <table>
                            <tr>
                                <td style="font-size: 8pt;" valign="top" align="left">
                                    Standard-Lieferant&nbsp;
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
                            <th style="display:none">BookingID</th>
                            <th class="th-sm">Bewegung</th>
                            <th class="th-sm">Lager</th>
                            <th class="th-sm">Lagerort</th>
                            <th class="th-sm">ErsatzteilNr</th>
                            <th class="th-sm">Ersatzteil</th>
                            <th class="th-sm">Menge</th>
                            <th class="th-sm">am</th>
                            <th class="th-sm">von</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    If Not vwList Is Nothing Then
                        For Each vwItem In vwList.Items
                             %><tr>
                                <td style="display:none"><%=vwItem.BookingID%></td>
                                <td nowrap><%=vwItem.TransferType%></td>
                                <td><%=vwItem.Warehouse%></td>
                                <td><%=vwItem.Location%></td>
                                <td><%=vwItem.SparepartNb%></td>
                                <td><%=vwItem.Sparepart%></td>
                                <td><%=FormatNumber(vwItem.Act,2)%></td>
                                <td><%=DBFormatDateTime(vwItem.Created)%></td>
                                <td><%=vwItem.CreatedBy%></td>
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
<script src="<%=curRootFile%>/js/pages/booking/index.js?v1.1"></script>
