<%

    Dim vwPlantList : Set vwPlantList = ViewData("plant-list")
    Dim vwCatList : Set vwCatList = ViewData("cat-list")
    Dim vwItem
    Dim vwStandList : Set vwStandList = ViewData("stand-list")
    Dim vwStandItem : Set vwStandItem = ViewData("item")

    Dim vwDeviceList : Set vwDeviceList = vwStandItem.DeviceList
    Dim vwModuleList : Set vwModuleList = vwStandItem.ModuleList




%>

<!--Section: Table-->
<section class="mb-5">

    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-stopwatch"></i>&nbsp;<%=Application("title")%>&nbsp;<%=Date%>&nbsp;&nbsp;&nbsp;Login:<%=curUser%></a>
            <div class="float-right">
                 &nbsp;&nbsp;<button class="btn btn-sm btn-cyan" href="" id="refreshbtn" name="refreshbtn" title="Refresh"><i class="fas fa-sync"></i></button>
            </div>
        </div>

        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">
            <div class="form">
                <form id="appform" name="appform" method="post" action="<%=curRootFile%>/home/indexpost">
                    <input id="id" name="id" type="hidden" required value="<%=IIf(vwStandItem.ID="", -1, vwStandItem.ID)%>">
                    <input id="lasteditby" name="lasteditby" type="hidden" required value="<%=curUser%>">
                    <input id="created" name="created" type="hidden" required value="<%=Date%>">
                    <div class="col-12 text-right">

                            &nbsp;&nbsp;<button type="submit" class="btn btn-cyan" id="btnSave" >Senden</button>
                            &nbsp;&nbsp;<button type="button"  class="btn btn-danger" id="btnReset" name="btnReset">Neue Eingabe</button>
                            &nbsp;&nbsp;<button type="button"  class="btn btn-dark" id="btnLogout" name="btnLogout">Logout</button>

                    </div>
                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="plantid">Linie:</label>
                        <div class="col-10">
                            <select name="plantid" id="plantid" class="form-control form-control-inline search-drowdown" style="width: 30%;" required>
                                <option value="">-- Auswahl --</option>
                                <% For Each vwItem In vwPlantList.Items %>
                                    <option value="<%=vwItem.Value%>" <%=IIf(CLng(vwItem.Value)=CLng(vwStandItem.PlantID)," selected", "")%>><%=vwItem.Name%></option>
                                <% Next %>
                            </select>

                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="deviceid">Anlage:</label>
                        <div class="col-10">
                            <select name="deviceid" id="deviceid" class="form-control form-control-inline search-drowdown" style="width: 30%;" required>
                                <option value="">-- Auswahl --</option>
                                <% For Each vwItem In vwDeviceList.Items %>
                                    <option value="<%=vwItem.Value%>" <%=IIf(CLng(vwItem.Value)=CLng(vwStandItem.DeviceID)," selected", "")%>><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="moduleid">Baugruppe:</label>
                        <div class="col-10">
                            <select name="moduleid" id="moduleid" class="form-control form-control-inline search-drowdown" style="width: 30%;" required>
                                <option value="">-- Auswahl --</option>
                                <% For Each vwItem In vwModuleList.Items %>
                                    <option value="<%=vwItem.Value%>" <%=IIf(CLng(vwItem.Value)=CLng(vwStandItem.ModuleID)," selected", "")%>><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="categoryid">Kategorie:</label>
                        <div class="col-10">
                            <select name="categoryid" id="categoryid" class="form-control form-control-inline search-drowdown" style="width: 30%;" required>
                                <% For Each vwItem In vwCatList.Items %>
                                    <option value="<%=vwItem.Value%>" <%=IIf(CLng(vwItem.Value)=CLng(vwStandItem.CategoryID)," selected", "")%>><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="created">Start Stillstand:</label>
                        <div class="col-4">
                            <input type="datetime-local" id="startdate" name="startdate" class="form-control" required value="<%=DBFormatDateTime(vwStandItem.StartDate)%>"/>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="duration">Dauer Stunden:</label>
                        <div class="col-4">
                            <input type="number" id="durationhour" name="durationhour" class="form-control" placeholder="00" min=0 required value="<%=vwStandItem.DurationHour%>"/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="duration">Dauer Minuten:</label>
                        <div class="col-4">
                            <input type="number" id="durationmin" name="durationmin" class="form-control" placeholder="00" required min="0" max="59"value="<%=vwStandItem.DurationMin%>"/>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="description">Beschreibung:</label>
                        <div class="col-10">
                            <textarea id="description" name="description" class="form-control" rows="4" required/><%=vwStandItem.Description%></textarea>
                        </div>
                    </div>

                </form>

            </div>

            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">ID</th>
                            <th class="th-sm">Nr</th>
                            <th class="th-sm">Linie</th>
                            <th class="th-sm">Anlage</th>
                            <th class="th-sm">Baugruppe</th>
                            <th class="th-sm">Kategorie</th>
                            <th class="th-sm">Start</th>
                            <th class="th-sm">Dauer</th>
                            <th class="th-sm">Erstellt von</th>
                            <th class="th-sm">Beschreibung</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <% For Each vwItem In vwStandList.Items %>
                            <tr>
                                <td style="display:none"><%=vwItem.StandID%></td>
                                <td><%=vwItem.StandNb%></td>
                                <td><%=vwItem.Plant%></td>
                                <td><%=vwItem.Device%></td>
                                <td><%=vwItem.Module%></td>
                                <td><%=vwItem.Category%></td>
                                <td nowrap><%=vwItem.StartDate%></td>
                                <td><%=vwItem.Duration%></td>
                                <td><%=vwItem.CreatedBy%></td>
                                <td><%=vwItem.Description%></td>
                                <td nowrap><a href="javascript:editItem(<%=vwItem.StandID%>);"><i class="far fa-edit btnedit"></i></a>&nbsp;<a href="javascript:deleteItem(<%=vwItem.StandID%>);"><i class="fas fa-trash-alt btndel"></i></a></td>
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

<form id="appfill" name="appfill" method="post" action="<%=curRootFile%>/home/fillpost">
    <input type="hidden" id="fillid" name="fillid" value="-1"/>
</form>
<!-- javascript -->
<script src="<%=curRootFile%>/_js/home/index.js?v=1.0"></script>
