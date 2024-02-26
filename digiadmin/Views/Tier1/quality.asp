<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwDDDepartments : Set  vwDDDepartments = ViewData("dddepartmentlist")
   Dim vwDDStreamType : Set  vwDDStreamType = ViewData("ddstreamtypelist")
   Dim ListItem
%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditGroup" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fab fa-algolia"></i>&nbsp;&nbsp;Tier1:Quality-Daten</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="editform" action="javascript:save_data();">

                    <input id="qualityid" name="qualityid" type="hidden" value="">
                    <input id="userdepartmentid" name="userdepartmentid" type="hidden" value="<%=Session("departmentid")%>">
                    <input id="userstreamtypeid" name="userstreamtypeid" type="hidden" value="<%=Session("streamtypeid")%>">
                    <input id="departmentid" name="departmentid" type="hidden" value="<%=Session("departmentid")%>">
                    <div class="md-form mb-2">
                        Datum:<br>
                         <input id="dateid" name="dateid" type="date" size="12" maxlength="10" required value="<%=DBFormatDate(FormatDateTime(Date,vbShortDate))%>" placeholder="Datum">
                    </div>
                    <div class="md-form mb-2">
                        IPT:<br>
                        <select id="streamtypeid" name="streamtypeid"class="browser-default custom-select">
                            <option selected disabled>W&auml;hlen Sie die IPT aus</option>
                            <%

                                For Each DDItem In vwDDStreamType.Items
                                        %><option value="<%=DDItem.Value%>"><%=DDItem.Name%></option><%
                                Next

                            %>
                        </select>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            Anzahl Complaints:<br>
                            <input id="complaintscnt" name="complaintscnt" type="number" min="0" required value="">
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            Anzahl LROT:<br>
                            <input id="lrotcnt" name="lrotcnt" type="number" min="0" required value="">
                        </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <input type="submit" style="display:none;"/>
                        <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                        <button type="submit" class="btn btn-cyan sendbtn" id="sendbtn">Speichern</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Form -->
<!--Section: Table Groups-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Quality-Daten</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Eintrag hinzuf&uuml;gen" alt="Eintrag hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/tier1/quality" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">QualityID</th>
                            <th class="th-sm">Datum</th>
                            <th style="display:none">StreamTypeID</th>
                            <th class="th-sm">IPT</th>
                            <th class="th-sm">Anzahl Complaints</th>
                            <th class="th-sm">Anzahl LROT</th>
                            <th class="th-sm">letzte &Auml;nderung am</th>
                            <th class="th-sm">von</th>
                            <th></th>
                        </tr>
                    </thead>
                    <!--<tbody>
                    </tbody>-->
                </table>
            </div>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/tier1/quality.js?v1.1"></script>
