<%
Class SpareController

    Dim Model
    Dim ViewData
    Dim PlantList
    Dim ModuleList
    Dim DeviceList
    Dim mHelper

    Private Sub Class_Initialize()

        Set ViewData = Server.CreateObject("Scripting.Dictionary")

        Dim oPlant : Set oPlant = New PlantHelper
        Set PlantList = oPlant.PlantListMin()
        Set mHelper = New ModuleHelper

        If Session("activeline") = "" Then
            Session("activeline") = "9"
        End If
        If Session("activedevice") = "" Then
            Session("activedevice") = "33"
        End If
        Set ModuleList = mHelper.ListByDeviceID(Session("activedevice"),True)
        Set DeviceList = oPlant.DeviceListMin(Session("activeline"), True)

    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Sub Index()

        Dim oCart : Set oCart = New ShoppingCart
        oCart.InitByUserID(Session("login"))
        ViewData.Add "cart", oCart

        Dim pHelper : Set pHelper = New SpareHelper

        Dim pSearch : Set pSearch = New SpareSearch
        ' init SearchParam'

        pSearch.WarehouseID = IIf(Session("warehouseid")<>"", Session("warehouseid"), pSearch.WarehouseID)
        pSearch.ShelfID = IIf(Session("shelfid")<>"", Session("shelfid"), pSearch.ShelfID)
        pSearch.CompID = IIf(Session("compid")<>"", Session("compid"), pSearch.CompID)
        pSearch.BoxID = IIf(Session("boxid")<>"", Session("boxid"), pSearch.BoxID)

        Dim List : Set List = pHelper.List(pSearch)

        Dim plHelper : Set plHelper = New PlantHelper


        Dim wHelper : Set wHelper = New WarehouseHelper


        Dim mHelper : Set mHelper = New ModuleHelper
        Dim sHelper : Set sHelper = New SupplierHelper

        Dim bHelper: Set bHelper = New BoxHelper

        ViewData.Add "boxlist", bHelper.DDList()
        ViewData.Add "list", List
        ViewData.Add "modlist", mHelper.ListDD()
        ViewData.Add "suplist", sHelper.ListDD()
        ViewData.Add "lines",  plHelper.DDSpareList()
        ViewData.Add "devices", plHelper.DeviceListDD("-1",True)
        ViewData.Add "search", pSearch
        ViewData.Add "view", Session("view")
        ViewData.Add "warehouse", wHelper.ListDD()


        %>   <!--#include file="../views/Spare/Index.asp" --> <%

    End Sub

    Public Sub SearchPost(args)

        Session("warehouseid") = args("searchwarehouseid")
        Session("shelfid") = args("searchshelfid")
        Session("compid") = args("searchcompid")
        Session("boxid") = args("searchboxid")

        Response.Redirect(curRootFile & "/spare")

    End Sub

    Public Sub Clear

        Session("warehouseid") = ""
        Session("shelfid") = ""
        Session("compid") = ""
        Session("boxid") = ""

        Response.Redirect(curRootFile & "/spare")

    End Sub


End Class
%>