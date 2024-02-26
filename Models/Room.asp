<%

Class RoomItem

    Private prvID
    Private prvRoomID

    Public Property Get ID
        ID = prvRoomID
    End Property

    Public Property Let ID (Value)
        prvRoomID = IIf(Value="",-1,Value)
        Init
    End Property

    Public Property Get RoomID
        RoomID  = prvRoomID
    End Property

    Public Property Let RoomID  (Value)
        prvRoomID = Value
    End Property

    Public Nb
    Public Name
    Public RegionID
    Public Region
    Public RegionNb
    Public Active
    Public UserID
    Public LastEdit

    Public BuildingID
    Public BuildingNb
    Public Building

    Public SVPList

    Private Sub Class_Initialize()
        prvRoomID = -1
        UserID = Session("login")
        Set SVPList = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Private Sub Init

        If prvRoomID > 0 Then
            Dim SQLStr : SQLStr = "SELECT * FROM vwRoom WHERE roomid=" & prvRoomID
            Dim iRs : Set iRs = DbExecute(SQLStr)
            If Not iRs.Eof Then
                Nb = iRs("roomnb")
                Name = iRs("room")
                RegionID = iRs("regionid")
                Region = iRs("region")
                RegionNb = iRs("regionnb")
                Active = iRs("active")
                UserID = iRs("userid")
                LastEdit = IRs("lastedit")

                BuildingID = IRs("buildingid")
                BuildingNb = IRs("buildingnb")
                Building = IRs("building")
            End If
        End If

    End Sub

    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "RoomUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@RoomID", adInteger, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvRoomID

        Set Parameter = Cmd.CreateParameter("@Nb", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UCase(Nb)

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@RegionID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = RegionID

        Set Parameter = Cmd.CreateParameter("@BuildingID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = BuildingID

        Set Parameter = Cmd.CreateParameter("@Active", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

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

        Save = RetVal

    End Function


    Public Function Exists(ByVal actRoomNb)

        Dim SQLStr : SQLStr = "SELECT * FROM room WHERE UPPER(nb)='" & UCase(actRoomNb) & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close
        DbCloseConnection()

    End Function

End Class


Class Rooms

    Private Sub Class_Initialize()

    End Sub

    Public Function List

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM room ORDER BY nb"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("roomid")
            Item.Name = iRs("nb") & ":" & Left(iRs("name"),30)
            Item.Active = iRs("active")
            List.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function

    Public Function ListByRegion(ByVal BuildingID, ByVal RegionID)

        Set ListByRegion = Server.CreateObject("Scripting.Dictionary")

        Dim Filter : Filter = "1=1"

        If BuildingID <> "" AND BuildingID <> "-1" AND BuildingID <> "0" Then

            Filter = Filter & " AND buildingid=" & BuildingID

        End If

        If RegionID <> "" AND RegionID <> "-1" AND RegionID <> "0" Then

            Filter = Filter & " AND regionid=" & RegionID

        End If

        Dim SQLStr : SQLStr = "SELECT * FROM vwroom WHERE " & Filter & " ORDER BY roomnb"

        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("roomid")
            Item.Name = iRs("roomnb") & ":" & Left(iRs("room"),30)
            Item.Active = iRs("active")
            ListByRegion.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function

End Class

Class Room

    Public Function List

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM vwRoom ORDER BY roomnb"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

        Do While Not iRs.Eof
            Set Item = New RoomItem
            Item.RoomID = iRs("roomid")
            Item.nb = iRs("roomnb")
            Item.Name = iRs("room")
            Item.RegionID = iRs("regionid")
            Item.Region = iRs("region")
            Item.RegionNb = iRs("regionnb")
            Item.Active = iRs("active")
            Item.UserID = iRs("userid")
            Item.LastEdit = iRs("lastedit")
            Item.BuildingID = iRs("buildingid")
            Item.BuildingNb = iRs("buildingnb")
            Item.Building = iRs("building")
            List.Add Item.RoomID, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function

    Public Function DDList

        Set DDList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM vwRoom ORDER BY roomnb"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("roomid")
            Item.Name = iRs("roomnb") & " " & iRs("room")
            DDList.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function

End Class


Class RegionSVPItem

     Public RegionID
     Public UserID
     Public Name
     Public Active

End Class

Class RegionItem

    Private prvID
    Private prvRegionID

    Public Property Get ID
        ID = prvRegionID
    End Property

    Public Property Let ID (Value)
        prvRegionID = IIf(Value="",-1,Value)
        Init
    End Property

    Public Property Get RegionID
        RegionID  = prvRegionID
    End Property

    Public Property Let RegionID  (Value)
        prvRegionID = Value
    End Property

    Public Nb
    Public Name
    Public Active
    Public UserID
    Public LastEdit

    Public SVPList

    Private Sub Class_Initialize()
        prvRegionID = -1
        UserID = Session("login")
        Set SVPList = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Private Sub Init

        Dim Item

        If prvRegionID > 0 Then
            Dim SQLStr : SQLStr = "SELECT * FROM region WHERE regionid=" & prvRegionID
            Dim iRs : Set iRs = DbExecute(SQLStr)
            If Not iRs.Eof Then
               Nb = iRs("nb")
               Name = iRs("name")
               Active = iRs("active")
               UserID = iRs("userid")
               LastEdit = IRs("lastedit")
            End If

            SQLStr = "SELECT s.userid, s.active, s.regionid, ISNULL(u.lastname,'') + ' ' + ISNULL(u.firstname,'') As name  FROM region_svp s LEFT OUTER JOIN userlist u ON s.userid=u.userid WHERE regionid=" & prvRegionID


            Dim iiRs : Set iiRs = DbExecute(SQLStr)
            Do While Not  iiRs.Eof
                Set Item = New RegionSVPItem
                Item.RegionID = prvRegionID
                Item.Active = iiRs("active")
                Item.Name = iiRs("name")
                Item.UserID = iiRs("userid")
                SVPList.Add Item.UserID, Item
                iiRs.MoveNext
            Loop

            iRs.Close
            iiRs.Close
            Set iRs = Nothing
            Set iiRs = Nothing

        End If

    End Sub

    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "RegionUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@RegionID", adInteger, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvRegionID

        Set Parameter = Cmd.CreateParameter("@Nb", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UCase(Nb)

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@Active", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

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

        Save = RetVal

    End Function


    Public Function Exists(ByVal actNb)

        Dim SQLStr : SQLStr = "SELECT * FROM region WHERE UPPER(nb)='" & UCase(actNb) & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close
        DbCloseConnection()

    End Function

    Public Function RemSVPList()

         Set RemSVPList = Server.CreateObject("Scripting.Dictionary")
         Dim SQLStr : SQLStr = "SELECT userid, CASE WHEN ISNULL(lastname,'') = '' THEN userid ELSE ISNULL(lastname,'') + ' ' + ISNULL(firstname,'') END As name FROM userlist WHERE userid IN (SELECT userid FROM userlist_group WHERE groupid='coach') AND userid NOT IN (select userid FROM region_svp WHERE regionid=" & prvRegionID & ")"
         Dim iiRs : Set iiRs = DbExecute(SQLStr)

         Do While Not  iiRs.Eof
            Set Item = New ListItem
            Item.Value = iiRs("userid")
            Item.Name = iiRs("name")

            RemSVPList.Add Item.Value, Item
            iiRs.MoveNext
        Loop
        iiRs.Close
        Set iiRs = Nothing

    End Function

    Public Function SVPDelete(ByVal iUserID)

        Dim SQLStr : SQLStr = "DELETE FROM region_svp WHERE regionid=" & prvRegionID & " AND userid='" & iUserID & "'"
        DbExecute(SQLStr)

        SVPDelete = True

    End Function

    Public Function SVPAdd(ByVal iUserID)

        Dim SQLStr : SQLStr = "INSERT INTO region_svp (regionid, userid, active) VALUES(" & prvRegionID & ",'" & iUserID & "',1)"
        DbExecute(SQLStr)

        SVPAdd = True

    End Function


End Class




Class Region

     Public Function DDList

        Set DDList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM region ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

         Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("regionid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            DDList.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function

    Public Function List

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM region ORDER BY nb"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

        Do While Not iRs.Eof
            Set Item = New RoomItem
            Item.RegionID = iRs("regionid")
            Item.nb = iRs("nb")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.UserID = iRs("userid")
            Item.LastEdit = iRs("lastedit")
            List.Add Item.RegionID, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function


End Class


Class BuildingItem

    Private prvID
    Private prvBuildingID

    Public Property Get ID
        ID = prvBuildingID
    End Property

    Public Property Let ID (Value)
        prvBuildingID = IIf(Value="",-1,Value)
        Init
    End Property

    Public Property Get BuildingID
        BuildingID  = prvBuildingID
    End Property

    Public Property Let BuildingID  (Value)
        prvBuildingID = Value
    End Property

    Public Nb
    Public Name
    Public Active
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        prvRegionID = -1
        UserID = Session("login")
    End Sub

    Private Sub Init

        Dim Item

        If prvBuildingID > 0 Then
            Dim SQLStr : SQLStr = "SELECT * FROM building WHERE buildingid=" & prvBuildingID
            Dim iRs : Set iRs = DbExecute(SQLStr)
            If Not iRs.Eof Then
               Nb = iRs("buildingnb")
               Name = iRs("building")
               Active = iRs("active")
               UserID = iRs("userid")
               LastEdit = IRs("lastedit")
            End If
            iRs.Close
            Set iRs = Nothing
        End If

    End Sub

    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "BuildingUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@BuildingID", adInteger, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvBuildingID

        Set Parameter = Cmd.CreateParameter("@Nb", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UCase(Nb)

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@Active", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

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

        Save = RetVal

    End Function


    Public Function Exists(ByVal actNb)

        Dim SQLStr : SQLStr = "SELECT * FROM building WHERE UPPER(buildingnb)='" & UCase(actNb) & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close
        DbCloseConnection()

    End Function

End Class



Class Building

     Public Function DDList

        Set DDList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM building ORDER BY buildingnb"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

         Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("buildingid")
            Item.Name = iRs("buildingnb")
            Item.Active = iRs("active")
            DDList.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function

    Public Function List

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM building ORDER BY buildingnb"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

        Do While Not iRs.Eof
            Set Item = New BuildingItem
            Item.BuildingID = iRs("buildingid")
            Item.Nb = iRs("buildingnb")
            Item.Name = iRs("building")
            Item.Active = iRs("active")
            Item.UserID = iRs("userid")
            Item.LastEdit = iRs("lastedit")
            List.Add Item.BuildingID, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function


    Public Function RegionList (ByVal ID)

        Set RegionList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT DISTINCT v.regionid, v.region, r.Active FROM vwRoom v JOIN region r ON v.regionid=r.regionid WHERE v.regionid IS NOT NULL AND v.buildingid=" & ID & " ORDER BY v.region"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("regionid")
            Item.Name = iRs("region")
            Item.Active = iRs("active")
            RegionList.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function

     Public Function RoomList (ByVal ID)

        Set RoomList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT DISTINCT v.roomid, v.roomnb, v.room, v.Active FROM vwRoom v WHERE v.roomid IS NOT NULL AND v.buildingid=" & ID & " ORDER BY v.roomnb"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim Item

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("roomid")
            Item.Name = iRs("roomnb") & ":" & iRs("room")
            Item.Active = iRs("active")
            RoomList.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Function


End Class


%>