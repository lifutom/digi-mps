<%

    Dim vwProduction : Set vwProduction = ViewData("production")

    Dim curStartTime : Set curStartTime = New DigiDate
    curStartTime.actDate = vwProduction.StartTime

    Dim curEndTime : Set curEndTime = New DigiDate
    curEndTime.actDate = vwProduction.EndTime

%>
<!--Section: Main panel-->
<form id="searchform" name="searchform" method="POST" action="<%=curRootFile%>/overview/productioneditpost/?partial=yes">
    <input type="hidden" id="id" name="id" value="<%=vwProduction.ProductionID%>"/>
    <input type="hidden" id="idx" name="idx" value="<%=ViewData("idx")%>"/>
    <section class="mb-5">
        <!--Card-->
        <div class="card card-cascade narrower">
            <!--Card header-->
            <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center mt-2">
                <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Produktion&nbsp;</a>
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
                                    Linie:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input type="text" id="plant" name="plant" value="<%=vwProduction.Plant%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    UIN:
                                </td>
                                <td style="font-size: 8pt;height=25px">
                                    <input type="text" id="uin" name="uin" value="<%=vwProduction.UinNb%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    Batch:
                                </td>
                                <td style="font-size: 8pt;height=25px">
                                    <input type="text" id="batch" name="batch" value="<%=vwProduction.BatchNb%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    Status:
                                </td>
                                <td style="font-size: 8pt;height=25px">
                                    <input type="text" id="statusid" name="statusid" value="<%=vwProduction.Status%>" disabled/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;height=25px">
                                    Start:
                                </td>
                                <td style="font-size: 8pt;height=25px">
                                    <input type="time" id="start_time" name="start_time" value="<%=curStartTime.curShortTime%>"/>&nbsp;<input type="date" id="start" name="start" value="<%=DBFormatDate(vwProduction.StartTime)%>"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;">
                                    Ende:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input type="time" id="end_time" name="end_time" value="<%=curEndTime.curShortTime%>"/>&nbsp;<input type="date" id="end" name="end" value="<%=DBFormatDate(vwProduction.EndTime)%>"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;">
                                    Gut-Stücke FPP:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input type="number" id="counter" name="counter" value="<%=vwProduction.Counter%>" min="0"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 8pt;">
                                    Schlecht-Stücke FPP:
                                </td>
                                <td style="font-size: 8pt;">
                                    <input type="number" id="counterbad" name="counterbad" value="<%=vwProduction.CounterBad%>" min="0"/>
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
        <a href="javascript:window_close();"type="button" id="dangerbtn" class="btn btn-danger waves-effect">Schließen</a>
     </div>
 </form>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/overview/productionedit.js?v=1.0"></script>