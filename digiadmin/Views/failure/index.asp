<%
   Dim vwList : Set vwList = ViewData("failurelist")
   Dim ListItem
%>
<!-- Modal Stop Downtime -->
<div class="modal fade" id="editForm" tabindex="-1" role="dialog" aria-labelledby="EditFailure" aria-hidden="true">
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
                <form id="failureform" action="javascript:save_failuredata();" >
                    <input id="failureid" name="failureid" type="hidden" required value="0">
                    <input id="active" name="active" type="hidden" required value="0">
                    <input id="defvalue" name="defvalue" type="hidden" required value=""> 
                    <div class="md-form mb-2">
                         <input id="failure" name="failure" type="text" size="40" required value="" placeholder="Fehlerbild">
                    </div>
                    <div class="md-form mb-2">
                        <div class="md-form">
                            <textarea type="text" id="description" class="md-textarea form-control" rows="2" placeholder="Fehlerbildbeschreibung" required></textarea>
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
<!-- /.Modal Stop Downtime -->
<script>
    var myTable;

</script>
<!--Section: Table Plant-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Fehlerliste</a>
            <div class="float-right">
                 <button id="addbtn" class="btn btn-sm btn-cyan" title="Fehler hinzuf&uuml;gen" alt="Fehler hinzuf&uuml;gen"><i class="fas fa-plus-circle"></i></button>
            </div>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <table id="dtfailurelist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">FailureID</th>
                            <th style="display:none">Active</th>
                            <th class="th-sm">Fehler</th>
                            <th class="th-sm">Beschreibung</th>
                            <th class="th-sm">Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each ListItem In vwList.Items %>
                            <tr>
                                <td style="display:none"><%=ListItem.FailureID%></td>
                                <td style="display:none"><%=ListItem.Active%></td>
                                <td><%=ListItem.Failure%></td>
                                <td><%=ListItem.Description%></td>
                                <td><%=IIf(ListItem.Active=0,"<i class=""fas fa-ban"" title=""Deaktiviert""></i>","<i class=""far fa-check-circle"" title=""Aktiv""></i>")%></td>
                                <td><a href="javascript:toggleitem(<%=ListItem.FailureID%>);"><%=IIf(ListItem.Active=0,"<i class=""fas fa-plus-circle"" title=""Aktivieren""></i>","<i class=""fas fa-minus-circle"" title=""Deaktivieren""></i>")%></a></td>
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
<script src="<%=curRootFile%>/js/pages/failure/index.1.0.js"></script>
