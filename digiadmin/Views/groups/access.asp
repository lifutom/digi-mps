<%

    Dim vwGroupAccess : Set vwGroupAccess = ViewData("groupaccess")
    Dim vwGroupID : vwGroupID = ViewData("groupid")
    Dim vwGroupName : vwGroupName = ViewData("groupname")
    Dim vwMenuItem
    Dim vwMenuSubItem

%>
<!--Section: Table GroupAccess-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <a href="" class="white-text text-center mx-3"><i class="fas fa-home"></i>&nbsp;Berechtigungen&nbsp;<%=vwGroupName%></a>
        </div>
        <!--/Card header-->

        <!--Card content-->
        <div class="card-body">

            <div class="table-responsive">
                <!-- GroupAccess -->
                <table id="dtgroupaccess" class="table table-bordered table-sm table-hover row-cursor" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th style="display:none">Active</th>
                            <th style="display:none">MenuID</th>
                            <th class="th-sm">Applikation</th>
                            <th class="th-sm">Menu</th>
                            <th class="th-sm">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% For Each vwMenuItem In vwGroupAccess.Items %>
                            <tr>
                                <td style="display:none"><%=vwMenuItem.Active%></td>
                                <td style="display:none"><%=vwMenuItem.MenuID%></td>
                                <td><b><%=vwMenuItem.App%></b></td>
                                <td><b><%=vwMenuItem.MenuName%></b></td>
                                <td><a href="javascript:toggleitem('<%=vwGroupID%>','<%=vwMenuItem.MenuID%>');"><%=IIf(vwMenuItem.Active = False,"<i class=""fas fa-ban"" title=""kein Zugriff""></i>","<i class=""far fa-check-circle"" title=""Zugriff""></i>")%></a></td>
                            </tr>
                            <% For Each vwMenuSubItem In vwMenuItem.SubMenuItems.Items %>

                               <tr>
                                <td style="display:none"><%=vwMenuSubItem.Active%></td>
                                <td style="display:none"><%=vwMenuSubItem.MenuID%></td>
                                <td></td>
                                <td><%=" - " & vwMenuSubItem.MenuName%></td>
                                <td><a href="javascript:toggleitem('<%=vwGroupID%>','<%=vwMenuSubItem.MenuID%>');"><%=IIf(vwMenuSubItem.Active = False,"<i class=""fas fa-ban"" title=""kein Zugriff""></i>","<i class=""far fa-check-circle"" title=""Zugriff""></i>")%></a></td>
                               </tr>

                            <% Next %>
                    <% Next %>
                    </tbody>
                </table>
            </div>
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>
<!--Section: Table Plant-->
<form id="access_form" name="access_form" method="post" action="<%=curRootFile%>/groups/accesspost">
     <input type="hidden" id="groupid" name="groupid" value="" />
</form>

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/groups/access.js?v1.0"></script>