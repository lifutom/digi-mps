<%

Class OrderController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    Public Sub Index

        Dim oHelper : Set oHelper = New OrderHelper
        Dim bParam : Set bParam = New OrderSearch

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
        %>   <!--#include file="../views/order/index.asp" --> <%

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

        Response.Redirect(curRootFile & "/order")

    End Sub


    Public Sub Edit(vars)

        Dim sHelper : Set sHelper = New SupplierHelper
        ViewData.Add "suplist", sHelper.ListDD()

        Dim iItem

        If Request("id") > 0 Then
            Set iItem = New Order
            iItem.ID = Request("id")
        Else
            Set iItem = New Order
        End If

        ViewData.Add "item", iItem

        %>   <!--#include file="../views/order/edit.asp" --> <%

    End Sub


    Public Sub EditPost(args)

        Dim SupplierID
        Dim OrderDate
        Dim Description
        Dim Details
        Dim OrderID

        Dim QItem : Set QItem = New Order
        Dim QDItem

        QItem.ID = args("id")
        QItem.OrderDate = args("orderdate")
        QItem.SupplierID = args("supplierid")
        QItem.OrderNb = args("ordernb")
        QItem.Description = args("description")

        For Each OrderID In args("orderid")
            Set QDItem = New OrderItem
            QDItem.ID = OrderID
            QDItem.OrderID = OrderID
            QDItem.Qty = args("qty_" & OrderID)
            QDItem.Price = args("price_" & OrderID)
            QItem.NewDetails.Add QDItem.ID, QDItem
        Next

        Dim NewID : NewID = IIf(QItem.Save, QItem.ID, 0)


        Response.Redirect("/" & CurRoot & "/order/edit/?partial=yes&id=" & NewID & "&idx=0")

    End Sub


    Public Sub Delete(vars)

        Dim QItem : Set QItem = New Order

        QItem.ID = vars("id")
        QItem.Delete

        Response.Redirect("/" & CurRoot & "/order")

    End Sub


    Public Sub CreateOrder(vars)

        Dim QItem : Set QItem = New Order

        QItem.ID = vars("id")
        QItem.CreateOrder

        Response.Redirect("/" & CurRoot & "/order")

    End Sub


    Public Sub Receipt(vars)

        Dim sHelper : Set sHelper = New SupplierHelper
        ViewData.Add "suplist", sHelper.ListDD()

        Dim iItem

        If Request("id") > 0 Then
            Set iItem = New Order
            iItem.ID = Request("id")
        Else
            Set iItem = New Order
        End If

        ViewData.Add "item", iItem

        %>   <!--#include file="../views/order/receipt.asp" --> <%

    End Sub

    Public Sub ReceiptPost(args)

        Dim SupplierID
        Dim OrderDate
        Dim Description
        Dim Detail
        Dim NewDetail
        Dim OrderID

        Dim QItem : Set QItem = New Order

        QItem.ID = args("id")

        For Each OrderID In args("orderid")
            Set NewDetail = New OrderItem
            NewDetail.ID=CLng(OrderID)
            NewDetail.OrderID = CLng(OrderID)
            NewDetail.ReceiptQty = args("receiptqty_" & OrderID)
            NewDetail.ReceiptDate = args("receiptdate_" & OrderID)
            QItem.NewDetails.Add NewDetail.ID, NewDetail
        Next

        QItem.Book

        Response.Redirect("/" & CurRoot & "/order/Receipt/?partial=yes&id=" & QItem.ID & "&idx=0")

    End Sub


End Class

%>