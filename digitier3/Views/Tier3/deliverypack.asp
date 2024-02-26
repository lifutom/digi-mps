<%

    Dim vwDateID : vwDateID = ViewData("dateid")
    Dim vwList : Set vwList = ViewData("plantlist")
    Dim vwpList : Set vwpList = ViewData("prodlist")
    Dim vwOverView : Set vwOverView = ViewData("escalationlist")
    Dim vwItem
%>

<section class="mb-5">
    <!--Javascript Variable-->
    <input type="hidden" id="dateid" value="<%=vwDateID%>"  />
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Delivery</a>
            <div class="float-right">
                 <a class="white-text" href="<%=curRootFile%>/tier3/deliverypack" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>

        <!--/Card header-->
        <!--Card content-->
        <div class="card-body">
            <div class="row">
                <div class="col-8">

                    <div class="col-12">
                        <!-- Card -->
                        <div class="card card-cascade mt-2">

                            <!-- Card image -->
                            <div class="view view-cascade gradient-card-header grey py-1 align-items-center">
                                <!-- Title -->
                                <h6 class="card-header-title mb-3">Production</h6>
                            </div>

                            <!-- Card content -->
                            <div class="card-body card-body-cascade text-center">
                                <table class="table table-striped table-bordered table-sm">
                                    <thead>
                                        <th class="th-sm font-weight-bold">
                                            Bereich
                                        </th>
                                        <th class="th-sm font-weight-bold">
                                            Planned&nbsp;KW-<%=RIGHT("00" & ViewData("curcw"),2)%>
                                        </th>
                                        <th class="th-sm font-weight-bold">
                                            Produced&nbsp;KW-<%=RIGHT("00" & ViewData("curcw"),2)%>
                                        </th>
                                    </thead>
                                    <tbody>
                                        <% For Each vwItem In vwpList.Items %>
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
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div id="chartdiv" style="height: 350px">
                            <canvas id="oeechart"></canvas>
                        </div>
                    </div>
                    <div class="col-12">
                        <!-- Card -->
                        <div class="card-body">
                            <div class="text-center"><h4>Todays Escalation Topics</h4></div>
                            <% For Each vwItem In vwOverView.Items %>
                                <div class="text-left card card-cascade mb-2 mt-2 py-2">
                                      <table border=1>
                                          <tr>
                                              <td width="70">
                                                   <img src="<%=curRootFile%>/Images/Alert128h.png" width="64" height="64" alt="">
                                              </td>
                                              <td align="left">
                                                  <table>
                                                      <tr>
                                                          <td>
                                                               <h6><%=vwItem.EscaTxt%></h6>
                                                          </td>
                                                          <td>

                                                          </td>
                                                      </tr>
                                                      <tr>
                                                          <td>
                                                               <%=vwItem.EscaTask%>
                                                          </td>
                                                      </tr>
                                                  </table>

                                              </td>
                                          </tr>
                                    </table>
                                </div>
                            <% Next %>
                        </div>
                    </div>
                </div>
                 <!-- Card -->
                <div class="col-4">
                    <!-- Card -->
                    <div class="card card-cascade mt-2">

                        <!-- Card image -->
                        <div class="view view-cascade gradient-card-header <%=IIf(1=1,"success-color","danger-color")%>">
                            <!-- Title -->
                            <h3 class="card-header-title mb-3">Datum:&nbsp;<%=vwDateID%></h3>
                            <!-- Subtitle -->
                            <p class="card-header-subtitle mb-0">

                            </p>
                        </div>

                        <!-- Card content -->
                        <div class="card-body card-body-cascade text-center">
                            <table class="table table-striped table-bordered table-sm">
                                    <thead>
                                        <tr>
                                            <th class="th-sm font-weight-bold">Linie</th>
                                            <th class="th-sm font-weight-bold">OEE  %</th>
                                            <th class="th-sm font-weight-bold">Output</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% For Each vwItem In vwList.Items %>
                                               <tr>
                                                    <td>
                                                        <%=vwItem.Plant%>
                                                    </td>
                                                    <td>
                                                        <%=vwItem.OEEValueText%>

                                                    </td>
                                                    <td>
                                                        <%=vwItem.OutputCntText%>
                                                    </td>
                                              </tr>
                                        <% Next %>
                                    </tbody>
                            </table>
                        </div>
                    </div>
                    </div>
                </div>
            </div>
        </div>
</section>

<!-- javascript -->
<script src="<%=curRootFile%>/_js/tier3/deliverypack.js?v.1.1"></script>