<%
    Dim POverview : Set POverview = ViewData("overview")
    Dim ListItem

    Dim vwProdID : vwProdID = ""
    Dim vwProdText : vwProdText = ""
    Dim vwProdRunning : vwProdRunning = False
    If partial <> "" Then
       vwProdID = ViewData("production").ProductionID
       vwProdText = ViewData("production").Plant & " UIN:" & ViewData("production").UINNb & " Batch:" & ViewData("production").BatchNb
       vwProdRunning = IIf(LCase(ViewData("production").Status) = "running", True, False)
    End If
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
                <% If partial <> "" And vwProdRunning Then %>
                        <!-- Default unchecked -->
                        <div class="custom-control custom-checkbox">
                             <input type="checkbox" class="custom-control-input" id="auto" <%=IIf(Auto<>"", "CHECKED","")%>>
                             <label class="custom-control-label" for="auto">Automatisch</label>
                        </div>
                <% Else %>
                      <input type="hidden" id="auto" value="0"/>
                <% End If %>
                <%=vwProdText%>&nbsp;&nbsp;<a class="white-text" href="javascript: window.location.reload();"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <table id="dtdowntime" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">Start</th>
                            <th class="th-sm">Beendet</th>
                            <th class="th-sm">Control</th>
                            <th class="th-sm">Anlage</th>
                            <th class="th-sm">Anlagenteil</th>
                            <th class="th-sm">Teilbereich</th>
                            <th class="th-sm">Fehler</th>
                            <th class="th-sm text-right">Minuten</th>
                            <th style="display:none">DowntimeID</th>
                        </tr>

                    </thead>
                    <tbody>
                    <% For Each ListItem In POverview.Items %>
                        <tr>
                            <td><%=ListItem.Status%></td>
                            <td><%=ListItem.StartTime%></td>
                            <td><%=ListItem.EndTime%></td>
                            <td><%=ListItem.ControlID%></td>
                            <td><%=ListItem.Plant%></td>
                            <td><%=ListItem.Device%></td>
                            <td><%=ListItem.Component%></td>
                            <td><%=ListItem.Failure%></td>
                            <td class="text-right"><%=ListItem.MinutesDownTime%></td>
                            <td style="display:none"><%=ListItem.DownTimeID%></td>
                        </tr>
                     <% Next %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!--/.Card-->
     <!--Footer-->
     <div class="text-center">
        <a href="javascript:window.close();"type="button" id="dangerbtn" class="btn btn-danger waves-effect">Schlieﬂen</a>
     </div>
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/overview/downtimedetail.1.0.js"></script>