<%

    Dim vwDownTime : Set vwDownTime = ViewData("downtime")
    Dim vwFailureList : Set vwFailureList = ViewData("failure")
    Dim DDItem



    Dim curStartTime : Set curStartTime = New DigiDate
    curStartTime.actDate = vwDownTime.StartTime

    Dim curEndTime : Set curEndTime = New DigiDate
    curEndTime.actDate = vwDownTime.EndTime

%>
<!--Section: Main panel-->
<form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/overview/downtimeeditpost/?partial=yes">
    <input type="hidden" id="id" name="id" value="<%=vwDownTime.DownTimeID%>"/>
    <input type="hidden" id="idx" name="idx" value="<%=ViewData("idx")%>"/>
    <section class="mb-5">
        <% If partial <> "" Then %>
              <h4>&nbsp;</h4>
        <% End If %>
        <!--Card-->
        <div class="card card-cascade narrower">
            <!--Card header-->
            <div class="view view-cascade py-3 gradient-card-header cyan mx-4 d-flex justify-content-between align-items-center">
                <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Downtime&nbsp;</a>
                <div class="float-right">
                    <a class="white-text" href="javascript: refresh_data();"><i class="fas fa-sync"></i></a>
                </div>
            </div>
            <!--Card content-->
            <div class="card-body">
                <div class="table-responsive">

                        <table class="table table-bordered table-sm" cellspacing="0" width="100%">

                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    UIN:
                                </td>
                                <td style="font-size: 8pt;height=25px">
                                    <input type="text" id="uin" name="uin" value="<%=vwDownTime.UINb%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    Batch:
                                </td>
                                <td style="font-size: 8pt;height=25px">
                                    <input type="text" id="batch" name="batch" value="<%=vwDownTime.BatchNb%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    Status:
                                </td>
                                <td style="font-size: 8pt;height=25px">
                                    <input type="text" id="statusid" name="statusid" value="<%=vwDownTime.Status%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    Start:
                                </td>
                                <td style="font-size: 8pt;height=25px">
                                    <input type="time" id="start_time" name="start_time" value="<%=curStartTime.curShortTime%>"/>&nbsp;<input type="date" id="start" name="start" value="<%=DBFormatDate(vwDownTime.StartTime)%>"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;">
                                    Ende:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input type="time" id="end_time" name="end_time" value="<%=curEndTime.curShortTime%>"/>&nbsp;<input type="date" id="end" name="end" value="<%=DBFormatDate(vwDownTime.EndTime)%>"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    Linie:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input type="text" id="plant" name="plant" value="<%=vwDownTime.Plant%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;">
                                   Anlage:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input type="text" id="device" name="device" value="<%=vwDownTime.Device%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;">
                                   Anlagenteil:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input type="text" id="component" name="component" value="<%=vwDownTime.Component%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;">
                                   Fehler:
                                </td>
                                <td style="font-size: 8pt;">
                                    <select style="height: 25px;" id="failureid" name="failureid" class="browser-default custom-select">
                                         <%
                                                    For Each DDItem In vwFailureList.Items
                                                        %><option value="<%=DDItem.FailureID%>" <%=IIf(CInt(DDItem.FailureID) = CInt(vwDownTime.FailureID),"selected","")%>><%=DDItem.Failure%></option><%
                                                    Next
                                         %>
                                    </select>
                                </td>
                            </tr>
                        </table>

                </div>
            </div>
        </div>
        <!--/.Card-->
    </section>
     <!--Footer-->
     <div class="text-center">
        <a href="javascript:form_submit();"type="button" id="successbtn" class="btn btn-cyan waves-effect">Speichern</a>
        <a href="javascript:window_close();"type="button" id="dangerbtn" class="btn btn-danger waves-effect">Schlieﬂen</a>
     </div>
 </form>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/overview/downtimeedit.js?v=1.0"></script>