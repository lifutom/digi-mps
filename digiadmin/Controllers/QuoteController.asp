<%

Class QuotesController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    Public Sub Index

        Dim oHelper : Set oHelper = New QuoteHelper
        Dim bParam : Set bParam = New QuoteSearch

        ''bParam.ID = IIf(Session("orderid") = "",-99,Session("orderid"))
        ''bParam.PlantID = IIf(Session("plantid") = "",-1,Session("plantid"))
        ''bParam.DeviceID = IIf(Session("deviceid") = "",-1,Session("deviceid"))
        ''bParam.ModuleID = IIf(Session("moduleid") = "",-1,Session("moduleid"))
        bParam.SupplierID = IIf(Session("supplierid") = "",-1,Session("supplierid"))
        bParam.SearchTxt = IIf(Session("searchtxt") = "","",Session("searchtxt"))
        bParam.StartDate = IIf(Session("startdate") = "","",Session("startdate"))
        bParam.EndDate = IIf(Session("enddate") = "","",Session("enddate"))

        ''Dim plHelper : Set plHelper = New PlantHelper
        ''Dim mHelper : Set mHelper = New ModuleHelper
        Dim sHelper : Set sHelper = New SupplierHelper

        ''ViewData.Add "modlist", mHelper.ListDD()
        ''ViewData.Add "lines",  plHelper.DDSpareList()
        ''ViewData.Add "devices", plHelper.DeviceListDD(bParam.PlantID,True)
        
        ViewData.Add "suplist", sHelper.ListDD()
        ViewData.Add "search", bParam
        ViewData.Add "list", oHelper.List(bParam)
        %>   <!--#include file="../views/quote/index.asp" --> <%

    End Sub


    Public Sub IndexPost(args)


        If args("todo") <> "" Then
            ''Session("bookingid") = ""
            ''Session("plantid") = ""
            ''Session("deviceid") = ""
            ''Session("moduleid") = ""
            Session("supplierid") = ""
            Session("searchtxt") = ""
            Session("startdate") = ""
            Session("enddate") = ""
        Else
            ''Session("bookingid") = -1
            ''Session("plantid") = IIf(args("plantid") = "",-1,args("plantid"))
            ''Session("deviceid") = IIf(args("deviceid") = "",-1,args("deviceid"))
            ''Session("moduleid") = IIf(args("moduleid") = "",-1,args("moduleid"))
            Session("supplierid") = IIf(args("supplierid") = "",-1,args("supplierid"))
            Session("searchtxt") = IIf(args("searchtxt") = "","",args("searchtxt"))
            Session("startdate") = IIf(args("start") = "","",args("start"))
            Session("enddate") = IIf(args("end") = "","",args("end"))
        End If

        Response.Redirect(curRootFile & "/quotes")

    End Sub


    Public Sub Edit(vars)

        Dim sHelper : Set sHelper = New SupplierHelper
        ViewData.Add "suplist", sHelper.ListDD()

        Dim iItem

        If Request("id") > 0 Then
            Set iItem = New Quote
            iItem.ID = Request("id")
        Else
            Set iItem = New Quote
        End If

        ViewData.Add "item", iItem

        %>   <!--#include file="../views/quote/edit.asp" --> <%

    End Sub


    Public Sub EditPost(args)

        Dim SupplierID
        Dim QuoteDate
        Dim Description
        Dim Details

        Dim OrderID





        Dim QItem : Set QItem = New Quote
        Dim QDItem

        QItem.ID = args("id")
        QItem.QuoteDate = args("quotedate")
        QItem.SupplierID = args("supplierid")
        QItem.QuoteNb = args("quotenb")
        QItem.Description = args("description")

        For Each OrderID In args("orderid")
            Set QDItem = New QuoteItem
            QDItem.ID = OrderID
            QDItem.OrderID = OrderID
            QDItem.Qty = args("qty_" & OrderID)
            QItem.NewDetails.Add QDItem.ID, QDItem
        Next

        Dim NewID : NewID = IIf(QItem.Save, QItem.ID, 0)


        Response.Redirect("/" & CurRoot & "/quotes/edit/?partial=yes&id=" & NewID & "&idx=0")

    End Sub


    Public Sub Delete(vars)

        Dim QItem : Set QItem = New Quote

        QItem.ID = vars("id")
        QItem.Delete

        Response.Redirect("/" & CurRoot & "/quotes")

    End Sub


    Public Sub CreateOrder(vars)

        Dim QItem : Set QItem = New Quote

        QItem.ID = vars("id")
        QItem.CreateOrder

        Response.Redirect("/" & CurRoot & "/order/edit?partial=yes&id=" & QItem.OrderID & "&idx=0")

    End Sub


End Class

%>