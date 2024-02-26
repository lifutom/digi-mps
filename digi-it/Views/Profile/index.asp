<%
   Dim vwRoomList : Set vwRoomList = ViewData("roomlist")
   Dim vwDepList : Set vwDepList = ViewData("deplist")
   Dim vwUser : Set vwUser = ViewData("user")
   Dim vwDelegate : Set vwDelegate = ViewData("delegate")
   Dim vwItem

%>

<!--Section: Table-->
<section>
    <div class="col-md-12">

        <div class="card">
            <div class="card-header-black">
                <div class="float-left">
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold"><i class="<%=cUserIcon%>"></i>&nbsp;Profile</h5>
                </div>
                <div class="float-right mr-2 mt-2">
                    <a href="#" id="refresh" name="refresh"><i style="font-size: 24px" class="<%=cRefreshButtonIcon%> mr-3"></i></a>
                </div>
            </div>
            <div class="card-body">

                    <input type="hidden" id="currow" name="currow" value="">
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="isid">ISID:</label>
                        <div class="col-sm-10">
                            <input type="text" id="isid" name="isid" class="form-control" value="<%=vwUser.ISID%>"readonly/>
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
                            <form id="form" action="javascript:saveData();">
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="lastname"><%=GetLabel("lblLastname", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="text" id="lastname" name="lastname" value="<%=vwUser.LastName%>" class="form-control"  readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="firstname"><%=GetLabel("lblFirstname", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="text" id="firstname" name="firstname" value="<%=vwUser.FirstName%>" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="displayname"><%=GetLabel("lblDisplayname", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="text" id="displayname" name="displayname" value="<%=vwUser.DisplayName%>" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="email"><%=GetLabel("lblEmail", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="email" id="email" name="email" value="<%=vwUser.Email%>" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="addepartment">AD-<%=GetLabel("lblDepartment", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="textl" id="addepartment" name="addepartment" value="<%=vwUser.ADDepartment%>" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="departmentid">DigiMPS-<%=GetLabel("lblDepartment", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <select name="departmentid" id="departmentid" class="search-drowdown form-control" style="width: 100%" disabled>
                                        <option value="" disabled selected>-- <%=GetLabel("lblDepartment", Lang)%> ----------------------</option>
                                        <% For Each vwItem In vwDepList.Items %>
                                            <option value="<%=vwItem.Value%>"<%=IIf(CLng(vwItem.Value)=CLng(vwUser.DepartmentID)," selected","")%>><%=vwItem.Name%></option>
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
                                            <option value="<%=vwItem.Value%>"<%=IIf(CLng(vwItem.Value)=CLng(vwUser.RoomID)," selected","")%>><%=vwItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </div>
                            </div>
                            <div class="text-center">
                                <input type="submit" style="display:none;"/>
                                <button type="submit" class="btn btn-cyan" id="btnSubmit"><%=GetLabel("btnSubmit", Lang)%></button>
                            </div>
                            </form>
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
                                        <% For Each vwItem In vwUser.AccessItemList.Items %>
                                            <tr>
                                                <td><%=vwItem.AccessType%></td>
                                                <td><%=vwItem.AccessItem%></td>
                                                <td><%=vwItem.AccessRight%></td>
                                            </tr>
                                        <% Next %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="delegate" role="tabpanel" aria-labelledby="delegate-tab">
                            <form id="delegateform">
                                <div class="form-group row">
                                    <label class="col-sm-2 col-form-label" for="roomid"><%=GetLabel("lblDelegate", Lang)%>:</label>

                                    <div class="col-sm-10">
                                        <select name="delegateisid" id="delegateisid" class="search-drowdown form-control" style="width: 60%" required>
                                            <option value="" disabled selected>-- <%=GetLabel("lblSelect", Lang)%> ---</option>
                                            <% For Each vwItem In vwDelegate.Items %>
                                                <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                            <% Next %>
                                        </select>&nbsp;
                                        <input type="submit" style="display:none;"/>
                                        <button id="btnAdd" name="btnAdd" type="button" class="btn-sm btn-primary" title="<%=GetLabel("btnAdd", Lang)%>">
                                            <span class="addbtn"><i class="fas fa-plus-circle"></i></span>
                                        </button>
                                    </div>

                                </div>
                            </form>
                            <div class="table-responsive">
                                <table id="deldtlist" name="deldtlist" class="table table-striped table-bordered table-sm" cellspacing="0" width="100%">
                                    <thead>
                                        <tr>
                                            <th class="th-sm">ISID</th>
                                            <th class="th-sm"><%=GetLabel("lblLastName", Lang)%></th>
                                            <th class="th-sm"><%=GetLabel("lblFirstName", Lang)%></th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% For Each vwItem In vwUser.Delegates.Items %>
                                            <tr>
                                                <td><%=vwItem.DelegateISID%></td>
                                                <td><%=vwItem.LastName%></td>
                                                <td><%=vwItem.FirstName%></td>
                                                <td><i class="fas fa-trash-alt btndel"></i></td>
                                            </tr>
                                        <% Next %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">

                    </div>

            </div>
        </div>
    </div>
</section>
<!--Section: Table-->
<!-- javascript -->
<script src="<%=curRootFile%>/_js/profile/index.js?v1.0"></script>