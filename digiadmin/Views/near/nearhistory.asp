<%
    Dim vwList : Set vwList = ViewData("list")
    Dim vwRegionList : Set vwRegionList = ViewData("regionlist")
    Dim vwBuildingList : Set vwBuildingList = ViewData("buildinglist")
    Dim vwRoomList : Set vwRoomList = ViewData("roomlist")

    Dim ListItem

    Dim vwTypList : Set vwTypList = New NearMissTyp
    Dim vwStateList : Set vwStateList = New NearMissState
    Dim vwSVPList : Set vwSVPList = ViewData("svplist")

    Dim vwOpen : vwOpen = ViewData("open")
    Dim vwClosed : vwClosed = ViewData("closed")



%>

<!--Section: Table Groups-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-eye"></i>&nbsp;Meldungen suchen&nbsp;(<%=DBFormatDateTime(Now)%>)&nbsp;&nbsp;&nbsp;Offen:&nbsp;<%=vwOpen%>&nbsp;&nbsp;Geschlossen:&nbsp;<%=vwClosed%></a>
            <div class="float-right">
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/near/nearhistory" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->

        <div class="card-body">
            <form class="form" id="searchform" name="searchform" method="post" action="<%=curRootFile%>/near/nearhistorypost">
            <div class="row">
                <div class="col-5">
                    <div class="form-group row">
                        <label for="typ" class="col-sm-3 col-form-label">Typ:</label>
                        <div class="col-sm-9">
                            <select id="typ" name="typ" class="browser-default custom-select">
                                <option value="-1">--Alle--</option>
                                <% For Each Item In vwTypList.List.Items

                                    %>

                                        <option value="<%=Item.Value%>" <%=IIf(CInt(Item.Value)=CInt(Session("neartyp")), "SELECTED","")%>><%=Item.Name%></option>

                                    <%

                                 Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="datefrom" class="col-sm-3 col-form-label">Datum von:</label>
                        <div class="col-sm-9">
                            <input type="date" class="form-control" id="datefrom" name="datefrom" value="<%=Session("datefrom")%>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="dateto" class="col-sm-3 col-form-label">Datum bis:</label>
                        <div class="col-sm-9">
                            <input type="date" class="form-control" id="dateto" name="dateto" value="<%=Session("dateto")%>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-sm-3 col-form-label">

                        </div>
                        <div class="col-sm-9">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="istarget0" name="istarget0" value="1" <%=IIf(Session("istarget0") = 1, "CHECKED", "")%>>
                                <label for="istarget0" class="form-check-label">nur Target-0</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-5">
                    <div class="form-group row">
                        <label for="assignedtosvp" class="col-sm-3 col-form-label">SVP:</label>
                        <div class="col-sm-9">
                            <select id="assignedtosvp" name="assignedtosvp" class="browser-default custom-select">
                                <option value="">--Alle--</option>
                                <% For Each Item In vwSVPList.Items
                                    %>

                                        <option value="<%=Item.Value%>" <%=IIf(Item.Value=Session("assignedtosvp"), "SELECTED","")%>><%=Item.Name%></option>

                                    <%
                                    Next
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="state" class="col-sm-3 col-form-label">Status:</label>
                        <div class="col-sm-9">
                            <select id="state" name="state" class="browser-default custom-select">
                                <option value="-1">--Alle--</option>
                                <% For Each Item In vwStateList.List.Items
                                    ''If Item.Value >= 3 Then
                                    %>

                                        <option value="<%=Item.Value%>" <%=IIf(CInt(Item.Value)=CInt(Session("state")), "SELECTED","")%>><%=Item.Name%></option>

                                    <%
                                    ''End If
                                Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="nearnb" class="col-sm-3 col-form-label">Vorfall-Nr:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="nearnb" name="nearnb" value="<%=Session("nearnb")%>">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="regionid" class="col-sm-3 col-form-label">Bereich:</label>
                        <div class="col-sm-9">
                            <select id="regionid" name="regionid" class="browser-default custom-select">
                                <option value="-1">--Alle--</option>
                                <% For Each Item In vwRegionList.Items %>
                                        <option value="<%=Item.Value%>" <%=IIf(CInt(Item.Value)=CInt(Session("regionid")), "SELECTED","")%>><%=Item.Name%></option>
                                <%  Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="roomid" class="col-sm-3 col-form-label">Gebäude:</label>
                        <div class="col-sm-9">
                            <select id="buildingid" name="buildingid" class="browser-default custom-select">
                                <option value="-1">--Alle--</option>
                                <% For Each Item In vwBuildingList.Items %>
                                        <option value="<%=Item.Value%>" <%=IIf(CInt(Item.Value)=CInt(Session("buildingid")), "SELECTED","")%>><%=Item.Name%></option>
                                <%  Next %>
                            </select>
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
                            <th style="display:none">NearID</th>
                            <th class="th-sm">Nummer</th>
                            <th class="th-sm">Typ</th>
                            <th class="th-sm">Erstellt am</th>
                            <th class="th-sm">SVP-Assigned</th>
                            <th class="th-sm">Datum</th>
                            <th class="th-sm">Zeit</th>
                            <th class="th-sm">Beschreibung</th>
                            <th class="th-sm">Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <%  Dim cssClass : cssClass = ""

                        For Each ListItem In vwList.Items
                             Select Case ListItem.Typ
                            Case 1
                                cssClass = "text-success"
                            Case 2
                                cssClass = "text-warning"
                            Case 3
                                cssClass = "text-danger"
                            End Select

                        %>
                            <tr>
                                <td style="display:none"><%=ListItem.NearID%></td>
                                <td class="<%=cssClass%>" nowrap>
                                    <% If ListItem.IsTarget0 = 1 Then %>
                                        <i class="fab fa-opera" title="Target-0"></i>&nbsp;
                                    <% End If %>
                                    <%=ListItem.NearNb%>
                                </td>
                                <td class="<%=cssClass%>"><%=ListItem.TypName%></td>
                                <td><%=DBFormatDate(ListItem.Created)%></td>
                                <td><%=ListItem.AssignedToSPV%></td>
                                <td><%=ListItem.NearDate%></td>
                                <td><%=ListItem.NearTime%></td>
                                <td><%=ListItem.Description%></td>
                                <td nowrap><%=ListItem.StateText%></td>
                                <td>
                                    <% If ListItem.IsTarget0 = 1 Then %>
                                        &nbsp;<a href="<%=curRootFile%>/report/printonepager?id=<%=ListItem.NearID%>" title="Drucken" target="_blank"><i style="font-size: 16px" class="fas fa-print"></i></a>
                                     <% End If %>
                                </td>
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
<script src="<%=curRootFile%>/js/pages/near/nearhistory.js?v1.2"></script>
