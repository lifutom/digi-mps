<%

   Dim vwList : Set vwList = ViewData("list")
   Dim vwProgressList : Set vwProgressList = ViewData("progresslist")
   Dim vwTypeList : Set vwTypeList = ViewData("typelist")
   Dim vwItem

%>

<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="<%=cRequestToDoTaskIcon%>"></i>&nbsp;&nbsp;<%=GetLabel("mnuMainWorkListMaint", Lang)%>&nbsp;<div id="reqtype"></div></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="appform">
                    <input id="id" name="id" type="hidden" required value="-1">
                    <input id="taskid" name="taskid" type="hidden" required value="-1">
                    <input id="accesstypeid" name="accesstypeid" type="hidden" required value="-1">
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="tasknb"><%=GetLabel("lblTaskNb", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="tasknb" name="tasknb" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="reqnb"><%=GetLabel("lblRequestNb", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="reqnb" name="reqnb" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="displayname"><%=GetLabel("lblRequestedFor", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="displayname" name="displayname" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="accesstype"><%=GetLabel("lblAccessItemType", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="accesstype" name="accesstype" class="form-control" readonly/>
                        </div>
                    </div>
                    <!--<div id="accessitem-text" style="display:none" class="form-group row">
                        <label class="col-sm-2 col-form-label" for="accessitem"><%=GetLabel("lblAccessItem", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="accessitem" name="accessitem" class="form-control" readonly/>
                        </div>
                    </div>-->
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="accesstypeid"><%=GetLabel("lblAccessItem", Lang)%>:</label>
                        <div class="col-sm-10">
                            <select name="accessitemid" id="accessitemid" class="form-control form-control-inline search-drowdown" style="width: 30%;">
                                <option value="" disabled selected>--&nbsp;<%=GetLabel("lblAccessItem", Lang)%>&nbsp;--</option>
                            </select>
                        </div>
                    </div>
                    <!--<div style="display:none" class="form-group row">
                        <label class="col-sm-2 col-form-label" for="accessright"><%=GetLabel("lblAccessRights", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="accessright" name="accessright" class="form-control" readonly/>
                        </div>
                    </div>-->
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="accesstypeid"><%=GetLabel("lblAccessRights", Lang)%>:</label>
                        <div class="col-sm-10">
                            <select name="accessrightid" id="accessrightid" class="form-control form-control-inline search-drowdown" style="width: 40%;">
                                 <option value="" disabled selected>--&nbsp;<%=GetLabel("lblARight", Lang)%>&nbsp;--</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="elognb"><%="E-LogNb"%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="elognb" name="elognb" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row app">
                        <label class="col-sm-2 col-form-label" for="isgxp"><%=GetLabel("lblGmp", Lang)%>:</label>
                        <label class="switch mt-2 ml-3">
                            <input class="mt-1" type="checkbox" name="isgxp" id="isgxp" value="1" disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="description"><%=GetLabel("lblDescription", Lang)%>:</label>
                        <div class="col-sm-10">
                            <textarea id="description" name="description" class="form-control" rows="3" readonly/></textarea>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="comment"><%=GetLabel("lblComment", Lang)%>:</label>
                        <div class="col-sm-10">
                            <textarea id="comment" name="comment" class="form-control" rows="3"/></textarea>
                        </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <div style="display:none">
                            <input type="submit" id="btnSubmit"/>
                        </div>
                        <button class="btn btn-danger" data-dismiss="modal"><%=GetLabel("btnCancel", Lang)%></button>
                        <button type="button" class="btn btn-cyan" id="btnDone"><div id="spinner-workitem-done"></div><%=GetLabel("btnDone", Lang)%></button>
                        <button type="button" class="btn btn-grey btnNotDone" id="btnNotDone"><div id="spinner-workitem-notdone"></div><%=GetLabel("btnNotDone", Lang)%></button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Form -->
<!-- Modal Upload Form -->
<div class="modal fade" id="uploadForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="<%=cRequestToDoTaskIcon%>"></i>&nbsp;&nbsp;&nbsp;&nbsp;<%=GetLabel("mnuMainWorkListMaint", Lang)%>&nbsp;<div id="ureqtype"></div></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="appform">
                    <input id="uid" name="uid" type="hidden" required value="-1">
                    <input id="utaskid" name="utaskid" type="hidden" required value="-1">
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="utasknb"><%=GetLabel("lblTaskNb", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="utasknb" name="utasknb" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="ureqnb"><%=GetLabel("lblRequestNb", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="ureqnb" name="ureqnb" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="udisplayname"><%=GetLabel("lblRequestedFor", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="udisplayname" name="udisplayname" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="uaccesstype"><%=GetLabel("lblAccessItemType", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="uaccesstype" name="uaccesstype" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="uaccessitem"><%=GetLabel("lblAccessItem", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="uaccessitem" name="uaccessitem" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="uaccessright"><%=GetLabel("lblAccessRights", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="uaccessright" name="uaccessright" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="udescription"><%=GetLabel("lblDescription", Lang)%>:</label>
                        <div class="col-sm-10">
                            <textarea id="udescription" name="udescription" class="form-control" rows="3" readonly/></textarea>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="uaf"><%=GetLabel("lblUserAccessForm", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="file" id="uaf" name="uaf" accept=".pdf"class="form-control" requested/>
                        </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <button class="btn btn-danger" data-dismiss="modal"><%=GetLabel("btnCancel", Lang)%></button>
                        <button type="button" class="btn btn-cyan" id="btnUpload"><div id="spinner-task-uaf-done"></div><i class="<%=cTaskTypeUploadIcon%>"></i>&nbsp;<%=GetLabel("btnUpload", Lang)%></button>
                        <button type="button" class="btn btn-grey btnNotDone" id="btnUploadNotDone"><div id="spinneruploadnotdone"></div><%=GetLabel("btnNotDone", Lang)%></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Upload Form -->
<!--Section: Table-->
<section>
    <div class="col-md-12">

        <div class="card">
            <div class="card-header-black">
                <div class="float-left">
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold"><i class="<%=cRequestToDoTaskIcon%>"></i>&nbsp;<%=GetLabel("mnuMainWorkListMaint", Lang)%></h5>
                </div>
                <div class="float-right mr-2 mt-2">
                    <a href="#" id="printreport" name="printreport"><i style="font-size: 24px" class="<%=cPrintButtonIcon%> mr-3"></i></a>&nbsp;<a href="#" id="export" name="export"><i style="font-size: 24px" class="<%=cExcelButtonIcon%> mr-3"></i></a>
                    &nbsp;<a href="#" id="refresh" name="refresh"><i style="font-size: 24px" class="<%=cRefreshButtonIcon%> mr-3"></i></a>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive mt-3">
                    <table id="dtlist" name="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th style="max-width: 25px;"></th>
                                <th style="display:none">ID</th>
                                <th style="display:none">ReqID</th>
                                <th style="display:none">AccessTypeID</th>
                                <th style="display:none">AccessItemID</th>
                                <th style="display:none">AccessRightID</th>
                                <th style="display:none">DepartmentID</th>
                                <th style="display:none">ISID</th>
                                <th style="display:none">TaskStateID</th>
                                <th class="th-sm"><%=GetLabel("lblRequestNb", Lang)%></th>
                                <th style="max-width: 25px;"></th>
                                <th class="th-sm"><%=GetLabel("lblTaskNb", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblCreatedBy", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblCreated", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblRequestedFor", Lang)%></th>
                                <th style="display:none"><%=GetLabel("lblDepartment", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblState", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessItemType", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessItem", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessRights", Lang)%></th>
                                <th style="display:none">Description</th>
                                <th style="display:none">TaskID</th>
                                <th style="display:none">ReqType</th>
                                <th style="display:none">TaskType</th>
                                <th style="display:none">TaskTypeID</th>
                                <th class="th-sm"><%=GetLabel("lblAssignedTo", Lang)%></th>
                                <th class="th-sm">ElogNb</th>
                                <th style="display:none">IsGMP</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% For Each vwItem In vwList.Items  %>
                                <tr>
                                    <td><i class="<%=vwItem.ReqTypeIcon%>" title="<%=vwItem.ReqType%>"></i></td>
                                    <td style="display:none"><%=vwItem.ID%></td>
                                    <td style="display:none"><%=vwItem.ReqID%></td>
                                    <td style="display:none"><%=vwItem.AccessTypeID%></td>
                                    <td style="display:none"><%=vwItem.AccessItemID%></td>
                                    <td style="display:none"><%=vwItem.AccessRightID%></td>
                                    <td style="display:none"><%=vwItem.DepartmentID%></td>
                                    <td style="display:none"><%=vwItem.ISID%></td>
                                    <td style="display:none"><%=vwItem.TaskStateID%></td>
                                    <td><%=vwItem.ReqNb%></td>
                                    <td style="max-width: 25px;"><i class="<%=vwItem.TaskTypeIcon%>" title="<%=vwItem.TaskType%>"></i></td>
                                    <td><%=vwItem.TaskNb%></td>
                                    <td><%=vwItem.CreatedBy%></td>
                                    <td><%=DBFormatDate(vwItem.Created)%></td>
                                    <td nowrap><%=vwItem.DisplayName%></td>
                                    <td style="display:none"><%=vwItem.Department%></td>
                                    <td><%=vwItem.TaskState%></td>
                                    <td><%=vwItem.AccessType%></td>
                                    <td><%=vwItem.AccessItem%></td>
                                    <td><%=vwItem.AccessRight%></td>
                                    <td style="display:none"><%=vwItem.Description%></td>
                                    <td style="display:none"><%=vwItem.TaskID%></td>
                                    <td style="display:none"><%=vwItem.ReqType%></td>
                                    <td style="display:none"><%=vwItem.TaskType%></td>
                                    <td style="display:none"><%=vwItem.TaskTypeID%></td>
                                    <th class="th-sm"><%=vwItem.SendToFinal%></th>
                                    <td><%=vwItem.ElogNb%></td>
                                    <td style="display:none"><%=vwItem.IsGXP%></td>
                                    <td nowrap>
                                        <i class="<%=cEditButtonIcon%> btnedit"></i>
                                        &nbsp;<i class="<%=cRequestAccessWorkFlowIcon%> btnwfstate" title="Workflow State"></i>
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
<script src="<%=curRootFile%>/_js/worklist/index_1_4.js?v1.5"></script>