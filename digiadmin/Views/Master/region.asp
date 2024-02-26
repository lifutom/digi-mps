<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwListItem
   Dim vwDDItem
%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditGroup" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fa fa-home"></i>&nbsp;&nbsp;Bereich</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <!--<form class="form" id="editform" action="javascript:save_data();">-->
                <form class="form" id="editform">
                    <div class="form">
                        <input id="regionid" name="regionid" type="hidden" value="">
                        <input id="defvalue" name="defvalue" type="hidden" value="">

                        <label for="capanb">Region-Nr:</label>
                        <input class="form-control form-control-sm mb-2" id="nb" name="nb" type="text" maxlength="20" required value="">

                        <label for="capanb">Bezeichnung:</label>
                        <input class="form-control form-control-sm mb-2" id="name" name="name" type="text" maxlength="50" required value="">

                        <div class="custom-control custom-checkbox mt-3">
                            <input type="checkbox" class="custom-control-input" id="active" value="1">
                            <label class="custom-control-label" for="active">Active</label>
                        </div>

                        <input type="submit" style="display:none;"/>

                       <div class="modal-footer d-flex justify-content-center  mt-5">
                            <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                            <button type="button" class="btn btn-cyan sendbtn" id="sendbtn" onclick="checkdoublescb();">Speichern</button>
                        </div>

                    </div>
                </form>
                <div id="regionsvp">
                    <table>
                        <tr>
                            <th>
                                <div class="input-group mb-3">
                                        <select id="svpuserid" name="svpuserid" class="browser-default custom-select">
                                            <option selected disabled>W&auml;hlen Sie eine SVP aus</option>
                                            <%

                                            %>
                                        </select>
                                        <div class="input-group-append ml-1">
                                            <button id="addsvpbtn" class="btn-sm btn-cyan" type="button" title="SVP hinzufügen"><i class="fas fa-plus-circle"></i></button>
                                        </div>
                                </div>
                            </th>
                        </tr>
                    </table>
                    <table id="dtsvplist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th style="display:none">RegionID</th>
                                <th class="th-sm">SVP</th>
                                <th class="th-sm">Name</th>
                                <th class="th-sm"></th>
                                <th style="display:none">Active</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Form -->

<!--Section: Table Regions-->
<section class="mb-5">

    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Bereichsliste</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Eintrag hinzuf&uuml;gen" alt="Eintrag hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/master/regionlist" title="Refresh"><i class="fas fa-sync"></i></a>
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
                            <th style="display:none">RegionID</th>
                            <th class="th-sm">BereichsNr</th>
                            <th class="th-sm">Bezeichnung</th>
                            <th class="th-sm">letzte &Auml;nderung am</th>
                            <th class="th-sm">von</th>
                            <th class="th-sm">Status</th>
                            <th style="display:none">Active</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each vwListItem In vwList.Items %>
                        <tr>
                            <td style="display:none"><%=vwListItem.RegionID%></td>
                            <td><%=vwListItem.NB%></td>
                            <td><%=vwListItem.Name%></td>
                            <td><%=DBFormatDateTime(vwListItem.LastEdit)%></td>
                            <td><%=vwListItem.UserID%></td>
                            <td><a href="javascript:toggleitem(<%=vwListItem.RegionID%>);"><%=IIf(vwListItem.Active=0,"<span class=""red-text""><i class=""fas fa-ban"" title=""Deaktiviert""></i></span>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a></td>
                            <td style="display:none"><%=vwListItem.Active%></td>
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
<!--Section: Table Plant-->

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/master/region.js?v1.0"></script>
