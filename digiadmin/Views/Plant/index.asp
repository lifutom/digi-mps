<%
   Dim vwPlantList : Set vwPlantList = ViewData("plantlist")
   Dim ListItem
%>

<!--Section: Table Plant-->
<section class="mb-5">

    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Anlagenliste</a>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtplantlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">PlantID</th>
                            <th class="th-sm">Anlage</th>
                            <th class="th-sm">Beschreibung</th>
                            <th class="th-sm">RaumNr</th>
                            <th class="th-sm">Bild</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each ListItem In vwPlantList.Items %>
                        <tr>
                            <td style="display:none"><%=ListItem.PlantID%></td>
                            <td><%=ListItem.Plant%></td>
                            <td><%=ListItem.Description%></td>
                            <td><%=ListItem.RoomNb%></td>
                            <td><%=ListItem.Image%></td>
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
<script src="<%=curRootFile%>/js/pages/plant/index.1.0.js"></script>
