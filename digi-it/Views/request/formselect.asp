<!--Section -->
<section>
    <div class="col-md-12">
        <div class="card">
            <div class="card-header-black">
                <div class="float-left">
                    <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold"><%=GetLabel("lblRequestForm", Lang)%></h5>
                </div>
                <div class="float-right mr-2 mt-2">

                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-6">
                        <button type="button" class="btn-lg btn-cyan btn-block mb-3" id="btngrant"><%=GetLabel("btnGrant", Lang)%>&nbsp;<i class="<%=cRequestTypeGrantIcon%>"></i></button>
                        <button type="button" class="btn-lg btn-secondary btn-block mb-5" id="btnrevoke"><%=GetLabel("btnRevoke", Lang)%>&nbsp;<i class="<%=cRequestTypeRevokeIcon%>"></i></button>
                    </div>
                    <div class="col-6">
                        <!--<a href="/<%=CurRoot%>/downloads/VIE-15-003-IT-System-Formular.docx" class="btn-lg btn-green btn-block mb-3 text-center">Download: VIE-15-003-IT-System-Form&nbsp;<i class="<%=cTaskTypeDownloadIcon%>"></i></a>-->
                        <!--<a href="https://webview.merck.com/webview/getContentById/VIE-15-011-SOP-FRM01.docx?version=Current&format=&DocbaseName=mdasprd&ObjectId=0901435089359389&cid=0901435089027c61" class="btn-lg btn-green btn-block mb-3 text-center">Download: VIE-15-011-SOP-FRM01&nbsp;<i class="<%=cTaskTypeDownloadIcon%>"></i></a>-->
                        <!--<a href="/<%=CurRoot%>/downloads/VIE-15-001-SOP-FRM02.docx" class="btn-lg btn-green btn-block mb-3 text-center">Download: VIE-15-001-SOP-FRM02&nbsp;<i class="<%=cTaskTypeDownloadIcon%>"></i></a>-->
                    </div>
                </div>
                <!--<button type="button" class="btn-lg btn-primary btn-block mb-5" id="btnadmin">&nbsp;Digi-IT&nbsp;Backoffice&nbsp;<i class="<%=cDashboardIcon%>"></i></button>-->
                <a href="<%=curRootFile%>/dash" class="btn-lg btn-primary btn-block mb-5 text-center" target="_blank">&nbsp;Digi-IT&nbsp;Backoffice&nbsp;<i class="<%=cDashboardIcon%>"></i></a>
                <button type="button" class="btn-lg btn-grey btn-block" id="btnlogout"><%=GetLabel("btnLogout", Lang)%>&nbsp;<i class="fas fa-sign-out-alt"></i></button>
            </div>
        </div>
    </div>
</section>
<!--Section -->
<!-- javascript -->
<script src="<%=curRootFile%>/_js/request/formselect.js?v1.0"></script>