<%

    Dim vwItem
    Dim vwColumn
    Dim vwField
    ''Dim vwRs : Set vwRs = ViewData("criticalstock")
    Dim vwRs : vwRs = ViewData("criticalstock")

%>
<style>
.embed-container {
    position: relative;
    padding-bottom: 56.25%; /* ratio 16x9 */
    height: 0;
    overflow: hidden;
    width: 100%;
    height: auto;
}
.embed-container iframe {

    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}
/* ratio 4x3 */
.embed-container.ratio4x3 {
    padding-bottom: 75%;
}
</style>
<section class="mb-5">
    <!--Javascript Variable-->
    <!--Card-->
    <div class="card card-cascade narrower">

        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Delivery Critical Stock&nbsp;&nbsp;KW-<%=glKW(Date)%>&nbsp;&nbsp;<%=Year(Date)%></a>
            <div class="float-right">
                 <a class="white-text" href="<%=curRootFile%>/tier3/deliverycritical" title="Refresh"><i class="fas fa-sync"></i></a>
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
                        <div class="card-body card-body-cascade">
                                <div class="embed-container">
                                    <iframe src="/digitier3/crst/<%=vwRs%>" frameborder="0" width="900" height="700" allowfullscreen></iframe>
                                </div>

                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
     <!-- Card -->
</section>