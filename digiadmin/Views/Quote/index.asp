<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwItem
   Dim DDItem

   ''Dim vwDDModuleList : Set vwDDModuleList = ViewData("modlist")
   Dim vwDDSupplierList : Set vwDDSupplierList = ViewData("suplist")
   ''Dim vwLines : Set vwLines = ViewData("lines")
   ''Dim vwDevices : Set vwDevices = ViewData("devices")
   Dim vwSearch : Set vwSearch = ViewData("search")
%>
<!-- ./Modal Add Sparepart to Cart Form -->
<!-- Edit Article in Orderlist -->
<div class="modal fade" id="quoteWindow" tabindex="-1" role="dialog" aria-labelledby="quoteWindow" aria-hidden="true">
    <div class="modal-dialog" style="max-width:750px;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-dollar-sign"></i>&nbsp;&nbsp;Anfrage</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="form" action="javascript:save_data();">
                    <input type="hidden" id="id" name="id" value="" />
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Lieferant:
                                </td>
                                <td>
                                    <select id="quotesupplierid" name="quotesupplierid" class="browser-default custom-select" required>
                                        <option value="">--Lieferantenauswahl--</option>
                                        <% For Each DDItem In vwDDSupplierList.Items  %>
                                               <option value="<%=DDItem.Value%>"><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Anfrage-Nr:
                                </td>
                                <td>
                                    <input id="quotenb" name="quotenb" type="text" size="20" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Datum:
                                </td>
                                <td>
                                    <input type="date" id="quotedate" name="quotedate" value="" required/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Bemerkung:
                                </td>
                                <td>
                                    <input id="description" name="description" type="text" size="40" value="">
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
                                                <th>
                                                </th>
                                                <th style="display:none">OrderID</th>
                                                <th style="display:none">SparepartID</th>
                                                <th class="th-sm">Lieferanten-Nr</th>
                                                <th class="th-sm">Nummer</th>
                                                <th class="th-sm">Bezeichnung</th>
                                                <th class="th-sm">Anzahl</th>
                                                <th>&nbsp;</th>
                                            </tr>
                                        </thead>
                                        <tbody>
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
                <a href="" class="white-text text-center mx-3"><i class="fas fa-dollar-sign"></i>&nbsp;Anfragen</a>
            </div>
            <div>
                <form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/quotes/indexpost">
                    <input type="hidden" id="todo" name="todo" value=""/>
                        <table>
                            <tr>
                                <td valign="top" align="left">
                                    Lieferant&nbsp;
                                    <select id="supplierid" name="supplierid" class="browser-default custom-select">
                                        <option value="-1">--Alle--</option>
                                        <%
                                            For Each DDItem In vwDDSupplierList.Items
                                                %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.SupplierID),"selected","")%>><%=DDItem.Name%></option><%
                                            Next
                                        %>
                                    </select>&nbsp;&nbsp;
                                </td>
                                <td align="left" style="font-size: 8pt;">
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
                                <td>
                                    <a class="btn btn-sm btn-cyan" id="searchlink" name="searchlink" title="Suchen" alt="Suchen"><span style="font-size: 14px" class="glyphicon glyphicon-eye-open"></span></a>
                                    &nbsp;
                                    <a class="btn btn-sm btn-cyan" title="Filter l&ouml;schen" alt="Filter l&ouml;schen" id="delfilter" name="delfilter"><span style="font-size: 14px"class="glyphicon glyphicon-eye-close"></span></a>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" valign="top" style="font-size: 8pt;" colspan="3">
                                    Textsuche:&nbsp;<input type="text" id="searchtxt" name="searchtxt" value="<%=vwSearch.SearchTxt%>"/>
                                </td>
                            </tr>
                        </table>

                </form>
            </div>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Anfrage erstellen" alt="Anfrage erstellen"><i class="fas fa-plus-circle"></i></button>
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
                            <th style="display:none">QuoteID</th>
                            <th class="th-sm">Anfrage-Nr</th>
                            <th class="th-sm">Anfrage-Datum</th>
                            <th class="th-sm">Lieferant</th>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">Bestell-Nr</th>
                            <th class="th-sm">Bestell-Datum</th>
                            <th class="th-sm">Erstellt am</th>
                            <th class="th-sm">von</th>
                            <th>&nbsp;</th>
                            <th style="display:none">stateid</th>
                            <th style="display:none">orderid</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    If Not vwList Is Nothing Then
                        For Each vwItem In vwList.Items
                             %><tr>
                                <td style="display:none"><%=vwItem.QuoteID%></td>
                                <td nowrap><%=vwItem.QuoteNb%></td>
                                <td><%=vwItem.QuoteDate%></td>
                                <td><%=vwItem.Supplier%></td>
                                <td><%=vwItem.QuoteState%></td>
                                <td><%=vwItem.OrderNb%></td>
                                <td><%=vwItem.OrderDate%></td>
                                <td><%=DBFormatDateTime(vwItem.Created)%></td>
                                <td><%=vwItem.CreatedBy%></td>
                                <td>
                                    <% If vwItem.StateID = 1 Then %>
                                        <a href="javascript:deleteItemQue(<%=vwItem.QuoteID%>);" title="L&ouml;schen"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                        <a href="javascript:createOrderQue(<%=vwItem.QuoteID%>);" title="Bestellung erstellen"><i style="font-size: 16px" class="fas fas fa-shuttle-van"></i></a>
                                    <% End If %>
                                    &nbsp;<a href="<%=curRootFile%>/report/printreceipt/?id=<%=vwItem.QuoteID%>&typ=quote" title="Drucken" target="_blank"><i style="font-size: 16px" class="fas fa-print"></i></a>
                                    &nbsp;<a href="javascript:sendEmail(<%=vwItem.QuoteID%>);" title="E-Mail senden"><i style="font-size: 16px" class="far fa-envelope"></i></a>
                                </td>
                                <td style="display:none"><%=vwItem.StateID%></td>
                                <td style="display:none"><%=vwItem.OrderID%></td>
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
<script src="<%=curRootFile%>/js/pages/quote/index.js?v1.1"></script>
