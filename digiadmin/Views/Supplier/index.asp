<%
   Dim vwList : Set vwList = ViewData("list")
   Dim ListItem
   Dim DDItem
%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditSite" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Lieferant</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="form" action="javascript:save_data();">
                    <input id="active" name="active" type="hidden" required value="0">
                    <input id="supplierid" name="supplierid" type="hidden" required value="-1">
                    <input id="defvalue" name="defvalue" type="hidden" required value="">
                    <div class="md-form mb-2">
                        <label for="name">Name:</label>
                         <input id="name" name="name" type="text" size="30" maxlength="50" required value=" ">
                    </div>
                    <div class="md-form mb-2">
                        <label for="country">Land:</label>
                        <input id="country" name="country" type="text" size="5" maxlength="5" value=" ">
                    </div>
                    <div class="md-form mb-2">
                        <label for="zip">Plz:</label>
                        <input id="zip" name="zip" type="text" size="10" maxlength="10" value=" ">
                    </div>
                    <div class="md-form mb-2">
                        <label for="city">Ort:</label>
                        <input id="city" name="city" type="text" size="30" maxlength="50" value=" ">
                    </div>
                    <div class="md-form mb-2">
                        <label for="street">Adresse:</label>
                        <input id="street" name="street" type="text" size="30" maxlength="50" value=" ">
                    </div>
                    <div class="md-form mb-2">
                        <label for="phone">Telefon-Nr:</label>
                        <input id="phone" name="phone" type="text" size="30" maxlength="50" value=" ">
                    </div>
                    <div class="md-form mb-2">
                        <label for="mobile">Mobil-Nr:</label>
                        <input id="mobile" name="mobile" type="text" size="30" maxlength="50" value=" ">
                    </div>
                    <div class="md-form mb-2">
                        <label for="maincontact">Kontakt:</label>
                        <input id="maincontact" name="maincontact" type="text" size="30" maxlength="50" value=" ">
                    </div>
                    <div class="md-form mb-2">
                        <label for="email">E-Mail:</label>
                        <input id="email" name="email" type="text" size="30" maxlength="50" value=" ">
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
<!--Section: Table User-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Lieferantenliste</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="User hinzuf&uuml;gen" alt="User hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
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
                            <th style="display:none">Active</th>
                            <th style="display:none">SupplierID</th>
                            <th class="th-sm">Name</th>
                            <th class="th-sm">Land</th>
                            <th class="th-sm">Plz</th>
                            <th class="th-sm">Ort</th>
                            <th class="th-sm">Adresse</th>
                            <th class="th-sm">TelefonNr</th>
                            <th class="th-sm">Mobil</th>
                            <th class="th-sm">Kontakt</th>
                            <th class="th-sm">E-Mail</th>
                            <th class="th-sm">letzte Änderung am</th>
                            <th class="th-sm">von</th>
                            <th class="th-sm">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    If Not vwList Is Nothing Then
                        For Each ListItem In vwList.Items
                                 %><tr>
                                    <td style="display:none"><%=ListItem.Active%></td>
                                    <td style="display:none"><%=ListItem.SupplierID%></td>
                                    <td><%=ListItem.Name%></td>
                                    <td><%=ListItem.Country%></td>
                                    <td><%=ListItem.Zip%></td>
                                    <td><%=ListItem.City%></td>
                                    <td><%=ListItem.Street%></td>
                                    <td><%=ListItem.Phone%></td>
                                    <td><%=ListItem.Mobile%></td>
                                    <td><%=ListItem.MainContact%></td>
                                    <td><%=ListItem.EMail%></td>
                                    <td><%=DBFormatDateTime(ListItem.LastEdit)%></td>
                                    <td><%=ListItem.UserID%></td>
                                    <td><a href="javascript:toggleitem('<%=ListItem.SupplierID%>');"><%=IIf(ListItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a></td>
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
<script src="<%=curRootFile%>/js/pages/supplier/index.js?v1.0"></script>
