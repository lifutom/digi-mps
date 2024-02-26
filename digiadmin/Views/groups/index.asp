<%
   Dim vwList : Set vwList = ViewData("list")
   Dim ListItem
%>
<!-- Modal Edit Form -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditGroup" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <div class="float-left"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>&nbsp;&nbsp;Fehlerbild</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <form id="groupform" action="javascript:save_data();">
                    <input id="active" name="active" type="hidden" required value="0">
                    <input id="defvalue" name="defvalue" type="hidden" required value="">
                    <div class="md-form mb-2">
                         <input id="groupid" name="groupid" type="text" size="12" maxlength="10" required value="" placeholder="GruppenID">
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <input id="group" name="group" type="text" size="30" maxlength="50" required value="" placeholder="Gruppenbezeichnung">
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
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Berechtigungsgruppen</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Gruppe hinzuf&uuml;gen" alt="Gruppe hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
            </div>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtgrouplist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">Active</th>
                            <th class="th-sm">Gruppe</th>
                            <th class="th-sm">Beschreibung</th>
                            <th class="th-sm">Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each ListItem In vwList.Items %>
                            <tr>
                                <td style="display:none"><%=ListItem.Active%></td>
                                <td><%=ListItem.GroupID%></td>
                                <td><%=ListItem.Group%></td>
                                <td><%=IIf(ListItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></td>
                                <% If ListItem.GroupID = "admin" Then %>
                                   <td></td>
                                <% Else %>
                                   <td>
                                       <a href="javascript:openaccess('<%=ListItem.GroupID%>')"><i style="font-size: 20px;" class="fab fa-expeditedssl" title="Berechtigungen"></i></a>
                                       &nbsp;<a href="javascript:toggleitem('<%=ListItem.GroupID%>');"><%=IIf(ListItem.Active=0,"<i style=""font-size: 20px;"" class=""fas fa-plus-circle"" title=""Aktivieren""></i>","<i style=""font-size: 20px;"" class=""fas fa-minus-circle"" title=""Deaktivieren""></i>")%></a>

                                   </td>
                                <% End If %>
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
<form id="access_form" name="access_form" method="post" action="<%=curRootFile%>/groups/accesspost">
     <input type="hidden" id="actgroupid" name="groupid" value="" />
</form>

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/groups/index.1.0.js?v1.1"></script>
