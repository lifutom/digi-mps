<%

    Dim IsMyCart : IsMyCart = ViewData("mycart")
    Dim myCart : Set myCart = ViewData("cart")
    Dim vwList : Set vwList = myCart.ShoppingItems
    Dim vwItem

%>
<!--Section: Table carts-->
<section class="mb-5">
    <!-- jquery variablen -->
    <input type="hidden" name="ismycart" id="ismycart" value="<%=IIf(IsMyCart,1,0)%>">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-shopping-cart"></i>&nbsp;Warenkorb&nbsp;<b><%=myCart.Name%></b></a>
            <div class="float-right">
                <a class="white-text" href="<%=curRootFile%>/cart/mycart" title="Refresh"><i class="fas fa-sync"></i></a>
            </div>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">
            <div class="table-responsive">
                <!-- Material Design Bootstrap -->
                <input type="hidden" name="shoppingid" id="shoppingid" value="<%=myCart.ShoppingID%>" />
                <table id="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                           <td colspan="9">
                                Erstellt&nbsp;am:&nbsp;<%=DBFormatDateTime(myCart.Created)%>
                           </td>
                        </tr>
                        <tr>
                            <th style="display:none">LocationID</th>
                            <th style="display:none">SparepartID</th>
                            <th class="th-sm">Ersatzteil-Nr</th>
                            <th class="th-sm">Ersatzteil</th>
                            <th class="th-sm">Lagerort</th>
                            <th class="th-sm">Lager</th>
                            <th class="th-sm">Verfügbar</th>
                            <th class="th-sm">Entnahme</th>
                            <th class="th-sm"></th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each vwItem In vwList.Items %>
                        <tr>
                            <td style="display:none"><%=vwItem.LocationID%></td>
                            <td style="display:none"><%=vwItem.SparepartID%></td>
                            <td><%=vwItem.SparepartNb%></td>
                            <td><%=vwItem.Sparepart%></td>
                            <td><%=vwItem.Location%></td>
                            <td><%=vwItem.Warehouse%></td>
                            <% If vwItem.LocAct >= vwItem.Act Then %>
                                <td><%=FormatNumber(vwItem.LocAct,2)%></td>
                                <td><%=FormatNumber(vwItem.Act,2)%></td>
                            <% Else %>
                                <td bgcolor="#FF0033"><%=FormatNumber(vwItem.LocAct,2)%></td>
                                <td bgcolor="#FF0033"><%=FormatNumber(vwItem.LocAct,2)%></td>
                            <% End If %>
                            <td><a href="javascript:deleteCartItemQue(<%=vwItem.ShoppingID%>,<%=vwItem.LocationID%>,<%=vwItem.SparepartID%>);" title="L&ouml;schen"><i style="font-size: 16px" class="fas fa-trash-alt"></i></a></td>
                        </tr>
                    <% Next %>
                    </tbody>
                    <tfoot>
                           <tr>
                               <td colspan="9">
                                   <div style="float:left">
                                        <button class="btn btn-danger btn-delete"><i class="fas fa-trash-alt"></i>&nbsp;Löschen</button>&nbsp;&nbsp;
                                        <% If IsMyCart Then %>
                                            <button class="btn btn-default btn-cancel"><i class="fas fa-sign-out-alt"></i>&nbsp;Ersatzteile hinzufügen</button>
                                        <% Else %>
                                            <button class="btn btn-default btn-cancel"><i class="fas fa-sign-out-alt"></i>&nbsp;Warenkörbe</button>
                                        <% End If %>
                                   </div>
                                   <div style="float:right">
                                        <button class="btn btn-primary btn-book"><i class="fas fa-toolbox"></i>&nbsp;Lager-entnahme</button>
                                   </div>
                               </td>
                           </tr>
                    </tfoot>
                </table>
            </div>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>
<!--Section: Table Plant-->
<!--Form: open ShoppingCart -->
<form id="frmcart" name="frmcart" method="POST" action="<%=curRootFile%>/cart/cartpost">
    <input name="id" id="id" type="hidden" value="">
</form>
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/cart/mycart.js?v1.0"></script>



