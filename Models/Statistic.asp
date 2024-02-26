<%
Class StatSpareSearch

    Private prvModuleID
    Private prvPlantID
    Private prvDeviceID
    Private prvSupplierID
    Private prvSQLStr
    Private prvCatID
    Private prvWarehouseID

    Private prvStartDate
    Private prvEndDate


    Public Property Get CatID
        CatID = prvCatID
    End Property

    Public Property Let CatID (Value)
        prvCatID = IIf(Value <> "", Value, 0)
        SetSQLStr
    End Property

    Public Property Get WarehouseID
        WarehouseID = prvWarehouseID
    End Property

    Public Property Let WarehouseID (Value)
        prvWarehouseID = IIf(Value <> "", Value, -1)
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


    Public Property Get SQLStr
        SQLStr = prvSQLStr
    End Property



    Private Sub Class_Initialize()

        prvModuleID = -1
        prvPlantID = -1
        prvDeviceID = -1
        prvSupplierID = -1

        prvWarehouseID = -1

        prvCatID = 0

        prvStartDate = ""
        prvEndDate = ""

        SetSQLStr

    End Sub


    Private Sub SetSQLStr

        Dim SQLStrIn : SQLStrIn = "SELECT DISTINCT sparepartid FROM vwSparepart WHERE 1=1"

        If CInt(prvModuleID) <> CInt(-1) Then
           SQLStrIn = SQLStrIn & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE moduleid=" & prvModuleID & ")"
        End If

        If CInt(prvPlantID) <> CInt(-1) Then
            If CInt(prvDeviceID) <> CInt(-1) Then
                SQLStrIn = SQLStrIn & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE plantid=" & prvPlantID & " AND deviceid=" & prvDeviceID & ")"
            Else
                SQLStrIn = SQLStrIn & " AND sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE plantid=" & prvPlantID & ")"
            End If
        End If

        If CInt(prvSupplierID) <> CInt(-1) Then
           SQLStrIn = SQLStrIn & " AND (defsupplierid=" & prvSupplierID & ")"
        End If

        If CInt(prvWarehouseID) <> CInt(-1) Then
           SQLStrIn = SQLStrIn & " AND sparepartid IN (SELECT sparepartid FROM vwLocationWarehouse WHERE warehouseid=" & prvWarehouseID & ")"
        End If

        If CInt(prvCatID) <> CInt(0) Then
           SQLStrIn = SQLStrIn & " AND catid=" & prvCatID
        End If

        Dim sqlStartDate

        If prvStartDate <> "" Then
            sqlStartDate = "'" & DBFormatDate(prvStartDate) & "'"
        Else
            sqlStartDate = "'1900-01-01'"
        End If

        Dim sqlEndDate
        If prvEndDate <> "" Then
            sqlEndDate = "'" & DBFormatDate(prvEndDate) & "'"
        Else
            sqlEndDate = "'" & DBFormatDate(Date) & "'"
        End If


        DIm SQLStr : SQLStr = "SELECT * FROM dbo.tblSpareStatistic(" & sqlStartDate & "," & sqlEndDate & "," & prvWarehouseID & ",-1,-1,-1,-1,'') " & _
                        "WHERE sparepartid IN (" & SQLStrIn & ") " & _
                        " ORDER BY sparepart"
        prvSQLStr = SQLStr

    End Sub

End Class


Class StatSpareReport

    Public Amount
    Public Remove
    Public Receive

    Public List

    Private Sub Class_Initialize()
        Set List = Server.CreateObject("Scripting.Dictionary")
        Amount = 0
        Remove = 0
        Receive = 0
    End Sub

End Class


Class StatSpare

    Public SparepartID
    Public SparepartNb
    Public SpareNb
    Public Sparepart
    Public Price
    Public Act
    Public Amount
    Public actRemove
    Public cntRemove
    Public amountRemove
    Public actDelete
    Public cntDelete
    Public amountDelete
    Public actAdd
    Public cntAdd
    Public amountAdd
    Public actReceive
    Public cntReceive
    Public amountReceive

    Private Sub Class_Initialize()

        SparepartID = -1
        SparepartNb = ""
        SpareNb = ""
        Sparepart = ""
        Price = 0.00
        Act = 0.00
        Amount = 0.00
        actRemove = 0.00
        cntRemove = 0.00
        amountRemove = 0.00
        actDelete = 0.00
        cntDelete = 0.00
        amountDelete = 0.00
        actAdd = 0.00
        cntAdd = 0.00
        amountAdd = 0.00
        actReceive = 0.00
        cntReceive = 0.00
        amountReceive = 0.00

    End Sub

    Public Sub Fill(iRs)
        SparepartID = iRs("sparepartid")
        SparepartNb = iRs("sparepartnb")
        SpareNb = iRs("sparenb")
        Sparepart = iRs("sparepart")
        Price = iRs("price")
        Act = iRs("act")
        Amount = iRs("amount")
        actRemove = iRs("actRemove")
        cntRemove = iRs("cntRemove")
        amountRemove = iRs("amountRemove")
        actDelete = iRs("actDelete")
        cntDelete = iRs("cntDelete")
        amountDelete = iRs("amountDelete")
        actAdd = iRs("actAdd")
        cntAdd = iRs("cntAdd")
        amountAdd = iRs("amountAdd")
        actReceive = iRs("actReceive")
        cntReceive = iRs("cntReceive")
        amountReceive = iRs("amountReceive")
    End Sub


End Class


Class StatSpareHelper

    Public Function List (ByVal ParamSearch)

        Dim Results : Set Results = New StatSpareReport
        Dim Item

        If ParamSearch Is Nothing Then
            Set List = Results
            Exit Function
        End If

        Dim iRs : Set iRs = DbExecute(ParamSearch.SQLStr)

        Do While Not iRs.Eof
            Set Item = New StatSpare
            Item.Fill(iRs)
            Results.Amount = Results.Amount + Item.Amount
            Results.Receive = Results.Receive + Item.amountReceive + Item.amountAdd
            Results.Remove = Results.Remove + Item.amountRemove + Item.amountDelete
            Results.List.Add Item.SparepartID, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set List = Results

    End Function
End Class

%>