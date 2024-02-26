<%
'-------------------------------------------------'
' Quote'
'-------------------------------------------------'
Class QuoteSearch


    Private prvID
    Private prvPlantID
    Private prvDeviceID
    Private prvSupplierID
    Private prvSearch
    Private prvSearchTxt
    Private prvSQLStr
    Private prvModuleID
    Private prvStartDate
    Private prvEndDate

     Public Property Get StartDate
        StartDate = prvStartDate
    End Property

    Public Property Let StartDate (Value)
        prvStartDate = Value
        SetSQLStr
    End Property

    Public Property Get EndDate
        EndDate = prvEndDate
    End Property

    Public Property Let EndDate (Value)
        prvEndDate = Value
        SetSQLStr
    End Property

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID  (Value)
        prvID = Value
        SetSQLStr
    End Property


    Public Property Get ModuleID
        ModuleID = prvModuleID
    End Property

    Public Property Let ModuleID (Value)
        prvModuleID = Value
        SetSQLStr
    End Property

    Public Property Get PlantID
        PlantID = prvPlantID
    End Property

    Public Property Let PlantID (Value)
        prvPlantID = Value
        SetSQLStr
    End Property

    Public Property Get DeviceID
        DeviceID = prvDeviceID
    End Property

    Public Property Let DeviceID (Value)
        prvDeviceID = Value
        SetSQLStr
    End Property

    Public Property Get SupplierID
        SupplierID = prvSupplierID
    End Property

    Public Property Let SupplierID (Value)
        prvSupplierID = Value
        SetSQLStr
    End Property

    Public Property Get Search
        Search = prvSearch
    End Property

    Public Property Let Search (Value)
        prvSearch = Value
        SetSQLStr
    End Property

    Public Property Get SearchTxt
        SearchTxt = prvSearchTxt
    End Property

    Public Property Let SearchTxt (Value)
        prvSearchTxt = Value
        SetSQLStr
    End Property

    Public Property Get SQLStr
        SQLStr = prvSQLStr
    End Property



    Private Sub Class_Initialize()

        prvModuleID = -1
        prvPlantID = -1
        prvDeviceID = -1
        prvSupplierID = -1
        prvID = CLng(-1)
        prvSearch = ""
        prvSearchTxt = ""

        SetSQLStr

    End Sub


    Private Sub SetSQLStr

        Dim SQLStr : SQLStr = "SELECT * FROM vwQuote WHERE 1=1"

        If prvStartDate <> "" Or prvEndDate <> "" Then
            If prvStartDate <> "" And prvEndDate <> "" Then
               SQLStr = SQLStr & " AND CONVERT(date,created) BETWEEN '" & DBFormatDate(prvStartDate)  & "' AND '" & DBFormatDate(prvEndDate) & "'"
            Else
               If  prvStartDate <> "" Then
                   SQLStr = SQLStr & " AND CONVERT(date,created) >= '" & DBFormatDate(prvStartDate) & "'"
               Else
                   SQLStr = SQLStr & " AND CONVERT(date,created) <= '" & DBFormatDate(prvEndDate) & "'"
               End If
            End If
        End If


        If CLng(prvID) <> CLng(-1) Then
           SQLStr = SQLStr & " AND quoteid=" & prvID
        End If

        If CInt(prvSupplierID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND supplierid =" & prvSupplierID
        End If


        ''If CInt(prvModuleID) <> CInt(-1) Then
        ''   SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM sparepart_plant WHERE moduleid=" & prvModuleID & ")"
        ''End If

        ''If CInt(prvPlantID) <> CInt(-1) Then
        ''    If CInt(prvDeviceID) <> CInt(-1) Then
        ''        SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM sparepart_plant WHERE plantid=" & prvPlantID & " AND deviceid=" & prvDeviceID & ")"
        ''    Else
        ''        SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM sparepart_plant WHERE plantid=" & prvPlantID & ")"
        ''    End If
        ''End If



        If prvSearchTxt <> "" Then
           SQLStr = SQLStr & " AND (LOWER(quotenb) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(createdby) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(supplier) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(ordernb) LIKE '%" & LCase(prvSearchTxt) & "%')"
        End If

        SQLStr = SQLStr & " ORDER BY created"

        prvSQLStr = SQLStr

        ''Response.Write prvSQLStr

    End Sub

End Class


Class QuoteItem

    Public ID
    Public QuoteID
    Public OrderID
    Public Qty
    Public Price

    Public SparepartID
    Public Sparepart
    Public SparepartNb
    Public SupplierNb

    Public Created
    Public CreatedBy
    Public LastEdit
    Public UserID

    Private Sub Class_Initialize()
        ID = -1
        QuoteID = -1
        OrderID = -1
        Qty = 0.00
        Price = 0.00

        SparepartID = -1
        Sparepart = ""
        SparepartNb = ""
        SupplierNb = ""

        Created = ""
        CreatedBy = ""
        LastEdit = ""
        UserID = Session("login")
    End Sub


End Class



Class Quote

    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get QuoteID
        QuoteID = prvID
    End Property

    Public Property Let QuoteID(Value)
        prvID = Value
    End Property

    Public QuoteDate
    Public QuoteNb

    Public OrderNb
    Public OrderDate
    Public OrderID

    Public Description
    Public SupplierQuoteNb
    Public SupplierID
    Public Supplier

    Public StateID
    Public QuoteState

    Public Created
    Public CreatedBy
    Public LastEdit
    Public UserID

    Public Details
    Public NewDetails

    Private Sub Class_Initialize()
        prvID = -1
        StateID = 1
        OrderID = 0
        QuoteDate = Date
        Set Details = Server.CreateObject("Scripting.Dictionary")
        Set NewDetails = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Public Sub Init()

        Dim SQLStr : SQLStr = "SELECT * FROM vwQuote WHERE quoteid=" & prvID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Dim iiRs

        Dim iItem

        If Not iRs.Eof Then
            FillObject (iRs)
        End If

        DbCloseConnection()


    End Sub

    Public Sub FillObject(Rs)

        prvID = Rs("quoteid")
        QuoteDate = Rs("quotedate")
        QuoteNb = Rs("quotenb")
        OrderNb = Rs("ordernb")
        OrderDate = Rs("orderdate")

        OrderID = Rs("ordersid")
        Description = Rs("description")
        SupplierQuoteNb = Rs("supplierquotenb")
        SupplierID = Rs("supplierid")
        Supplier = Rs("supplier")


        StateID = Rs("stateid")
        QuoteState = Rs("quotestate")

        UserID = Rs("userid")
        LastEdit = Rs("lastedit")
        Created = Rs("created")
        CreatedBy = Rs("createdby")

        Dim iiRs

        Details.RemoveAll()

        Set iiRs = DbExecute("SELECT * FROM vwQuoteDetail WHERE quoteid=" & prvID & " ORDER BY OrderID")
        Do While Not iiRs.Eof
            Set iItem = New QuoteItem

            iItem.ID = iiRs("orderid")
            iItem.QuoteID = iiRs("quoteid")
            iItem.OrderID = iiRs("orderid")
            iItem.Qty = iiRs("quoteqty")
            iItem.Price = iiRs("price")
            iItem.SparepartID = iiRs("sparepartid")
            iItem.Sparepart = iiRs("sparepart")
            iItem.SparepartNb = iiRs("sparepartnb")
            iItem.SupplierNb = iiRs("suppliernb")
            iItem.Created = iiRs("created")
            iItem.CreatedBy = iiRs("createdby")
            iItem.LastEdit = iiRs("lastedit")
            iItem.UserID = iiRs("userid")
            Details.Add iItem.ID, iItem
            iiRs.MoveNext
        Loop
        iiRs.Close

    End Sub


    Public Function Save

        Dim retVal : retVal = False

        Dim myConn : Set myConn = DbOpenConnection()

        Dim dItem

        myConn.BeginTrans


        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")
        Dim CmdDet


        Cmd.CommandText = "QuoteUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@QuoteID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@SupplierID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SupplierID

        Set Parameter = Cmd.CreateParameter("@QuoteDate", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = QuoteDate

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Set Parameter = Cmd.CreateParameter("@StateID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = StateID

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = Cmd.Parameters("@QuoteID").Value
            RetVal = True


            'reset status'
            For Each dItem In Details.Items
                DbExecute("UPDATE orderlist SET stateid=0 WHERE orderid=" & dItem.OrderID)
            Next

            DbExecute("DELETE FROM quote_detail WHERE quoteid=" & prvID)

            For Each dItem In NewDetails.Items

                Set CmdDet = Server.CreateObject("ADODB.Command")

                CmdDet.CommandText = "QuoteDetailUpdate"
                CmdDet.CommandType = adCmdStoredProc
                Set CmdDet.ActiveConnection = myConn


                Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
                CmdDet.Parameters.Append Parameter

                Set Parameter = Cmd.CreateParameter("@OrderID", adBigInt, adParamInput)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = dItem.OrderID

                Set Parameter = Cmd.CreateParameter("@QuoteID", adBigInt, adParamInput)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = prvID

                Set Parameter = Cmd.CreateParameter("@Qty", adDouble, adParamInput)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = Replace(dItem.Qty,".",",")


                Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = Session("login")

                CmdDet.Execute

                If CmdDet.Parameters("@RETURN_VALUE").Value = -1 Then
                   myConn.RollbackTrans
                   Save = False
                   DbCloseConnection()
                   Exit Function
                End If

                DbExecute("UPDATE orderlist SET stateid=1 WHERE orderid=" & dItem.OrderID)

            Next

            myConn.CommitTrans
        Else
            myConn.RollbackTrans
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Delete

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Delete = False

        Cmd.CommandText = "QuoteDelete"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@QuoteID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = Cmd.Parameters("@QuoteID").Value
            Delete = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

    End Function


    Public Function CreateOrder

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        CreateOrder = False

        Cmd.CommandText = "CreateOrderFromQuote"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter


        Set Parameter = Cmd.CreateParameter("@OID", adBigInt, adParamOutput)
        Cmd.Parameters.Append Parameter


        Set Parameter = Cmd.CreateParameter("@QuoteID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            CreateOrder = True
            OrderID = Cmd.Parameters("@OID").Value
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

    End Function

    Public Function Receipt ()

        Dim PdfReport : Set PdfReport = New CreateReportAsPdf
        Receipt = PdfReport.CreateReceipt(prvID,"quote")

    End Function


End Class




Class QuoteHelper

    Public Function List(ByVal Param)

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = Param.SQLStr
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim iItem

        Do While Not Rs.Eof
            Set iItem = bItem(Rs)
            List.Add iItem.ID, iItem
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Private Function bItem(ByVal Rs)

        Set bItem = New Quote
        bItem.FillObject(Rs)

    End Function


End Class




'-------------------------------------------------'
' Order Proposal'
'-------------------------------------------------'
Class OrderPropSearch

    Private prvID
    Private prvPlantID
    Private prvDeviceID
    Private prvSupplierID
    Private prvSearch
    Private prvSearchTxt
    Private prvSQLStr
    Private prvModuleID
    Private prvStartDate
    Private prvEndDate

    Public Property Get StartDate
        StartDate = prvStartDate
    End Property

    Public Property Let StartDate (Value)
        prvStartDate = Value
        SetSQLStr
    End Property

    Public Property Get EndDate
        EndDate = prvEndDate
    End Property

    Public Property Let EndDate (Value)
        prvEndDate = Value
        SetSQLStr
    End Property

    Public Property Get BookingID
        BookingID = prvBookingID
    End Property

    Public Property Let BookingID  (Value)
        prvBookingID = Value
        SetSQLStr
    End Property


    Public Property Get ModuleID
        ModuleID = prvModuleID
    End Property

    Public Property Let ModuleID (Value)
        prvModuleID = Value
        SetSQLStr
    End Property

    Public Property Get PlantID
        PlantID = prvPlantID
    End Property

    Public Property Let PlantID (Value)
        prvPlantID = Value
        SetSQLStr
    End Property

    Public Property Get DeviceID
        DeviceID = prvDeviceID
    End Property

    Public Property Let DeviceID (Value)
        prvDeviceID = Value
        SetSQLStr
    End Property

    Public Property Get SupplierID
        SupplierID = prvSupplierID
    End Property

    Public Property Let SupplierID (Value)
        prvSupplierID = Value
        SetSQLStr
    End Property

    Public Property Get Search
        Search = prvSearch
    End Property

    Public Property Let Search (Value)
        prvSearch = Value
        SetSQLStr
    End Property

    Public Property Get SearchTxt
        SearchTxt = prvSearchTxt
    End Property

    Public Property Let SearchTxt (Value)
        prvSearchTxt = Value
        SetSQLStr
    End Property

    Public Property Get SQLStr
        SQLStr = prvSQLStr
    End Property



    Private Sub Class_Initialize()

        prvModuleID = -1
        prvPlantID = -1
        prvDeviceID = -1
        prvSupplierID = -1
        prvID = CLng(-1)
        prvSearch = ""
        prvSearchTxt = ""

        SetSQLStr

    End Sub


    Private Sub SetSQLStr

        Dim SQLStr : SQLStr = "SELECT * FROM vwOrderList WHERE 1=1"

        If prvStartDate <> "" Or prvEndDate <> "" Then
            If prvStartDate <> "" And prvEndDate <> "" Then
               SQLStr = SQLStr & " AND CONVERT(date,created) BETWEEN '" & DBFormatDate(prvStartDate)  & "' AND '" & DBFormatDate(prvEndDate) & "'"
            Else
               If  prvStartDate <> "" Then
                   SQLStr = SQLStr & " AND CONVERT(date,created) >= '" & DBFormatDate(prvStartDate) & "'"
               Else
                   SQLStr = SQLStr & " AND CONVERT(date,created) <= '" & DBFormatDate(prvEndDate) & "'"
               End If
            End If
        End If


        If CLng(prvID) <> CLng(-1) Then
           SQLStr = SQLStr & " AND orderid=" & prvID
        End If

        If CInt(prvModuleID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE moduleid=" & prvModuleID & ")"
        End If

        If CInt(prvPlantID) <> CInt(-1) Then
            If CInt(prvDeviceID) <> CInt(-1) Then
                SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE plantid=" & prvPlantID & " AND deviceid=" & prvDeviceID & ")"
            Else
                SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE plantid=" & prvPlantID & ")"
            End If
        End If

        If CInt(prvSupplierID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM sparepart_supplier WHERE supplierid=" & prvSupplierID & ")"
        End If

        If prvSearchTxt <> "" Then
           SQLStr = SQLStr & " AND (LOWER(sparepartnb) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(sparepart) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(createdby) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(suppliernb) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(supplier) LIKE '%" & LCase(prvSearchTxt) & "%')"
        End If

        SQLStr = SQLStr & " ORDER BY created"

        prvSQLStr = SQLStr

    End Sub


End Class


Class OrderPropItem

    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get OrderID
        OrderID = prvID
    End Property

    Public Property Let OrderID(Value)
        prvID = Value
    End Property

    Public SparepartID
    Public SparepartNb
    Public Sparepart

    Public OrderQty
    Public DeliveredQty
    Public Act

    Public SupplierID
    Public Supplier
    Public Price
    Public OrderNb

    Public StateID
    Public OrderState

    Public Created
    Public CreatedBy
    Public LastEdit
    Public UserID

    Public Suppliers


    Private Sub Class_Initialize()
        prvID = -1
        Set Suppliers = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Public Sub Init()

        Dim SQLStr : SQLStr = "SELECT * FROM vwOrderlist WHERE orderid=" & prvID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Dim iiRs

        Dim iItem

        If Not iRs.Eof Then
            FillObject (iRs)
            Set iiRs = DbExecute("SELECT * FROM vwSparepartSupplier WHERE active=1 AND sparepartid=" & SparepartID)
            Do While Not iiRs.Eof
                Set iItem = New SparepartSupplier
                iItem.SparepartID = iiRs("sparepartid")
                iItem.SupplierID = iiRs("supplierid")
                iItem.Supplier = iiRs("name")
                iItem.SpareNb = iiRs("sparenb")
                iItem.IsDefault = iiRs("isdefault")
                iItem.Price = iiRs("price")
                Suppliers.Add iItem.SupplierID, iItem
                iiRs.MoveNext
            Loop
            iiRs.Close
        End If

        DbCloseConnection()


    End Sub


    Public Sub FillObject(Rs)
        prvID = Rs("orderid")
        SparepartID = Rs("sparepartid")
        SupplierID = Rs("supplierid")
        Sparepart = Rs("sparepart")
        SparepartNb = Rs("sparepartnb")
        Supplier = Rs("supplier")
        OrderNb = Rs("suppliernb")
        OrderQty = Rs("orderqty")
        DeliveredQty = Rs("deliveredqty")
        StateID = Rs("stateid")
        OrderState = Rs("orderstate")
        Price = Rs("price")
        UserID = Rs("userid")
        LastEdit = Rs("lastedit")
        LastEditBy = Rs("userid")
        Created = Rs("created")
        CreatedBy = Rs("createdby")
        Act = Rs("act")
    End Sub


    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "OrderListUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@OrderID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@SparepartID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SparepartID

        Set Parameter = Cmd.CreateParameter("@SupplierID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SupplierID

        Set Parameter = Cmd.CreateParameter("@OrderQty", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Replace(OrderQty,".",",")

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = Cmd.Parameters("@OrderID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal


    End Function

    Public Function Delete

        Dim SQLStr : SQLStr = "DELETE FROM Orderlist WHERE orderid=" & prvID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Delete = True

    End Function



End Class



Class OrderPropHelper

    Public Function List(ByVal Param)

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = Param.SQLStr
        Dim Rs : Set Rs = DbExecute(SQLStr)
      
        Dim iItem

        Do While Not Rs.Eof
            Set iItem = bItem(Rs)
            List.Add iItem.ID, iItem
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Private Function bItem(ByVal Rs)

        Set bItem = New OrderPropItem
        bItem.FillObject(Rs)

    End Function


End Class


'-------------------------------------------------'
' Quote'
'-------------------------------------------------'
Class OrderSearch


    Private prvID
    Private prvPlantID
    Private prvDeviceID
    Private prvSupplierID
    Private prvSearch
    Private prvSearchTxt
    Private prvSQLStr
    Private prvModuleID
    Private prvStartDate
    Private prvEndDate

     Public Property Get StartDate
        StartDate = prvStartDate
    End Property

    Public Property Let StartDate (Value)
        prvStartDate = Value
        SetSQLStr
    End Property

    Public Property Get EndDate
        EndDate = prvEndDate
    End Property

    Public Property Let EndDate (Value)
        prvEndDate = Value
        SetSQLStr
    End Property

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID  (Value)
        prvID = Value
        SetSQLStr
    End Property


    Public Property Get ModuleID
        ModuleID = prvModuleID
    End Property

    Public Property Let ModuleID (Value)
        prvModuleID = Value
        SetSQLStr
    End Property

    Public Property Get PlantID
        PlantID = prvPlantID
    End Property

    Public Property Let PlantID (Value)
        prvPlantID = Value
        SetSQLStr
    End Property

    Public Property Get DeviceID
        DeviceID = prvDeviceID
    End Property

    Public Property Let DeviceID (Value)
        prvDeviceID = Value
        SetSQLStr
    End Property

    Public Property Get SupplierID
        SupplierID = prvSupplierID
    End Property

    Public Property Let SupplierID (Value)
        prvSupplierID = Value
        SetSQLStr
    End Property

    Public Property Get Search
        Search = prvSearch
    End Property

    Public Property Let Search (Value)
        prvSearch = Value
        SetSQLStr
    End Property

    Public Property Get SearchTxt
        SearchTxt = prvSearchTxt
    End Property

    Public Property Let SearchTxt (Value)
        prvSearchTxt = Value
        SetSQLStr
    End Property

    Public Property Get SQLStr
        SQLStr = prvSQLStr
    End Property



    Private Sub Class_Initialize()

        prvModuleID = -1
        prvPlantID = -1
        prvDeviceID = -1
        prvSupplierID = -1
        prvID = CLng(-1)
        prvSearch = ""
        prvSearchTxt = ""

        SetSQLStr

    End Sub


    Private Sub SetSQLStr

        Dim SQLStr : SQLStr = "SELECT * FROM vwOrders WHERE 1=1"

        If prvStartDate <> "" Or prvEndDate <> "" Then
            If prvStartDate <> "" And prvEndDate <> "" Then
               SQLStr = SQLStr & " AND CONVERT(date,created) BETWEEN '" & DBFormatDate(prvStartDate)  & "' AND '" & DBFormatDate(prvEndDate) & "'"
            Else
               If  prvStartDate <> "" Then
                   SQLStr = SQLStr & " AND CONVERT(date,created) >= '" & DBFormatDate(prvStartDate) & "'"
               Else
                   SQLStr = SQLStr & " AND CONVERT(date,created) <= '" & DBFormatDate(prvEndDate) & "'"
               End If
            End If
        End If


        If CLng(prvID) <> CLng(-1) Then
           SQLStr = SQLStr & " AND ordersid=" & prvID
        End If

        If CInt(prvSupplierID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND supplierid =" & prvSupplierID
        End If


        ''If CInt(prvModuleID) <> CInt(-1) Then
        ''   SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM sparepart_plant WHERE moduleid=" & prvModuleID & ")"
        ''End If

        ''If CInt(prvPlantID) <> CInt(-1) Then
        ''    If CInt(prvDeviceID) <> CInt(-1) Then
        ''        SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM sparepart_plant WHERE plantid=" & prvPlantID & " AND deviceid=" & prvDeviceID & ")"
        ''    Else
        ''        SQLStr = SQLStr & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM sparepart_plant WHERE plantid=" & prvPlantID & ")"
        ''    End If
        ''End If



        If prvSearchTxt <> "" Then
           SQLStr = SQLStr & " AND (LOWER(quotenb) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(ordernb) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(createdby) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(supplier) LIKE '%" & LCase(prvSearchTxt) & "%')"
        End If

        SQLStr = SQLStr & " ORDER BY created"

        prvSQLStr = SQLStr

        ''Response.Write prvSQLStr

    End Sub

End Class


Class OrderItem

    Public ID
    Public OrdersID
    Public QuoteDetailID
    Public OrderID
    Public Qty
    Public Price

    Public SparepartID
    Public Sparepart
    Public SparepartNb
    Public SupplierNb
    Public ManufacturNb

    Public PropQty
    Public QuoteQty
    Public ReceiptQty
    Public ReceiptDate

    Public OpenQty

    Public Created
    Public CreatedBy
    Public LastEdit
    Public UserID

    Public StatusID

    Private Sub Class_Initialize()
        ID = -1
        OrdersID = -1
        QuoteDetailID = -1
        OrderID = -1
        Qty = 0.00
        Price = 0.00

        SparepartID = -1
        Sparepart = ""
        SparepartNb = ""
        SupplierNb = ""
        ManufacturNb = ""

        PropQty = 0.00
        QuoteQty = 0.00
        ReceiptQty = 0.00
        OpenQty = 0.00
        ReceiptDate = Date

        Created = ""
        CreatedBy = ""
        LastEdit = ""
        UserID = Session("login")

        StatusID = 0
    End Sub


End Class



Class Order

    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get OrderID
        OrderID = prvID
    End Property

    Public Property Let OrderID(Value)
        prvID = Value
    End Property

    Public OrderNb
    Public OrderDate

    Public QuoteID
    Public QuoteDate
    Public QuoteNb

    Public Description
    Public SupplierQuoteNb
    Public SupplierID
    Public Supplier

    Public StateID
    Public OrderState

    Public Created
    Public CreatedBy
    Public LastEdit
    Public UserID

    Public Details
    Public NewDetails

    Private Sub Class_Initialize()
        prvID = -1
        QuoteID = 0
        StateID = 0
        OrderID = 0
        Set Details = Server.CreateObject("Scripting.Dictionary")
        Set NewDetails = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Public Sub Init()

        Dim SQLStr : SQLStr = "SELECT * FROM vwOrders WHERE ordersid=" & prvID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Dim iiRs

        Dim iItem

        If Not iRs.Eof Then
            FillObject (iRs)
        End If

        DbCloseConnection()


    End Sub

    Public Sub FillObject(Rs)

        prvID = Rs("ordersid")
        OrderNb = Rs("ordernb")
        OrderDate = Rs("orderdate")


        QuoteID = Rs("quoteid")
        QuoteDate = Rs("quotedate")
        QuoteNb = Rs("quotenb")

        Description = Rs("description")
        ''SupplierQuoteNb = Rs("supplierquotenb")
        SupplierID = Rs("supplierid")
        Supplier = Rs("supplier")


        StateID = Rs("stateid")
        OrderState = Rs("orderstate")

        UserID = Rs("userid")
        LastEdit = Rs("lastedit")
        Created = Rs("created")
        CreatedBy = Rs("createdby")

        Dim iiRs

        Details.RemoveAll()

        Set iiRs = DbExecute("SELECT * FROM vwOrdersDetail WHERE ordersid=" & prvID & " ORDER BY OrdersID")
        Do While Not iiRs.Eof
            Set iItem = New OrderItem

            iItem.ID = iiRs("orderid")
            iItem.OrdersID = prvID
            iItem.OrderID = iiRs("orderid")
            iItem.Qty = iiRs("orderqty")
            iItem.Price = iiRs("price")

            iItem.SparepartID = iiRs("sparepartid")
            iItem.Sparepart = iiRs("sparepart")
            iItem.SparepartNb = iiRs("sparepartnb")
            iItem.SupplierNb = iiRs("suppliernb")
            iItem.ManufacturNb = iiRs("manufacturenb")

            iItem.PropQty = iiRs("propqty")
            iItem.QuoteQty = iiRs("quoteqty")
            iItem.ReceiptQty = iiRs("receiptqty")

            iItem.OpenQty = IIf(iItem.Qty - iItem.ReceiptQty < 0, 0.00,iItem.Qty - iItem.ReceiptQty)

            iItem.Created = iiRs("created")
            iItem.CreatedBy = iiRs("createdby")
            iItem.LastEdit = iiRs("lastedit")
            iItem.UserID = iiRs("userid")


            Details.Add iItem.ID, iItem
            iiRs.MoveNext
        Loop
        iiRs.Close

    End Sub


    Public Function Save

        Dim retVal : retVal = False

        Dim myConn : Set myConn = DbOpenConnection()

        Dim dItem

        myConn.BeginTrans


        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")
        Dim CmdDet


        Cmd.CommandText = "OrdersUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@OrdersID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@QuoteID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = QuoteID

        Set Parameter = Cmd.CreateParameter("@SupplierID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SupplierID

        Set Parameter = Cmd.CreateParameter("@OrderDate", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OrderDate

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Set Parameter = Cmd.CreateParameter("@StateID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = StateID

        Cmd.Execute


        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = Cmd.Parameters("@OrdersID").Value
            RetVal = True

            For Each dItem In NewDetails.Items

                Set CmdDet = Server.CreateObject("ADODB.Command")

                CmdDet.CommandText = "OrdersDetailUpdate"
                CmdDet.CommandType = adCmdStoredProc
                Set CmdDet.ActiveConnection = myConn


                Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
                CmdDet.Parameters.Append Parameter

                Set Parameter = Cmd.CreateParameter("@OrderID", adBigInt, adParamInput)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = dItem.OrderID


                Set Parameter = Cmd.CreateParameter("@OrdersID", adBigInt, adParamInput)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = prvID

                Set Parameter = Cmd.CreateParameter("@Qty", adDouble, adParamInput)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = Replace(dItem.Qty,".",",")

                Set Parameter = Cmd.CreateParameter("@Price", adDouble, adParamInput)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = Replace(dItem.Price,".",",")


                Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
                CmdDet.Parameters.Append Parameter
                Parameter.Value = Session("login")

                CmdDet.Execute

                If CmdDet.Parameters("@RETURN_VALUE").Value = -1 Then
                   myConn.RollbackTrans
                   Save = False
                   DbCloseConnection()
                   Exit Function
                End If

            Next

            myConn.CommitTrans
        Else
            myConn.RollbackTrans
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Delete

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Delete = False

        Cmd.CommandText = "OrdersDelete"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@OrdersID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = Cmd.Parameters("@OrdersID").Value
            Delete = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

    End Function

    Public Function CreateOrder

        If Save Then
            DbExecute("UPDATE orders SET stateid=3 WHERE ordersid=" & prvID)
            DbExecute("UPDATE quote SET stateid=3 WHERE quoteid=" & QuoteID) 
            DbExecute("UPDATE orderlist SET stateid=3 WHERE orderid IN (SELECT orderid FROM orders_detail WHERE ordersid=" & prvID & ")")
        End If

    End Function


    Public Function Book

        Dim retVal : retVal = False

        Dim myConn : Set myConn = DbOpenConnection()

        Dim dItem

        myConn.BeginTrans

        For Each dItem In NewDetails.Items

            Set CmdDet = Server.CreateObject("ADODB.Command")

            CmdDet.CommandText = "OrdersDetailBook"
            CmdDet.CommandType = adCmdStoredProc
            Set CmdDet.ActiveConnection = myConn


            Set Parameter = CmdDet.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            CmdDet.Parameters.Append Parameter

            Set Parameter = CmdDet.CreateParameter("@OrderID", adBigInt, adParamInput)
            CmdDet.Parameters.Append Parameter
            Parameter.Value = dItem.OrderID


            Set Parameter = CmdDet.CreateParameter("@OrdersID", adBigInt, adParamInput)
            CmdDet.Parameters.Append Parameter
            Parameter.Value = prvID

            Set Parameter = CmdDet.CreateParameter("@Qty", adDouble, adParamInput)
            CmdDet.Parameters.Append Parameter
            Parameter.Value = Replace(dItem.ReceiptQty,".",",")

            Set Parameter = CmdDet.CreateParameter("@Date", adDate, adParamInput)
            CmdDet.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(dItem.ReceiptDate)

            Set Parameter = CmdDet.CreateParameter("@WarehouseID", adInteger, adParamInput)
            CmdDet.Parameters.Append Parameter
            Parameter.Value = GetAppSettings("receiptwh")

            Set Parameter = CmdDet.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
            CmdDet.Parameters.Append Parameter
            Parameter.Value = Session("login")

            CmdDet.Execute

            If CmdDet.Parameters("@RETURN_VALUE").Value = -1 Then
               myConn.RollbackTrans
               Book = False
               DbCloseConnection()
               Exit Function
            End If

        Next

        Set CmdDet = Server.CreateObject("ADODB.Command")

        CmdDet.CommandText = "OrdersBook"
        CmdDet.CommandType = adCmdStoredProc
        Set CmdDet.ActiveConnection = myConn

        Set Parameter = CmdDet.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        CmdDet.Parameters.Append Parameter

        Set Parameter = CmdDet.CreateParameter("@OrdersID", adBigInt, adParamInput)
        CmdDet.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = CmdDet.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        CmdDet.Parameters.Append Parameter
        Parameter.Value = Session("login")

        CmdDet.Execute

        If CmdDet.Parameters("@RETURN_VALUE").Value = -1 Then
            myConn.RollbackTrans
            Book = False
            DbCloseConnection()
            Exit Function
        End If

        myConn.CommitTrans

        Set CmdDet = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        RetVal = True

        Book = RetVal

    End Function



End Class


Class OrderHelper

    Public Function List(ByVal Param)

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = Param.SQLStr

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim iItem

        Do While Not Rs.Eof
            Set iItem = bItem(Rs)
            List.Add iItem.ID, iItem
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Private Function bItem(ByVal Rs)

        Set bItem = New Order
        bItem.FillObject(Rs)

    End Function


End Class



%>