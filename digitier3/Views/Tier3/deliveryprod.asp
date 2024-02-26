<%

    Dim vwDateID : vwDateID = ViewData("dateid")
    Dim vwList : Set vwList = ViewData("plantlist")
    ''Dim vwOverView : Set vwOverView = ViewData("overview")

%>

<section class="mb-5">
    <!--Javascript Variable-->
    <input type="hidden" id="dateid" value="<%=vwDateID%>"  />
    <input type="hidden" id="area" value="<%=Session("area")%>"  />
    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Delivery&nbsp;<%=IIf(Session("area")="prod","Production","Packaging")%></a>
            <div class="float-right">
                 <a class="white-text" href="<%=curRootFile%>/tier2/deliveryprod" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body">
            <div class="row">
                <div class="col-8">
                    <div id="chartdiv" class="col-12">
                         <canvas id="prodchart" height="100"></canvas>
                    </div>
                </div>
                <div class="col-4">
                    <!-- Card -->
                    <div class="card card-cascade mt-2">

                        <!-- Card image -->
                        <div class="view view-cascade gradient-card-header <%=IIf(1=1,"success-color","danger-color")%>">
                            <!-- Title -->
                            <h3 class="card-header-title mb-3">Übersicht</h3>
                            <!-- Subtitle -->
                            <p class="card-header-subtitle mb-0">

                            </p>
                        </div>

                        <!-- Card content -->
                        <div class="card-body card-body-cascade text-center">
                            <h2>Datum:&nbsp;<%=vwDateID%></h2> 
                            <table class="table table-striped table-bordered table-sm">
                                    <thead>
                                        <tr>
                                            <th class="th-sm font-weight-bold">Linie</th>
                                            <th class="th-sm font-weight-bold">Planned</th>
                                            <th class="th-sm font-weight-bold">Produced</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% For Each vwItem In vwList.Items %>
                                               <tr>
                                                    <td>
                                                        <%=vwItem.Plant%>
                                                    </td>
                                                    <td>
                                                        <%=vwItem.PlannedCntText%>

                                                    </td>
                                                    <td>
                                                        <%=vwItem.ProducedCntText%>
                                                    </td>
                                              </tr>
                                        <% Next %>
                                    </tbody>
                            </table>
                            <!-- All over -->
                            <!-- OEE
                            <table class="table table-striped table-bordered table-sm">
                                    <thead>
                                        <tr>
                                            <th class="th-sm font-weight-bold">Aktuell</th>
                                            <th class="th-sm font-weight-bold">Durchschnitt</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>

                                            </td>
                                            <td>

                                            </td>
                                        </tr>
                                    </tbody>
                            </table>
                            <!-- ./All over -->
                            <!--Output
                            <table class="table table-striped table-bordered table-sm">
                                    <thead>
                                        <tr>
                                            <th class="th-sm font-weight-bold">Aktuell</th>
                                            <th class="th-sm font-weight-bold">Geplant</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>

                                            </td>
                                            <td>

                                            </td>
                                        </tr>
                                    </tbody>
                            </table> -->
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </div>
     <!-- Card -->
</section>

<!-- javascript -->
<script src="<%=curRootFile%>/_js/tier2/deliveryprod.js?v.1.0"></script>