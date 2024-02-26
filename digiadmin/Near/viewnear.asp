<%

    Dim vwItem : Set vwItem = ViewData("near")

    Dim vwTypList : Set vwTypList = ViewData("typ")
    Dim vwTaskTypList : Set vwTaskTypList = ViewData("tasktyp")
    Dim vwTaskStateList : Set vwTaskStateList = ViewData("taskstate")
    Dim vwTarget0List : Set vwTarget0List = ViewData("target0list")
    Dim vwSPVList : Set vwSPVList =  ViewData("svplist")
    Dim vwUserList : Set vwUserList =  ViewData("userlist")
    Dim vwRoomList : Set vwRoomList =  ViewData("roomlist")
    Dim vwFolder : Set vwFolder = ViewData("folder")
    Dim vwHasAnalyse : vwHasAnalyse = ViewData("hasanalyse")
    Dim vwHasTarget0 : vwHasTarget0 = ViewData("hastarget0")
    Dim vwDDItem
    Dim vwFile

    Dim Is5why  : Is5why = False
    Dim IsFishbone  : IsFishbone = False

    Dim File5why  : File5why = ""
    Dim FileFishbone : FileFishbone = ""

    If Not vwFolder Is Nothing Then
        For Each vwFile In vwFolder.Files
            If Left(LCase(vwFile.Name),5) = "5-why"  Then
                Is5why = True
                File5why = vwFile.Name
            End If
            If Left(LCase(vwFile.Name),9) = "fish-bone" Then
                IsFishbone = True
                FileFishbone = vwFile.Name
            End If
        Next
    End If

    Dim vwListItem

%>
<style>
    .img-max {
    max-width: 300px;
    width:100%;
}
</style>
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
                <form id="form" name="form" method="POST">
                    <div class="form-group">
                        <label for="tasknb">Task-Nb</label>
                        <input class="form-control" id="tasknb" name="tasknb" type="text" disabled/>
                    </div>
                    <div class="form-group">
                        <label for="tasktypeid">Tasktyp</label>
                        <select id="tasktypeid" name="tasktypeid" class="browser-default custom-select" disabled>
                            <% For Each vwDDItem In vwTaskTypList.Items %>
                                <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                            <% Next %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="duedate">fällig am</label>
                        <input class="form-control" id="duedate" name="duedate" type="date" disabled/>
                    </div>
                    <div class="form-group">
                        <label for="state">Status</label>
                        <select id="state" name="state" class="browser-default custom-select" disabled>
                            <% For Each vwDDItem In vwTaskStateList.Items %>
                                <option value="<%=vwDDItem.Value%>"><%=vwDDItem.Name%></option>
                            <% Next %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="assignedto">SPV/Coach</label>
                        <select style="height: 30px;" name="assignedto" id="assignedto" class="browser-default" disabled>
                            <% For Each vwDDItem In vwSPVList.Items %>
                                <option value="<%=vwDDItem.Value%>" <%=vwDDItem.Disabled%>><%=vwDDItem.Name%></option>
                            <% Next %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="">Bezeichnung</label>
                        <input class="form-control" id="description" name="description" disabled/>
                    </div>

                    <div class="form-group">
                        <label for="comments">Beschreibung</label>
                        <textarea class="form-control rounded-0" id="comments" name="comments" rows="5" disabled></textarea>
                    </div>

                    <div class="modal-footer d-flex justify-content-center">
                        <button class="btn btn-danger" data-dismiss="modal">Schließen</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Location Form -->


<section class="mb-5">

<form name="nearform" id="nearform" method="POST" action="<%=CurRootFile%>/near/editpost?partial=yes">
    <input name="nearid" id="nearid" type="hidden" value="<%=vwItem.NearID%>" />
    <input name="acttab" id="acttab" type="hidden" value="<%=CurRootFile & "/near/edit/?partial=yes&id=" & vwItem.NearID & "&idx=0#" & ActiveTab%>" />
    <input name="activetab" id="activetab" type="hidden" value="<%=ActiveTab%>" />
    <input name="todo" id="todo" type="hidden" value="<%=IIf(ViewData("todo")="","save",ViewData("todo"))%>" />
    <input name="queue" id="queue" type="hidden" value="<%=vwItem.Queue%>" />
    <div style="display:none">
        <input type="submit" id="send" name="send" />
    </div>
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header cyan mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-eye"></i>&nbsp;<%=vwItem.TypName%>&nbsp;<%=vwItem.NearNb &  " vom " & DBFormatDate(vwItem.NearDate) & " " & vwItem.NearTime %></a>
            <div class="float-right">
                <a class="white-text" href="javascript: refresh_data();"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--Card content-->
        <div class="card-footer">
                <div style="float: left;" class="mr-3">
                    <div class="form-group inline">
                        <button class="btn-sm btn-default" name="cmdCancel" type="button" onclick="window.close();">Schließen</button>
                        <div class="form-check">
                            <br>
                            <input type="checkbox" class="form-check-input" id="svpclosed" name="svpclosed" <%=IIf(vwItem.SVPClosed=1,"checked","")%> disabled>
                            <label class="form-check-label" for="svpclosed">Meldung durch SVP erledigt</label>
                        </div>
                    </div>
                </div>
        </div>
        <div class="card-body">

            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link  <%=IIf(ActiveTab = "home","active","")%>" id="home-tab" data-toggle="tab" href="#home" role="tab" aria-controls="home"
                        aria-selected="true">Ersterfassung</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%=IIf(ActiveTab = "rating","active","")%>" id="rating-tab" data-toggle="tab" href="#rating" role="tab" aria-controls="rating"
                        aria-selected="false"><span class="<%=IIf(vwItem.IsRated,"text-success","text-danger")%>">Bewertung</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%=IIf(ActiveTab = "tasks","active","")%>" id="task-tab" data-toggle="tab" href="#tasks" role="tab" aria-controls="tasks"
                        aria-selected="false"><span class="<%=IIf(vwItem.TaskOpen=0,"text-success","text-danger")%>">Tasks(<%=vwItem.TaskOpen%>/<%=vwItem.TaskCount%>)</span></a>
                </li>

                <li id="cause" class="nav-item">
                    <a class="nav-link <%=IIf(ActiveTab = "analyze","active","")%>" id="analyze-tab" data-toggle="tab" href="#analyze" role="tab" aria-controls="analyze"
                        aria-selected="false"><span class="<%=IIf(vwHasAnalyse,"text-success","text-danger")%>">Ursachenanalyse</span></a>
                </li>
                <li id="target" class="nav-item">
                    <a class="nav-link <%=IIf(ActiveTab = "target0","active","")%>" id="target0-tab" data-toggle="tab" href="#target0" role="tab" aria-controls="target0"
                        aria-selected="false"><span class="<%=IIf(vwHasTarget0,"text-success","text-danger")%>">Target-0</span></a>
                </li>
                <% If vwItem.Queue = "ehs"  Then %>
                    <li class="nav-item">
                        <a class="nav-link <%=IIf(ActiveTab = "tasks","active","")%>" id="ehs-tab" data-toggle="tab" href="#ehs" role="tab" aria-controls="ehs"
                            aria-selected="false">EHS-Bewertung</a>
                    </li>
                <% End If %>
            </ul>
            <div class="tab-content" id="myTabContent">
                <div class="tab-pane fade <%=IIf(ActiveTab = "home","show active","")%>" id="home" role="tabpanel" aria-labelledby="home-tab">
                    <div class="col-12">
                        <div class="row">
                            <div class="form-group mr-3">
                                <label for="createdby">Melder:</label>
                                <input type="hidden" name="createdby" id="createdby" value="<%=vwItem.CreatedBy%>" />
                                <select name="createdby" id="createdby" class="search-drowdown form-control" required disabled>
                                    <% For Each vwDDItem In vwUserList.Items
                                        %><option value="<%=vwDDItem.Value%>" <%=IIf(vwDDItem.Value = vwItem.CreatedBy,"selected","")%>><%=vwDDItem.Name%></option><%
                                     Next %>
                                </select>
                            </div>
                            <div class="form-group mr-3">
                                <label for="">Raum:&nbsp;</label>
                                <select name="roomid" id="roomid" class="search-drowdown form-control"  disabled>
                                    <% For Each vwDDItem In vwRoomList.Items
                                        %><option value="<%=vwDDItem.Value%>" <%=IIf(CInt(vwDDItem.Value) = CInt(vwItem.RoomID),"selected","")%>><%=vwDDItem.Name%></option><%
                                     Next %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="assignedtospv">SVP/Coach:</label>
                                <select style="height: 30px;" name="assignedtospv" id="assignedtospv" class="search-drowdown form-control"  disabled>
                                    <% For Each vwDDItem In vwSPVList.Items %>
                                        <option value="<%=vwDDItem.Value%>" <%=IIf(UCASE(Trim(vwDDItem.Value)) = UCASE(Trim(vwItem.AssignedToSpv)),"selected","")%> <%=vwDDItem.Disabled%>><%=vwDDItem.Name%></option>
                                    <% Next %>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-4">
                                <div class="form-group">
                                     <label for="">Beschreibung</label>
                                     <textarea class="form-control rounded-0" id="description" name="description" rows="5"  disabled><%=vwItem.Description%></textarea>
                                </div>
                            </div>
                            <div class="col-6">
                                <% If  vwItem.VirtualPath <> "" Then %>
                                    <label for="">Foto:</label>
                                    <div class="img-max">
                                        <img src="<%=curRootFile & "/" & vwItem.VirtualPath%>" class="img-fluid" alt="<%=vwItem.NearNb%>"/>
                                    </div>
                                <% End If %>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-4">
                                <div class="form-group">
                                     <label for="">Sofortmassnahmen</label>
                                     <textarea class="form-control rounded-0" id="task" name="task" rows="5"  disabled><%=vwItem.Task%></textarea>
                                </div>
                            </div>
                            <div class="col-6 ">
                                <% If  vwItem.VirtualTaskPath <> "" Then %>
                                    <label for="">Foto:</label>
                                    <div class="img-max">
                                        <img src="<%=curRootFile & "/" & vwItem.VirtualTaskPath%>" class="img-fluid" alt="<%=vwItem.NearNb%>"/>
                                    </div>
                                <% End If %>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade <%=IIf(ActiveTab = "rating","show active","")%>" id="rating" role="tabpanel" aria-labelledby="rating-tab">

                    <div class="form-group mt-3">
                        <label>Klassifizierung:</label>
                        <% For Each vwDDItem In vwTypList.Items %>
                            <div class="form-check form-check-inline">
                                <input type="radio" class="form-check-input" id="typ_<%=vwDDItem.Value%>" name="typ" value="<%=vwDDItem.Value%>" <%=IIf(vwItem.Typ=vwDDItem.Value,"checked","")%>  disabled>
                                <label class="form-check-label" for="typ_<%=vwDDItem.Value%>"><%=vwDDItem.Name%></label>
                            </div>
                        <% Next %>
                        &nbsp;&nbsp;
                        <label for="duedate">Fällig am:</label>
                        <input type="date" id="nmduedate" name="nmduedate" value="<%=DBFormatDate(vwItem.DueDate)%>"  disabled />
                        &nbsp;&nbsp;
                        <div class="form-check form-check-inline">
                                <input type="checkbox" class="form-check-input" id="istarget0" name="istarget0" value="1" <%=IIf(vwItem.IsTarget0=1,"checked","")%>  disabled>
                                <label class="form-check-label" for="istarget0">Target-0</label>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-6">
                            <div class="form-group">
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="falling" name="falling" <%=IIf(vwItem.Falling=1,"checked","")%>  disabled>
                                    <label class="form-check-label" for="falling">Sturz/Fall</label>
                                </div>
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="rotatingparts" name="rotatingparts" <%=IIf(vwItem.RotatingParts=1,"checked","")%>  disabled>
                                    <label class="form-check-label" for="rotatingparts">bewegende/rotierenden Teile<br><small>(herabfallende, umfallende Gegenstände...)</small></label>
                                </div>
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="squeezedang" name="squeezedang" <%=IIf(vwItem.SqueezeDang=1,"checked","")%> disabled>
                                    <label class="form-check-label" for="squeezedang">Quetschgefahr</label>
                                </div>
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="cutdang" name="cutdang" <%=IIf(vwItem.CutDang=1,"checked","")%> disabled>
                                    <label class="form-check-label" for="cutdang">Schnittgefahr</label>
                                </div>
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="pushdang" name="pushdang" <%=IIf(vwItem.PushDang=1,"checked","")%> disabled>
                                    <label class="form-check-label" for="pushdang">Anstoßgefahr</label>
                                </div>
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="hotdang" name="hotdang" <%=IIf(vwItem.HotDang=1,"checked","")%> disabled>
                                    <label class="form-check-label" for="hotdang">heiße oder kalte Oberfläche</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                           <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="fireprotect" name="fireprotect" <%=IIf(vwItem.FireProtect=1,"checked","")%> disabled>
                                <label class="form-check-label" for="fireprotect">Brandschutz<br><small>(Fluchtwege, Brandgefahr, Branschutzeinrichtungen betreffend)</small></label>
                            </div>
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="danggoods" name="danggoods" <%=IIf(vwItem.DangGoods=1,"checked","")%> disabled>
                                <label class="form-check-label" for="danggoods">Gefahrstoffe</label>
                            </div>
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="power" name="power" <%=IIf(vwItem.Power=1,"checked","")%> disabled>
                                <label class="form-check-label" for="power">Elektrizität</label>
                            </div>
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="other" name="other" <%=IIf(vwItem.other=1,"checked","")%> disabled>
                                <label class="form-check-label" for="other">Sonstiges(z.B. Ergonomie)</label>
                                <div class="othertxt" style="<%=IIf(vwItem.other=1,"","display:none;")%>" class="otherbox">
                                     <input type="text" class="form-control" id="othertext" name="othertext" size="15" value="<%=vwItem.OtherText%>" disabled>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Kommentar</label>
                        <textarea class="form-control rounded-0" id="ratingcomment" name="ratingcomment" rows="5" disabled><%=vwItem.RatingComment%></textarea>
                    </div>
                </div>
                <div class="tab-pane fade <%=IIf(ActiveTab = "tasks","show active","")%>" id="tasks" role="tabpanel" aria-labelledby="tasks-tab">
                     <div class="table-responsive">
                        <table id="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <th style="display:none">TaskID</th>
                                    <th style="display:none">TaskTypeID</th>
                                    <th style="display:none">State</th>
                                    <th class="th-sm">Status</th>
                                    <th class="th-sm">Nummer</th>
                                    <th class="th-sm">Task</th>
                                    <th class="th-sm">Erstellt am</th>
                                    <th class="th-sm">Assigned</th>
                                    <th class="th-sm">Fällig am</th>
                                    <th class="th-sm">letzte &Auml;nderung am</th>
                                    <th class="th-sm">von</th>
                                    <th style="display:none">Comment</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% For Each vwListItem In vwItem.Tasks.Items %>
                                    <tr>
                                        <td style="display:none"><%=vwListItem.TaskID%></td>
                                        <td style="display:none"><%=vwListItem.TaskTypeID%></td>
                                        <td style="display:none"><%=vwListItem.State%></td>
                                        <td><%=vwListItem.StateText%></td>
                                        <td><%=vwListItem.TaskNb%></td>
                                        <td><%=vwListItem.Description%></td>
                                        <td><%=DBFormatDate(vwListItem.Created)%></td>
                                        <td><%=vwListItem.AssignedTo%></td>
                                        <td><%=DBFormatDate(vwListItem.DueDate)%></td>
                                        <td><%=DBFormatDateTime(vwListItem.LastEdit)%></td>
                                        <td><%=vwListItem.UserID%></td>
                                        <td style="display:none"><%=vwListItem.Comments%></td>
                                    </tr>
                                <% Next %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="tab-pane fade <%=IIf(ActiveTab = "analyze","show active","")%>" id="analyze" role="tabpanel" aria-labelledby="analyze-tab">
                        <div class="row">
                            <div class="col-7">
                                <div class="form-group mt-3">
                                    <p style="font-size: 8pt;">
                                        SN 06: Vorfalluntersuchung, - management
                                        <h6><b>5. Untersuchung von Vorfällen</b></h6>
                                        <span style="font-size: 8pt;">
                                            Der Vorfall ist so bald als möglich nach der Meldung jedenfalls innerhalb von 24 Stunden zu bearbeiten.
                                            Art und Umfang der Untersuchung richten sich nach der festgestellten oder potenziellen Schwere des Vorfalls.<br>

                                            Befolgen Sie bei der Untersuchung von Vorfällen/Beinaheunfällen die nachstehenden Schritte:<br>
                                            <ul>
                                                <li>Festlegen eines Untersuchungsteam – meistens Coach, EHS, Mitarbeiter, bei Bedarf GF, Ersthelfer, SVP, BSB </li>
                                                <li>Erfassen relevanter Daten (Unfallort, Zeitpunkt, MA Befragungen, Fotos, Prüfungsunterlagen)</li>
                                                <li>Ermitteln der Ursachenfaktoren und Festlegung von Maßnahmen zu jeder festgestellten Ursache</li>
                                                <li>Korrekturmaßnahmen müssen unverzüglich ergriffen werden bei unmittelbarer Gefahr für die Mitarbeiter oder die Umwelt.</li>
                                                <li>Erstellen einer Dokumentation</li>
                                            </ul>
                                        </span>
                                    </p>
                                </div>
                                <div class="row">
                                    <div class="col-6 text-center">
                                        <% If Is5why Then %>
                                            <div class="row">
                                                <div class="col-8">
                                                    <a href="<%=CurRootFile & "/nearimages/" & vwItem.NearID & "/" & File5why%>" class="btn-sm btn-primary text-center btn-block" target="_blank"><i class="fas fa-cloud-download-alt"></i>&nbsp;Download 5-Why Analyse</a>
                                                </div>
                                            </div>
                                        <% End If %>
                                    </div>
                                </div>
                                <div class="row mt-2">
                                    <div class="col-6 text-center">
                                        <% If IsFishbone Then %>
                                            <div class="row">
                                                <div class="col-8">
                                                    <a href="<%=CurRootFile & "/nearimages/" & vwItem.NearID & "/" & FileFishbone%>" class="btn-sm btn-primary text-center btn-block" target="_blank"><i class="fas fa-cloud-download-alt"></i>&nbsp;Download Fishbone Analyse</a>
                                                </div>
                                            </div>
                                        <% End If %>
                                    </div>
                                </div>
                                <div class="row mt-2">
                                    <div class="table-responsive mt-2">
                                        <table id="dtlist" class="table table-striped table-bordered table-sm table-hover" cellspacing="0" width="100%">
                                        <thead>
                                            <tr>
                                                <th class="th-sm">Filename</th>
                                                <th class="th-sm">Type</th>
                                                <th class="th-sm">Size</th>
                                                <th class="th-sm">Datum</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%  If Not vwFolder Is Nothing Then
                                                    For Each vwFile In vwFolder.Files
                                                        If Left(LCase(vwFile.Name),5) <> "5-why" And Left(LCase(vwFile.Name),9) <> "fish-bone" Then
                                                        %>
                                                             <tr>
                                                                <td><a href="<%=CurRootFile & "/nearimages/" & vwItem.NearID & "/" & vwFile.Name%>" target="_blank"><i class="fas fa-cloud-download-alt"></i></a>&nbsp;<%=vwFile.Name%></td>
                                                                <td><%=vwFile.Type%></td>
                                                                <td align="right"><%=FormatNumber(vwFile.Size,0)%></td>
                                                                <td><%=DBFormatDateTime(vwFile.DateLastModified)%></td>
                                                            </tr>
                                                        <%
                                                        End If
                                                    Next
                                                End If
                                            %>
                                        </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="col-5">
                                <div class="form-group">
                                    <label for="">Ursache</label>
                                    <textarea class="form-control rounded-0" id="causecomment" name="causecomment" rows="5" disabled><%=vwItem.CauseComment%></textarea>
                                </div>
                            </div>
                        </div>
                </div>
                <div class="tab-pane fade <%=IIf(ActiveTab = "target0","show active","")%>" id="target0" role="tabpanel" aria-labelledby="target0-tab">
                    <div class="form-group">
                        <label>Risiko-Level:</label>
                        <% For Each vwDDItem In vwTarget0List.Items %>
                            <div class="form-check form-check-inline">
                                <input type="radio" class="form-check-input" id="target0risk_<%=vwDDItem.Value%>" name="target0risk" value="<%=vwDDItem.Value%>" <%=IIf(CInt(vwItem.RiskLevel)=CInt(vwDDItem.Value),"checked","")%>  disabled>
                                <label style="background-color: <%=vwDDItem.IconClass%>"  class="form-check-label" for="target0risk_<%=vwDDItem.Value%>"><%=vwDDItem.Name%>&nbsp;&nbsp;</label>
                            </div>
                        <% Next %>
                    </div>

                    <div class="card-deck">
                        <% For Each vwDDItem In vwItem.CategorieList.Items
                            If vwDDItem.Value < 6 Then
                                %> <div class="card">

                                    <div class="card-body text-center">
                                        <div class="form-check form-check-inline">
                                            <input type="checkbox" class="form-check-input" id="target0rate_<%=vwDDItem.Value%>" name="target0rate_<%=vwDDItem.Value%>" value="<%=vwDDItem.Value%>" <%=IIf(vwDDItem.Active=1,"checked","")%>  disabled>
                                            <label style="font-size: 10pt;" class="form-check-label" for="target0rate_<%=vwDDItem.Value%>"><%=vwDDItem.Name%></label>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                         <img style="height: 50px; width: 50px;" class="card-img-bottom" src="<%=CurRootFile & "/images/" & vwDDitem.IconClass%>" alt="<%=vwDDItem.Name%>" title="<%=vwDDItem.Name%>">
                                    </div>

                                </div><%
                            End If
                         Next %>
                    </div>
                    <div class="card-deck mt-2">
                        <% For Each vwDDItem In vwItem.CategorieList.Items
                            If vwDDItem.Value > 5 Then %>
                                <div class="card">
                                    <div class="card-body text-center">
                                        <div class="form-check form-check-inline">
                                            <input type="checkbox" class="form-check-input" id="target0rate_<%=vwDDItem.Value%>" name="target0rate_<%=vwDDItem.Value%>" value="<%=vwDDItem.Value%>" <%=IIf(vwDDItem.Active=1,"checked","")%>  disabled>
                                            <label style="font-size: 10pt;" class="form-check-label" for="target0rate_<%=vwDDItem.Value%>"><%=vwDDItem.Name%></label>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                        <img style="height: 50px; width: 50px;" class="card-img-bottom" src="<%=CurRootFile & "/images/" & vwDDitem.IconClass%>" alt="<%=vwDDItem.Name%>" title="<%=vwDDItem.Name%>">
                                    </div>
                                </div>

                            <%
                            End If
                        Next %>
                    </div>
                    <div class="mt-3">
                        <div class="form-check form-check-inline">
                            <input type="checkbox" class="form-check-input" id="cont2work" name="cont2work" value="1" <%=IIf(CInt(vwItem.Cont2Work)=1,"checked","")%>  disabled>
                            <label class="form-check-label" for="cont2work">Produktions-/Gerätestop erforderlich</label>
                        </div>
                    </div>
                    <div class="mt-3">
                        <div class="form-check form-check-inline">
                            <input type="checkbox" class="form-check-input" id="solveimm" name="solveimm" value="1" <%=IIf(vwItem.SolveImm=1,"checked","")%>  disabled>
                            <label class="form-check-label" for="solveimm">Sofort behoben</label>
                        </div>
                    </div>

                </div>
                <% If vwItem.Queue = "ehs"  Then %>
                    <div class="tab-pane fade <%=IIf(ActiveTab = "ehs","show active","")%>" id="ehs" role="tabpanel" aria-labelledby="ehs-tab">
                        <div class="row">
                            <div class="col-6">
                                <div class="form-group">
                                    <label for="">Melder:</label>
                                    <input class="form-control rounded-0" id="description" name="description" value="<%=vwItem.CreatedBy%>" disabled>
                                    <label for="">Raum:</label>
                                    <input class="form-control rounded-0" id="room" name="room" value="<%=vwItem.RoomNb & " " & vwItem.Room%>" disabled>
                                </div>
                                <div class="form-group">
                                     <label for="">Abschluss-Bewertung</label>
                                     <textarea class="form-control rounded-0" id="ehsrating" name="ehsrating" rows="5"  disabled><%=vwItem.EHSRating%></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                <% End If %>
            </div>
        </div>
    </div>
</form>
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/near/editnear.js?v=1.1"></script>