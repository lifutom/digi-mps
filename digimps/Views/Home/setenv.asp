<%
    Dim ListItems : Set ListItems = ViewData("plantitems")
%>
<!-- Modal SetDevice -->
<div class="modal fade" id="modalLinkForm" tabindex="-1" role="dialog" aria-labelledby="LinkControl"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
                <div class="modal-content">
                        <div class="modal-header text-center">
                                <div class="float-left ml-1 mt-1"><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="40" height="40"></div>
                                <h4 class="modal-title w-100 font-weight-bold"><i class="fas fa-home"></i>Auswahl Anlage</h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                </button>
                        </div>
                        <div class="modal-body mx-3">
                                <div class="md-form mb-2">
                                        <select id="plantid" name="plantid"class="browser-default custom-select" onchange="fill_control();">
                                                <option selected disabled>W&auml;hlen Sie die Anlage aus</option>
                                                <%

                                                    For Each Item In ListItems.Items

                                                        %><option value="<%=Item.ID%>"><%=Item.Name%></option><%

                                                    Next

                                                %>
                                        </select>
                                </div>
                                <div class="md-form mb-2">
                                        <select id="controlid" name="controlid" class="browser-default custom-select">
                                                <option selected disabled>W&auml;hlen Sie das Control-Device aus</option>
                                        </select>
                                </div>


                        </div>
                        <div class="modal-footer d-flex justify-content-center">
                                <button class="btn btn-danger" data-dismiss="modal">Abbrechen</button>
                                <button class="btn btn-default" id="sendbtn" onclick="setlink();">Zuordnen</button>
                        </div>
                </div>
        </div>
</div>
<!-- /.Modal Stop Downtime -->
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
                <img src="<%=curRootFile%>/images/digimps.png" class="img-fluid rounded-bottom" alt="DigiMPS" title="DigiMPS">
            </div>-->
            <div class="col-12 mt-5 mb-5">
                <!--<form name="frmsetenv" id="frmsetenv" action="<%=CurRootFile%>/home/setenvpost" method="post">-->


                    <div class="text-left">
                        <strong>Ihr Device wurde nicht zugeordnet.</strong>&nbsp;&nbsp;&nbsp;<a href="" class="btn btn-default mb-4" data-toggle="modal" data-target="#modalLoginForm">Zuordnen</a>
                    </div>

                    <!--<button class="btn btn-success stoppbtn" id="stoppbtn" onclick="login()">Zuordnen</button>-->



                <!--</form>-->

            </div>
        </div>
    <!-- Grid column -->
    </div>
</div>
<!-- /.active devices -->
<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/home/setenv.1.0.js"></script>


