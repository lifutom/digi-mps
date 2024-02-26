<%

   Dim vwAccessTypeList : Set vwAccessTypeList = ViewData("accesstypelist")
   Dim vwUserList : Set vwUserList = ViewData("userlist")
   Dim vwStateList : Set vwStateList = ViewData("statelist")
   Dim vwPeopleManager : Set vwPeopleManager = ViewData("peoplemanager")
   Dim vwItem

%>
<!--Section: Table-->
<section>
    <div class="col-md-12">
        <div class="card">
            <div class="card-header-black">
                <div class="float-left">
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold">&nbsp;<i class="<%=cRequestTypeRevokeIcon%>"></i>&nbsp;<%=GetLabel("lblRequestForm", Lang) & " - " & GetLabel("lblRevokeAccessRights", Lang)%></h5>
                </div>
                <div class="float-right mr-2 mt-2">
                </div>
            </div>
            <div class="card-body">
                <ul class="nav nav-tabs mt-3" id="myTab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="master-tab" data-toggle="tab" href="#master" role="tab" aria-controls="master"
                            aria-selected="true"><%=GetLabel("lblTabGenerally", Lang)%></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="detail-tab" data-toggle="tab" href="#detail" role="tab" aria-controls="detail"
                            aria-selected="false"><%=GetLabel("lblTabAccess", Lang)%></a>
                    </li>
                </ul>
                <form id="form" action="javascript:saveData();">
                    <input type="hidden" id="lblAccessItemType" name="lblAccessItemType" value="<%=GetLabel("lblAccessItemType", Lang)%>"/>
                    <input type="hidden" id="lblAccessItem" name="lblAccessItem" value="<%=GetLabel("lblAccessItem", Lang)%>"/>
                    <input type="hidden" id="lblARight" name="lblARight" value="<%=GetLabel("lblARight", Lang)%>"/>
                    <input type="hidden" id="msgFillAllFields" name="msgFillAllFields" value="<%=GetLabel("msgFillAllFields", Lang)%>"/>
                    <input type="hidden" id="msgAccessRightAtLeastOne" name="msgAccessRightAtLeastOne" value="<%=GetLabel("msgAccessRightAtLeastOne", Lang)%>"/>
                    <input type="hidden" id="reqtypeid" name="reqtypeid" value="<%=cRequestTypeRevoke%>"/>

                    <div class="tab-content" id="myTabContent">
                        <div class="tab-pane fade show active" id="master" role="tabpanel" aria-labelledby="master-tab">


                            <input id="reqid" name="reqid" type="hidden" required value="-1">
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="createdby"><%=GetLabel("lblRequestor", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="text" id="createdby" name="createdby" class="form-control" value="<%=Session("login")%>" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="reqnb"><%=GetLabel("lblRequestNb", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="text" id="reqnb" name="reqnb" class="form-control" readonly placeholder="<%=GetLabel("lblPlaceholderNew", Lang)%>"/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="created"><%=GetLabel("lblDate", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="date" id="created" name="created" class="form-control" readonly value="<%=DBFormatDate(Date)%>"/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="isid">ISID:</label>
                                <div class="col-sm-10">
                                    <select name="isid" id="isid" class="search-drowdown form-control" style="width: 100%; height: 30px" required>
                                        <option value="" disabled selected>-- Auswahl ISID ----------------------</option>
                                        <% For Each vwItem In vwUserList.Items %>
                                            <option value="<%=vwItem.ISID%>"><%=vwItem.DisplayName & "(" & UCase(vwItem.ISID) & ")"%></option>
                                        <% Next %>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="department"><%=GetLabel("lblDepartment", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <input type="hidden" id="departmentid" name="departmentid"/>
                                    <input type="text" id="department" name="department" class="form-control" readonly/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="stateid"><%=GetLabel("lblRequestState", Lang)%></label>
                                <div class="col-sm-10">
                                    <select name="stateid" id="stateid" class="form-control search-drowdown" style="width: 100%;" required disabled>
                                        <% For Each vwItem In vwStateList.Items %>
                                            <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="description"><%=GetLabel("lblDescription", Lang)%>:</label>
                                <div class="col-sm-10">
                                    <textarea id="description" name="description" class="form-control" rows="3"/></textarea>
                                </div>
                            </div>

                        </div>
                        <div class="tab-pane fade" id="detail" role="tabpanel" aria-labelledby="detail-tab">
                             <div class="form-group row">
                                <label class="col-sm-2 col-form-label" for="accesstypeid"><%=GetLabel("lblAccessRights", Lang)%></label>
                            </div>
                            <div class="table-responsive mt-3">
                                <table id="dtlist" name="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th style="display:none">ItemID</th>
                                            <th style="display:none">ItemRightID</th>
                                            <th>&nbsp;</th>
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
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <input type="submit" style="display:none;"/>
                        <button type="submit" class="btn btn-cyan sendbtn" id="sendbtn"><div id="showspinner"></div>&nbsp;<i class="<%=cRequestTypeRevokeIcon%>"></i>&nbsp;<%=GetLabel("btnSubmit", Lang)%></button>&nbsp;
                        <button type="button" class="btn btn-primary" id="btnlogout"><%=GetLabel("btnBack", Lang)%></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>
<!--Section -->
<!-- javascript -->
<script src="<%=curRootFile%>/_js/request/revokeform.js?v1.0"></script>