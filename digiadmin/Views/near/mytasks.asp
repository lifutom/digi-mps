<%
   Dim vwList : Set vwList = ViewData("list")
   Dim ListItem

   Dim vwTaskTypList : Set vwTaskTypList = ViewData("tasktyp")
   Dim vwTaskStateList : Set vwTaskStateList = ViewData("taskstate")
   Dim vwDDItem

%>

<!-- Modal Edit Location Form -->
<div class="modal fade" id="edittask" tabindex="-1" role="dialog" aria-labelledby="EditTask" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-eye"></i>&nbsp;&nbsp;Task</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="form" name="form" method="POST" action="<%=CurRootFile%>/near/editmytaskspost">
                    <input id="nearid" name="nearid" type="hidden" value="-1">
                    <input id="taskid" name="taskid" type="hidden" value="-1">
                    <input id="assignedto" name="assignedto" type="hidden" value="<%=Session("login")%>">
                    <div class="form-group">
                        <label for="tasknb">Task-Nb</label>
                        <input class="form-control" id="tasknb" name="tasknb" type="text" disabled/>
                    </div>
                    <div class="form-group">
                        <label for="tasktypeid">Tasktyp</label>
                        <select id="tasktypeid" name="tasktypeid" class="browser-default custom-select" required>
                            <% For Each vwDDItem In vwTaskTypList.Items %>
                                <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                            <% Next %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="duedate">fällig am</label>
                        <input class="form-control" id="duedate" name="duedate" type="date" required/>
                    </div>
                    <div class="form-group">
                        <label for="state">Status</label>
                        <select id=state" name="state" class="browser-default custom-select" required>
                            <% For Each vwDDItem In vwTaskStateList.Items %>
                                <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                            <% Next %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="">Bezeichnung</label>
                        <input class="form-control" id="description" name="description" required/>
                    </div>

                    <div class="form-group">
                        <label for="comments">Beschreibung</label>
                        <textarea class="form-control rounded-0" id="comments" name="comments" rows="5" required></textarea>
                    </div>

                    <div class="modal-footer d-flex justify-content-center">
                        <button type="submit" class="btn btn-cyan sendbtn" id="sendbtn">Speichern</button>
                        <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Location Form -->


<!--Section: Table Groups-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-eye"></i>&nbsp;meine zugeordneten Tasks&nbsp;(<%=DBFormatDateTime(Now)%>)</a>
            <div class="float-right">
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/near/mytasks" title="Refresh"><i class="fas fa-sync"></i></a>
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
                            <th style="display:none">TaskID</th>
                            <th style="display:none">NearID</th>
                            <th style="display:none">TaskTypeID</th>
                            <th style="display:none">State</th>
                            <th class="th-sm">Nummer</th>
                            <th class="th-sm">Typ</th>   
                            <th class="th-sm">Task</th>
                            <th class="th-sm">Erstellt am</th>
                            <th class="th-sm">von</th>
                            <th class="th-sm">NM-Nummer</th>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">Fällig am</th>
                            <th class="th-sm">letzte &Auml;nderung am</th>
                            <th class="th-sm">von</th>
                            <th style="display:none">Comments</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each ListItem In vwList.Items %>
                            <tr>
                                <td style="display:none"><%=ListItem.TaskID%></td>
                                <td style="display:none"><%=ListItem.NearID%></td>
                                <td style="display:none"><%=ListItem.TaskTypeID%></td>
                                <td style="display:none"><%=ListItem.State%></td>
                                <td><%=ListItem.TaskNb%></td>
                                <td><%=ListItem.TaskType%></td>
                                <td><%=ListItem.Description%></td>
                                <td><%=DBFormatDate(ListItem.Created)%></td>
                                <td><%=ListItem.CreatedBy%></td>
                                <td><a class="text-primary" href="javascript:viewnearMiss(<%=ListItem.NearID%>);" alt="<%=ListItem.NearNb%>" title="<%=ListItem.NearNb%>"><%=ListItem.NearNb%></a></td>
                                <td><%=ListItem.StateText%></td>
                                <td><%=DBFormatDate(ListItem.DueDate)%></td>
                                <td><%=DBFormatDateTime(ListItem.LastEdit)%></td>
                                <td><%=ListItem.UserID%></td>
                                <td style="display:none"><%=ListItem.Comments%></td>
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

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/near/mytasks.js?v1.1"></script>
