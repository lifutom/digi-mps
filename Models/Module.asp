<%
Class ModulePlant

    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        If prvID <> "" Then
           Init
        End If
    End Property

    Public Property Get LinkID
        LinkID = prvID
    End Property

    Public Property Let LinkID (Value)
        prvID = Value
    End Property

    Private Sub Class_Initialize()
        EmptyObj
    End Sub

    Public ModuleID
    Public PlantID
    Public DeviceID
    Public UserID
    Public LastEdit

    Public Module
    Public Plant
    Public Device


    Private Sub Init

        Dim SQLStr : SQLStr = "SELECT * FROM vwModulePlant WHERE linkid=" & prvID
        Dim iRs : Set iRs = DBExecute(SQLStr)

        If Not iRs.Eof Then
           Fill (iRs)
        End If

        iRs.Close
        Set iRs = Nothing

    End Sub

    Public Sub Fill (ByVal Rs)

        prvId = Rs("linkid")
        ModuleID = Rs("moduleid")
        PlantID = Rs("plantid")
        DeviceID = Rs("deviceid")
        LastEdit = Rs("lastedit")
        UserID = Rs("userid")
        Module = Rs("module")
        Plant = Rs("plant")
        Device = Rs("device")

    End Sub

    Public Sub EmptyObj

        prvID = CLng(-1)
        ModuleID = -1
        PlantID = -1
        DeviceID = -1
        UserID = Session("login")
        LastEdit = ""
        Module = ""
        Plant = ""
        Device = ""

    End Sub


    Public Function Exists(ByVal mModuleID, ByVal mPlantID, ByVal mDeviceID)

        Exists = False

        Dim SQLStr : SQLStr = "SELECT * FROM vwModulePlant WHERE moduleid=" & mModuleID & " AND plantid=" & mPlantID & " AND deviceid=" & mDeviceID
        Dim iRs : Set iRs = DBExecute(SQLStr)

        If Not iRs.Eof Then
           Fill (iRs)
           Exists = True
        End If
        iRs.Close
        Set iRs = Nothing

    End Function

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ModulePlantUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@LinkID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@ModuleID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ModuleID

        Set Parameter = Cmd.CreateParameter("@PlantID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = PlantID

        Set Parameter = Cmd.CreateParameter("@DeviceID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DeviceID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = Cmd.Parameters("@LinkID").Value
            RetVal = True
            Init
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        Save = RetVal

    End Function

    Public Function Delete

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ModulePlantDelete"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@LinkID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = Cmd.Parameters("@LinkID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        Delete = retVal

    End Function

End Class


Class Module

    Public ModuleID
    Public Name
    Public Active
    Public IsCategorie
    Public UserID
    Public LastEdit
    Public IsInStand

    Private Sub Class_Initialize()
        ModuleID = -1
        Name =""
        Active = 0
        IsInStand = 0
        IsCategorie = 0
        UserID = Session("login")
        LastEdit = ""
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Default Sub Init(ByVal mID)

        ModuleID = mID
        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=0 AND moduleid=" & mID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            ModuleID = mID
            Name = iRs("name")
            Active = iRs("active")
            IsCategorie = iRs("iscategorie")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
            IsInStand = iRs("isinstand")
        End If

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ModuleUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ModuleID", adInteger, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ModuleID

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@Active", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Set Parameter = Cmd.CreateParameter("@IsCategorie", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IsCategorie

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Set Parameter = Cmd.CreateParameter("@IsInStand", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IsInStand

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            ModuleID = Cmd.Parameters("@ModuleID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Exists (ByVal mName)

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=0 AND LOWER(name)='" & LCase(mName) & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close

    End Function

End Class

Class ModuleHelper

    Public Function List ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=0 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set List = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Module
                Item.ModuleID = iRs("moduleid")
                Item.Name = iRs("name")
                Item.Active = iRs("active")
                Item.IsCategorie = iRs("iscategorie")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Item.IsInStand = iRs("isinstand")
                Results.Add Item.ModuleID, Item
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

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=0 AND active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set ActiveList = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Module
                Item.ModuleID = iRs("moduleid")
                Item.Name = iRs("name")
                Item.Active = iRs("active")
                Item.IsCategorie = iRs("iscategorie")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Item.IsInStand = iRs("isinstand")
                Results.Add Item.ModuleID, Item
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

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=0 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("name")
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

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=0 AND active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ActiveListDD = Results

    End Function


    Public Function ListByDeviceID(ByVal ID, ByVal WithEmpty)


        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=0 AND active=1 AND moduleid IN (SELECT DISTINCT moduleid FROM vwSparepartPlant WHERE deviceid=" & ID & ") ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ListByDeviceID = Results

    End Function


    Public Function ListByPlantID(ByVal ID, ByVal WithEmpty)


        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr
        If Not WithEmpty  Then
            SQLStr = "SELECT * FROM module WHERE iscategorie=0 AND active=1 AND moduleid IN (SELECT DISTINCT moduleid FROM vwSparepartPlant WHERE plantid=" & ID & ") ORDER BY name"
        Else
            If ID > 0 Then
               SQLStr = "SELECT * FROM module WHERE iscategorie=0 AND active=1 AND moduleid IN (SELECT DISTINCT moduleid FROM vwSparepartPlant WHERE plantid=" & ID & ") ORDER BY name"
            Else
               SQLStr = "SELECT * FROM module WHERE iscategorie=0 AND active=1 ORDER BY name"
            End If
        End If

        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ListByPlantID = Results

    End Function


    Public Function LinkList(ByVal ModuleID)


        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM vwModulePlant WHERE moduleid=" & ModuleID

        Dim iRs : Set iRs = DbExecute(SQLStr)



        Do While Not iRs.Eof
            Set Item = New ModulePlant
            Item.ID = iRs("linkid")
            Results.Add Item.ID, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        Set LinkList = Results

    End Function




End Class

%>