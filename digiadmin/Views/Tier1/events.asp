<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwDDDepartments : Set  vwDDDepartments = ViewData("dddepartmentlist")
   Dim ListItem
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
                <h4 class="modal-title w-100 font-weight-bold"><i class="fab fa-algolia"></i>&nbsp;&nbsp;Tier1:Event-Daten</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="editform" action="javascript:save_data();">

                    <input id="eventid" name="eventid" type="hidden" value="">
                    <input id="userdepartmentid" name="userdepartmentid" type="hidden" value="<%=Session("departmentid")%>">
                    <div class="md-form mb-2">
                        <label style="font-size: 14px;" for="eventstart">Datum:</label><br>
                        <input class="mt-2" id="dateid" name="dateid" type="date" size="12" maxlength="10" required value="<%=DBFormatDate(FormatDateTime(Date,vbShortDate))%>" placeholder="Datum">
                    </div>
                    <div class="md-form mb-2">
                        <label style="font-size: 14px;" for="eventstart">Abteilung:</label><br>
                        <select id="departmentid" name="departmentid"class="browser-default custom-select mt-3">
                            <option selected disabled>W&auml;hlen Sie die Abteilung aus</option>
                            <%

                                For Each DDItem In vwDDDepartments.Items
                                        %><option value="<%=DDItem.Value%>"><%=DDItem.Name%></option><%
                                Next

                            %>
                        </select>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="eventstart">Event-Nr:</label>
                            DV-<input class="mt-2" id="eventnb" name="eventnb" type="text" maxlength="7" minlength="7" max="7" required value="" placeholder="Event Nummer">
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label style="font-size: 14px;" for="eventstart">Event erstellt:</label><br>
                            <input class="mt-2" id="eventstart" name="eventstart" type="date" required value="">
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="eventdescription">Kurzbeschreibung:</label>
                            <textarea class="mt-1" id="eventdescription" name="eventdescription" maxlength="255" rows="3" cols="40" required placeholder="Event Kurzbeschreibung">
                            </textarea>
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label style="font-size: 14px;" for="eventclosed">Event abgeschlossen:</label><br>
                            <input class="mt-3" id="eventclosed" name="eventclosed" type="date" value="">
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
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Event-Daten</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Eintrag hinzuf&uuml;gen" alt="Eintrag hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/tier1/events" title="Refresh"><i class="fas fa-sync"></i></a>
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
                            <th style="display:none">EventID</th>
                            <th class="th-sm">Datum</th>
                            <th style="display:none">DepartmentID</th>
                            <th class="th-sm">Abteilung</th>
                            <th class="th-sm">EventNr</th>
                            <th class="th-sm">Kurzbeschreibung</th>
                            <th class="th-sm">Erstellt</th>
                            <th class="th-sm">Geschlossen</th>
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
<script src="<%=curRootFile%>/js/pages/tier1/events.js?v1.1"></script>
