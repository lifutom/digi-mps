<%

    Dim vwDateID : vwDateID = ViewData("dateid")
    Dim vwList : Set vwList = ViewData("list")
    Dim vItem

%>

<section class="mb-5">
    <!--Javascript Variable-->
    <input type="hidden" id="dateid" value="<%=vwDateID%>"  />
    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Safety Issues Tier2</a>
            <div class="float-right">
                 <a class="white-text" href="<%=curRootFile%>/tier3/safetyissue" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body">
            <% For Each vItem In vwList.Items %>
                <div class="text-left card card-cascade mb-2 mt-2 py-2">
                    <table>
                        <tr>
                            <td valign="top" rowspan="2" width="80">
                                <img src="<%=curRootFile%>/Images/Alert128h.png" width="64" height="64" alt="">
                            </td>
                            <td align="left">
                                <h6><b><%=vItem.Description%></b></h6>
                            </td>
                            <td rowspan="2" width="15%">
                                  <%

                                    vwCloseDate = vItem.Closed3
                                    vwItemType = "tier3_safetyissue"
                                    vwID = vItem.ID

                                    If IsNull(vwCloseDate) Or vwCloseDate="" Then
                                        ' already open'
                                         %><a href="javascript:changeitem('<%=vwID%>','<%=vwItemType%>')"><img src="<%=curRootFile%>/Images/CheckmarkRed64h.png" width="64" height="64" alt="close item" title="close item"></a><%
                                    Else
                                        ' closed'
                                        %><a href="javascript:changeitem('<%=vwID%>','<%=vwItemType%>')"><img src="<%=curRootFile%>/Images/CheckmarkGreen64h.png" width="64" height="64" alt="open item" title="open item"></a><%
                                    End If
                                  %>
                            </td>
                        </tr>
                        <tr>
                              <td>
                                 <h6><%=Replace(IIf(Not IsNull(vItem.LongDescription),vItem.LongDescription,""),vbLf,"<br>")%></h6>
                              </td>
                        </tr>
                    </table>
                </div>
            <% Next %>
        </div>
    </div>
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/_js/tier2/safetyissue.js?v.1.0"></script>