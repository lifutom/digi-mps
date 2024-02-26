<%

    Dim vwList : Set vwList = ViewData("deplist")
    Dim vwItem
    Dim vwDateID : vwDateID = ViewData("dateid")

    Dim vwAccidentCnt : vwAccidentCnt = ViewData("accidentcnt")
    Dim vwNearAccidentCnt : vwNearAccidentCnt = ViewData("nearaccidentcnt")
    Dim vwIncidentCnt : vwIncidentCnt = ViewData("incidentcnt")


%>

<section class="mb-5">
    <!--Javascript Variable-->
    <input type="hidden" id="dateid" value="<%=vwDateID%>"  />
    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Safety</a>
            <div class="float-right">
                 <a class="white-text" href="<%=curRootFile%>/tier2/safety" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body">
            <div class="row">
                <div class="col-8">
                    <div id="chartdiv" class="col-12">
                         <canvas id="linechart" height="150"></canvas>
                    </div>
                    <div id="chartdiv1" class="col-12">
                        <canvas id="linechart1" height="100"></canvas>
                    </div>
                </div>
                <div class="col-4">
                    <!-- Card -->
                    <div class="card card-cascade mt-2">

                        <!-- Card image -->
                        <div class="view view-cascade gradient-card-header <%=IIf(1=1,"success-color","danger-color")%>">
                            <!-- Title -->
                            <h3 class="card-header-title mb-3">Abteilungsübersicht</h3>
                            <!-- Subtitle -->
                            <p class="card-header-subtitle mb-0">
                                Incidents:&nbsp;<%=vwAccidentCnt%>&nbsp;&nbsp;Good Catches:&nbsp;<%=vwNearAccidentCnt%>&nbsp;&nbsp;Near Misses:&nbsp;<%=vwIncidentCnt%>
                            </p>
                        </div>

                        <!-- Card content -->
                        <div class="card-body card-body-cascade text-center">
                            <!-- All over -->
                            <h2>Datum:&nbsp;<%=vwDateID%></h2>
                            <table class="table table-striped table-bordered table-sm">
                                    <thead>
                                        <tr>
                                            <th class="th-sm font-weight-bold">Abteilung</th>
                                            <th class="th-sm font-weight-bold">I</th>
                                            <th class="th-sm font-weight-bold">GC</th>
                                            <th class="th-sm font-weight-bold">NM</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% For Each vwItem In vwList.Items %>
                                               <tr>
                                                    <td>
                                                        <%=vwItem.Department%>
                                                    </td>
                                                    <td>
                                                        <%=vwItem.AccidentCntText%>

                                                    </td>
                                                    <td>
                                                        <%=vwItem.NearAccidentCntText%>
                                                    </td>
                                                    <td>
                                                        <%=vwItem.IncidentCntText%>
                                                    </td>
                                              </tr>
                                        <% Next %>
                                    </tbody>
                            </table>
                            <!-- ./All over -->


                        </div>

                    </div>

                </div>
            </div>
        </div>
    </div>
     <!-- Card -->
</section>

<!-- javascript -->
<script src="<%=curRootFile%>/_js/tier2/safety.js?v.1.1"></script>