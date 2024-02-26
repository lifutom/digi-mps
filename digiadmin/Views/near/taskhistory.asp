<%
   Dim vwList : Set vwList = ViewData("list")
   Dim ListItem

   Dim vwTaskTypList : Set vwTaskTypList = ViewData("tasktyp")
   Dim vwTaskStateList : Set vwTaskStateList = ViewData("taskstate")
   Dim vwUserList : Set vwUserList = ViewData("userlist")
   Dim vwDDItem

   Dim vwOpenTasks : vwOpenTasks = ViewData("opentasks")
   Dim vwClosedTasks : vwClosedTasks = ViewData("closedtasks")

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
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="tasknb">Task-Nb</label>
                        <div class="col-sm-9">
                            <input class="form-control" id="tasknb" name="tasknb" type="text" disabled/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="tasktypeid">Tasktyp</label>
                        <div class="col-sm-9">
                            <select id="tasktypeid" name="tasktypeid" class="browser-default custom-select" disabled>
                                <% For Each vwDDItem In vwTaskTypList.Items %>
                                    <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="tassignedto">Zugeteilt an</label>
                        <div class="col-sm-9">
                            <select id="tassignedto" name="tassignedto" class="browser-default custom-select" disabled>
                                <% For Each vwDDItem In vwUserList.Items %>
                                    <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group  row">
                        <label class="col-sm-3 col-form-label" for="created">Erstellt am</label>
                        <div class="col-sm-9">
                            <input class="form-control" id="created" name="created" type="date" disabled/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="duedate">f‰llig am</label>
                        <div class="col-sm-9">
                            <input class="form-control" id="duedate" name="duedate" type="date" disabled/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="rstate">Status</label>
                        <div class="col-sm-9">
                            <select id="rstate" name="rstate" class="browser-default custom-select" disabled>
                                <% For Each vwDDItem In vwTaskStateList.Items %>
                                    <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="description">Bezeichnung</label>
                        <div class="col-sm-9">
                            <input class="form-control" id="description" name="description" disabled/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="comments">Beschreibung</label>
                        <div class="col-sm-9">
                            <textarea class="form-control rounded-0" id="comments" name="comments" rows="5" disabled></textarea>
                        </div>
                    </div>

                    <div class="modal-footer d-flex justify-content-center">
                        <button class="btn btn-danger" data-dismiss="modal">Schlieﬂen</button>
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
            <a href="" class="white-text text-center mx-3"><i class="fas fa-eye"></i>&nbsp;Task suchen&nbsp;(<%=DBFormatDateTime(Now)%>)&nbsp;&nbsp;&nbsp;Offen:&nbsp;<%=OpenTasks%>&nbsp;&nbsp;Geschlossen:&nbsp;<%=ClosedTasks%></a>
            <div class="float-right">
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/near/mytasks" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->
        <div class="card-body">
            <form class="form" id="searchform" name="searchform" method="post" action="<%=curRootFile%>/near/taskhistorypost">
            <div class="row">
                <div class="col-5">
                    <div class="form-group row">
                        <label for="typ" class="col-sm-3 col-form-label">Typ:</label>
                        <div class="col-sm-9">
                            <select id="typ" name="typ" class="browser-default custom-select">
                                <option value="-1">--Alle--</option>
                                <% For Each vwDDItem In vwTaskTypList.Items

                                    %>

                                        <option value="<%=vwDDItem.Value%>" <%=IIf(CInt(vwDDItem.Value)=CInt(Session("tasktyp")), "SELECTED","")%>><%=vwDDItem.Name%></option>

                                    <%

                                 Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="tdatefrom" class="col-sm-3 col-form-label">Datum von:</label>
                        <div class="col-sm-9">
                            <input type="date" class="form-control" id="tdatefrom" name="tdatefrom" value="<%=Session("tdatefrom")%>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="tdateto" class="col-sm-3 col-form-label">Datum bis:</label>
                        <div class="col-sm-9">
                            <input type="date" class="form-control" id="tdateto" name="tdateto" value="<%=Session("tdateto")%>">
                        </div>
                    </div>
                </div>
                <div class="col-5">
                    <div class="form-group row">
                        <label for="assignedto" class="col-sm-3 col-form-label">User:</label>
                        <div class="col-sm-9">
                            <select id="assignedto" name="assignedto" class="browser-default custom-select">
                                <option value="">--Alle--</option>
                                <% For Each vwDDItem In vwUserList.Items %>
                                    <option value="<%=vwDDItem.Value%>" <%=IIf(vwDDItem.Value=Session("tassignedto"), "SELECTED","")%>><%=vwDDItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="tstate" class="col-sm-3 col-form-label">Status:</label>
                        <div class="col-sm-9">
                            <select id="tstate" name="tstate" class="browser-default custom-select">
                                <option value="-1">--Alle--</option>
                                <% For Each vwDDItem In vwTaskStateList.Items %>
                                        <option value="<%=vwDDItem.Value%>" <%=IIf(CInt(vwDDItem.Value)=CInt(Session("tstate")), "SELECTED","")%>><%=vwDDItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="ttasknb" class="col-sm-3 col-form-label">Task-Nr:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="ttasknb" name="ttasknb" value="<%=Session("tasknb")%>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="tnearnb" class="col-sm-3 col-form-label">Vorfall-Nr:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="nearnb" name="nearnb" value="<%=Session("tnearnb")%>">
                        </div>
                    </div>
                </div>
                <div class="col-2">
                    <button type="submit" class="btn btn-primary btn-block mb-2" id="cmdfilter" name="cmdfilter">Suchen</button>
                    <button type="button" class="btn btn-primary btn-block" id="cmdresetfilter" name="cmdresetfilter">Reset</button>
                </div>
            </div>
            </form>
        </div>

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
                            <th class="th-sm">Zugeteilt an</th>
                            <th class="th-sm">NM-Nummer</th>
                            <th class="th-sm">Status</th>
                            <th class="th-sm">F‰llig am</th>
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
                                <td><%=ListItem.AssignedTo%></td>
                                <td><a class="text-primary" href="javascript:viewnearMiss(<%=ListItem.NearID%>);" alt="<%=ListItem.NearNb%>" title="<%=ListItem.NearNb%>"><%=ListItem.NearNb%></a></td>
                                <td><%=ListItem.StateText%></td>
                                <td><%=DBFormatDate(ListItem.DueDate)%></td>
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
<script src="<%=curRootFile%>/js/pages/near/taskhistory.js?v1.1"></script>
