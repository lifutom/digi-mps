<%

    Dim vwList : Set vwList = ViewData("list")
    Dim vwGroups : Set vwGroups = ViewData("groups")
    Dim vwDetail
    Dim vwGroupDetail
    Dim vwAccessType :  vwAccessType = CInt(ViewData("accesstype"))
    Dim vwItem

    Dim vwIcon
    Dim vwTitle
    Dim vwEditTitle


    Select Case vwAccessType

        Case cAccessTypeShare

           vwIcon = cRequestAccessShareIcon
           vwEditTitle = GetLabel("mnuMainAccessItemShares", Lang)
           vwTitle = GetLabel("lblWorkFlow", Lang) & " " & vwEditTitle


        Case cAccessTypeApp

            vwIcon =  cRequestAccessAppIcon
            vwEditTitle = GetLabel("mnuMainAccessItemApps", Lang)
            vwTitle = GetLabel("lblWorkFlow", Lang)  & " " & vwEditTitle


        Case cAccessTypeSAP

            vwIcon =  cRequestAccessAppIcon
            vwEditTitle = GetLabel("mnuMainAccessItemSAP", Lang)
            vwTitle = GetLabel("lblWorkFlow", Lang)  & " " & vwEditTitle

    End Select


%>
<input type="hidden" id="vwaccesstypeid" name="vwaccesstypeid" value="<%=vwAccessType%>" />
<section>
    <div class="col-md-12">

        <div class="card">
            <div class="card-header-black">
                <div class="float-left">
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold"><i class="<%=vwIcon%>"></i>&nbsp;&nbsp;<%=vwTitle%></h5>
                </div>
                <div class="float-right mr-2 mt-2">

                </div>
            </div>
            <div class="card-body">

                    <div class="wrapper-editor">
                        <table id="dtlist" name="dtlist" class="table table-striped display" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <th style="display:none">AccessItemID</th>
                                    <th style="display:none">ItemRightID</th>
                                    <th style="display:none">WorkflowID</th>
                                    <th style="display:none">Pos</th>
                                    <th style="display:none">TaskTypeID</th>
                                    <th class="th-sm"><%=GetLabel("lblAccessItem", Lang)%></th>
                                    <th class="th-sm"><%=GetLabel("lblAccessRight", Lang)%></th>
                                    <th class="th-sm"><%=GetLabel("lblWorkflow", Lang)%></th>
                                    <th class="th-sm"><%=GetLabel("lblTaskType", Lang)%></th>
                                    <th class="th-sm"><%=GetLabel("lblQueue", Lang)%></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% For Each vwItem In vwList.Items
                                    For Each vwDetail In vwItem.Tasks.Items
                                    %><tr>
                                        <td style="display:none"><%=vwItem.AccessItemID%></td>
                                        <td style="display:none"><%=vwItem.AccessRightID%></td>
                                        <td style="display:none"><%=vwItem.WorkflowID%></td>
                                        <td style="display:none"><%=vwDetail.Pos%></td>
                                        <td style="display:none"><%=vwDetail.TaskTypeID%></td>
                                        <td><%=vwItem.AccessItem%></td>
                                        <td><%=vwItem.AccessRight%></td>
                                        <td><%=vwItem.WorkFlow%></td>
                                        <td><%=vwDetail.TaskType%></td>
                                        <td nowrap>
                                            <select id="sendto_<%=vwItem.AccessRightID%>_<%=vwDetail.Pos%>" class="form-control-inline browser-default custom-select update-sendto">
                                                <option value="">--<%=GetLabel("lblSelect", Lang)%>--</option>
                                                <% For Each vwGroupDetail In vwGroups.Items %>
                                                    <option value="<%=vwGroupDetail.Value%>"<%=IIf(vwGroupDetail.Value=vwDetail.SendTo," selected","")%>><%=vwGroupDetail.Value%></option>
                                                <% Next %>
                                            </select>
                                        </td>
                                        <td>
                                            &nbsp;<i style="font-size: 20px;"class="<%=cSaveButtonIcon%> btnsave" title="<%=GetLabel("btnSave", Lang)%>"></i>
                                        </td>
                                    </tr><%
                                    Next
                                Next %>
                            </tbody>
                        </table>
                    </div>

            </div>
        </div>
    </div>
</section>
<!--Section: Table-->
<!-- javascript -->
<script src="<%=curRootFile%>/_js/accessitem/itemworkflow.js?v1.0"></script>