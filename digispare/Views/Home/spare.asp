<%

Dim vwList : Set vwList =  ViewData("list")
Dim ListItem
Dim vwItem
Dim vwCart : Set vwCart = ViewData("cart")

%>
<!--Section: Table-->
<section class="mb-5">


    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;DigiSpare&nbsp;<%=Application("version")%><%=IIf(Session("login") <> "", "&nbsp;(user: " & Session("login"),"")%>)</a>
            <% If vwCart.Count > 0 Then%>
                <li class="nav-item mt-2">
                    <a href="<%=curRootFile%>/home/mycart" class="nav-item" title="Warenkorb öffnen">
                        <i class="fas fa-shopping-cart pr-4"></i>
                    </a>
                    <span class="counter counter-sm"><%=vwCart.Count%></span>
                </li>
            <% End If %>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-group">

            <%
            If Not vwList Is Nothing Then

                Dim pictPath
                Dim oSpare


                For Each ListItem In vwList.Items
                    Set oSpare = New Spare
                    oSpare.Init(ListItem.ID)
                    %>
                    <div class="col-auto mb-3">
                    <!-- Card -->
                    <div class="card mb-4" style="width: 18rem;">
                        <!-- Card image -->
                        <div class="view overlay">
                            <img style="width: 200px;" class="card-img-top rounded-1 img-thumbnail" src="<%=IIf(ListItem.PhysicalImagePath = "", curRootFile & "/images/nopicture.png", ListItem.ImageName) %>" alt="<%=ListItem.SparepartNb%>">
                            <a href="#">
                                <div class="mask rgba-white-slight"></div>
                            </a>
                        </div>
                        <!-- Card content -->
                        <div class="card-body">
                            <!-- Content -->
                            <h5 class="card-title font-weight-bold mb-2"><%=ListItem.Sparepart%></h5>
                            <!-- Subtitle -->
                            <p class="card-text">
                                <table width="100%">
                                    <tr>
                                        <td>
                                            Artikel-Nr:
                                        </td>
                                        <td align="right">
                                            <%=ListItem.SparepartNb%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            aktueller Lagerstand:
                                        </td>
                                        <td align="right">
                                            <%=FormatNumber(ListItem.ActLevel,2)%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            Serienbezeichnung
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <%=ListItem.SpareNb%>
                                        </td>
                                    </tr>
                                </table>
                            </p>
                            <div class="form-group">
                                <div class="form-control-inline">
                                    <label for="locationid<%=ListItem.ID%>">Lagerort:</label>
                                    <select class="browser-default custom-select" name="locationid<%=ListItem.ID%>" id="locationid<%=ListItem.ID%>">
                                        <% For Each vwItem In oSpare.Locations.Items %>
                                           <option value="<%=vwItem.LocationID%>"><%=vwItem.Name & " Verfügbar: " & FormatNumber(vwItem.Act,2)%></option>
                                        <% Next %>
                                    </select>
                                </div>
                                <div class="form-control-inline mt-2">
                                    <label for="cnt<%=ListItem.ID%>">Anzahl:</label>
                                    <input type="number" name="cnt<%=ListItem.ID%>" id="cnt<%=ListItem.ID%>" value="1" size="6" max="<%=ListItem.ActLevel%>"/>
                                </div>
                                <button type="button" class="btn btn-primary" onclick="add2cart(<%=ListItem.ID%>);"><i class="fas fa-shopping-cart"></i>&nbsp;in den Warenkorb</button>
                            </div>
                        </div>
                    </div>
                    </div>
                    <%
                Next
            Else
                %>
                <div class="card mb-4" style="width: 18rem;">
                    <div class="col-auto mb-3">
                        <div class="card-body">
                            keine Ersatzteile gefunden
                        </div>
                    </div>
                </div>
                <%
            End If
            %>
        </div>
        <div class="card-footer">

            <a class="btn btn-grey" href="<%=curRootFile & "/home/logout"%>">Logout</a>&nbsp;&nbsp;
            <a class="btn btn-primary" href="<%=curRootFile & "/home/spareindex"%>">Zurück</a>&nbsp;&nbsp;
            <a class="btn btn-default" href="<%=curRootFile & "/home/mycart"%>">zum Warenkorb</a>&nbsp;&nbsp;

        </div>
    </div>
    <!--/.Card-->
    <form id="form" name="form" action="<%=CurRootFile%>/home/add2cartpost" method="POST">
        <input type="hidden" name="actcnt" id="actcnt" value=""/>
        <input type="hidden" name="sparepartid" id="sparepartid" value=""/>
        <input type="hidden" name="locationid" id="locationid" value=""/>
    </form>
</section>
<!-- javascript -->
<script src="<%=curRootFile%>/_js/home/spare.js?v.1.0"></script>
