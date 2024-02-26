<%
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
        <div class="card-body">

            <div class="col-12">
                    <div class="card">
                        <div class="card-header blue font-weight-bold">
                            MENU
                        </div>
                        <div class="card-body">
                            
                            <button type="button" class="btn btn-primary btn-block" id="sparepart"  value="v">Ersatzteilentnahme</button><br>
                            <!--<button type="button" class="btn btn-primary btn-block"  id="warehouse" value="v">Lagerverwaltung</button><br>-->

                        </div>
                    </div>
            </div>

        </div>
        <div class="card-footer">
            <a class="btn btn-grey" href="<%=curRootFile & "/home/logout"%>">Logout</a>&nbsp;&nbsp;
        </div>
    </div>
    <!--/.Card-->
</section>
<!--Section: Table-->

<!-- javascript -->
<script src="<%=curRootFile%>/_js/home/index.js?v1.0"></script>
