<%
    Dim vwTypeList : Set vwTypeList = ViewData("typelist")
    Dim vwItem
%>
<!--Section: Table-->
<section>
    <div class="col-md-12">
        <div class="card">
            <div class="card-header-black">
                <div>
                    <div class="float-left">
                        <h5 class="ml-2 mt-2 dark-grey-text font-weight-bold"><i class="<%=cRequestAccessIcon%>"></i>&nbsp;<%=GetLabel("mnuMainAccessItem", Lang) & " " & UCase(ISID)%></h5>
                    </div>
                    <div class="float-right mr-2 mt-2">
                        <a href="#" id="refresh" name="refresh"><i style="font-size: 24px" class="<%=cRefreshButtonIcon%> mr-3"></i></a>
                    </div>
                </div>
                <div class="float-left col-12 ml-4">
                    <form class="form form-inline" id="form" name="form" action="user/accessmaintpost">
                        <input type="hidden" name="queDataDelete" id="queDataDelete" value="<%=GetLabel("queDataDelete", Lang)%>"/>
                        <input type="hidden" id="isid" name="isid" value="<%=ISID%>"/>
                        <input type="hidden" name="resp_accessitemtypeid" id="resp_accessitemtypeid" value="<%=vwAccessItemTypeID%>"/>
                        <input type="hidden" name="resp_accessitemid" id="resp_accessitemid" value="<%=vwAccessItemID%>"/>
                        <input type="hidden" name="resp_accessrightid" id="resp_accessrightid" value="<%=vwAccessRightID%>"/>

                        <div class="form-group row">
                            <label class="col-form-label form-label-inline" for="accessitemtypeid"><%=GetLabel("lblAccessItemType", Lang)%>:</label>
                            <select id="accessitemtypeid" class="form-control-inline browser-default custom-select search-drowdown">
                                <option value="" disabled="disabled">--<%=GetLabel("lblSelect", Lang)%>--</option>
                                <% For Each vwItem In vwTypeList.Items %>
                                    <option value="<%=vwItem.Value%>"<%=IIf(vwItem.Value=-1," selected","")%>><%=vwItem.Name%></option>
                                <% Next %>
                            </select>
                            &nbsp;&nbsp;
                            <label class="col-form-label form-label-inline" for="accessitemid"><%=GetLabel("lblAccessItem", Lang)%>:</label>
                            <select id="accessitemid" class="form-control-inline browser-default custom-select search-drowdown">
                                <option value="" disabled="disabled">--<%=GetLabel("lblSelect", Lang)%>--</option>
                            </select>
                            &nbsp;&nbsp;
                            <label class="col-form-label form-label-inline" for="accessrightid"><%=GetLabel("lblAccessRight", Lang)%>:</label>
                            <select id="accessrightid" class="form-control-inline browser-default custom-select search-drowdown">
                                <option value="" disabled="disabled">--<%=GetLabel("lblSelect", Lang)%>--</option>
                            </select>
                            &nbsp;&nbsp;
                            <button id="btnAdd" name="btnAdd" type="button" class="btn-sm btn-primary" title="<%=GetLabel("btnAdd", Lang)%>">
                                <span class="addbtn"><i class="fas fa-plus-circle"></i></span>
                            </button>
                        </div>
                    </form>

                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive mt-3">
                    <table id="dtlist" name="dtlist" class="table table-striped table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th class="th-sm"><%=GetLabel("lblAccessItemType", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblAccessItem", Lang)%></th>
                                <th class="th-sm"><%=GetLabel("lblARight", Lang)%></th>
                                <th style="display:none">AccessTypeID</th>
                                <th style="display:none">AccessItemID</th>
                                <th style="display:none">AccessRightID</th>
                                <th class="th-sm"><%=GetLabel("lblTyp", Lang)%></th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>
<!--Section: Table-->
<!-- javascript -->
<script src="<%=curRootFile%>/_js/user/accessmaint.js?v1.0"></script>