<%
   Dim vwLines : Set vwLines = ViewData("lines")
   Dim vwList : Set vwList = ViewData("list")
   Dim ListItem
   Dim DDItem
%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Baugruppe</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="form" action="javascript:save_data();">
                    <input id="active" name="active" type="hidden" required value="0">
                    <input id="moduleid" name="moduleid" type="hidden" required value="-1">
                    <input id="defvalue" name="defvalue" type="hidden" required value="">
                    <div class="md-form mb-2">
                         <input id="name" name="name" type="text" size="30" maxlength="50" required value="" placeholder="Bauteil">
                    </div>

                    <label class="switch mt-2">
                        <input class="mt-1"type="checkbox" name="isinstand" id="isinstand">
                        <span class="slider round"></span>
                    </label>
                    &nbsp;&nbsp;Anzeige in Stillstandsmeldungen
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
<!-- Modal Edit Links Form -->
<div class="modal fade" id="editLinkForm" tabindex="-1" role="dialog" aria-labelledby="EditLink" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-link"></i>&nbsp;&nbsp;Zuordnung</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form class="form-horizontal" id="linkform">
                    <input id="lmoduleid" name="lmoduleid" type="hidden" required value="-1">
                    <div class="form-group form-inline">
                        <label for="plantid" class="col-sm-2 control-label">Linie</label>
                        <select id="plantid" name="plantid" class="browser-default custom-select  col-sm-5" required>
                            <option value="" disabled>--Auswahl einer Linie--</option>
                            <%
                                For Each DDItem In vwLines.Items
                                    %><option value="<%=DDItem.Value%>"><%=DDItem.Name%></option><%
                                Next
                            %>
                        </select>
                        &nbsp;<button type="button" class="btn btn-cyan" id="sendlinkbtn"><i class="fas fa-plus-circle"></i></button>
                    </div>
                    <div class="form-group form-inline">
                        <label for="deviceid" class="col-sm-2 control-label">Anlage</label>
                        <select id="deviceid" name="deviceid" class="browser-default custom-select col-sm-5" required>
                            <option value="" disabled>--Auswahl einer Anlage--</option>
                        </select>
                    </div>
                    <div class="table mt-3">
                        <table id="tblLink">
                            <thead>
                                <th style="display:none">LinkID</th>
                                <th>Linie</th>
                                <th>Anlage</th>
                                <th></th>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <input type="submit" style="display:none;"/>
                        <button class="btn btn-danger" data-dismiss="modal">Schließen</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Links Form -->


<!--Section: Table User-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Baugruppen</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Baugruppe hinzuf&uuml;gen" alt="Baugruppe hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
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
                            <th style="display:none">Active</th>
                            <th style="display:none">ModuleID</th>
                            <th class="th-sm">Name</th>
                            <th class="th-sm">in Meldungen anzeigen</th>
                            <th class="th-sm">letzte Änderung am</th>
                            <th class="th-sm">von</th>
                            <th class="th-sm">Status</th>
                            <th style="display:none">IsInStand</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    If Not vwList Is Nothing Then
                        For Each ListItem In vwList.Items
                                 %><tr>
                                    <td style="display:none"><%=ListItem.Active%></td>
                                    <td style="display:none"><%=ListItem.ModuleID%></td>
                                    <td><%=ListItem.Name%></td>
                                    <td><a href="javascript:togglestanditem('<%=ListItem.ModuleID%>');"><%=IIf(ListItem.IsInStand=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a></td>
                                    <td><%=DBFormatDateTime(ListItem.LastEdit)%></td>
                                    <td><%=ListItem.UserID%></td>
                                    <td>
                                        <a href="javascript:toggleitem('<%=ListItem.ModuleID%>');"><%=IIf(ListItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a>
                                        &nbsp;&nbsp;<a href="javascript:links('<%=ListItem.ModuleID%>');" title="Zuordnung bearbeiten" alt="Zuordnung bearbeiten"><i class="fas fa-link"></i></a>
                                    </td>
                                    <td style="display:none"><%=ListItem.IsInStand%></td>
                                </tr><%
                         Next
                    End If
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>
<!--Section: Table Plant-->

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/module/index.js?v1.2"></script>
