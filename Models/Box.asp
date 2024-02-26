<%
Class Box

    Private prvID

    Public Property Get ID
        ID = prvID
    End Property
    Public Property Let ID (Value)
        prvID=Value
        Init
    End Property

    Public Property Get BoxID
        BoxID = prvID
    End Property
    Public Property Let BoxID (Value)
        prvID=Value
    End Property

    Public Name
    Public Created
    Public Active
    Public ShelfID
    Public CompID
    Public WarehouseID
    Public Warehouse
    Public LocationID
    Public Location

    Public UserID

    Public ContentList

    Private Sub Class_Initialize()
        prvID = 0
        Name = ""
        Created = ""
        Active = 1
        ShelfID = 0
        CompID = 0
        LocationID = 0
        Location = ""
        WarehouseID = 0
        Warehouse = ""
        UserID = Session("login")

        Set ContentList = Server.CreateObject("Scripting.Dictionary")
    End Sub


    Private Sub Init
        'fill object'
        Dim SQLStr : SQLStr ="SELECT * FROM vwBox WHERE boxid=" & prvID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Fill Rs, True
        Else
            Rs.Close
        End If
    End Sub

    Public Sub Fill(ByVal Rec, ByVal WithContent)

        prvID = Rec("boxid")
        Name = Rec("name")
        Created = Rec("created")
        Active = Rec("active")
        ShelfID = Rec("shelfid")
        CompID = Rec("compid")
        LocationID = Rec("locationid")
        WarehouseID = Rec("warehouseid")
        Location = Rec("location")
        Warehouse = Rec("warehouse")

    End Sub


    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "BoxUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@BoxID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function


    Public Function Exists( ByVal Name)

        Exists = False

        Dim SQLStr : SQLStr ="SELECT * FROM vwBox WHERE LOWER(name)='" & LCase(Name) &"'"
        Dim Rs : Set Rs = DbExecute(SQLStr)


        If Not Rs.Eof Then
            Exists = True
        End If

        Rs.Close
        Set Rs = Nothing

    End Function


    Public Function Move

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "BoxMove"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@BoxID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@LocationID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LocationID

        Set Parameter = Cmd.CreateParameter("@WarehouseID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = WarehouseID

        Set Parameter = Cmd.CreateParameter("@ShelfID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ShelfID

        Set Parameter = Cmd.CreateParameter("@CompID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CompID


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

        Move = RetVal

    End Function

End Class

Class BoxHelper


    Public Function List ()

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr ="SELECT * FROM vwBox ORDER BY boxid"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item
	Dim i : i=1

        Do While Not Rs.Eof
            Set Item = New Box
            Item.Fill Rs, False
            List.Add i, Item
	    i=i+1
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing
        DbCloseConnection()

    End Function


    Public Function DDList ()

        Set DDList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr ="SELECT DISTINCT boxid, name FROM vwBox ORDER BY boxid"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("boxid")
            Item.Name = Rs("name")
            Item.Active = 1
            Item.IconClass = ""
            DDList.Add Item.Value, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing
        DbCloseConnection()

    End Function


End Class

%>