<%

   Dim POverview : Set POverview = ViewData("overview")
   Dim ListItem
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
                            <th class="th-sm">Anlage</th>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">UIN</th>
                            <th class="th-sm">BatchNb</th>
                            <th class="th-sm">Start</th>
                            <th class="th-sm">Beendet</th>
                            <th class="th-sm text-right">Gut-St&uuml;ck FPP</th>
                            <th class="th-sm text-right">Schlecht-St&uuml;ck FPP</th>
                            <th class="th-sm text-right">Downtimes</th>
                            <th class="th-sm text-right">Minuten</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each ListItem In POverview.Items %>
                        <tr>
                            <td style="display:none"><%=ListItem.ProductionID%></td>
                            <td><%=ListItem.Plant%></td>
                            <td><%=ListItem.Status%></td>
                            <td><%=ListItem.UINNb%></td>
                            <td><%=ListItem.BatchNb%></td>
                            <td><%=ListItem.StartTime%></td>
                            <td><%=ListItem.EndTime%></td>
                            <td class="text-right"><%=ListItem.Counter%></td>
                            <td class="text-right"><%=ListItem.CounterBad%></td>
                            <td class="text-right"><%=ListItem.DowntimeCounter%></td>
                            <td class="text-right"><%=ListItem.MinutesProdTime%></td>
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
<script src="<%=curRootFile%>/_js/pages/home/index.js?v.1.0"></script>
