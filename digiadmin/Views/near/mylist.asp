<%
   Dim vwList : Set vwList = ViewData("list")
   Dim ListItem
%>

<!--Section: Table Groups-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-eye"></i>&nbsp;meine zugeordneten Meldungen&nbsp;(<%=DBFormatDateTime(Now)%>)</a>
            <div class="float-right">
                 &nbsp;&nbsp;<a class="white-text" href="<%=curRootFile%>/near/mylist" title="Refresh"><i class="fas fa-sync"></i></a>
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
                            <th style="display:none">NearID</th>
                            <th class="th-sm">Nummer</th>
                            <th class="th-sm">Typ</th>
                            <th class="th-sm">Erstellt am</th>
                            <th class="th-sm">SVP-Assigned</th>
                            <th class="th-sm">Datum</th>
                            <th class="th-sm">Zeit</th>
                            <th class="th-sm">Beschreibung</th>
                            <th class="th-sm">Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <%  Dim cssClass : cssClass = ""

                        For Each ListItem In vwList.Items
                             Select Case ListItem.Typ
                            Case 1
                                cssClass = "text-success"
                            Case 2
                                cssClass = "text-warning"
                            Case 3
                                cssClass = "text-danger"
                            End Select

                        %>
                            <tr>
                                <td style="display:none"><%=ListItem.NearID%></td>
                                <td class="<%=cssClass%>" nowrap>
                                    <% If ListItem.IsTarget0 = 1 Then %>
                                        <i class="fab fa-opera" title="Target-0"></i>&nbsp;
                                    <% End If %>
                                    <%=ListItem.NearNb%>
                                </td>
                                <td class="<%=cssClass%>"><%=ListItem.TypName%></td>
                                <td><%=DBFormatDate(ListItem.Created)%></td>
                                <td><%=ListItem.AssignedToSPV%></td>
                                <td><%=ListItem.NearDate%></td>
                                <td><%=ListItem.NearTime%></td>
                                <td><%=ListItem.Description%></td>
                                <td><%=ListItem.StateText%></td>
                                <td>
                                    <a href="javascript:askfordelete(<%=ListItem.NearID%>,'<%=ListItem.NearNb%>');" title="L&ouml;schen" class="deletelink"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a>
                                    <% If ListItem.IsTarget0 = 1 Then %>
                                        &nbsp;<a href="<%=curRootFile%>/report/printonepager?id=<%=ListItem.NearID%>" title="Drucken" target="_blank"><i style="font-size: 16px" class="fas fa-print"></i></a>
                                     <% End If %>
                                </td>
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

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/near/mylist.js?v1.3"></script>
