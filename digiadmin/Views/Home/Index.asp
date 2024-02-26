<%

   Dim POverview : Set POverview = ViewData("overview")
   Dim DTOverview : Set DTOverview = ViewData("downtimelist")
   Dim ListItem
   Dim fItem : Set fItem = ViewData("firstitem")
   
%>

<!--Section: Table-->
<section class="mb-5">

    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Produktions&uuml;bersicht</a>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">

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
                            <td><%=ListItem.Status%></td>
                            <td><%=ListItem.Plant%></td>
                            <td><%=ListItem.UINNb%></td>
                            <td><%=ListItem.BatchNb%></td>
                            <td><%=ListItem.StartTime%></td>
                            <td><%=ListItem.EndTime%></td>
                            <td class="text-right"><%=ListItem.Counter%></td>
                            <td class="text-right"><%=ListItem.CounterBad%></td>
                            <td class="text-right"><%=ListItem.DowntimeCounter%></td>
                            <td class="text-right"><%=ListItem.MinutesProdTime%></td>
                            <td class="text-right"><a href="javascript:openwindow('overview/devicegraph/?partial=yes&id=<%=ListItem.ProductionID%>');"><i class="fas fa-chart-bar"></i></a></td>
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

<!--Section: Main panel-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header cyan mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Downtimes&nbsp;</a><span class="actproduction"><%=IIf(fItem Is Nothing,"", fItem.Plant & " UIN:" & fItem.UINNb & " Batch:" & fItem.BatchNb)%></span>
        </div>
        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <table id="dtdowntime" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>Status</th>
                            <th>Start</th>
                            <th>Beendet</th>
                            <th>Control</th>
                            <th>Anlagenteil</th>
                            <th>Teilbereich</th>
                            <th>Fehler</th>
                            <th>Minuten</th>
                            <th style="display:none">DowntimeID</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each ListItem In DTOverview.Items %>
                        <tr>
                            <td><%=ListItem.Status%></td>
                            <td><%=ListItem.StartTime%></td>
                            <td><%=ListItem.EndTime%></td>
                            <td><%=ListItem.ControlID%></td>
                            <td><%=ListItem.Device%></td>
                            <td><%=ListItem.Component%></td>
                            <td><%=ListItem.Failure%></td>
                            <td><%=ListItem.MinutesDownTime%></td>
                            <td style="display:none"><%=ListItem.DownTimeID%></td>
                        </tr>
                    <% Next %>
                    </tbody>
                </table>
            </div>
    <!--/.Card-->
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/home/index.1.0.js"></script>
