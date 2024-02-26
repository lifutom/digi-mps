<%
    Dim POverview : POverview = ViewData("datalist")
    Dim ListItem

    Dim vwProdID : vwProdID = ""
    Dim vwProdText : vwProdText = ""
    Dim vwProdRunning : vwProdRunning = False

    vwProdID = ViewData("production").ProductionID
    vwProdText = " UIN:" & ViewData("production").UINNb & " Batch:" & ViewData("production").BatchNb
    vwProdRunning = IIf(LCase(ViewData("production").Status) = "running", True, False)
    Dim vwDeviceList : Set vwDeviceList = ViewData("devicelist")

%>
<!--Section: Main panel-->
<input type="hidden" id="prodid" value="<%=vwProdID%>"/>
<input type="hidden" id="listname" value="<%=ViewData("datalist")%>"/>
<section class="mb-2">

    <!--Card-->
    <div class="card card-cascade narrower">
        <div class="col-12">
            <!--auswahl header-->
            <div class="md-form float-left ml-4">
                <select id="deviceid" name="deviceid"class="browser-default custom-select" onchange="updatechart();">
                    <option value="0" selected>Alle Anlagenteile</option>
                    <%
                        For Each ListItem In vwDeviceList.Items
                            %><option value="<%=ListItem.DeviceID%>"><%=ListItem.Device%></option><%
                        Next
                    %>
                </select>
            </div>
            <div>

            </div>
            <div class="text-right justify-content-between ml-3 mt-4">
                <div class="form-check form-check-inline">
                    <input type="radio" class="form-check-input" id="devicechartcnt" name="listname" value="devicechartcnt" <%=IIf(ViewData("datalist") = "devicechartcnt","checked","")%>>
                    <label class="form-check-label" for="devicechartcnt">Anzahl</label>
                </div>
                <!-- Material checked -->
                <div class="form-check form-check-inline">
                    <input type="radio" class="form-check-input" id="devicechartmin" name="listname" value="devicechartmin" <%=IIf(ViewData("datalist") = "devicechartmin","checked","")%>>
                    <label class="form-check-label" for="devicechartmin">Zeit</label>
                </div>
            </div>
       </div>
    </div>

    <!--Card-->
    <div class="card card-cascade narrower mt-2">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;<%=ViewData("production").Plant%>&nbsp;</a>
             <!-- Material unchecked -->

            <div class="float-right">
                <%=vwProdText%>&nbsp;&nbsp;<a class="white-text" href="javascript: window.location.reload();"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--Card content-->
        <div class="card-body">
            <div id="chartdiv" class="col-12">
                 <canvas id="prodbarchart" style="max-width: 800px;max-height:650px;"></canvas>
            </div>
        </div>
    </div>
    <!--/.Card-->
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/overview/prodbarchart.1.0.js"></script>