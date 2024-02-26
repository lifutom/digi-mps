<%

    Dim vwList : Set vwList = ViewData("list")
    Dim vwModList : Set vwModList = ViewData("modlist")
    Dim vwCatList : Set vwCatList = ViewData("catlist")
    Dim vwDeviceList : Set vwDeviceList = ViewData("devicelist")
    Dim vwItem
    Dim vwDevice

    Dim vwCurLine : vwCurLine = ViewData("curline")
    Dim vwCurDevice : vwCurDevice = ViewData("curdevice")

    Dim vwCart : Set vwCart = ViewData("cart")

%>

<!--Section: Table-->
<section class="mb-5">

    <form id="form" name="form" action="<%=CurRootFile%>/home/IndexPost" method="POST">
    <input type="hidden" name="catid" id="catid" value="0"/>
    <input type="hidden" name="searchstr" id="searchstr" value=""/> 
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
        <div class="card-body">
            <!-- FormHeader -->
            <div class="row">
                <div class="col-4">
                    <div class="card">
                        <div class="card-header blue font-weight-bold">
                            Linie
                        </div>
                        <div class="card-body">
                            <%
                                For Each vwItem In vwList.Items
                                    If CInt(vwItem.PlantID) = CInt(vwCurLine) Then
                                        %><button type="button" class="btn btn-primary btn-block"  value="<%=vwItem.PlantID%>" disabled><i class="fas fa-flag-checkered"></i>&nbsp;<%=vwItem.Plant%></button><br><%
                                    Else
                                        %><button type="button" class="btn btn-grey btn-block" name="cmdLine"  value="<%=vwItem.PlantID%>" onclick="changeActivePlant(<%=vwItem.PlantID%>);"><%=vwItem.Plant%></button><br><%
                                    End If

                                Next
                            %>

                            Suche:&nbsp;<input type="text" name="searchtext" id="searchtext" value="" size="20"/>&nbsp;<button type="button" class="btn btn-warning" onclick="liststrspare();"><i class="fas fa-search"></i></button><br><br>

                            <%
                                For Each vwItem In vwCatList.Items
                                    %><button type="button" class="btn btn-warning btn-block"  value="<%=vwItem.Value%>" onclick="listspare(<%=vwItem.Value%>);"><i class="fas fa-tags"></i>&nbsp;<%=vwItem.Name%></button><br><%
                                Next
                            %>
                        </div>
                    </div>
                </div>
                <div class="col-4">
                     <div class="card">
                          <div class="card-header blue font-weight-bold">
                               Anlage
                          </div>
                          <div id=""class="card-body">
                               <div class="col-12">
                                    <%
                                        For Each vwItem In vwDeviceList.Items
                                            If CInt(vwItem.Value) = CInt(vwCurDevice) Then
                                               %><button type="button" class="btn-sm btn-primary btn-block" disabled><i class="fas fa-flag-checkered"></i>&nbsp;<%=vwItem.Name%></button><br><%
                                            Else
                                                %><button type="button" class="btn-sm btn-grey btn-block" onclick="changeActiveDevice(<%=vwItem.Value%>);"><%=vwItem.Name%></button><br><%
                                            End If
                                        Next
                                    %>
                              </div>
                          </div>
                     </div>
                </div>
                <div class="col-4">
                     <div class="card">
                          <div class="card-header blue font-weight-bold">
                               Baugruppe
                          </div>
                          <div class="card-body">
                               <select name="moduleid" id="moduleid" size=20 class="browser-default" required>
                                    <%
                                    If vwModList.Count = 0 Then
                                        %><option value="" disabled>--N/A--</option><%
                                    Else
                                        For Each vwItem In vwModList.Items
                                            %><option value="<%=vwItem.Value%>"><%=vwItem.Name%></option><%
                                        Next
                                    End If
                                    %>
                                </select>
                          </div>
                     </div>
                </div>
            </div>
            <div class="mt-3">
                <a class="btn btn-grey" href="<%=curRootFile & "/home/logout"%>">Logout</a>&nbsp;&nbsp;
                <a class="btn btn-primary" href="<%=curRootFile & "/home"%>">Zurück</a>&nbsp;&nbsp;
                <input class="btn btn-primary" type="submit" name="cmdnext" id="cmdnext" value="Weiter">
            </div>
        </div>
    </div>
    <!--/.Card-->
    </form>
    <form id="formLine" name="formLine" action="<%=CurRootFile%>/home/LinePost" method="POST">
        <input type="hidden" id="activeline" name="activeline" value="<%=vwCurLine%>" />
    </form>
    <form id="formDevice" name="formDevice" action="<%=CurRootFile%>/home/DevicePost" method="POST">
        <input type="hidden" id="activedevice" name="activedevice" value="<%=vwCurDevice%>" />
    </form>

</section>
<!--Section: Table-->

<!-- javascript -->
<script src="<%=curRootFile%>/_js/home/spareindex.js?v.1.3"></script>
