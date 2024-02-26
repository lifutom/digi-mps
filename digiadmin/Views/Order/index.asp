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
<!--Section: Table OrderProp-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <div>
                <a href="" class="white-text text-center mx-3"><i class="fas fas fa-shuttle-van"></i>&nbsp;Bestellungen</a>
            </div>
            <div>
                <form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/order/indexpost">
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
                            <th class="th-sm">Bestell-Nr</th>
                            <th class="th-sm">Bestell-Datum</th>
                            <th class="th-sm">Lieferant</th>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">Anfrage-Nr</th>
                            <th class="th-sm">Anfrage-Datum</th>
                            <th class="th-sm">Erstellt am</th>
                            <th class="th-sm">von</th>
                            <th>&nbsp;</th>
                            <th style="display:none">stateid</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    If Not vwList Is Nothing Then
                        For Each vwItem In vwList.Items
                             %><tr>
                                <td style="display:none"><%=vwItem.OrderID%></td>
                                <td nowrap><%=vwItem.OrderNb%></td>
                                <td><%=vwItem.OrderDate%></td>
                                <td><%=vwItem.Supplier%></td>
                                <td><%=vwItem.OrderState%></td>
                                <td><%=vwItem.QuoteNb%></td>
                                <td><%=vwItem.QuoteDate%></td>
                                <td><%=DBFormatDateTime(vwItem.Created)%></td>
                                <td><%=vwItem.CreatedBy%></td>
                                <td>
                                    <% If vwItem.StateID = 2 Then %>
                                        <a href="javascript:deleteItemQue(<%=vwItem.OrderID%>);" title="L&ouml;schen"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                        <a href="javascript:createOrderQue(<%=vwItem.OrderID%>);" title="Bestellung erstellen"><i style="font-size: 16px" class="fas fas fa-shuttle-van"></i></a>
                                    <% End If %>
                                    <% If vwItem.StateID > 2 Then %>
                                        <a href="<%=curRootFile%>/report/printreceipt/?id=<%=vwItem.OrderID%>&typ=order" title="Drucken" target="_blank"><i style="font-size: 16px" class="fas fa-print"></i></a>
                                    <% End If %>
                                    <% If vwItem.StateID=3 Or vwItem.StateID=4  Then %>
                                        &nbsp;<a href="javascript:orderReceipt(<%=vwItem.OrderID%>);" title="Bestelleingang"><i style="font-size: 16px" class="fas fas fa-truck-loading"></i></a>
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
<script src="<%=curRootFile%>/js/pages/order/index.js?v1.0"></script>
