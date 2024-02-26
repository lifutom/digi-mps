<%

    Dim vwList : Set vwList = ViewData("list")
    Dim vwItem

%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Applikation</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="appform" action="javascript:save_data();">
                    <input id="active" name="active" type="hidden" required value="0">
                    <input id="siteid" name="siteid" type="hidden" required value="-1">
                    <input id="defvalue" name="defvalue" type="hidden" required value="">
                    <div class="md-form mb-2">
                         <input id="sitename" name="sitename" type="text" size="12" maxlength="50" required value="" placeholder="Sitename">
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

<!-- Modal AccessList -->
<div class="modal fade" id="listAccess" tabindex="-1" role="dialog" aria-labelledby="listAccess" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="<%=cRequestAccessShareIcon%>"></i>&nbsp;&nbsp;<%=GetLabel("mnuMainAccessItem", Lang)%>&nbsp;<div id="reqtype"></div></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <div class="table-responsive mt-3">
                    <table id="dtlistuseraccess" name="dtlistuseraccess" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th class="th-sm">ISID</th>
                                <th class="th-sm"><%=GetLabel("lblDisplayname", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessItem", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblARight", Lang)%></th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal AccessList -->

<!--Section: Table-->
<section>
    <div class="col-md-12">

        <div class="card">
            <div class="card-header-black">
                <div class="float-left">
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold">verfügbare Applikationen</h5>
                </div>
                <div class="float-right mr-2 mt-2">
                    <button id="addbtn" name="addbtn" type="button" class="btn-sm btn-primary">
                        <span><i class="fas fa-plus-circle"></i></span>
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive mt-3">
                    <table id="dtlist" name="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th></th>
                                <th style="display:none">ID</th>
                                <th style="display:none">TypeID</th>
                                <th class="th-sm">Name</th>
                                <th class="th-sm">Type</th>
                                <th class="th-sm">Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% For Each vwItem In vwList.Items  %>
                                <tr>
                                    <td style="text-align: center; width: 20px; vertical-align: middle"></td>
                                    <td style="display:none"><%=vwItem.ID%></td>
                                    <td style="display:none"><%=vwItem.AccessTypeID%></td>
                                    <td><%=vwItem.Name%></td>
                                    <td><%=vwItem.AccessType%></td>
                                    <td><a href="javascript:toggleitem('<%=vwItem.ID%>');"><%=IIf(vwItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a></td>
                                    <td><i class="<%=cViewButtonIcon%> btnview" title="<%=GetLabel("mnuMainAccessItem", Lang)%>"></i></td>
                                </tr>
                            <% Next %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>
<!--Section: Table-->
<!-- javascript -->
<script src="<%=curRootFile%>/_js/accessitem/apps.js?v1.1"></script>