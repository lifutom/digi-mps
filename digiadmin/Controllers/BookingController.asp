<%

Class BookingController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    Public Sub Index

        Dim bHelper : Set bHelper = New BookingHelper
        Dim bParam : Set bParam = New BookingSearch

        bParam.BookingID = IIf(Session("bookingid") = "",-99,Session("bookingid"))
        bParam.PlantID = IIf(Session("plantid") = "",-1,Session("plantid"))
        bParam.DeviceID = IIf(Session("deviceid") = "",-1,Session("deviceid"))
        bParam.ModuleID = IIf(Session("moduleid") = "",-1,Session("moduleid"))
        bParam.SupplierID = IIf(Session("supplierid") = "",-1,Session("supplierid"))
        bParam.SearchTxt = IIf(Session("searchtxt") = "","",Session("searchtxt"))
        bParam.StartDate = IIf(Session("startdate") = "","",Session("startdate"))
        bParam.EndDate = IIf(Session("enddate") = "","",Session("enddate"))

        Dim plHelper : Set plHelper = New PlantHelper
        Dim mHelper : Set mHelper = New ModuleHelper
        Dim sHelper : Set sHelper = New SupplierHelper

        ViewData.Add "modlist", mHelper.ListDD()
        ViewData.Add "suplist", sHelper.ListDD()
        ViewData.Add "lines",  plHelper.DDSpareList()
        ViewData.Add "devices", plHelper.DeviceListDD(bParam.PlantID,True)
        ViewData.Add "search", bParam

        ViewData.Add "list", bHelper.List(bParam)
        %>   <!--#include file="../views/booking/index.asp" --> <%

    End Sub


    Public Sub IndexPost(args)


        If args("todo") <> "" Then
            Session("bookingid") = ""
            Session("plantid") = ""
            Session("deviceid") = ""
            Session("moduleid") = ""
            Session("supplierid") = ""
            Session("searchtxt") = ""
            Session("startdate") = ""
            Session("enddate") = ""
        Else
            Session("bookingid") = -1
            Session("plantid") = IIf(args("plantid") = "",-1,args("plantid"))
            Session("deviceid") = IIf(args("deviceid") = "",-1,args("deviceid"))
            Session("moduleid") = IIf(args("moduleid") = "",-1,args("moduleid"))
            Session("supplierid") = IIf(args("supplierid") = "",-1,args("supplierid"))
            Session("searchtxt") = IIf(args("searchtxt") = "","",args("searchtxt"))
            Session("startdate") = IIf(args("start") = "","",args("start"))
            Session("enddate") = IIf(args("end") = "","",args("end"))
        End If

        Response.Redirect(curRootFile & "/booking")

    End Sub






End Class

%>