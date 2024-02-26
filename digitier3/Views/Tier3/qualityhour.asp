<%

    Dim vwItem
    Dim vwColumn
    Dim vwField
    Dim vwRs : Set vwRs = ViewData("qualityhour")

    Dim vwQHLink : vwQHLink = GetAppSettings("qh-link")

%>

<section class="mb-5">
    <!--Javascript Variable-->
    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Quality Hour&nbsp;&nbsp;KW-<%=glKW(Date)%>&nbsp;&nbsp;<%=Year(Date)%></a>
            <div class="float-right">
                 <a class="white-text" href="<%=curRootFile%>/tier3/qualityhour" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body">
            <div class="row">

                <div class="col-12">
                    <!-- Card -->
                    <div class="card card-cascade mt-2">

                        <!-- Card content -->
                        <div class="card-body card-body-cascade text-center">
                            <div class="mb-10">
                                <a href="<%=vwQHLink%>" class="btn-sm btn-primary"name="qh-link" id="qh-link" target="_blank">To Q-Hour App</a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-sm">
                                        <thead>
                                            <tr>
                                                <%
                                                    For Each Column In vwRs.Fields
                                                        ''Response.Write "<th class=""th-sm font-weight-bold"" bgcolor=""lightgrey""><small>" & Column.Name & "</small></th>"
                                                        Response.Write "<th class=""th-sm font-weight-bold"" bgcolor=""lightgrey""><small>&nbsp;</small></th>"
                                                    Next
                                                %>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                If Not vwRs.Eof Then
                                                    Do While Not vwRs.Eof
                                                        Response.Write "<tr>"
                                                        For Each Field In vwRs.Fields
                                                            Response.Write "<td><small>" & Field.Value & "</small></td>"
                                                        Next
                                                        Response.Write "</tr>"
                                                        vwRs.MoveNext
                                                    Loop
                                                End If
                                            %>
                                        </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
     <!-- Card -->
</section>