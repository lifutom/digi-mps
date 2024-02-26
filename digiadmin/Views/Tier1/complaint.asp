<%
   Dim vwList : Set vwList = ViewData("list")
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
                <h4 class="modal-title w-100 font-weight-bold"><i class="fab fa-algolia"></i>&nbsp;&nbsp;Tier1:Complaints-Daten</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="editform" action="javascript:save_data();">

                    <input id="cid" name="cid" type="hidden" value="">

                    <div class="md-form mb-2">
                        <label style="font-size: 14px;" for="dateid">Datum:</label><br>
                        <input class="mt-2" id="dateid" name="dateid" type="date" size="12" maxlength="10" required value="<%=DBFormatDate(FormatDateTime(Date,vbShortDate))%>" placeholder="Datum">
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="cnb">Complaint-Nr:</label>
                             <input class="mt-2 text-uppercase" id="cnb" name="cnb" type="text" maxlength="15" required value="" placeholder="Comlaint-Nr">
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="cnumber">International Complaint-Nr:</label>
                             <input class="mt-2 text-uppercase" id="cnumber" name="cnumber" type="text" maxlength="20" required value="" placeholder="Int. Comlaint-Nr">
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="cproduct">Produktgruppe:</label>
                             <input class="mt-2" id="cproduct" name="cproduct" type="text" size="30" maxlength="50" required value="" placeholder="Produktgruppe">
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="ccdescription">Kurzbeschreibung:</label>
                            <textarea class="mt-1" id="cdescription" name="cdescription" maxlength="255" rows="3" cols="40" required placeholder="Kurzbeschreibung">
                            </textarea>
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="ccountry">Land:</label>
                             <input class="mt-2 text-uppercase" id="ccountry" name="ccountry" type="text" size="5" maxlength="5" required value="" placeholder="Land">
                        </div>
                    </div>
                     <div class="md-form mb-2">
                        <div class="md-form">
                            <label for="creason">Grund:</label>
                             <input class="mt-2" id="creason" name="creason" type="text" size="50" maxlength="255" required value="" placeholder="Grund">
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
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;Complaints-Daten</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Eintrag hinzuf&uuml;gen" alt="Eintrag hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/tier1/complaints" title="Refresh"><i class="fas fa-sync"></i></a>
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
                            <th style="display:none">CID</th>
                            <th class="th-sm">Datum</th>
                            <th class="th-sm">ComplaintNr</th>
                            <th class="th-sm">Internationale-Nr</th>
                            <th class="th-sm">Produktgruppe</th>
                            <th class="th-sm">Beschreibung</th>
                            <th class="th-sm">Land</th>
                            <th class="th-sm">Grund</th>
                            <th class="th-sm">letzte &Auml;nderung am</th>
                            <th class="th-sm">Von</th>
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
<script src="<%=curRootFile%>/js/pages/tier1/complaint.js?v1.0"></script>
