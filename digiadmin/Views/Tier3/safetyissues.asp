<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwItem
%>
<style>
    textarea {
     resize: both;
     overflow: auto;
    }
</style>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditGroup" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fab fa-algolia"></i>&nbsp;&nbsp;Tier3: SafetyIssue</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="editform" action="javascript:save_data();">

                    <input id="id" name="escaid" type="hidden" value="">
                    <div class="md-form mb-2">
                        <label style="font-size: 14px;" for="dateid">Datum:</label><br>
                        <input class="mt-2" id="dateid" name="dateid" type="date" size="12" maxlength="10" required value="<%=DBFormatDate(FormatDateTime(Date,vbShortDate))%>" placeholder="Datum">
                    </div>
                    <div class="md-form mb-2">
                        <label style="font-size: 14px;" for="tierlevel">Tier-Level:</label><br>
                        <input class="mt-2" id="tierlevel" name="tierlevel" type="text" size="15" maxlength="15" value="" readonly>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="description">Kurzbeschreibung:</label>
                            <textarea class="mt-1" id="description" name="description" maxlength="255" rows="3" cols="40" required placeholder="Kurzbeschreibung">
                            </textarea>
                        </div>
                    </div>

                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label style="font-size: 14px;" for="start">erstellt:</label><br>
                            <input class="mt-2" id="start" name="start" type="date" required value="">
                        </div>
                    </div>

                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="description">Beschreibung:</label>
                            <textarea class="mt-1" id="longdescription" name="longdescription" maxlength="4000" rows="5" cols="40" placeholder="Beschreibung">
                            </textarea>
                        </div>
                    </div>

                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label style="font-size: 14px;" for="closed3">abgeschlossen:</label><br>
                            <input class="mt-3" id="closed3" name="closed3" type="date" value="">
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
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Safety Issues Tier3</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Eintrag hinzuf&uuml;gen" alt="Eintrag hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/tier3/safetyissues" title="Refresh"><i class="fas fa-sync"></i></a>
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
                            <th style="display:none">ID</th>
                            <th class="th-sm">Datum</th>
                            <th class="th-sm">Level</th>
                            <th class="th-sm">Kurzbeschreibung</th>
                            <th class="th-sm">Erstellt</th>
                            <th class="th-sm">Geschlossen</th>
                            <th style="display:none">Beschreibung</th>
                            <th class="th-sm">letzte &Auml;nderung am</th>
                            <th class="th-sm">von</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <% For Each vItem In vwList.Items %>
                            <tr>
                                <td style="display:none">
                                    <%=vItem.ID%>
                                </td>
                                <td>
                                    <%=vItem.DateID%>
                                </td>
                                <td>
                                    <%=vItem.TierLevel%>
                                </td>
                                <td>
                                    <%=vItem.Description%>
                                </td>
                                <td>
                                    <%=DBFormatDate(vItem.Start)%>
                                </td>
                                <td>
                                    <%=DBFormatDate(vItem.Closed3)%>
                                </td>
                                <td style="display:none">
                                    <%=vItem.LongDescription%>
                                </td>
                                 <td>
                                    <%=DBFormatDateTime(vItem.LastEdit)%>
                                </td>
                                <td>
                                    <%=vItem.UserID%>
                                </td>
                                <td>
                                    <a href="javascript:delete_item('<%=FormatGUID(vItem.ID)%>')" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                </td>
                            </tr>
                        <% Next %>
                    </tbody>
                </table>
            </div>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/tier3/safetyissues.js?v1.0"></script>
