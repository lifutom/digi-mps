<%

    Dim vwList : Set vwList = ViewData("deplist")
    Dim vwItem
    Dim vwDateID : vwDateID = ViewData("dateid")

    Dim vwAccidentCnt : vwAccidentCnt = ViewData("accidentcnt")
    Dim vwNearAccidentCnt : vwNearAccidentCnt = ViewData("nearaccidentcnt")
    Dim vwIncidentCnt : vwIncidentCnt = ViewData("incidentcnt")
    Dim vwDaysSinceLastInc : vwDaysSinceLastInc = ViewData("dayssincelastinc")
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
                 <a class="white-text" href="<%=curRootFile%>/tier3/safety" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body">
            <div class="row">
                <div class="col-8">
                    <div id="chartdiv2" style="height: 250px">
                         <canvas id="linechart2"></canvas>
                    </div>
                    <div id="chartdiv"  style="height: 250px">
                         <canvas id="linechart"></canvas>
                    </div>
                    <div id="chartdiv1"  style="height: 250px">
                        <canvas id="linechart1"></canvas>
                    </div>
                </div>
                <div class="col-4">
                    <!-- Card -->
                    <div class="card card-cascade mt-2 py-4">
                        <!-- Card image -->
                        <div class="view view-cascade gradient-card-header <%=IIf(1=1,"success-color","danger-color")%>">
                            <!-- Title -->
                            <h4 class="card-header-title mb-3">Site Overview&nbsp;(<%=vwDateID%>)</h4>
                            <!-- Subtitle -->
                            <p class="card-header-subtitle mb-0">Incidents:&nbsp;<%=vwAccidentCnt%>&nbsp;&nbsp;Good Catches:&nbsp;<%=vwNearAccidentCnt%>&nbsp;&nbsp;Near Misses:&nbsp;<%=vwIncidentCnt%></p>
                        </div>

                        <!-- Card content -->
                        <div class="card-body card-body-cascade text-center mb-3">
                             <img src="<%=curRootFile%>/Images/IMG-20170629-WA0002.jpg" width="350px" height="auto" alt="" />
                        </div>

                        <div class="view view-cascade gradient-card-header <%=IIf(1=1,"success-color","danger-color")%>">
                            <!-- Title -->
                            <p class="card-header-subtitle mb-0">Days since last incident:</p>
                            <h4 class="card-header-title mb-2"><%=FormatNumber(vwDaysSinceLastInc,0)%></h4>
                        </div>

                    </div>
                    <!-- Card -->
                </div>
            </div>
        </div>
    </div>
     <!-- Card -->
</section>

<!-- javascript -->
<script src="<%=curRootFile%>/_js/tier3/safety.js?v.1.0"></script>