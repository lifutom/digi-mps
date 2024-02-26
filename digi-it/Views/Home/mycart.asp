<%

  Dim myCart : Set myCart = ViewData("cart")
  Dim vwList : Set vwList = myCart.ShoppingItems
  Dim vwItem

%>
<!--Section: Table-->
<section class="mb-5">


    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;DigiSpare&nbsp;<%=Application("version")%><%=IIf(Session("login") <> "", "&nbsp;(user: " & Session("login"),"")%>)</a>&nbsp;Warenkorb
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
                            <th class="th-sm">Lager</th>
                            <th class="th-sm">Lagerort</th>
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
                            <td><%=vwItem.Warehouse%></td>
                            <td><%=vwItem.Location%></td>
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
                </table>
            </div>
        </div>
        <div class="card-footer">
            <a class="btn btn-grey" href="<%=curRootFile & "/home/logout"%>">Logout</a>&nbsp;&nbsp;
            <a class="btn btn-primary" href="<%=curRootFile & "/home/spareparts"%>">Zurück</a>&nbsp;&nbsp;
            <button class="btn btn-default btn-book"><i class="fas fa-toolbox"></i>&nbsp;Lager-entnahme</button>
        </div>
    </div>
    <!--/.Card-->
</section>
<!--Form: open ShoppingCart -->
<form id="frmcart" name="frmcart" method="POST" action="<%=curRootFile%>/cart/cartpost">
    <input name="id" id="id" type="hidden" value="">
</form>
<!-- javascript -->
<script src="<%=curRootFile%>/_js/home/mycart.js?v.1.0"></script>





