<%
  Dim vwControl : Set vwControl = ViewData("control")
  Dim vwPlant : Set vwPlant = ViewData("plant")

  Dim Item
%>

<form>
    <input type="hidden" id="plantid" name="plantid" value="<%=vwPlant.PlantID%>">
    <input type="hidden" id="downtimeid" name="downtimeid" value="<%=vwControl.DownTimeID%>">
    <input type="hidden" id="productionid" name="productionid" value="<%=vwControl.ProductionID%>">
    <input type="hidden" id="controlid" name="controlid" value="<%=vwControl.ControlID%>">
    <input type="hidden" id="start_time" name="start_time" value="<%=IIf(vwControl.IsDTRunning=1,vwControl.DownTimeStartTime, "")%>">
    <input type="hidden" id="end_time" name="end_time" value="">
    <input type="hidden" id="pstart_time" name="pstart_time" value="">
    <input type="hidden" id="pend_time" name="pend_time" value="">
    <input type="hidden" id="isprunning" name="isprunning" value="<%=vwControl.IsPRunning%>">
    <input type="hidden" id="isdtrunning" name="isdtrunning" value="<%=vwControl.IsDTRunning%>">
    <input type="hidden" id="prseconds" name="prseconds" value="<%=vwControl.PrSeconds%>">
    <input type="hidden" id="dtseconds" name="dtseconds" value="<%=vwControl.DTSeconds%>">
</form>

<!-- Central Modal Medium Success-->
<!-- Modal Start Production -->
<div class="modal fade" id="modalStartProdForm" tabindex="-1" role="form" aria-labelledby="StartProdForm"
    aria-hidden="true">
    <div class="modal-dialog" role="document">
        <form id="frmproduction" name="frmproduction">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;<%=vwControl.Plant%>&nbsp;Produktion</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

                <div class="md-form mb-2 ml-2">
                    <input class="form-control validate text-uppercase" type="text" name="uinnb" id="uinnb" placeholder="UIN-Nr"  required/>
                </div>


                <div class="md-form mb-2 ml-2 mt-0">
                    <input class="form-control validate text-uppercase" type="text" name="batchnb" id="batchnb" placeholder="Chargen-Nr" required/>
                </div>

            <div class="modal-footer d-flex justify-content-center">
                <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                <button type="submit" class="btn btn-default sendpbtn" id="sendpbtn" onclick="start_production();">Starten</button>
            </div>
        </div>
        </form>
    </div>
</div>
<!-- /.Modal Start Production -->
<!-- Modal Stop Production -->
<div class="modal fade" id="modalStopProdForm" tabindex="-1" role="dialog" aria-labelledby="StopProdForm"
    aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;<%=vwControl.Plant%>&nbsp;Produktion</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <div class="md-form mb-5">
                    <input class="form-control" type="number" min=1 name="counter" id="counter" placeholder="Gut-St&uuml;cke in FPP " required/>
                </div>
            </div>
            <div class="modal-body mx-3">
                <div class="md-form mb-5">
                    <input class="form-control" type="number" min=1 name="counterbad" id="counterbad" placeholder="Schlecht-St&uuml;cke in FPP" required/>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                <button class="btn btn-default stoppbtn" id="stoppbtn" onclick="stop_production();">Beenden</button>
            </div>
        </div>
    </div>
</div>
<!-- /.Modal Stop Production -->


<!-- Modal Stop Downtime -->
<div class="modal fade" id="modalStopForm" tabindex="-1" role="dialog" aria-labelledby="StopDowntime"
    aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;<%=vwControl.Plant%>&nbsp;Downtime</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <div class="md-form mb-2">
                    <select id="deviceid" name="deviceid"class="browser-default custom-select" onchange="fill_component();">
                        <option selected disabled>W&auml;hlen Sie die Anlage aus</option>
                        <%

                          For Each Item In vwPlant.DeviceList.Items

                              %><option value="<%=Item.DeviceID%>"><%=Item.Device%></option><%

                          Next

                        %>
                    </select>
                </div>
                <div class="md-form mb-2">
                    <select id="componentid" name="componentid" class="browser-default custom-select" onchange="fill_failure();">
                        <option selected disabled>W&auml;hlen Sie die Komponente</option>
                    </select>
                </div>
                <div class="md-form mb-4">
                    <select id="failureid" name="failureid" class="browser-default custom-select">
                        <option selected disabled>W&auml;hlen Sie das Fehlerbild</option>
                    </select>
                </div>
                <div class="form-control">
                  <label>Startzeit&nbsp;<span class="act_start_time"><%=IIf(vwControl.IsDTRunning=1,vwControl.DownTimeStartTime, "")%></span></label>
                </div>
                <div class="md-form mb-2">
                  Downtime in Minuten:<br><br>
                  <input id="act_end_time" name="act_end_time" type="number" min="1" required value="">
                </div>
                <div class="md-form mb-2">
                    <div class="md-form">
                        <i class="fas fa-pencil-alt prefix"></i>
                        <textarea type="text" id="dtdescription" class="md-textarea form-control" rows="2"></textarea>
                        <label data-error="wrong" data-success="right" for="dtdescription">Beschreibung</label>
                    </div>
                </div>

            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                <button class="btn btn-default sendbtn" id="sendbtn" onclick="save_downtimedata();">Speichern</button>
            </div>
        </div>
    </div>
</div>
<!-- /.Modal Stop Downtime -->
<!-- active devices -->
<div class="row">
    <% If vwControl.PlantID > 0 Then %>
    <!-- Grid column -->
    <div class="col-xl-8 col-lg-12 mb-2">
        <div class="row">
            <div class="col-6">
                <h2 class="card-title font-weight-bold pt-0">
                        <strong><%=vwPlant.Plant%></strong>
                </h2>
                <span class="uinnb"><%=IIf(vwControl.IsPRunning=1, "UIN:&nbsp;" & vwControl.UINNb & "/ChargenNr:&nbsp;" & vwControl.BatchNb, "")%></span>
            </div>
            <div class="col-6">
                <h2 class="card-title font-weight-bold pt-0">
                        <strong>&nbsp;</strong>
                </h2>
                <div style="text-align: right;" id="pstatus"></div>
                    <!--<span class="actwatch">
                        <div class="clock1"></div>
                        <script type="text/javascript">
                            var clock = $('.clock1').FlipClock({
                                clockFace: 'TwentyFourHourClock'
                            });
                        </script>
                    </span>-->
            </div>
        </div>
        <!--Image -->
        <div class="view zoom z-depth-1 rounded">

            <img src="<%=curRootFile%>/images/<%=vwPlant.Image%>" class="img-fluid rounded-bottom" alt="<%=vwPlant.Plant%>" title="<%=vwPlant.Description%>">
            <div class="mask rgba-stylish-strong">
                <div class="row">
                    <div class="col-4 text-white pl-3 pt-4">
                        <div>
                            <button id="btnpstart" type="button" class="btn btn-cyan btn-lg btnpstart" onclick="starting_production();"><i class="fas fa-stopwatch left"></i>Start<br>Produktion</button>
                            <button id="btnpstop" type="button" class="btn btn-cyan btn-lg btnpstop" onclick="stoping_production();"><i class="fas fa-stopwatch left"></i>Stop<br>Produktion</button>
                        </div>
                    </div>
                    <div class="col-8" style="text-align: center">
                        <div style="display: inline-block">
                            <span class="pwatch">
                                <div class="phour-counter"></div>
                                <script type="text/javascript">
                                   var pclockcnt = $('.phour-counter').FlipClock(<%=vwControl.PrSeconds%>,{
                                       language: 'de'
                                   });
                                </script>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row ">
                    <div class="col-4 text-white pl-3 pt-4">
                        <div>
                            <button id="btnstart" type="button" class="btn btn-cyan btn-lg btnstart" onclick="starting_downtime();"><i class="fas fa-stopwatch left"></i>Start<br>Downtime&nbsp;&nbsp;&nbsp;</button>
                            <button id="btnstop" type="button" class="btn btn-cyan btn-lg btnstop" onclick="stopping_downtime();"><i class="fas fa-stopwatch left"></i>Stop<br>Downtime&nbsp;&nbsp;&nbsp;</button>
                        </div>
                    </div>
                    <div class="col-8" style="text-align: center">
                        <div style="display: inline-block">
                            <span class="watch">
                                <div class="hour-counter"></div>
                                <script type="text/javascript">
                                   var clockcnt = $('.hour-counter').FlipClock(<%=vwControl.DTSeconds%>,{
                                       language: 'de'
                                   });
                                </script>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <!--Image -->

    </div>
    <% Else %>
    <!-- Grid column -->
    <div class="col-xl-12 col-lg-12 mb-2">
        <div class="row">
            <div class="col-12">
                <h2 class="card-title font-weight-bold pt-0">
                        <strong>MSD Austria AH Wien 2019</strong>
                </h2>
            </div>
             <!--Image -->
             <div class="mt-5">
                <img src="<%=CurRootFile%>/images/digimps.png" class="img-fluid rounded-bottom" alt="DigiMPS" title="DigiMPS">
            </div>
            <!--<div class="view zoom z-depth-1 rounded">
                <img src="<%=curRootFile%>/images/digimps.png" class="img-fluid rounded-bottom" alt="DigiMPS" title="DigiMPS">
            </div>-->
            <div class="col-12 mt-5 mb-5">
                 <strong>Ihr Device wurde nicht zugeordnet. Bitte wenden Sie sich an Herrn Osterauer Martin</strong>
            </div>
        </div>
    </div>
    <% End If %>
    <!-- Grid column -->


</div>
<!-- /.active devices -->
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/home/index.1.7.js"></script>
<!-- handle cookies -->
<script src="<%=curRootFile%>/js/cookies.1.0.js"></script>

