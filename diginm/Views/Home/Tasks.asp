<%

    Dim vwObject : Set vwObject = ViewData("nearmiss")
    Dim vwRoomList : Set vwRoomList = ViewData("roomlist")
    Dim vwRegionList : Set vwRegionList = ViewData("regionlist")
    Dim vwBuildingList : Set vwBuildingList = ViewData("buildinglist")
    Dim vwSPVList : Set vwSPVList = ViewData("spvlist")
    Dim vwItem

%>

<!--Section: Table-->
<section class="mb-5">

    <form id="formNear" action="<%=CurRootFile%>/home/CreatePost" method="POST" enctype="multipart/form-data">

    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Meldungen&nbsp;<%=IIf(Session("login") <> "", "(user: " & Session("login"),"")%>)</a>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">
            <!-- FormHeader -->
            <div class="row">
                <div class="col-4">
                     <div class="card">
                          <div class="card-header blue font-weight-bold">
                               Datum
                          </div>
                          <div class="card-body">
                               <input type="date" name="nmdate" id="nmdate" value="<%=DBFormatDate(vwObject.NearDate)%>"/>
                          </div>
                     </div>
                </div>
                <div class="col-4">
                     <div class="card">
                          <div class="card-header blue font-weight-bold">
                               Zeit
                          </div>
                          <div class="card-body">
                               <input type="time" id="nmtime" name="nmtime" value="<%=Left(CStr(vwObject.NearTime),5)%>" pattern="([1]?[0-9]|2[0-3]):[0-5][0-9]"/>
                          </div>
                     </div>
                </div>
                <div class="col-4">
                     <div class="card">
                          <div class="card-header blue font-weight-bold">
                                Raum
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <select name="roomid" id="roomid" class="search-drowdown form-control" style="width: 100%" required>
                                            <option value="" disabled selected>-- Auswahl Raum ----------------------</option>
                                            <% For Each vwItem In vwRoomList.Items %>
                                                <option value="<%=vwItem.Value%>" <%=IIf(CInt(vwItem.Value) = CInt(vwObject.RoomID),"selected","")%>><%=vwItem.Name%></option>
                                            <% Next %>
                                    </select>
                                </div>

                                <div class="mb-2">
                                    <label for="buildingid">Filter</label>
                                    <select name="buildingid" id="buildingid" class="search-drowdown form-control" style="width: 100%">
                                        <option value="" disabled selected>Auswahl Gebäude</option>
                                        <% For Each vwItem In vwBuildingList.Items %>
                                            <option value="<%=vwItem.Value%>" <%=IIf(CInt(vwItem.Value) = CInt(vwObject.BuildingID),"selected","")%>><%=vwItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </div>
                                <select name="regionid" id="regionid" class="search-drowdown form-control" style="width: 100%">
                                    <option value="" disabled selected>Auswahl Region</option>-->
                                    <% For Each vwItem In vwRegionList.Items %>
                                        <option value="<%=vwItem.Value%>" <%=IIf(vwItem.Value = IIf(vwObject.RegionID <> "",vwObject.RegionID, CInt(-1)),"selected","")%>><%=vwItem.Name%></option>
                                    <% Next %>
                                </select>
                          </div>
                     </div>
                </div>
            </div>
            <div class="card mt-2">
                <div class="card-header blue font-weight-bold">
                    SVP/Coach
                </div>
                <div class="card-body">
                    <select style="height: 30px;" name="assignedtospv" id="assignedtospv" class="browser-default" required>
                        <% For Each vwItem In vwSPVList.Items %>
                            <option value="<%=vwItem.Value%>" <%=IIf(UCASE(Trim(vwItem.name)) = UCASE(Trim(vwObject.AssignedToSpv)),"selected","")%> <%=vwItem.Disabled%>><%=vwItem.Name%></option>
                        <% Next %>
                    </select>
                </div>
            </div>
            <!--/.FormHeader -->
            <div class="card mt-2">
                <div class="card-header blue font-weight-bold">
                        Sofortmaßnahmen
                </div>
                <div class="card-body">
                    <div class="col-12">
                        <div class="row">
                            <div class="col-6">
                                <div class="form-group shadow-textarea">
                                        <label for="task">Beschreibung</label>
                                        <textarea class="form-control z-depth-1" id="task"  name="task" rows="9" required placeholder="getroffen Sofortmassnahmen..."><%=vwObject.Task%></textarea>
                                </div>
                                <div>
                                    <input type="submit" style="display:none;"/>
                                    <button class="btn btn-default" type="button" name="cmdlogout" id="cmdlogout">Logout</button>&nbsp;&nbsp;
                                    <button  class="btn btn-primary" type="button" name="cmdback" id="cmdback">Zurück</button>
                                    <button  class="btn btn-success" type="button" name="cmdsave" id="cmdsave">Anlegen</button>
                                </div>
                            </div>
                            <div class="col-6">
                                <label for="neartaskimage">Foto</label>
                                 <div class="file-upload-wrapper">
                                        <input type="file" id="neartaskimage"
                                        accept="image/png, image/jpeg, image/jpg"
                                        name="neartaskimage"
                                        class="file-upload"
                                        data-max-file-size="5M"
                                        data-height="300"
                                        data-default-file="<%=IIf(vwObject.VirtualTaskPath <> "",curRootFile & "/" & vwObject.VirtualTaskPath, "")%>"/>
                                 </div>
                                 <% If vwObject.VirtualTaskPath <> "" Then %>
                                 <% End If%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
    </form>
</section>
<!--Section: Table-->

<!-- javascript -->
<script src="<%=curRootFile%>/_js/home/task.js?v.1.2"></script>
