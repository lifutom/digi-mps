<%

    Dim vwList : Set vwList = ViewData("list")
    Dim vwUserList : Set vwUserList = ViewData("userlist")
    Dim vwStateList : Set vwStateList = ViewData("statelist")
    Dim vwTypeList : Set vwTypeList = ViewData("accesstypelist")
    Dim vwAccessType :  vwAccessType = ViewData("accesstype")
    Dim vwItem

    Dim vwIcon
    Dim vwTitle
    Dim vwEditTitle


    Select Case vwAccessType

        Case cAccessTypeShare

           vwIcon = cRequestAccessShareIcon
           vwTitle = GetLabel("lblAvailableShares", Lang)
           vwEditTitle = GetLabel("mnuMainAccessItemShares", Lang)

        Case cAccessTypeApp

            vwIcon =  cRequestAccessAppIcon
            vwTitle = GetLabel("lblAvailableApps", Lang)
            vwEditTitle = GetLabel("mnuMainAccessItemApps", Lang)

        Case cAccessTypeSAP

            vwIcon =  cRequestAccessAppIcon
            vwTitle = GetLabel("lblAvailableApps", Lang)
            vwEditTitle = GetLabel("mnuMainAccessItemSAP", Lang)

        Case cAccessTypeDevice

            vwIcon =  cRequestAccessDeviceIcon
            vwTitle = "verfügbare Devices"
            vwEditTitle = GetLabel("mnuMainAccessItemDevice", Lang)

    End Select


%>
<!--Section: Table-->
<input type="hidden" id="defaccesstypeid" value="<%=vwAccessType%>" />
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="<%=vwIcon%>"></i>&nbsp;&nbsp;<%=vwEditTitle%>&nbsp;<div id="reqtype"></div></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="form">
                    <input id="id" name="id" type="hidden" required value="-1">
                    <input id="rowid" name="rowid" type="hidden" required value="">
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="name"><%=GetLabel("lblName", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="name" name="name" class="form-control" required/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="accesstypeid"><%=GetLabel("lblType", Lang)%>:</label>
                        <div class="col-sm-10">
                            <select id="accesstypeid" name="accesstypeid" style="width: 100%; height: 30px" class="form-control search-drowpdown" <%=IIf(IsAdmin,"","disabled")%> required>
                                <% For Each vwItem In vwTypeList.Items %>
                                    <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row app">
                        <label class="col-sm-2 col-form-label" for="isgmp"><%=GetLabel("lblGmp", Lang)%>:</label>
                        <label class="switch mt-2 ml-3">
                            <input class="mt-1" type="checkbox" name="isgmp" id="isgmp" value="1" disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                    <div class="form-group row app">
                        <label class="col-sm-2 col-form-label" for="sysowner"><%=GetLabel("lblSystemOwner", Lang)%>:</label>
                        <div class="col-sm-10">
                            <select id="sysowner" name="sysowner" style="width: 100%; height: 30px" class="form-control search-drowpdown" disabled>
                                <option value="">--<%=GetLabel("lblSelect", Lang)%>-- </option>
                                <% For Each vwItem In vwUserList.Items %>
                                    <option value="<%=vwItem.ID%>"><%=vwItem.DisplayName & "(" & UCase(vwItem.ISID) & ")"%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="active"><%=GetLabel("lblActive", Lang)%>:</label>
                        <label class="switch mt-2 ml-3">
                            <input class="mt-1" type="checkbox" name="active" id="active" value="1">
                            <span class="slider round"></span>
                        </label>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <input type="submit" style="display:none;"/>
                        <button class="btn btn-danger" data-dismiss="modal"><%=GetLabel("btnCancel", Lang)%></button>
                        <button type="button" class="btn btn-cyan" id="btnSubmit"><div id="spinnerdone"></div><%=GetLabel("btnSubmit", Lang)%></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Form -->
<!-- Modal Edit AccessRights Form -->
<div class="modal fade" id="editAccessForm" tabindex="-1" role="dialog" aria-labelledby="editAccessForm" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="<%=vwIcon%>"></i>&nbsp;&nbsp;<%=vwEditTitle%>&nbsp;<div id="reqtype"></div></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body mx-3">
                <form id="arform">
                    <input type="hidden" id="aid" name="aid" />
                    <input type="hidden" id="rid" name="rid" />
                    <div class="form-group row">
                        <div class="col-sm-12">
                            <label class="col-sm-2 col-form-label form-label-inline" for="accessrightid"><%=GetLabel("lblAccessRights", Lang)%>:</label>
                            <div class="row">
                                <div class="col-5">
                                    <input class="form-control form-control-inline" type="text" name="accessright" id="accessright" value="" required="required" />
                                </div>
                                <div class="col-7">
                                    <select name="workflowid" id="workflowid" class="form-control form-control-inline search-drowpdown-access" style="width: 60%;">
                                        <option value="" disabled selected>--&nbsp;<%=GetLabel("lblWorkFlow", Lang)%>&nbsp;--</option>
                                    </select>
                                    <input type="submit" style="display:none;"/>
                                    <button id="btnAdd" name="btnAdd" type="button" class="btn-sm btn-primary" title="<%=GetLabel("btnAdd", Lang)%>">
                                        <span class="addbtn"><i class="fas fa-plus-circle"></i></span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
                <div class="table-responsive mt-3">
                    <table id="dtlistaccess" name="dtlistaccess" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th style="display:none">AccessItemID</th>
                                <th style="display:none">ItemRightID</th>
                                <th style="display:none">WorkflowID</th>
                                <th class="th-sm"><%=GetLabel("lblAccessItem", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessRight", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblWorkflow", Lang)%></th>
                                <th></th>
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
<!-- Modal AccessRights Form -->
<!-- Modal AccessList -->
<div class="modal fade" id="listAccess" tabindex="-1" role="dialog" aria-labelledby="listAccess" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="<%=vwIcon%>"></i>&nbsp;&nbsp;<%=GetLabel("mnuMainAccessItem", Lang) & "&nbsp;" & vwEditTitle%>&nbsp;<div id="reqtype"></div></h4>
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
<input type="hidden" id="vwaccesstypeid" name="vwaccesstypeid" value="<%=vwAccessType%>" />
<section>
    <div class="col-md-12">

        <div class="card">
            <div class="card-header-black">
                <div class="float-left">
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold"><i class="<%=vwIcon%>"></i>&nbsp;&nbsp;<%=vwTitle%></h5>
                </div>
                <div class="float-right mr-2 mt-2">
                    <a href="#" id="printreport" name="printreport"><i style="font-size: 24px" class="<%=cPrintButtonIcon%> mr-3"></i></a>&nbsp;<a href="#" id="export" name="export"><i style="font-size: 24px" class="<%=cExcelButtonIcon%> mr-3"></i></a>
                    &nbsp;<a href="#" id="refresh" name="refresh"><i style="font-size: 24px" class="<%=cRefreshButtonIcon%> mr-3"></i></a>
                    &nbsp;<a href="#" id="add" name="add"><i style="font-size: 24px" class="<%=cAddButtonIcon%> mr-3"></i></a>
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
                                <th style="display:none">Active</th>
                                <th class="th-sm"><%=GetLabel("lblName", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblType", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblState", Lang)%></th>
                                <th style="display:none">IsGMP</th>
                                <th style="display:none">sysowner</th>
                                <th><%=GetLabel("lblSystemOwner", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblGMP", Lang)%></th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% For Each vwItem In vwList.Items  %>
                                <tr>
                                    <td style="text-align: center; width: 20px; vertical-align: middle"></td>
                                    <td style="display:none"><%=vwItem.ID%></td>
                                    <td style="display:none"><%=vwItem.AccessTypeID%></td>
                                    <td style="display:none"><%=vwItem.Active%></td>
                                    <td><%=vwItem.Name%></td>
                                    <td><%=vwItem.AccessType%></td>
                                    <td><a href="javascript:toggleitem('<%=vwItem.ID%>');"><%=IIf(vwItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a></td>
                                    <td style="display:none"><%=vwItem.IsGMP%></td>
                                    <td style="display:none"><%=vwItem.SystemOwner%></td>
                                    <td><%=IIf(vwItem.SystemOwner <> "", vwItem.SODisplayName & "(" & UCase(vwItem.SystemOwner) & ")","")%></td>
                                    <td><%=IIf(vwItem.IsGMP=0,"","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></td>
                                    <td>
                                        <% If IsAdmin Or IsKeyUser Then %>
                                            <i class="<%=cEditButtonIcon%> btnedit" title="<%=GetLabel("btnEdit", Lang)%>"></i>
                                            &nbsp;<i class="<%=cAccessRight%> btnaccess" title="<%=GetLabel("btnAccessRight", Lang)%>"></i>
                                            &nbsp;<i class="<%=cRequestAccessWorkFlowIcon%> btnworkflow" title="<%=GetLabel("btnWorkFlow", Lang)%>"></i>
                                        <% End If %>
                                        <i class="<%=cViewButtonIcon%> btnview" title="<%=GetLabel("mnuMainAccessItem", Lang)%>"></i>
                                    </td>
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
<script src="<%=curRootFile%>/_js/accessitem/adshares.js?v1.4"></script>