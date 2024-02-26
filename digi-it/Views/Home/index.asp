<%
   Dim vwStateList : Set vwStateList = ViewData("statelist")
   Dim vwTaskStateList : Set vwTaskStateList = ViewData("taskstatelist")
   Dim vwReqItem : Set vwReqItem = ViewData("requeststat")

%>

<!--Section: Table-->
<section class="mt-md-4 pt-md-2 mb-5 pb-4">
    <div class="card-group">
        <div class="card text-center">
          <div class="card-header"><%=GetLabel("lblRequestlist", Lang) & " (" & vwReqItem.CntSum & ")"%></div>
          <div class="card-body">
            <h5 class="card-title"><%=vwStateList(cRequestAppoverStateOpened).Name%></h5>
            <p class="card-text">
                <%=vwReqItem.CntOpen%>
            </p>
            <h5 class="card-title"><%=vwStateList(cRequestAppoverStateGranted).Name%></h5>
            <p class="card-text">
                <%=vwReqItem.CntApproved%>
            </p>
            <h5 class="card-title"><%=vwStateList(cRequestAppoverStateRejected).Name%></h5>
            <p class="card-text">
                <%=vwReqItem.CntRejected%>
            </p>
          </div>
          <div class="card-footer text-muted"><%=DBFormatDate(Date)%></div>
        </div>

            <div class="card text-center ml-2">
              <div class="card-header"><%=GetLabel("mnuMainWorkListMaint", Lang) & " (" & vwReqItem.CntWorkItem & ")"%></div>
              <div class="card-body">
                <h5 class="card-title"><%=vwTaskStateList(cTaskStateOpened).Name%></h5>
                <p class="card-text">
                    <%=vwReqItem.CntWorkItemOpen%>
                </p>
                <h5 class="card-title"><%=vwTaskStateList(cTaskStateClosed).Name%></h5>
                <p class="card-text">
                    <%=vwReqItem.CntWorkItemClosed%>
                </p>
                <h5 class="card-title"><%=vwTaskStateList(cTaskStateCanceled).Name%></h5>
                <p class="card-text">
                    <%=vwReqItem.CntWorkItemCanceled%>
                </p>
              </div>
              <div class="card-footer text-muted"><%=DBFormatDate(Date)%></div>
            </div>
         
    </div>

</section>
<!--Section: Table-->

<!-- javascript -->
<script src="<%=curRootFile%>/_js/home/index.js?v1.0"></script>
