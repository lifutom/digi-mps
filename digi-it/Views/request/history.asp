<%

   Dim vwList : Set vwList = ViewData("list")
   Dim vwStateList : Set vwStateList = ViewData("statelist")
   Dim vwTypeList : Set vwTypeList = ViewData("typelist")
   Dim vwItem

%>

<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="<%=cRequestInboxApproveIcon%>"></i>&nbsp;&nbsp;<%=GetLabel("lblRequestlist", Lang)%></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="appform">
                    <input id="id" name="id" type="hidden" required value="-1">
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
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="accessitem"><%=GetLabel("lblAccessItem", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="accessitem" name="accessitem" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="accessright"><%=GetLabel("lblAccessRights", Lang)%>:</label>
                        <div class="col-sm-10">
                            <input type="text" id="accessright" name="accessright" class="form-control" readonly/>
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
                            <textarea id="comment" name="comment" class="form-control" rows="3" readonly/></textarea>
                        </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <button class="btn btn-danger" data-dismiss="modal"><%=GetLabel("btnCancel", Lang)%></button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Form -->
<!--Section: Table-->
<section>
    <div class="col-md-12">

        <div class="card">
            <div class="card-header-black">
                <div class="float-left">
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold"><i class="<%=cRequestInboxApproveIcon%>"></i>&nbsp;<%=GetLabel("mnuMainRequestHistory", Lang) & "&nbsp;-&nbsp;"  & GetLabel("lblRequestlist", Lang)%></h5>
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
                                <th class="th-sm"><%=GetLabel("lblApproveState", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessItemType", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessItem", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessRights", Lang)%></th>
                                <th style="display:none">Description</th>
                                <th style="display:none">Comment</th>
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
                                    <td><%=vwItem.DisplayName%></td>
                                    <td style="display:none"><%=vwItem.Department%></td>
                                    <td><%=vwItem.TaskState%></td>
                                    <td><%=vwItem.AccessType%></td>
                                    <td><%=vwItem.AccessItem%></td>
                                    <td><%=vwItem.AccessRight%></td>
                                    <td style="display:none"><%=vwItem.Description%></td>
                                    <td style="display:none"><%=vwItem.Comment%></td>
                                    <td><%=vwItem.SendToFinal%></td>
                                    <td><%=vwItem.ElogNb%></td>
                                    <td style="display:none"><%=vwItem.IsGXP%></td>
                                    <td nowrap>
                                        <i class="<%=cViewButtonIcon%> btnview"></i>
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
<script src="<%=curRootFile%>/_js/request/history.js?v1.3"></script>