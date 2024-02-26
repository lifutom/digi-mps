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
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;User</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="siteform" action="javascript:save_data();">
                    <input id="active" name="active" type="hidden" required value="0">
                    <input id="siteid" name="siteid" type="hidden" required value="-1">
                    <input id="defvalue" name="defvalue" type="hidden" required value="">
                    <div class="md-form mb-2">
                         <input id="sitename" name="sitename" type="text" size="12" maxlength="50" required value="" placeholder="Sitename">
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
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Sitelist</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="User hinzuf&uuml;gen" alt="User hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
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
                            <th style="display:none">Active</th>
                            <th style="display:none">SiteID</th>
                            <th class="th-sm">Name</th>
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
                                    <td style="display:none"><%=ListItem.SiteID%></td>
                                    <td><%=ListItem.Name%></td>
                                    <td><%=DBFormatDateTime(ListItem.LastEdit)%></td>
                                    <td><%=ListItem.UserID%></td>
                                    <td><a href="javascript:toggleitem('<%=ListItem.SiteID%>');"><%=IIf(ListItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></a></td>
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
<script src="<%=curRootFile%>/js/pages/site/index.js?v1.0"></script>
