<%
Class StatController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Spare

        Dim pHelper : Set pHelper = New StatSpareHelper

        Dim pSearch : Set pSearch = New StatSpareSearch
        Dim List : Set List = pHelper.List(Nothing)

        Dim plHelper : Set plHelper = New PlantHelper

        Dim wHelper : Set wHelper = New WarehouseHelper

        Dim mHelper : Set mHelper = New ModuleHelper
        Dim sHelper : Set sHelper = New SupplierHelper

        Dim catHelper : Set catHelper = New CategorieHelper
        ViewData.Add "catlist", catHelper.ListDD()

        Session("view") = IIf(Session("view")="","list",Session("view"))

        ViewData.Add "list", List
        ViewData.Add "modlist", mHelper.ListDD()
        ViewData.Add "suplist", sHelper.ListDD()
        ViewData.Add "lines",  plHelper.DDSpareList()
        ViewData.Add "devices", plHelper.DeviceListDD("-1",True)
        ViewData.Add "search", pSearch
        ViewData.Add "warehouse", wHelper.ListDD()

        %>   <!--#include file="../views/stat/spare.asp" --> <%

    End Sub


    public Sub SparePost(args)

        Dim pHelper : Set pHelper = New StatSpareHelper
        Dim pSearch : Set pSearch = New StatSpareSearch

        pSearch.ModuleID = args("moduleid")
        pSearch.DeviceID = args("deviceid")
        pSearch.PlantID = args("plantid")
        pSearch.SupplierID = args("srcsupplierid")
        pSearch.WarehouseID = args("searchwarehouseid")
        pSearch.CatID = args("catid")
        pSearch.StartDate = args("start")
        pSearch.EndDate = args("end")

        ''Response.Write pSearch.SQLStr

        Dim List : Set List = pHelper.List(pSearch)

        Dim plHelper : Set plHelper = New PlantHelper

        Dim catHelper : Set catHelper = New CategorieHelper
        ViewData.Add "catlist", catHelper.ListDD()

        Dim wHelper : Set wHelper = New WarehouseHelper
        Dim mHelper : Set mHelper = New ModuleHelper
        Dim sHelper : Set sHelper = New SupplierHelper


        Dim mList
        If CInt(pSearch.PlantID) <> CInt(-1) Then
            If CInt(pSearch.DeviceID) <> CInt(-1) Then
                Set mList = mHelper.ListByDeviceID(pSearch.DeviceID, True)
            Else
                Set mList = mHelper.ListByPlantID(pSearch.PlantID, True)
            End If
        Else
           Set mList = mHelper.ListDD()
        End If

        ViewData.Add "list", List
        ViewData.Add "modlist", mList
        ViewData.Add "suplist", sHelper.ListDD()
        ViewData.Add "lines",  plHelper.DDSpareList()
        ViewData.Add "devices", plHelper.DeviceListDD(pSearch.PlantID,True)
        ViewData.Add "search", pSearch
        ViewData.Add "view", Session("view")
        ViewData.Add "warehouse", wHelper.ListDD()

        %>   <!--#include file="../views/stat/spare.asp" --> <%

    End Sub



End Class
%>