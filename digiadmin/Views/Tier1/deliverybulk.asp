<%
   Dim vwDDPlants : Set  vwDDPlants = ViewData("ddplantlist")
   Dim ListItem
%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditGroup" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fab fa-algolia"></i>&nbsp;&nbsp;Tier1:DeliveryBulk-Daten</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="eForm" action="javascript:save_data();">

                    <input id="deliverybulkid" name="deliverybulkid" type="hidden" value="">
                    <input id="dateid" name="dateid" type="hidden" value="">
                    <input id="defdateyear" name="defdateyear" type="hidden" value="<%=Year(Date)%>">
                    <input id="defdatekw" name="defdatekw" type="hidden" value="<%=glKW(Date)%>">

                    <div class="md-form mb-2">
                        Jahr:<br>
                         <input id="dateyear" name="dateyear" type="numeric" min="2000" max="<%=Year(Date)%>" size="5" maxlength="4" required value="">
                    </div>
                    <div class="md-form mb-2">
                        KW:<br>
                        <input id="datekw" name="datekw" type="numeric" min="1" max="53" size="5" maxlength="2" required value="">
                    </div>
                    <div class="md-form mb-2">
                        Linie:<br>
                        <select id="plantid" name="plantid"class="browser-default custom-select">
                            <option selected disabled>W&auml;hlen Sie die Linie</option>
                            <%

                                For Each DDItem In vwDDPlants.Items
                                        %><option value="<%=DDItem.Value%>"><%=DDItem.Name%></option><%
                                Next

                            %>
                        </select>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            Geplant:<br>
                            <input id="plannedcnt" name="plannedcnt" type="number" min="0" required value="">
                        </div>
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            Produziert:<br>
                            <input id="producedcnt" name="producedcnt" type="number" min="0" required value="">
                        </div>
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
<!--Section: Table Groups-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fab fa-algolia"></i>&nbsp;DeliveryBulk-Daten</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Eintrag hinzuf&uuml;gen" alt="Eintrag hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/tier1/deliverybulk" title="Refresh"><i class="fas fa-sync"></i></a>  
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
                            <th style="display:none">DeliveryBulkID</th>
                            <th style="display:none">DatumID</th>
                            <th class="th-sm">Jahr</th>
                            <th class="th-sm">KW</th>
                            <th style="display:none">PlantID</th>
                            <th class="th-sm">Plant</th>
                            <th class="th-sm">Geplant</th>
                            <th class="th-sm">Produziert</th>
                            <th class="th-sm">letzte &Auml;nderung am</th>
                            <th class="th-sm">von</th>
                            <th></th>
                        </tr>
                    </thead>
                    <!--<tbody>
                    </tbody>-->
                </table>
            </div>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/tier1/deliverybulk.js?v1.1"></script>
