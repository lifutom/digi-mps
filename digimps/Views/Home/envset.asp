<%

%>

<!-- active devices -->
<div class="row">
    <!-- Grid column -->
    <div class="col-xl-12 col-lg-12 mb-2">
        <div class="row">
            <div class="col-12">
                <h2 class="card-title font-weight-bold pt-0">
                        <strong>MSD Austria AH Wien 2019</strong>
                </h2>
            </div>
             <!--Image -->
             <div class="mt-5">
                <img src="<%=curRootFile%>/images/digimps.png" class="img-fluid rounded-bottom" alt="DigiMPS" title="DigiMPS">
            </div>
            <!--<div class="view zoom z-depth-1 rounded">
                <img src="./images/digimps.png" class="img-fluid rounded-bottom" alt="DigiMPS" title="DigiMPS">
            </div>-->
            <div class="col-12 mt-5 mb-5">
                <form name="frmsetenv" id="frmsetenv" action="home/index">
                    <% If hlpCont <> "" Then %>
                       Ihrem Device wurde&nbsp;<strong><%=hlpCont%></strong>&nbsp;zugeordnet.&nbsp;&nbsp;&nbsp;<a href="<%=CurRootFile%>" class="btn btn-success">Weiter</a>
                    <% Else %>
                       Es wurden bereits alle Controller vergeben.&nbsp;&nbsp;&nbsp;<a href="<%=CurRootFile%>" class="btn btn-danger">Weiter</a>
                    <% End If %>
                </form>

            </div>
    </div>
    <!-- Grid column -->
    </div>
</div>
<!-- /.active devices -->


