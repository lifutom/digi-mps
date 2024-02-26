<%
   Dim vwList : Set vwList = ViewData("list")
   Dim ListItem
   Dim DDItem

   Dim vwWarehouseList : Set vwWarehouseList = ViewData("warehouse")

%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
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
                <form id="form" action="javascript:save_data();">
                    <input id="boxid" name="boxid" type="hidden" required value="-1">
                    <input id="defvalue" name="defvalue" type="hidden" required value="">
                    <div class="md-form mb-2">
                         <input id="name" name="name" type="text" size="20" maxlength="50" required value="" placeholder="Box-Name">
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
<!-- Modal Move Box -->
<div class="modal fade" id="moveBox" tabindex="-1" role="dialog" aria-labelledby="moveBox" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-warehouse"></i>&nbsp;&nbsp;Umlagern</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="formBox" action="javascript:saveBoxMove_data();">
                    <input type="hidden" id="movid" name="movid" value="" />
                    <div class="table-responsive">
                        <table>
                            <tr>
                                <td>
                                    Lager:
                                </td>
                                <td>
                                    <input id="warehouseid" name="warehouseid" type="hidden" value="">
                                    <input id="warehouse" name="warehouse" type="text" value="" disabled>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lagerort:
                                </td>
                                <td>
                                    <input id="locationid" name="locationid" type="hidden" value="">
                                    <input id="shelfid" name="shelfid" type="hidden" value="">
                                    <input id="compid" name="compid" type="hidden" value="">
                                    <input id="location" name="location" type="text" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Box:
                                </td>
                                <td>
                                    <input id="boxid" name="boxid" type="hidden" value="">
                                    <input id="boxname" name="boxname" type="text" value="" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Lager:
                                </td>
                                <td>
                                    <select id="warehouseidnew" name="warehouseidnew" class="browser-default custom-select" required="required">
                                        <option value="" disabled>--Lager--</option>
                                        <% For Each DDItem In vwWarehouseList.Items %>
                                                <option value="<%=DDItem.Value%>"><%=DDItem.Name%></option>
                                        <% Next %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Regal:
                                </td>
                                <td>
                                    <input id="shelfidnew" name="shelfidnew" type="number" min="0" value="" required="required">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Fach:
                                </td>
                                <td>
                                    <input id="compidnew" name="compidnew" type="number" min="0" value="" required="required">
                                </td>
                            </tr>
                            <tr height="30">
                                <td colspan="2" valign="bottom">
                                     <div class="text-danger" id="errmsg"></div>
                                </td>
                            </tr>
                            <tr height="30">
                                <td colspan="2" valign="bottom">
                                     <div class="text-danger" id="errmsg1"></div>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer d-flex justify-content-center">
                            <input type="submit" style="display:none;"/>
                            <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                            <button type="submit" class="btn btn-cyan bookbtn" id="bookbtn"><i class="fas fa-warehouse"></i>&nbsp;Umlagern</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- ./Modal Add Sparepart to Cart Form -->


<!--Section: Table User-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Boxen</a>
            <div class="float-right">
                 <!--<button id="addbtn" class="btn btn-sm btn-cyan" title="User hinzuf&uuml;gen" alt="User hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>-->
            </div>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtsitelist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th class="th-sm">BoxID</th>
                            <th class="th-sm">Name</th>
                            <th class="th-sm">Lager</th>
                            <th class="th-sm">Lagerort</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    If Not vwList Is Nothing Then
                        For Each ListItem In vwList.Items
                             %><tr>
                                <td><%=ListItem.BoxID%></td>
                                <td><%=ListItem.Name%></td>
                                <td><%=ListItem.Warehouse%></td>
                                <td><%=ListItem.Location%></td>
                                <td>

                                    <a href="javascript:move2loc(<%=ListItem.BoxID%>);"><i class="fas fa-warehouse" title="Umlagern"></i></a>

                                </td>
                            </tr><%
                         Next
                    End If
                    %>
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
<script src="<%=curRootFile%>/js/pages/box/index.js?v1.0"></script>
