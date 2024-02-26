<%
Class SpareSearch

    Private prvModuleID
    Private prvPlantID
    Private prvDeviceID
    Private prvSupplierID
    Private prvSearch
    Private prvSearchTxt
    Private prvSQLStr

    Private prvWarehouseID
    Private prvShelfID
    Private prvCompID
    Private prvBoxID

    Private prvCatID

    Public Property Get CatID
        CatID = prvCatID
    End Property

    Public Property Let CatID (Value)
        prvCatID = IIf(Value <> "", Value, 0)
        SetSQLStr
    End Property

    Public Property Get BoxID
        BoxID = prvBoxID
    End Property

    Public Property Let BoxID (Value)
        prvBoxID = IIf(Value <> "", Value, -1)
        SetSQLStr
    End Property


    Public Property Get CompID
        CompID = prvCompID
    End Property

    Public Property Let CompID (Value)
        prvCompID = IIf(Value <> "", Value, -1)
        SetSQLStr
    End Property


    Public Property Get ShelfID
        ShelfID = prvShelfID
    End Property

    Public Property Let ShelfID (Value)
        prvShelfID = IIf(Value <> "", Value, -1)
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

        prvWarehouseID = -1
        prvShelfID = -1
        prvCompID = -1
        prvBoxID = -1

        prvCatID = 0

        prvSearch = ""
        prvSearchTxt = ""

        SetSQLStr

    End Sub


    Private Sub SetSQLStr

        Dim SQLStr : SQLStr = "SELECT s.*, ISNULL(p.proposedqty,0) As proposedqty, ISNULL(p.quotedqty,0) As quotedqty, ISNULL(p.ordercrqty,0) As ordercrqty, ISNULL(p.orderedqty,0) As orderedqty, ISNULL(p.receipedqty,0) As receipedqty , ISNULL(p.openqty,0) As openqty, ISNULL(p.orgorderqty,0) As orgorderqty FROM vwSparepart s LEFT OUTER JOIN tblSparePartQty() p ON s.sparepartid=p.sparepartid WHERE 1=1"

        If CInt(prvModuleID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND s.sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE moduleid=" & prvModuleID & ")"
        End If

        If CInt(prvPlantID) <> CInt(-1) Then
            If CInt(prvDeviceID) <> CInt(-1) AND CInt(prvModuleID) <> -1 Then
                SQLStr = SQLStr & " AND s.sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE plantid=" & prvPlantID & " AND deviceid=" & prvDeviceID & " AND moduleid=" & prvModuleID & ")"
            ElseIf CInt(prvDeviceID) <> CInt(-1) AND CInt(prvModuleID) = -1 Then
                SQLStr = SQLStr & " AND s.sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE plantid=" & prvPlantID & " AND deviceid=" & prvDeviceID & ")"
            Else
                SQLStr = SQLStr & " AND s.sparepartid IN (SELECT DISTINCT sparepartid FROM vwSparepartPlant WHERE plantid=" & prvPlantID & ")"
            End If
        End If

        If CInt(prvSupplierID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND (s.defsupplierid=" & prvSupplierID & ")"
        End If

        If prvSearchTxt <> "" Then
           SQLStr = SQLStr & " AND (LOWER(s.sparepartnb) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(s.sparepart) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(s.supplier) LIKE '%" & LCase(prvSearchTxt) & "%' OR LOWER(s.sparenb) LIKE '%" & LCase(prvSearchTxt) & "%')"
        End If

        If CInt(prvWarehouseID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND s.sparepartid IN (SELECT sparepartid FROM vwLocationWarehouse WHERE warehouseid=" & prvWarehouseID & ")"
        End If

        If CInt(prvShelfID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND s.sparepartid IN (SELECT sparepartid FROM vwLocationWarehouse WHERE shelfid=" & prvShelfID & ")"
        End If

        If CInt(prvCompID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND s.sparepartid IN (SELECT sparepartid FROM vwLocationWarehouse WHERE compid=" & prvCompID  & ")"
        End If

        If CInt(prvBoxID) <> CInt(-1) Then
           SQLStr = SQLStr & " AND s.sparepartid IN (SELECT sparepartid FROM vwLocationWarehouse WHERE boxid=" & prvBoxID  & ")"
        End If

        If CInt(prvCatID) <> CInt(0) Then
           SQLStr = SQLStr & " AND s.catid=" & prvCatID
        End If

        SQLStr = SQLStr & " ORDER BY s.sparepart"

        prvSQLStr = SQLStr

        ''Response.Write prvSQLStr

    End Sub


End Class

Class SparepartLink

    Private prvLinkID

    Public Property Get ID
        ID = prvLinkID
    End Property

    Public Property Let ID (Value)
        prvLinkID = Value
        If CLng(prvLinkID) <> CLng(-1) Then
           Init()
        End If
    End Property

    Public Property Get LinkID
        LinkID = prvLinkID
    End Property

    Public Property Let LinkID (Value)
        prvLinkID = Value
    End Property

    Public SparepartID
    Public SparepartNb
    Public Sparepart
    Public PlantID
    Public Plant
    Public DeviceID
    Public Device
    Public ModuleID
    Public Module
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()

        prvLinkID = -1
        SparepartID = -1
        SparepartNb = ""
        Sparepart = ""
        PlantID = -1
        Plant = ""
        DeviceID = -1
        Device = ""
        ModuleID = -1
        Module = ""
        UserID = ""
        LastEdit = ""

    End Sub

    Public Sub Init

        Dim SQLStr : SQLStr = "SELECT * FROM vwSparepartPlant WHERE linkid=" & prvLinkID & " AND sparepartid=" & SparepartID
        Dim iRs: Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            prvLinkID = iRs("linkid")
            SparepartID = iRs("sparepartid")
            SparepartNb = iRs("sparepartnb")
            Sparepart = iRs("sparepart")
            PlantID = iRs("plantid")
            Plant = iRs("plant")
            DeviceID = iRs("deviceid")
            Device = iRs("device")
            ModuleID = iRs("moduleid")
            Module = iRs("module")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
        End If
        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()


    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SparepartPlantUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@LinkID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvLinkID

        Set Parameter = Cmd.CreateParameter("@SparepartID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SparepartID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvLinkID = Cmd.Parameters("@LinkID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Delete

        Dim SQLStr : SQLStr = "DELETE FROM sparepart_plant WHERE linkid=" & prvLinkID & " AND sparepartid=" & SparepartID
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function

End Class


Class Location

    Private prvLocID

    Public Property Get LocationID
        LocationID = prvLocID
    End Property

    Public Property Let LocationID (Value)
        prvLocID = Value
        If CLng(prvLocID) <> CLng(-1) Then
           Init()
        End If
    End Property

    Public NoInit
    Public SparepartID
    Public WarehouseID
    Public Warehouse
    Public ShelfID
    Public CompID
    Public BoxID
    Public Name
    Public Act
    Public Active
    Public BoxName

    Private Sub Class_Initialize()

        SparepartID = -1
        LocationID = CLng(-1)
        WarehouseID = -1
        Warehouse = ""
        ShelfID = -1
        CompID = -1
        BoxID = -1
        Name = ""
        Act  = 0
        Active = 1
        NoInit = True
        BoxName = ""

    End Sub

    Public Sub Init
        If NoInit Then
        Else
            Dim SQLStr : SQLStr = "SELECT * FROM vwLocationWarehouse WHERE locationid=" & prvLocID
            Dim iRs: Set iRs = DbExecute(SQLStr)
            If Not iRs.Eof Then

                LocationID = iRs("locationid")
                WarehouseID = iRs("warehouseid")
                Warehouse = iRs("warehouse")
                ShelfID = iRs("shelfid")
                CompID = iRs("compid")
                BoxID = iRs("boxid")
                Name =  iRs("location")
                Act =   iRs("act")
                Active = iRs("active")
                SparepartID = iRs("sparepartid")
                BoxName = iRs("boxname")

            End If
            iRs.Close
            Set iRs = Nothing
            DbCloseConnection()
        End If

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SparepartLocationUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@LocationID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LocationID

        Set Parameter = Cmd.CreateParameter("@WarehouseID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = WarehouseID

        Set Parameter = Cmd.CreateParameter("@SparepartID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SparepartID

        Set Parameter = Cmd.CreateParameter("@ShelfID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ShelfID

        Set Parameter = Cmd.CreateParameter("@CompID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CompID

        Set Parameter = Cmd.CreateParameter("@BoxID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = BoxID

        Set Parameter = Cmd.CreateParameter("@Act", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Act

        Set Parameter = Cmd.CreateParameter("@Active", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            LocationID = Cmd.Parameters("@LocationID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal


    End Function

    Public Function Delete

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SparepartLocationDelete"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@LocationID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LocationID

        Set Parameter = Cmd.CreateParameter("@SparepartID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SparepartID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            LocationID = Cmd.Parameters("@LocationID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Delete = retVal

    End Function

    Public Function Exists(ByVal bID, ByVal spID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwLocationWarehouse WHERE boxid=" & bID & " AND sparepartid=" & spID
        Dim SQLStr1
        Dim iRs1
        Dim iRs: Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            LocationID = iRs("locationid")
            WarehouseID = iRs("warehouseid")
            Warehouse = iRs("warehouse")
            ShelfID = iRs("shelfid")
            CompID = iRs("compid")
            BoxID = iRs("boxid")
            Name =  iRs("location")
            Act =   iRs("act")
            Active = iRs("active")
            SparepartID = iRs("sparepartid")
            BoxName = iRs("boxname")
            Exists = True
        Else
            Exists = False
        End If
        iRs.Close
        DbCloseConnection()

    End Function

    Public Function BoxExists(ByVal bID)

        Dim SQLStr : SQLStr = "SELECT DISTINCT locationid, warehouseid, shelfid, compid, boxid, warehouse, location, name FROM vwBox WHERE locationid IS NOT NULL AND boxid=" & bID
        Dim iRs: Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then

            LocationID = iRs("locationid")
            WarehouseID = iRs("warehouseid")
            Warehouse = iRs("warehouse")
            ShelfID = iRs("shelfid")
            CompID = iRs("compid")
            BoxID = iRs("boxid")
            Name =  iRs("location")
            Act =   0
            Active = 0
            SparepartID = -1
            BoxName = iRs("name")
            BoxExists = True
        Else
            BoxExists = False
        End If
        iRs.Close
        DbCloseConnection()

    End Function

    Public Function LocationExists(ByVal wID, ByVal sID, ByVal cID, ByVal bID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwLocationWarehouse WHERE warehouseid=" & wID & " AND shelfid=" & sID & " AND compid=" & cID & " AND boxid=" & bID
        Dim iRs: Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            LocationID = iRs("locationid")
            WarehouseID = iRs("warehouseid")
            Warehouse = iRs("warehouse")
            ShelfID = iRs("shelfid")
            CompID = iRs("compid")
            BoxID = iRs("boxid")
            Name =  iRs("location")
            Act =   iRs("act")
            Active = iRs("active")
            SparepartID = iRs("sparepartid")
            BoxName = iRs("boxname")
            LocationExists = True
        Else
            LocationExists = False
        End If
        iRs.Close
        DbCloseConnection()

    End Function


    Public Function SpareAtLocationExists(ByVal lID, ByVal sID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwLocationWarehouse WHERE locationid=" & lID & " AND sparepartid=" & sID
        Dim iRs: Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            LocationID = iRs("locationid")
            WarehouseID = iRs("warehouseid")
            Warehouse = iRs("warehouse")
            ShelfID = iRs("shelfid")
            CompID = iRs("compid")
            BoxID = iRs("boxid")
            Name =  iRs("location")
            Act =   iRs("act")
            Active = iRs("active")
            SparepartID = iRs("sparepartid")
            BoxName = iRs("boxname")
            SpareAtLocationExists = True
        Else
            SpareAtLocationExists = False
        End If
        iRs.Close
        DbCloseConnection()

    End Function


    Public Sub InitBySparepartID(ByVal lID, ByVal sID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwLocationWarehouse WHERE locationid=" & lID & " AND sparepartid=" & sID
        Dim iRs: Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            LocationID = iRs("locationid")
            WarehouseID = iRs("warehouseid")
            Warehouse = iRs("warehouse")
            ShelfID = iRs("shelfid")
            CompID = iRs("compid")
            BoxID = iRs("boxid")
            Name =  iRs("location")
            Act =   iRs("act")
            Active = iRs("active")
            SparepartID = iRs("sparepartid")
            BoxName = iRs("boxname")
        End If
        iRs.Close
        DbCloseConnection()

    End Sub


    Public Function Move(ByVal OldID, ByVal NewID, ByVal Act, ByVal spID, ByVal bID, ByVal wID, ByVal sID, ByVal cID)

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SparepartLocationMove"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@OldLocationID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OldID

        Set Parameter = Cmd.CreateParameter("@NewLocationID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = NewID

        Set Parameter = Cmd.CreateParameter("@WarehouseID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = wID

        Set Parameter = Cmd.CreateParameter("@SparepartID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = spID

        Set Parameter = Cmd.CreateParameter("@ShelfID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = sID

        Set Parameter = Cmd.CreateParameter("@CompID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = cID

        Set Parameter = Cmd.CreateParameter("@BoxID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = bID

        Set Parameter = Cmd.CreateParameter("@Act", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Act

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            LocationID = Cmd.Parameters("@NewLocationID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Move = LocationID

    End Function

    Public Function StoreSpare(ByVal mSparepartID, ByVal mAct)

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SparepartStore"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        ''Response.Write  "SparepartStore " & prvLocID & "," & mSparepartID & "," & mAct & ",'" & Session("login") & "'"

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@LocationID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvLocID

        Set Parameter = Cmd.CreateParameter("@SparepartID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = mSparepartID

        Set Parameter = Cmd.CreateParameter("@Act", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = mAct

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        StoreSpare = RetVal

    End Function


End Class

Class SparepartSupplier

    Public SparepartID
    Public SupplierID
    Public Supplier
    Public SpareNb
    Public Price
    Public IsDefault
    Public Active
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()

        SparepartID = -1
        SupplierID = -1
        Supplier = ""
        SpareNb = ""
        IsDefault = 0
        Active = 1
        UserID = Session("login")
        LastEdit = ""

    End Sub

    Public Default Sub Init(ByVal mID, ByVal mSupplierID)

        SparepartID = mID
        SupplierID = mSupplierID

        Dim SQLStr : SQLStr = "SELECT * FROM vwSparepartSupplier WHERE active=1 AND sparepartid=" & SparepartID & " AND supplierid=" & SupplierID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            Supplier = iRs("name")
            SpareNb = iRs("sparenb")
            Price = iRs("price")
            IsDefault = iRs("isdefault")
            Active = iRs("active")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
        End If
        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SparepartSupplierUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@SupplierID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SupplierID

        Set Parameter = Cmd.CreateParameter("@SparepartID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SparepartID

        Set Parameter = Cmd.CreateParameter("@SpareNb", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SpareNb

        Set Parameter = Cmd.CreateParameter("@IsDefault", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IsDefault

        Set Parameter = Cmd.CreateParameter("@Price", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter

        Parameter.Value = Price ''Replace(Price,".",",")  'Price'


        Set Parameter = Cmd.CreateParameter("@Active", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            ID = Cmd.Parameters("@SupplierID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function


    Public Function Delete

        Dim SQLStr : SQLStr = "UPDATE sparepart_supplier SET active=0 WHERE sparepartid=" & SparepartID & " AND supplierid=" & SupplierID
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True


    End Function


End Class


Class Spare

    Private prvSparepartNb

    Public ID
    Public SparepartNbOrg

    Public Property Get SparepartNb
        SparepartNb = prvSparepartNb
    End Property

    Public Property Let SparepartNb(Value)
        prvSparepartNb =  Value
        If prvSparepartNb <> "" Then
           ImageName = SetImagePath
        End If
    End Property

    Public Sparepart
    Public SpareNb
    Public MinLevel
    Public ActLevel
    Public MinOrderLevel
    Public DefSupplierID
    Public Supplier
    Public ImageName
    Public PhysicalImagePath
    Public Active
    Public UserID
    Public LastEdit

    Public Locations
    Public Suppliers
    Public PlantLinks

    Public ErrMsg
    Public ErrStatus
    Public ErrNumber

    Private prvImagePath
    Public BinImage

    Public TargetOrder
    Public StartDate
    Public OrderLevel
    Public IntervallTyp
    Public Intervall
    Public CatID
    Public Categorie

    Public LocationCnt

    Public OrderQty
    Public OpenQty
    Public PropQty

    Private Sub Class_Initialize()
        ID = -1
        prvSparepartNb = ""
        SparepartNbOrg = ""
        Sparepart = ""
        SpareNb = ""
        MinLevel = 0
        ActLevel = 0
        MinOrderLevel = 0
        DefSupplierID = 0
        Supplier = ""
        Active = 0
        CatID = 0
        Categorie = ""
        ImageName = ""
        UserID = Session("login")
        LastEdit = ""
        Set Locations = Server.CreateObject("Scripting.Dictionary")
        Set Suppliers = Server.CreateObject("Scripting.Dictionary")
        Set PlantLinks = Server.CreateObject("Scripting.Dictionary")

        ErrMsg = ""
        ErrStatus = "OK"
        ErrNumber = 0

        TargetOrder = 0
        StartDate = ""
        OrderLevel = 0
        IntervallTyp = ""
        Intervall = 0
        LocationCnt = 0

        prvImagePath = GetAppSettings("spareimagepath")



    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Default Sub Init(ByVal mID)

        ID = mID
        ''Dim SQLStr : SQLStr = "SELECT * FROM vwSparepart WHERE sparepartid=" & mID

        Dim SQLStr : SQLStr = "SELECT s.*, ISNULL(p.proposedqty,0) As proposedqty, ISNULL(p.quotedqty,0) As quotedqty, ISNULL(p.ordercrqty,0) As ordercrqty, ISNULL(p.orderedqty,0) As orderedqty, ISNULL(p.receipedqty,0) As receipedqty , ISNULL(p.openqty,0) As openqty, ISNULL(p.orgorderqty,0) As orgorderqty FROM vwSparepart s LEFT OUTER JOIN tblSparePartQty() p ON s.sparepartid=p.sparepartid WHERE  s.sparepartid=" & mID

        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            ID = CLng(iRs("sparepartid"))
            prvSparepartNb = iRs("sparepartnb")
            SparepartNbOrg = prvSparepartNb
            ImageName = SetImagePath
            Sparepart = iRs("sparepart")
            SpareNb = iRs("sparenb")
            MinLevel = CDbl(iRs("min"))
            ActLevel = CDbl(iRs("act"))
            MinOrderLevel = CDbl(iRs("minorder"))
            DefSupplierID = CInt(iRs("defsupplierid"))
            Supplier = iRs("supplier")
            Active = iRs("active")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
            CatID = iRs("catid")
            Categorie = iRs("categorie")
            TargetOrder = iRs("targetorder")
            StartDate = iRs("startdate")
            OrderLevel = iRs("orderlevel")
            IntervallTyp = iRs("intervalltyp")
            Intervall = iRs("intervall")
            LocationCnt = iRs("locationcnt")
            OrderQty = iRs("orgorderqty")
            OpenQty = iRs("openqty")
            PropQty = iRs("proposedqty")


        End If

        SQLStr = "SELECT * FROM vwLocationWarehouse WHERE active=1 AND sparepartid=" & mID
        Set iRs = DbExecute(SQLStr)
        Dim Item
        ActLevel = 0
        Do While Not iRs.Eof
            Set Item = New Location
            Item.NoInit=True
            Item.LocationID = iRs("locationid")
            Item.WarehouseID = iRs("warehouseid")
            Item.Warehouse = iRs("warehouse")
            Item.ShelfID = iRs("shelfid")
            Item.CompID = iRs("compid")
            Item.BoxID = iRs("boxid")
            Item.Name =  iRs("location")
            Item.Act =   iRs("act")
            Item.BoxName = iRs("boxname")
            ActLevel = ActLevel + Item.Act
            Item.Active = iRs("active")

            ''Response.Write "Item.LocationID:" & Item.LocationID & "<br>"

            Locations.Add Item.LocationID , Item
            iRs.MoveNext
        Loop

        SQLStr = "SELECT * FROM vwSparepartSupplier WHERE active=1 AND sparepartid=" & mID
        Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New SparepartSupplier
            Item.SparepartID = iRs("sparepartid")
            Item.SupplierID = iRs("supplierid")
            Item.Supplier = iRs("name")
            Item.SpareNb = iRs("sparenb")
            Item.IsDefault = iRs("isdefault")
            Item.Price = iRs("price")
            Suppliers.Add Item.SupplierID, Item
            iRs.MoveNext
        Loop

        SQLStr = "SELECT * FROM vwSparepartPlant WHERE sparepartid=" & mID
        Set iRs = DbExecute(SQLStr)
        Do While Not iRs.Eof
            Set Item = New SparepartLink
            Item.LinkID = iRs("linkid")
            Item.SparepartID = iRs("sparepartid")
            Item.PlantID = iRs("plantid")
            Item.Plant = iRs("Plant")
            Item.DeviceID = iRs("deviceid")
            Item.Device = iRs("device")
            Item.ModuleID = iRs("moduleid")
            Item.Module = iRs("module")
            Item.UserID = iRs("userid")
            Item.LastEdit = iRs("lastedit")
            PlantLinks.Add Item.LinkID, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Sub

    Public Sub InitLocations(ByVal mID)

        Dim iRs
        Dim SQLStr

        Locations.RemoveAll

        SQLStr = "SELECT * FROM vwLocationWarehouse WHERE active=1 AND sparepartid=" & mID
        Set iRs = DbExecute(SQLStr)
        Dim Item
        ActLevel = 0
        Do While Not iRs.Eof
            Set Item = New Location
            Item.NoInit=True
            Item.LocationID = iRs("locationid")
            Item.WarehouseID = iRs("warehouseid")
            Item.Warehouse = iRs("warehouse")
            Item.ShelfID = iRs("shelfid")
            Item.CompID = iRs("compid")
            Item.BoxID = iRs("boxid")
            Item.Name =  iRs("location")
            Item.Act =   iRs("act")
            Item.BoxName = iRs("boxname")
            ActLevel = ActLevel + Item.Act
            Item.Active = iRs("active")

            ''Response.Write "Item.LocationID:" & Item.LocationID & "<br>"

            Locations.Add Item.LocationID , Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing

    End Sub

    Public Function Save

        If Exists Then
           Save = False
           Exit Function
        End If

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SpareUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@SparepartID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ID

        Set Parameter = Cmd.CreateParameter("@SparepartNb", adVarWChar, adParamInput, 25)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SparepartNb

        Set Parameter = Cmd.CreateParameter("@Sparepart", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Sparepart

        Set Parameter = Cmd.CreateParameter("@SpareNb", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SpareNb

        Set Parameter = Cmd.CreateParameter("@MinLevel", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = MinLevel

        Set Parameter = Cmd.CreateParameter("@ActLevel", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ActLevel

        Set Parameter = Cmd.CreateParameter("@MinOrderLevel", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = MinOrderLevel

        Set Parameter = Cmd.CreateParameter("@DefSupplierID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DefSupplierID

        Set Parameter = Cmd.CreateParameter("@TargetOrder", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TargetOrder

        Set Parameter = Cmd.CreateParameter("@Intervall", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Intervall

        Set Parameter = Cmd.CreateParameter("@IntervallTyp", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IntervallTyp

        If StartDate <> "" Then
            Set Parameter = Cmd.CreateParameter("@StartDate", adDate, adParamInput)
            Parameter.Value = StartDate
        Else
            Set Parameter = Cmd.CreateParameter("@StartDate", adDate, adParamInput,,Null)
        End If
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@OrderLevel", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OrderLevel

        Set Parameter = Cmd.CreateParameter("@CatID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CatID

        Set Parameter = Cmd.CreateParameter("@Active", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            ID = Cmd.Parameters("@SparepartID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Exists

        If SparepartNbOrg <> prvSparepartNb Then
            Dim SQLStr : SQLStr = "SELECT * FROM sparepart WHERE LOWER(sparepartnb)='" & LCase(prvSparepartNb) & "'"
            Dim iRs : Set iRs = DbExecute(SQLStr)
            If iRs.Eof Then
                Exists = False
                ErrMsg = ""
                ErrStatus = "OK"
                ErrNumber = 0
            Else
                Exists = True
                ErrMsg = "Artikelnummer existiert bereits"
                ErrStatus = "NOTOK"
                ErrNumber = -200
            End If
            iRs.Close
        Else
            Exists = False
            ErrMsg = ""
            ErrStatus = "OK"
            ErrNumber = 0
        End If


    End Function

    Public Function SetImagePath

        Dim Path : Path = prvImagePath
        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

        If prvSparepartNb <> "" Then
            If Fs.FileExists(Path & "\" & prvSparepartNb & ".jpg") Then
                SetImagePath = prvSparepartNb & ".jpg"

            ElseIf Fs.FileExists(Path & "\" & prvSparepartNb & ".jpeg") Then

                SetImagePath = prvSparepartNb & ".jpeg"

            ElseIf Fs.FileExists(Path & "\" & prvSparepartNb & ".png") Then

                SetImagePath = prvSparepartNb & ".png"

            Else
                SetImagePath = ""
            End If
            IF SetImagePath <> "" Then
                PhysicalImagePath  = prvImagePath & "\" & SetImagePath
                SetImagePath  = curRootFile & "/sparepart_images/" & SetImagePath
            Else
                PhysicalImagePath = ""
            End If

        Else
            SetImagePath = ""
            PhysicalImagePath = ""
        End If


    End Function


    Public Sub SaveImage (ByVal FileObj)


        If FileObj.FilePath <> ""  Then

            RemoveImage(prvImagePath & "\" & prvSparepartNb)

            Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
            Dim FileExt : FileExt =  Fs.GetExtensionName(FileObj.FilePath)

            FileObj.SaveAs prvImagePath & "\" & prvSparepartNb & "." & FileExt

        End If


    End Sub

    Public Sub RemoveImage(ByVal Path)

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

        If Fs.FileExists(Path & ".jpg") Then

            Fs.DeleteFile Path & ".jpg"
        ElseIf Fs.FileExists(Path & ".jpeg") Then
            Fs.DeleteFile Path & ".jpeg"
        ElseIf Fs.FileExists(Path & ".png") Then
            Fs.DeleteFile Path &".png"
        End If

    End Sub

    Public Sub RemovePath(ByVal Path)

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
      
        If Fs.FileExists(Path) Then
            Fs.DeleteFile Path, True
        End If

    End Sub


End Class

Class SpareHelper

    Public Function List (ByVal ParamSearch)

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        If ParamSearch Is Nothing Then
            Set List = Results
            Exit Function
        End If

        ''Response.Write ParamSearch.SQLStr
        ''Response.End

        Dim iRs : Set iRs = DbExecute(ParamSearch.SQLStr)

        If iRs.Eof Then
           Set List = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Spare
                Item.ID = iRs("sparepartid")
                Item.SparepartNb = iRs("sparepartnb")
                Item.Sparepart = iRs("sparepart")
                Item.SpareNb = iRs("sparenb")
                Item.MinLevel = iRs("min")
                Item.ActLevel = iRs("act")
                Item.MinOrderLevel = iRs("minorder")
                Item.DefSupplierID = iRs("defsupplierid")
                Item.Supplier = iRs("supplier")
                Item.Active = iRs("active")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")

                Item.TargetOrder = iRs("targetorder")
                Item.StartDate = iRs("startdate")
                Item.OrderLevel = iRs("orderlevel")
                Item.IntervallTyp = iRs("intervalltyp")
                Item.Intervall = iRs("intervall")
                Item.LocationCnt = iRs("locationcnt")
                Item.CatID = iRs("catid")
                Item.Categorie = iRs("categorie")
                Item.OrderQty = iRs("orgorderqty")
                Item.OpenQty = iRs("openqty")
                Item.PropQty = iRs("proposedqty")
                Item.SetImagePath
                Results.Add Item.ID, Item
                iRs.MoveNext
            Loop
            iRs.Close
            Set iRs = Nothing
            Set List = Results
        End If

    End Function

    Public Function ActiveList ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT s.*, ISNULL(p.proposedqty,0) As proposedqty, ISNULL(p.quotedqty,0) As quotedqty, ISNULL(p.ordercrqty,0) As ordercrqty, ISNULL(p.orderedqty,0) As orderedqty, ISNULL(p.receipedqty,0) As receipedqty , ISNULL(p.openqty,0) As openqty, ISNULL(p.orgorderqty,0) As orgorderqty FROM vwSparepart s LEFT OUTER JOIN tblSparePartQty() p ON s.sparepartid=p.sparepartid WHERE s.active=1 ORDER BY sparepart"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set ActiveList = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Spare
                Item.ID = iRs("sparepartid")
                Item.SparepartNb = iRs("sparepartnb")
                Item.Sparepart = iRs("sparepart")
                Item.SpareNb = iRs("sparenb")
                Item.MinLevel = iRs("min")
                Item.ActLevel = iRs("act")
                Item.MinOrderLevel = iRs("minorder")
                Item.DefSupplierID = iRs("defsupplierid")
                Item.Supplier = iRs("supplier")
                Item.Active = iRs("active")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Item.TargetOrder = iRs("targetorder")
                Item.StartDate = iRs("startdate")
                Item.OrderLevel = iRs("orderlevel")
                Item.IntervallTyp = iRs("intervalltyp")
                Item.Intervall = iRs("intervall")
                Item.LocationCnt = iRs("locationcnt")
                Item.CatID = iRs("catid")
                Item.Categorie = iRs("categorie")
                Item.OrderQty = iRs("orgorderqty")
                Item.OpenQty = iRs("openqty")
                Item.PropQty = iRs("proposedqty")
                Item.SetImagePath  
                Results.Add Item.ID, Item
                iRs.MoveNext
            Loop
            iRs.Close
            Set iRs = Nothing
            Set ActiveList = Results
        End If

    End Function

    Public Function ListDD ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM sparepart ORDER BY sparepart"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("sparepartid")
            Item.Name = iRs("sparepart")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ListDD = Results

    End Function



    Public Function ActiveListDD ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        SiteID = mSiteID
        Dim SQLStr : SQLStr = "SELECT * FROM sparepart WHERE active=1 ORDER BY sparepart"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("sparepartid")
            Item.Name = iRs("sparepart")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ActiveListDD = Results

    End Function



End Class

%>