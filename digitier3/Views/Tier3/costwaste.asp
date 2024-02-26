<%

    Dim vwDateID : vwDateID = ViewData("dateid")
    Dim vwList : Set vwList = ViewData("list")
    Dim vItem
    Dim hItem
    Dim vwItemList

    Dim vwRows
    Dim vwCloseDate
    Dim vwItemType
    Dim vwID

%>

<section class="mb-5">
    <!--Javascript Variable-->
    <input type="hidden" id="dateid" value="<%=vwDateID%>"  />
    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Cost/Waste</a>
            <div class="float-right">
                 <a class="white-text" href="<%=curRootFile%>/tier3/costwaste" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body">
            <%
                vwRows = 1
                For Each vItem In vwList.Items
                    If vwRows MOD 2 <> 0 Then
                       Response.Write "<div class=""row"">"
                    End If
                    %>
                    <div class="col-6">
                        <div class="col-12">
                            <!-- Card -->
                            <div class="card-body">
                                <div class="text-center"><h4><%=vItem.Cat%></h4></div>
                                <%
                                If  vItem.ItemList.Count > 0 Then
                                    For Each hItem In vItem.ItemList.Items
                                    %>
                                        <div class="text-left card card-cascade mb-2 mt-2 py-2">
                                            <div class="table-responsive">
                                                <table width="100%">
                                                  <tr>
                                                      <td width="15%">
                                                           <img src="<%=curRootFile%>/Images/Alert128h.png" width="64" height="64" alt="">
                                                      </td>
                                                      <td align="left" width="70%">
                                                           <h6><%
                                                                If CInt(vItem.CatID)=99 Then
                                                                    Response.Write Enc(hItem.ONTxt)
                                                                Else
                                                                    Response.Write Enc(hItem.OTxt)
                                                                End If
                                                            %></h6>
                                                      </td>
                                                      <td width="15%">
                                                          <%
                                                            If CInt(vItem.CatID)=99 Then
                                                                vwCloseDate = hItem.OnClosed
                                                                vwItemType = "tier_other_note"
                                                                vwID = hItem.ONID
                                                            Else
                                                                vwCloseDate = hItem.OClosed
                                                                vwItemType = "tier_other_other"
                                                                vwID = hItem.OID
                                                            End If

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
                                                </table>
                                            </div>
                                        </div>
                                    <%
                                    Next
                                Else
                                    %>
                                    <div class="text-left card card-cascade mb-2 mt-2 py-2">
                                              <table>
                                                  <tr>
                                                      <td>
                                                           <img src="<%=curRootFile%>/Images/Alert128h.png" width="64" height="64" alt="">
                                                      </td>
                                                      <td align="left">
                                                           <h6>no items available</h6>
                                                      </td>
                                                  </tr>
                                            </table>
                                    </div>
                                    <%
                                End If
                                %>
                            </div>
                        </div>
                    </div><%
                    If vwRows MOD 2 = 0 Then
                       Response.Write "</div>"
                    End If
                    vwRows = vwRows + 1
                Next %>
        </div>
    </div>
     <!-- Card -->
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/_js/tier3/costwaste.js?v.1.0"></script>