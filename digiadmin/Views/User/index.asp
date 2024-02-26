<%
   Dim vwList : Set vwList = ViewData("list")
   Dim vwDDList : Set  vwDDList = ViewData("ddgrouplist")
   Dim vwDDDepartments : Set  vwDDDepartments = ViewData("dddepartmentlist")
   Dim ListItem
   Dim DDItem
%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditUser" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;User</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="userform" action="javascript:save_data();">
                    <input id="active" name="active" type="hidden" required value="0">
                    <input id="defvalue" name="defvalue" type="hidden" required value="">
                    <div class="md-form mb-2">
                         <input id="userid" name="userid" type="text" size="12" maxlength="10" required value="" placeholder="User">
                    </div>
                    <div class="md-form mb-2">
                        <select id="departmentid" name="departmentid" class="browser-default custom-select">
                            <option selected disabled>W&auml;hlen Sie die Abteilung aus</option>
                            <%

                                For Each DDItem In vwDDDepartments.Items

                                        %><option value="<%=DDItem.Value%>"><%=DDItem.Name%></option><%

                                Next

                            %>
                        </select>
                    </div>
                    <div class="md-form mb-2">
                        <select id="groupid" name="groupid" class="browser-default custom-select" size="10" multiple>
                            <option selected disabled>W&auml;hlen Sie die Gruppe aus</option>
                            <%

                                For Each DDItem In vwDDList.Items

                                    %><option value="<%=DDItem.GroupID%>"><%=DDItem.Group%></option><%

                                Next

                            %>
                        </select>
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
<!--Section: Table User-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Userliste</a>
            <div class="float-right">
                 <!--button id="updatebtn" class="btn btn-sm btn-cyan" title="Userdaten aus AD aktualisieren" alt="Userdaten aus AD aktualisieren"><i class="fas fa-sync"></i></button-->&nbsp;
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="User hinzuf&uuml;gen" alt="User hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
            </div>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtuserlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">Active</th>
                            <th style="display:none">GroupID</th>
                            <th style="display:none">DepartmentID</th>
                            <th class="th-sm">User</th>
                            <th style="display:none">Gruppe</th>
                            <th class="th-sm">Abteilung</th>
                            <th class="th-sm">Stream</th>
                            <th class="th-sm">Bereich</th>
                            <th class="th-sm">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each ListItem In vwList.Items %>
                            <tr>
                                <td style="display:none"><%=ListItem.Active%></td>
                                <td style="display:none"><%=ListItem.GroupValues%></td>
                                <td style="display:none"><%=ListItem.DepartmentID%></td>
                                <td><%=ListItem.UserID%></td>
                                <td style="display:none"><%=ListItem.Group%></td>
                                <td><%=ListItem.Department%></td>
                                <td><%=ListItem.StreamType%></td>
                                <td><%=ListItem.Area%></td>
                                <% If ListItem.UserID = SysAdm Then %>
                                   <td></td>
                                <% Else %>
                                   <td><a href="javascript:toggleitem('<%=ListItem.UserID%>');"><%=IIf(ListItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a></td>
                                <% End If %>
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
<script src="<%=curRootFile%>/js/pages/user/index.1.0.js?v1.2"></script>
