<%
    Dim POverview : Set POverview = ViewData("overview")
    Dim ListItem

    Dim vwLines : Set vwLines = ViewData("lines")
    Dim vwDevices : Set vwDevices = ViewData("devices")
    Dim vwSearch : Set vwSearch = ViewData("search")
    Dim DDItem

    ' Acccess Rights'
    Dim acRights : Set acRights = New AccessRights
    Dim HasDeleteRight : HasDeleteRight = acRights.HasAccessRight("delete_downtime", Session("login"))


%>
<!--Section: Main panel-->
<input type="hidden" id="prodid" value="<%=vwProdID%>"/>
<section class="mb-5">
    <% If partial <> "" Then %>
          <h4>&nbsp;</h4>
    <% End If %>
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header cyan mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Downtimes&nbsp;</a>
            <div class="float-right">
                <a class="white-text" href="javascript: refresh_datatable();"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/overview/downtimepost">
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
                                                        <a class="btn btn-sm btn-cyan" id="searchlink" name="searchlink" title="Suchen" alt="Suchen"><span style="font-size: 14px" class="glyphicon glyphicon-eye-open"></span></a>
                                                    </td>
                                                    <td>
                                                        <a class="btn btn-sm btn-cyan" title="Filter l&ouml;schen" alt="Filter l&ouml;schen" id="delfilter" name="delfilter"><span style="font-size: 14px"class="glyphicon glyphicon-eye-close"></span></a>
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
                                           Anlage:
                                        </td>
                                        <td style="font-size: 8pt;">
                                            <select style="height: 25px;" id="deviceid" name="deviceid" class="browser-default custom-select">
                                                <option style="height: 20px;" value="-1">--Alle--</option>
                                                <%
                                                    For Each DDItem In vwDevices.Items
                                                        %><option value="<%=DDItem.Value%>" <%=IIf(CInt(DDItem.Value) = CInt(vwSearch.DeviceID),"selected","")%>><%=DDItem.Name%></option><%
                                                    Next
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                </table>
                            </th>
                        </tr>
                    </table>
                </form>
                <table id="dtdowntime" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">DowntimeID</th>
                            <th class="th-sm">UIN</th>
                            <th class="th-sm">Batch</th>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">Start</th>
                            <th class="th-sm">Beendet</th>
                            <th class="th-sm">Linie</th>
                            <th class="th-sm">Anlage</th>
                            <th class="th-sm">Anlagenteil</th>
                            <th class="th-sm">Fehler</th>
                            <th class="th-sm text-right">Minuten</th>
                            <th></th>
                        </tr>

                    </thead>
                    <tbody>
                    <% For Each ListItem In POverview.Items %>
                        <tr>
                            <td style="display:none"><%=ListItem.DownTimeID%></td>
                            <td><%=ListItem.UINb%></td>
                            <td><%=ListItem.BatchNb%></td>
                            <td style="font-size: 8pt;"><%=ListItem.Status%></td>
                            <td style="font-size: 8pt;"><%=DBFormatDateTime(ListItem.StartTime)%></td>
                            <td style="font-size: 8pt;"><%=DBFormatDateTime(ListItem.EndTime)%></td>
                            <td><%=ListItem.Plant%></td>
                            <td><%=ListItem.Device%></td>
                            <td><%=ListItem.Component%></td>
                            <td><%=ListItem.Failure%></td>
                            <td class="text-right"><%=ListItem.MinutesDownTime%></td>
                            <td>
                                <% If IsAdmin Or (HasDeleteRight And ListItem.PlantID = 10) Then%>
                                    <a href="javascript:deleteDTQue('<%=Replace(Replace(ListItem.DownTimeID,"}",""),"{","")%>');" title="L&ouml;schen"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                <% End If %>
                            </td>
                        </tr>
                     <% Next %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!--/.Card-->
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/overview/downtime.1.0.js?v=1.1"></script>