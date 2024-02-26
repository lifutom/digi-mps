<%
   Dim vwRoomList : Set vwRoomList = ViewData("roomlist")
   Dim vwDepList : Set vwDepList = ViewData("deplist")
   Dim vwList : Set vwList = ViewData("list")
   Dim vwItem

%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="<%=cUserIcon%>"></i>&nbsp;&nbsp;<%=GetLabel("lblUser", Lang)%></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="form" action="javascript:saveData();">
                    <input type="hidden" id="currow" name="currow" value="">
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="isid">ISID:</label>
                        <div class="col-sm-10">
                            <input type="text" id="isid" name="isid" class="form-control" readonly/>
                        </div>
                    </div>
                    <ul class="nav nav-tabs mt-3" id="myTab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="master-tab" data-toggle="tab" href="#master" role="tab" aria-controls="master"
                                aria-selected="true"><%=GetLabel("lblTabGenerally", Lang)%></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="detail-tab" data-toggle="tab" href="#detail" role="tab" aria-controls="detail"
                                aria-selected="false"><%=GetLabel("lblTabAccess", Lang)%></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="delegate-tab" data-toggle="tab" href="#delegate" role="tab" aria-controls="delegate"
                                aria-selected="false"><%=GetLabel("lblTabDelegate", Lang)%></a>
                        </li>
                    </ul>
                    <div class="tab-content" id="myTabContent">
                        <div class="tab-pane fade show active" id="master" role="tabpanel" aria-labelledby="master-tab">
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="lastname"><%=GetLabel("lblLastname", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="text" id="lastname" name="lastname" class="form-control"  readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="firstname"><%=GetLabel("lblFirstname", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="text" id="firstname" name="firstname" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="displayname"><%=GetLabel("lblDisplayname", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="text" id="displayname" name="displayname" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="email"><%=GetLabel("lblEmail", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="email" id="email" name="email" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="addepartment">AD-<%=GetLabel("lblDepartment", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="textl" id="addepartment" name="addepartment" value="" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="departmentid"><%=GetLabel("lblDepartment", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <select name="departmentid" id="departmentid" class="search-drowdown form-control" style="width: 100%" required>
                                        <option value="" disabled selected>-- <%=GetLabel("lblDepartment", Lang)%> ----------------------</option>
                                        <% For Each vwItem In vwDepList.Items %>
                                            <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="roomid"><%=GetLabel("lblLocation", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <select name="roomid" id="roomid" class="search-drowdown form-control" style="width: 100%">
                                        <option value="" disabled selected>-- Auswahl Raum ----------------------</option>
                                        <% For Each vwItem In vwRoomList.Items %>
                                            <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="detail" role="tabpanel" aria-labelledby="detail-tab">
                            <div class="table-responsive">
                                <table id="adtlist" name="adtlist" class="table table-striped table-bordered table-sm" cellspacing="0" width="100%">
                                    <thead>
                                        <tr>
                                            <th class="th-sm"><%=GetLabel("lblAccessItemType", Lang)%></th>
                                            <th class="th-sm"><%=GetLabel("lblAccessItem", Lang)%></th>
                                            <th class="th-sm"><%=GetLabel("lblARight", Lang)%></th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="delegate" role="tabpanel" aria-labelledby="delegate-tab">
                            <div class="table-responsive">
                                <table id="deldtlist" name="deldtlist" class="table table-striped table-bordered table-sm" cellspacing="0" width="100%">
                                    <thead>
                                        <tr>
                                            <th class="th-sm">ISID</th>
                                            <th class="th-sm"><%=GetLabel("lblLastName", Lang)%></th>
                                            <th class="th-sm"><%=GetLabel("lblFirstName", Lang)%></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                   
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <input type="submit" style="display:none;"/>
                        <button class="btn btn-danger" data-dismiss="modal"><%=GetLabel("btnCancel", Lang)%></button>
                        <button type="submit" class="btn btn-cyan" id="btnSubmit"><%=GetLabel("btnSubmit", Lang)%></button>
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
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold"><i class="<%=cUserIcon%>"></i>&nbsp;<%=GetLabel("lblUserlist", Lang)%></h5>
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
                                <th></th>
                                <th class="th-sm">ISID</th>
                                <th class="th-sm"><%=GetLabel("lblDisplayname", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblLastname", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblFirstname", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblLocation", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblEmail", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblDepartment", Lang)%></th>
                                <th style="display:none"><%=GetLabel("lblDepartment", Lang)%></th>
                                <th></th>
                                <th style="display:none">DepartmentID</th>
                                <th style="display:none">RoomID</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% For Each vwItem In vwList.Items  %>
                                <tr>
                                    <td style="text-align: center; width: 20px; vertical-align: middle"><%=IIf(vwItem.Enabled=0, "<i class=""" & cItemBannedIcon & """></i>","")%></td>
                                    <td><%=vwItem.ISID%></td>
                                    <td><%=vwItem.DisplayName%></td>
                                    <td><%=vwItem.LastName%></td>
                                    <td><%=vwItem.FirstName%></td>
                                    <td><%=vwItem.Room%></td>
                                    <td><%=vwItem.EMail%></td>
                                    <td><%=vwItem.ADDepartment%></td>
                                    <td style="display:none"><%=vwItem.Department%></td>
                                    <td nowrap>
                                        <i class="<%=IIf(IsAdmin, cEditButtonIcon, cViewButtonIcon)%> btnedit"></i>
                                        <% If IsAdmin Or IsKeyUser Then %>
                                            &nbsp;<i class="<%=cRequestAccessIcon%> btnaddaccess" title="<%=GetLabel("mnuMainAccessItem", Lang)%>"></i>          
                                        <% End If %>
                                    </td>
                                    <td style="display:none"><%=vwItem.DepartmentID%></td>
                                    <th style="display:none"><%=vwItem.RoomID%></th>
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
<script src="<%=curRootFile%>/_js/user/index.js?v1.1"></script>