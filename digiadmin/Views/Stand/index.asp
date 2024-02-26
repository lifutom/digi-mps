<%

    Dim vwPlantList : Set vwPlantList = ViewData("plant-list")
    Dim vwCatList : Set vwCatList = ViewData("cat-list")
    Dim vwItem


%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog" style="max-width: 50%;">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-stopwatch"></i>&nbsp;&nbsp;Stillstands-Meldung&nbsp;<div id="reqtype"></div></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="appform">
                    <input id="id" name="id" type="hidden" required value="-1">
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="standnb">Nr:</label>
                        <div class="col-sm-10">
                            <input type="text" id="standnb" name="standnb" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="created">Datum:</label>
                        <div class="col-sm-10">
                            <input type="date" id="created" name="created" class="form-control" readonly/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="createdby">ISID:</label>
                        <div class="col-sm-10">
                            <input type="text" id="createdby" name="createdby" class="form-control" readonly/>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="plantid">Linie:</label>
                        <div class="col-sm-10">
                            <select name="plantid" id="plantid" class="form-control form-control-inline search-drowdown" style="width: 30%;" disabled>
                                <option value="">--Auswahl--</option>
                                <% For Each vwItem In vwPlantList.Items %>
                                    <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="deviceid">Anlage:</label>
                        <div class="col-sm-10">
                            <select name="deviceid" id="deviceid" class="form-control form-control-inline search-drowdown" style="width: 30%;" disabled>
                                <option value="">--Auswahl--</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="moduleid">Baugruppe:</label>
                        <div class="col-sm-10">
                            <select name="moduleid" id="moduleid" class="form-control form-control-inline search-drowdown" style="width: 30%;" disabled>
                                <option value="">--Auswahl--</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="categoryid">Kategorie:</label>
                        <div class="col-sm-10">
                            <select name="categoryid" id="categoryid" class="form-control form-control-inline search-drowdown" style="width: 30%;" disabled>
                                <% For Each vwItem In vwCatList.Items %>
                                    <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="created">Start Stillstand:</label>
                        <div class="col-sm-10">
                            <input type="datetime-local" id="startdate" name="startdate" class="form-control" readonly/>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="durationhour">Dauer Stunden:</label>
                        <div class="col-4">
                            <input type="number" id="durationhour" name="durationhour" class="form-control" placeholder="00" min=0 required value="0"/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-2 col-form-label" for="durationmin">Dauer Minuten:</label>
                        <div class="col-4">
                            <input type="number" id="durationmin" name="durationmin" class="form-control" placeholder="00" required min="0" max="59"value="0"/>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label" for="description">Beschreibung:</label>
                        <div class="col-sm-10">
                            <textarea id="description" name="description" class="form-control" rows="4" readonly/></textarea>
                        </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <div style="display:none">
                            <input type="submit" id="btnSubmit"/>
                        </div>
                        <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                        <button type="button" class="btn btn-cyan" id="btnSave" disabled>Senden</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Edit Form -->

<!--Section: Table-->
<section class="mb-5">

    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-stopwatch"></i>&nbsp;Stillstands-Meldungen</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Eintrag hinzuf&uuml;gen" alt="Eintrag hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
                 &nbsp;&nbsp;<button class="btn btn-sm btn-cyan" href="" id="refreshbtn" name="refreshbtn" title="Refresh"><i class="fas fa-sync"></i></button>
            </div>
        </div>

        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">
            <div class="row">
                <div class="col-8">
                    <div class="form-group row">
                        <label class="col-3 col-form-label" for="search_plantid">Linie:</label>
                        <div class="col-8">
                            <select name="search_plantid" id="search_plantid" class="form-control form-control-inline search-drowdown-index" style="width: 80%">
                                <option value="">--Auswahl--</option>
                                <% For Each vwItem In vwPlantList.Items %>
                                    <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-3 col-form-label" for="search_deviceid">Anlage:</label>
                        <div class="col-8">
                            <select name="search_deviceid" id="search_deviceid" class="form-control form-control-inline search-drowdown-index" style="width: 80%">
                                <option value="">--Auswahl--</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-3 col-form-label" for="search_moduleid">Baugruppe:</label>
                        <div class="col-8">
                            <select name="search_moduleid" id="search_moduleid" class="form-control form-control-inline search-drowdown-index" style="width: 80%">
                                <option value="">--Auswahl--</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-3 col-form-label" for="search_categoryid">Kategorie:</label>
                        <div class="col-8">
                            <select name="search_categoryid" id="search_categoryid" class="form-control form-control-inline search-drowdown-index" style="width: 80%">
                                <option value="">--Auswahl--</option>
                                <% For Each vwItem In vwCatList.Items %>
                                    <option value="<%=vwItem.Value%>"><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-4 float-right">
                    <div class="form-group row">
                        <label class="col-3 col-form-label" for="datefrom">Datum von:</label>
                        <div>
                            <input type="date" id="datefrom" name="datefrom" class="form-control" value=""/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-3 col-form-label" for="dateto">Datum bis:</label>
                        <div>
                            <input type="date" id="dateto" name="dateto" class="form-control" value=""/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">ID</th>
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
                    </tbody>
                </table>
            </div>
        </div>
        <!--/.Card content-->

    </div>
    <!--/.Card-->

</section>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/stand/index.js?v=1.0"></script>
