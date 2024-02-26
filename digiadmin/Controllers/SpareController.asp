<%

Class SpareController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index

        Dim pHelper : Set pHelper = New SpareHelper

        Dim pSearch : Set pSearch = New SpareSearch
        Dim List : Set List = pHelper.List(Nothing)

        Dim plHelper : Set plHelper = New PlantHelper


        Dim wHelper : Set wHelper = New WarehouseHelper


        Dim mHelper : Set mHelper = New ModuleHelper
        Dim sHelper : Set sHelper = New SupplierHelper

        Dim bHelper : Set bHelper = New BoxHelper
        ViewData.Add "boxlist", bHelper.DDList

        Dim catHelper : Set catHelper = New CategorieHelper
        ViewData.Add "catlist", catHelper.ListDD()

        Session("view") = IIf(Session("view")="","list",Session("view"))

        ViewData.Add "list", List
        ViewData.Add "modlist", mHelper.ListDD()
        ViewData.Add "suplist", sHelper.ListDD()
        ViewData.Add "lines",  plHelper.DDSpareList()
        ViewData.Add "devices", plHelper.DeviceListDD("-1",True)
        ViewData.Add "search", pSearch
        ViewData.Add "view", Session("view")
        ViewData.Add "warehouse", wHelper.ListDD()

        %>   <!--#include file="../views/spare/index.asp" --> <%

    End Sub


    public Sub IndexPost(args)

        Dim pHelper : Set pHelper = New SpareHelper
        Dim pSearch : Set pSearch = New SpareSearch

        pSearch.ModuleID = args("moduleid")
        pSearch.DeviceID = args("deviceid")
        pSearch.PlantID = args("plantid")
        pSearch.SupplierID = args("srcsupplierid")
        pSearch.SearchTxt = Trim(args("searchtxt"))
        pSearch.WarehouseID = args("searchwarehouseid")
        pSearch.ShelfID = args("searchshelfid")
        pSearch.CompID = args("searchcompid")
        pSearch.BoxID = args("searchboxid")
        pSearch.CatID = args("catid")

        Session("view") = args("vwview")
        
        Dim List : Set List = pHelper.List(pSearch)

        Dim plHelper : Set plHelper = New PlantHelper


        Dim bHelper : Set bHelper = New BoxHelper
        ViewData.Add "boxlist", bHelper.DDList

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

        %>   <!--#include file="../views/spare/index.asp" --> <%

    End Sub

    public Sub Edit(vars)

        Dim Item : Set Item = New Spare
        Item(vars("id"))
        Dim ActiveTab : ActiveTab = vars("tab")

        Dim sHelper : Set sHelper = New SupplierHelper
        Dim wHelper : Set wHelper = New WarehouseHelper
        Dim mHelper : Set mHelper = New ModuleHelper
        Dim plHelper : Set plHelper = New PlantHelper
        Dim catHelper : Set catHelper = New CategorieHelper

        Dim bHelper: Set bHelper = New BoxHelper



        ViewData.Add "tab", IIf(ActiveTab="" Or ActiveTab="undefined","location-tab",ActiveTab)
        ViewData.Add "modlist", mHelper.ListDD()
        ViewData.Add "catlist", catHelper.ListDD()
        ViewData.Add "spare", Item
        ViewData.Add "suplist", sHelper.ListDD()
        ViewData.Add "whlist", wHelper.ListDD()
        ViewData.Add "idx", vars("idx")
        ViewData.Add "lines",  plHelper.DDList("","")
        ViewData.Add "boxlist", bHelper.DDList()


        %>   <!--#include file="../views/spare/spareedit.asp" --> <%

    End Sub

    public Sub EditPost(args)

        Dim Item : Set Item = New Spare
        Item(args("id"))

        Item.SparepartNb = args("sparepartnb")
        Item.Sparepart = args("sparepart")
        Item.SpareNb = args("snb")
        Item.MinLevel = CDbl(args("minlevel"))
        Item.ActLevel = CDbl(args("act"))
        Item.MinOrderLevel = CDbl(args("minorderlevel"))
        Item.DefSupplierID = CInt(args("defsupplierid"))

        Item.TargetOrder = IIf(args("targetorder") <> "", 1, 0)
        Item.StartDate = args("startdate")
        Item.OrderLevel = args("orderlevel")
        Item.Intervall = args("intervall")
        Item.IntervallTyp = args("intervalltyp")
        Item.CatID = args("catid")

        Item.Active = args("active")

        Item.Save
        
        Response.Redirect(curRootFile & "/spare/edit/?partial=yes&id=" & args("id") & "idx=" & args("idx"))


    End Sub

End Class
%>