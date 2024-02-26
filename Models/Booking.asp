<%

Class BookingSearch

    Private prvBookingID
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
        prvBookingID = CLng(-1)
        prvSearch = ""
        prvSearchTxt = ""

        SetSQLStr

    End Sub


    Private Sub SetSQLStr

        Dim SQLStr : SQLStr = "SELECT * FROM vwBookingList WHERE 1=1"

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


        If CLng(prvBookingID) <> CLng(-1) Then
           SQLStr = SQLStr & " AND bookingid=" & prvBookingID
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
           SQLStr = SQLStr & " AND (LOWER(sparepartnb) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(sparepart) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(createdby) LIKE '%" & LCase(prvSearchTxt) & "%')"
        End If

        SQLStr = SQLStr & " ORDER BY created"

        prvSQLStr = SQLStr

    End Sub


End Class


Class BookingInfo

    Private prvBookingID

    Public Property Get ID
        ID = prvBookingID
    End Property

    Public Property Let ID (Value)
        prvBookingID = Value
        Init
    End Property

    Public Property Get BookingID
        BookingID = prvBookingID
    End Property

    Public Property Let BookingID(Value)
        prvBookingID = Value
    End Property

    Public TransferTypeID
    Public ShoppingID
    Public SparepartID
    Public LocationID
    Public MoveToLocationID
    Public WarehouseID
    Public ShelfID
    Public CompID
    Public BoxID
    Public Location
    Public Warehouse
    Public SparepartNb
    Public Sparepart
    Public TransferType
    Public CntAct
    Public Act
    Public Created
    Public CreatedBy
    Public LastEdit
    Public UserID

    Private Sub Class_Initialize()
        prvBookingID = -1
    End Sub

    Public Sub Init()

    End Sub

End Class



Class BookingHelper

    Public Function List(ByVal Param)

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = Param.SQLStr
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim iItem

        Do While Not Rs.Eof
            Set iItem = bItem(Rs)
            List.Add iItem.BookingID, iItem
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Private Function bItem(ByVal Rs)

        Set bItem = New BookingInfo

        bItem.BookingID = Rs("BookingID")
        bItem.TransferTypeID = Rs("TransferTypeID")
        bItem.ShoppingID = Rs("ShoppingID")
        bItem.SparepartID = Rs("SparepartID")
        bItem.LocationID = Rs("LocationID")
        ''bItem.MoveToLocationID = Rs("MoveToLocationID")
        bItem.WarehouseID = Rs("WarehouseID")
        bItem.ShelfID = Rs("ShelfID")
        bItem.CompID = Rs("CompID")
        bItem.BoxID = Rs("BoxID")
        bItem.Location = Rs("Location")
        bItem.Warehouse = Rs("Warehouse")
        bItem.SparepartNb = Rs("SparepartNb")
        bItem.Sparepart = Rs("Sparepart")
        bItem.TransferType = Rs("TransferType")
        bItem.CntAct = Rs("CntAct")
        bItem.Act = Rs("Act")
        bItem.Created = Rs("Created")
        bItem.CreatedBy = Rs("CreatedBy")
        bItem.LastEdit = Rs("LastEdit")
        bItem.UserID = Rs("UserID")

    End Function


End Class

%>