<%

    Dim vwList : Set vwList = ViewData("comlaints")
    Dim vwItem
    Dim vwDateID : vwDateID = ViewData("dateid")

    Dim vwEventOpenedCnt : vwEventOpenedCnt = ViewData("eventopenedcnt")
    Dim vwEventClosedCnt : vwEventClosedCnt = ViewData("eventclosedcnt")
    Dim vwOverView : Set vwOverView = ViewData("escalationlist")  


%>

<section class="mb-5">
    <!--Javascript Variable-->
    <input type="hidden" id="dateid" value="<%=vwDateID%>"  />
    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Quality</a>
            <div class="float-right">
                 <a class="white-text" href="<%=curRootFile%>/tier3/quality" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body">
            <div class="row">
                <div class="col-4">
                    <div id="chartdiv" style="height: 680px">
                         <canvas id="barchart"></canvas>
                    </div>
                </div>
                <div class="col-8">
                    <div class="row">
                        <div id="chartdiv1" style="height: 250px; width:100%; margin-bottom: 10px" >
                            <canvas id="linechart"></canvas>
                        </div>
                        <div class="col-12">
                            <!-- Card -->
                            <div class="card card-cascade mt-2">
                              <!-- Card image -->
                              <div class="view view-cascade gradient-card-header grey py-3">
                                <!-- Title -->
                                <h6 class="card-header-title mb-3">Critical Customer Complaints</h6>
                              </div>

                              <!-- Card content -->
                              <div class="card-body card-body-cascade text-center">
                                <table class="table table-striped table-bordered table-sm">
                                        <thead>
                                            <tr>
                                                <th class="th-sm font-weight-bold">Nummer</th>
                                                <th class="th-sm font-weight-bold">Int-Nr</th>
                                                <th class="th-sm font-weight-bold">Product</th>
                                                <th class="th-sm font-weight-bold">Beschreibung</th>
                                                <th class="th-sm font-weight-bold">Land</th>
                                                <th class="th-sm font-weight-bold">Grund</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% For Each vwItem In vwList.Items %>
                                                   <tr>
                                                        <td>
                                                            <%=vwItem.CNb%>
                                                        </td>
                                                        <td>
                                                            <%=vwItem.CNumber%>
                                                        </td>
                                                        <td>
                                                            <%=vwItem.CProduct%>
                                                        </td>
                                                        <td>
                                                            <%=vwItem.CTxt%>
                                                        </td>
                                                        <td>
                                                            <%=vwItem.CCountry%>
                                                        </td>
                                                        <td>
                                                            <%=vwItem.CReason%>
                                                        </td>
                                                  </tr>
                                            <% Next %>
                                        </tbody>
                                </table>
                                <!-- ./All over -->
                              </div>
                            </div>
                            <!-- Card -->
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
                </div>
            </div>
        </div>
    </div>
     <!-- Card -->
</section>

<!-- javascript -->
<script src="<%=curRootFile%>/_js/tier3/quality.js?v.1.1"></script>