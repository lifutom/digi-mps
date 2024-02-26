<%

    Dim vwItem : Set vwItem = ViewData("item")
    Dim vwDetail
    Dim vwSubDetail
    Dim vwLang : vwLang = Session("lang")
    Dim vwTaksID : vwTaksID = CLng(ViewData("taskid"))

%>
<section>
    <div class="card">
        <div class="card-body">
            <h2><%=vwItem.ReqNb & " " & vwItem.ReqType%></h2>
            <h4><%=GetLabel("lblAccessRights", vwLang) & ": " & vwItem.AccessType & " " & vwItem.AccessItem & " " & vwItem.AccessRight%></h4>

            <table cellspacing="10" cellpadding="10">
                <thead>
                    <th><%=GetLabel("lblTaskType", vwLang)%></th>
                    <th><%=GetLabel("lblState", vwLang)%></th>
                    <th><%=GetLabel("lblAssignedTo", vwLang)%></th>
                    <th><%=GetLabel("lblTaskNb", vwLang)%></th>
                    <th><%=GetLabel("lblCreated", vwLang)%></th>
                    <th><%=GetLabel("lblLastEdit", vwLang)%></th>
                    <th><%=GetLabel("lblLastEditBy", vwLang)%></th>
                </thead>
                <tbody>
                    <%
                       Dim colClass

                       For Each vwDetail In vwItem.Tasks.Items
                        Select Case vwDetail.TaskStateID
                            Case 0
                                colClass = "text-danger"
                            Case 10
                                colClass = "text-warning"
                            Case 40
                                colClass = "text-success"
                        End Select
                        %>
                        <tr class="<%=colClass%>">
                            <td><i class="<%=vwDetail.TaskTypeIcon%>" title="<%=vwDetail.TaskType%>"></i>&nbsp;<%=vwDetail.TaskType%></td>
                            <td><%=vwDetail.TaskState%></td>
                            <td><%=vwDetail.SendTo%></td>
                            <td><%=vwDetail.TaskNb%></td>
                            <td><%=DBFormatDate(vwDetail.TaskCreated)%></td>
                            <td><%=IIf(vwDetail.TaskStateID = 40,DBFormatDate(vwDetail.TaskLastEdit),"")%></td>
                            <td><%=IIf(vwDetail.TaskStateID = 40,vwDetail.TaskLastEditBy,"")%></td>
                        </tr>
                    <% Next %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="7">
                            <table cellpadding="5">
                                <tr>
                                    <th><%=GetLabel("lblAssignedTo", vwLang)%></th>
                                    <th>ISID</th>
                                    <th><%=GetLabel("lblUser", vwLang)%></th>
                                </tr>
                                <% For Each vwDetail In vwItem.Queue.Items %>
                                    <tr>
                                        <td colspan="3"><%=vwDetail.Value%></td>
                                    </tr>
                                    <% For Each vwSubDetail In vwDetail.Tag.Items %>
                                        <tr>
                                            <td>&nbsp;-&nbsp;</td>
                                            <td><%=vwSubDetail.Value%></td>
                                            <td><%=vwSubDetail.Name%></td>
                                        </tr>
                                    <% Next %>
                                <% Next %>
                            </table>
                        </td>
                    </tr>
                </tfoot>
            </table>

        </div>
    </div>

</section>
<!-- javascript -->
<script src="<%=curRootFile%>/_js/shared/workflowstate.js?v1.0"></script>