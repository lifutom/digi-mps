<%

Class HomeController

    Dim Model
    Dim ViewData
    Dim PlantList
    Dim ModuleList
    Dim DeviceList
    Dim mHelper

    private sub Class_Initialize()
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

    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim oCart : Set oCart = New ShoppingCart
        oCart.InitByUserID(Session("login"))
        ViewData.Add "cart", oCart

        %>   <!--#include file="../views/Home/Index.asp" --> <%

    End Sub


    public Sub SpareIndex()


        Dim curLine : curLine = Session("activeline")
        Dim curDevice : curDevice = Session("activedevice")

        Session("catid") = ""
        Session("searchstr") = ""

        Dim oCart : Set oCart = New ShoppingCart
        oCart.InitByUserID(Session("login"))


        Dim catHelper : Set catHelper = New CategorieHelper
        ViewData.Add "catlist", catHelper.ListDD()

        ViewData.Add "list", PlantList
        ViewData.Add "modlist", ModuleList
        ViewData.Add "devicelist", DeviceList
        ViewData.Add "curline", curLine
        ViewData.Add "curdevice", curDevice
        ViewData.Add "cart", oCart


        %>   <!--#include file="../views/Home/SpareIndex.asp" --> <%

    End Sub

    Public Sub Logout

        Session("login") = Login
        Session("IsGuest") = False

        Link = curRootFile & "/login.asp"

        Session.Abandon
        Response.Redirect(Link)

    End Sub

    public Sub IndexPost(args)


        Session("activemoduleid") = args("moduleid")
        Session("catid") = args("catid")
        Session("searchstr") = args("searchstr")

        Response.Redirect(curRootFile & "/home/spareparts")


    End Sub

    Public Sub LinePost (args)

        Dim cLine : cLine = args("activeline")


        If cLine = "" Then
            Session("activeline") = "9"
            Session("activedevice") = "33"
        ElseIf cLine <> Session("activeline") Then
            Session("activeline") = cLine
            Select Case cLine
                Case 9:
                    Session("activedevice") = "33"
                Case 10:
                    Session("activedevice") = "37"
            End Select
        End If

        Response.Redirect(curRootFile & "/home/spareindex")


    End Sub

    Public Sub DevicePost (args)

        Dim cDevice : cDevice = args("activedevice")


        If cDevice = "" Then
            Select Case Session("activeline")
                Case 9:
                    Session("activedevice") = "33"
                Case 10:
                    Session("activedevice") = "37"
            End Select
        Else
            Session("activedevice") = cDevice
        End If

        Response.Redirect(curRootFile & "/home/spareindex")

    End Sub


    Public Sub SpareParts

        Dim cLine : cLine = Session("activeline")
        Dim cDevice : cDevice = Session("activedevice")
        Dim cModule : cModule = Session("activemoduleid")
        Dim cSearchStr : cSearchStr = Session("searchstr")

        Dim cCatID : cCatID = IIf(Session("catid") = "", 0, CInt(Session("catid")))

        Dim sHelper : Set sHelper = New SpareHelper
        Dim sParam : Set sParam = New SpareSearch

        If cCatID > 0 Then
            sParam.CatID = cCatID
        ElseIf cSearchStr <> "" Then
            sParam.SearchTxt = cSearchStr
        Else
            sParam.ModuleID = cModule
            sParam.DeviceID = cDevice
            sParam.PlantID = cLine
        End If

        Dim SparepartList : Set SparepartList = sHelper.List(sParam)

        Dim oCart : Set oCart = New ShoppingCart

        oCart.InitByUserID(Session("login"))

        ViewData.Add "list", SparepartList
        ViewData.Add "cart", oCart

        %><!--#include file="../views/Home/Spare.asp" --><%


    End Sub


    Public Sub Add2CartPost(args)



        Dim sCart : Set sCart = New ShoppingCart
        sCart.InitByUserID(Session("login"))

        Dim sItem : Set sItem = New ShoppingItem

        sItem.ShoppingID = sCart.ShoppingID
        sItem.SparepartID = args("sparepartid")
        sItem.LocationID = args("locationid")
        sItem.Act = args("actcnt")
        sItem.CreatedBy = Session("login")
        sItem.UserID = Session("login")
        sItem.Save

        Response.Redirect(curRootFile & "/home/spareparts")

    End Sub


    Public Sub MyCart


        Dim oCart : Set oCart = New ShoppingCart
        oCart.InitByUserID(Session("login"))
        
        ViewData.Add "cart", oCart


        %><!--#include file="../views/Home/MyCart.asp" --><%


    End Sub


End Class
%>