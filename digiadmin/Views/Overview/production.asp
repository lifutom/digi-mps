<%

   Dim POverview : Set POverview = ViewData("overview")
   Dim ListItem

   Dim vwLines : Set vwLines = ViewData("lines")
   Dim vwSearch : Set vwSearch = ViewData("search")

%>
<!--Section: Table-->
<section class="mb-5">

    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Produktions&uuml;bersicht</a>
            <div class="float-right">
                <a class="white-text" href="javascript: refresh_datatable();"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">
            <form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/overview/productionpost">
                <table class="table table-bordered table-sm" cellspacing="0" width="100%">
                    <tr>
                        <th>
                            <table class="table-borderless" cellspacing="0" >
                                <tr>
                                    <td style="font-size: 8pt;height=25px">
                                        UIN:
                                    </td>
                                    <td style="font-size: 8pt;height=25px">
                                        <input type="text" id="uin" name="uin" value="<%=vwSearch.UIN%>" placeholder="UIN"/>
                                    </td>
                                    <td style="font-size: 8pt;height=25px">
                                        Datum von:
                                    </td>
                                    <td style="font-size: 8pt;height=25px">
                                        <input type="date" id="start" name="start" value="<%=vwSearch.StartDate%>" placeholder="Start"/>
                                    </td>
                                    <td style="font-size: 8pt;height=25px">
                                       Linie:
                                    </td>
                                    <td style="font-size: 8pt;">
                                        <select style="height: 25px;" id="plantid" name="plantid" class="browser-default custom-select">
                                            <option style="height: 20px;" value="-1">--Alle--</option>
                                            <%
                                                For Each DDItem In vwLines.Items
                                                    %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.PlantID),"selected","")%>><%=DDItem.Name%></option><%
                                                Next
                                            %>
                                        </select>
                                    </td>
                                    <td rowspan="2">
                                        <table class="table table-borderless">
                                            <tr>
                                                <td>
                                                    <a class="btn btn-sm btn-grey" id="searchlink" name="searchlink" title="Suchen" alt="Suchen"><span style="font-size: 14px" class="glyphicon glyphicon-eye-open"></span></a>
                                                </td>
                                                <td>
                                                    <a class="btn btn-sm btn-grey" title="Filter l&ouml;schen" alt="Filter l&ouml;schen" id="delfilter" name="delfilter"><span style="font-size: 14px"class="glyphicon glyphicon-eye-close"></span></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-size: 8pt;height=25px">
                                        Batch:
                                    </td>
                                    <td style="font-size: 8pt;height=25px">
                                        <input type="text" id="batch" name="batch" value="<%=vwSearch.Batch%>" placeholder="Batch"/>
                                    </td>
                                    <td style="font-size: 8pt;">
                                        Datum bis:
                                    </td>
                                    <td style="font-size: 8pt;">
                                        <input type="date" id="end" name="end" value="<%=vwSearch.EndDate%>" placeholder="Ende"/>
                                    </td>
                                    <td style="font-size: 8pt;">

                                    </td>
                                    <td style="font-size: 8pt;">

                                    </td>
                                </tr>
                            </table>
                        </th>
                    </tr>
                </table>
            </form>
            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtplant" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">ProductionID</th>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">Anlage</th>
                            <th class="th-sm">UIN</th>
                            <th class="th-sm">BatchNb</th>
                            <th class="th-sm">Start</th>
                            <th class="th-sm">Beendet</th>
                            <th class="th-sm text-right">Gut-St&uuml;ck FPP</th>
                            <th class="th-sm text-right">Schlecht-St&uuml;ck FPP</th>
                            <th class="th-sm text-right">Downtimes</th>
                            <th class="th-sm text-right">Minuten</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each ListItem In POverview.Items %>
                        <tr>
                            <td style="display:none"><%=ListItem.ProductionID%></td>
                            <td style="font-size: 8pt;"><%=ListItem.Status%></td>
                            <td><%=ListItem.Plant%></td>
                            <td><%=ListItem.UINNb%></td>
                            <td><%=ListItem.BatchNb%></td>
                            <td style="font-size: 8pt;"><%=DBFormatDateTime(ListItem.StartTime)%></td>
                            <td style="font-size: 8pt;"><%=DBFormatDateTime(ListItem.EndTime)%></td>
                            <td class="text-right"><%=ListItem.Counter%></td>
                            <td class="text-right"><%=ListItem.CounterBad%></td>
                            <td class="text-right"><%=ListItem.DowntimeCounter%></td>
                            <td class="text-right"><%=ListItem.MinutesProdTime%></td>
                            <td class="text-right" nowrap>
                                <a href="javascript:openwindow('overview/devicegraph/?partial=yes&id=<%=ListItem.ProductionID%>');" title="Grafik"><i class="fas fa-chart-bar"></i></a>
                                &nbsp;<a href="javascript:openwindow('overview/downtimebyid/?partial=yes&id=<%=ListItem.ProductionID%>');" title="Liste mit Downtimes"><span class="glyphicon glyphicon-align-left"></span></a>
                            </td>
                        </tr>
                    <% Next %>
                    </tbody>
                </table>
            </div>
        </div>
        <!--/.Card content-->

    </div>
    <!--/.Card-->

</section>
<!--Section: Table-->
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/overview/production.1.0.js"></script>
