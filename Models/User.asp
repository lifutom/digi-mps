<%

Class User

    Private mUserID

    Public Property Get UserID
        UserID = mUserID
    End Property

    Public Property Let UserID (Value)
        mUserID = Value
        If mUserID <> "" Then
            InitObject
        End If
    End Property

    Private prvGroupID

    Public Property Get  GroupID
         GroupID = prvGroupID
    End Property

    Public Property Let GroupID (Value)
        RefreshGroupList Value
    End Property

    Public myGroupList

    Public Group
    Public Active
    Public IsNew
    Public DepartmentID
    Public Department
    Public StreamType
    Public Area
    Public EMail
    Public FirstName
    Public LastName
    Public RoomID
    Public Room

    Private Sub Class_Initialize()
        mUserID = ""
        ''GroupID =""
        ''Group = ""
        DepartmentID = 0
        Department = ""
        RoomID = 0
        Room = ""
        Active = 1
        IsNew = True
        StreamType = ""
        Area = ""
        EMail = ""
        FirstName = ""
        LastName = ""
        Set myGroupList = Server.CreateObject("Scripting.Dictionary")


    End Sub

    Private Sub InitObject
         '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM vwUserlist WHERE userid='" & mUserID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            FillObject iRs
        Else
            IsNew = True
        End If
        iRs.Close

    End Sub


    Public Sub FillObject (ByVal Rec)

        mUserID = Rec("userid")
        ''GroupID = Rec("groupid")
        ''Group = Rec("groupname")
        DepartmentID = Rec("departmentid")
        Department = Rec("department")
        Active = Rec("active")
        IsNew = False
        StreamType = Rec("streamtype")
        Area = Rec("area")
        EMail = IIf(IsNull(Rec("email")),"",Rec("email"))
        FirstName = IIf(IsNull(Rec("firstname")),"",Rec("firstname"))
        LastName = IIf(IsNull(Rec("lastname")),"",Rec("lastname"))

        InitGroupList

    End Sub


    Public Sub  InitGroupList

        Dim gSQLStr : gSQLStr = "SELECT * FROM vwUserlistGroup WHERE userid='" & mUserID & "' ORDER BY groupname"
        Dim gRs : Set gRs = DbExecute(gSQLStr)
        Dim gItem

        Do While Not gRs.Eof
            Set gItem = New ListItem
            gItem.Value = gRs("groupid")
            gItem.Name = gRs("groupname")

            myGroupList.Add gItem.Value, gItem

            gRs.MoveNext
        Loop
        gRs.Close

        Set gRs = Nothing

    End Sub

    Public Sub  RefreshGroupList  ( ByVal Value)

        Dim ArrVal
        Dim i
        Dim hlpList : hlpList = ""

        myGroupList.RemoveAll()

        If Value <> "" Then

            ArrVal = Split(Value,",")
            For i=0 To UBound(ArrVal)
                If hlpList = "" Then
                    hlpList = "'" & Trim(ArrVal(i)) & "'"
                Else
                    hlpList =  hlpList & ",'" & Trim(ArrVal(i)) & "'"
                End If
            Next

            Dim gSQLStr : gSQLStr = "SELECT * FROM [group] WHERE groupid IN (" & hlpList & ") ORDER BY groupname"

            Dim gRs : Set gRs = DbExecute(gSQLStr)
            Dim gItem

            Do While Not gRs.Eof
                Set gItem = New ListItem
                gItem.Value = gRs("groupid")
                gItem.Name = gRs("groupname")
                myGroupList.Add gItem.Value, gItem

                gRs.MoveNext
            Loop
            gRs.Close

            Set gRs = Nothing

        End If

    End Sub


    Public Function GroupValues ()

        Dim hItem

        GroupValues = ""

        For Each hItem In myGroupList.Items

            If GroupValues = "" Then
                GroupValues = Trim(hItem.Value)
            Else
                GroupValues =  GroupValues & "," & Trim(hItem.Value)
            End If

        Next

    End Function



    Public Function Save

        If IsNew Then
           Save = Add
        Else
           Save = Update
        End If

    End Function


    Private Function AddOld()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "AddUser"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = mUserID

        Set Parameter = Cmd.CreateParameter("@GroupID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = GroupID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@EMail", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = EMail

        Set Parameter = Cmd.CreateParameter("@FirstName", adVarWChar, adParamInput, 25)
        Cmd.Parameters.Append Parameter
        Parameter.Value = FirstName

        Set Parameter = Cmd.CreateParameter("@LastName", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LastName

        Set Parameter = Cmd.CreateParameter("@Active", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing


        DbCloseConnection()

        AddOld = RetVal

    End Function

    Private Function Add

        Add = Update

    End Function

    Public Function Update()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "UpdateUser"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

         Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = mUserID

        Set Parameter = Cmd.CreateParameter("@GroupID", adVarWChar, adParamInput, 10, NULL)
        Cmd.Parameters.Append Parameter
        ''Parameter.Value = GroupID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@EMail", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = EMail

        Set Parameter = Cmd.CreateParameter("@FirstName", adVarWChar, adParamInput, 25)
        Cmd.Parameters.Append Parameter
        Parameter.Value = FirstName

        Set Parameter = Cmd.CreateParameter("@LastName", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LastName


        Set Parameter = Cmd.CreateParameter("@Active", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbExecute("DELETE FROM userlist_group WHERE userid='" & mUserID & "'")

        Dim gItem

        For Each gItem In myGroupList.Items

             DbExecute("INSERT INTO userlist_group (userid, groupid) VALUES ('" & mUserID & "','" & gItem.Value & "')")

        Next

        DbCloseConnection()

        Update = RetVal

    End Function

    Public Function Exists(ByVal tstID)

        Dim SQLStr : SQLStr = "SELECT * FROM userlist WHERE userid='" & tstID & "'"
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

Class UserHelper

    Public Function UserList



        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwUserlist ORDER BY userid"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New User
            Item.FillObject Rs
            List.Add Item.UserID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  UserList =  List

    End Function


    Public Function UserListDD

        Set UserListDD = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwUserlist ORDER BY userid"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("userid")
            Item.Name = Rs("userid") & IIf(Rs("lastname") <> "", ":&nbsp;" & Rs("lastname") & " " & Rs("firstname"),"")
            UserListDD.Add Item.Value, Item
            Rs.MoveNext
        Loop
        DbCloseConnection


    End Function


    Public Sub UpdateEmails()

        Dim List : Set List = UserList
        Dim AD : Set AD = New ADAccess
        Dim Item
        Dim AdItem

        For Each Item In List.Items
            Set AdItem = AD.EMailByISID(Item.UserID)
            If Not AdItem Is Nothing Then
               Item.FirstName = AdItem.FirstName
               Item.LastName = AdItem.LastName
               Item.Email = AdItem.Email
               Item.Save
            End If
        Next

    End Sub


End Class

Class ADUserAccessItem

    Public ID
    Public ISID
    Public AccessItemID
    Public AccessItem
    Public AccessTypeID
    Public AccessType
    Public AccessRightID
    Public AccessRight
    Public Manual
    Public ReqID
    Public ReqDetailID
    Public Created
    Public CreatedBy

    Public IsRevoked
    Public RevokedBy
    Public Revoked

    Public ErrMsg
    Public ErrNb

    Private Sub Class_Initialize()

        ISID=""
        AccessItemID=-1
        AccessItem=""
        AccessTypeID=-1
        AccessType=""
        AccessRightID=-1
        AccessRight=""
        Manual=0
        ReqID=-1
        ReqDetailID=-1
        Created = Now
        CreatedBy = Session("login")

        IsRevoked=0
        RevokedBy=""
        Revoked=""

        ErrMsg = ""
        ErrNb = 0

    End Sub

    Public Sub Init (ByVal hlpISID, ByVal hlpAccessItemID, ByVal hlpAccessRightID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwADUserAccessItem WHERE isrevoked=0 AND isid='" & hlpISID & "' AND accessitemid=" &  hlpAccessItemID & " AND accessrightid=" & hlpAccessRightID
        Dim Rs : Set Rs = DbExecute(SQLStr)
        If Not Rs.Eof Then
           Fill(Rs)
        End If
        Rs.Close
        Set Rs = Nothing

    End Sub


    Public Sub Fill (ByVal Rs)

        ISID = Rs("isid")
        ID = ISID
        AccessItemID  = Rs("accessitemid")
        AccessItem  = Rs("accessitem")
        AccessTypeID = Rs("accesstypeid")
        AccessType = Rs("accesstype")
        AccessRightID = Rs("accessrightid")
        AccessRight = Rs("accessright")
        ReqID = Rs("reqid")
        ReqDetailID = Rs("reqdetailid")
        Created = Rs("created")
        CreatedBy = Rs("createdby")
        Manual = Rs("manual")
        IsRevoked = Rs("isrevoked")
        RevokedBy = Rs("revokedby")
        Revoked = Rs("revoked")
    End Sub

    Public Sub Save

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ADUserAccessItemUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ISID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ISID

        Set Parameter = Cmd.CreateParameter("@AccessItemID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccessItemID

        Set Parameter = Cmd.CreateParameter("@AccessRightID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccessRightID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CreatedBy

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = -1 Then
            ErrNb = 1
            ErrMsg = GetLabel("msgDataSaveError",Session("lang"))
        Else
            ErrMsg = GetLabel("msgDataSaveSuccess",Session("lang"))
        End If

        Set Cmd = Nothing

    End Sub

    Public Function Delete

        If Manual = 1 Then

            Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

            Cmd.CommandText = "ADUserAccessItemDelete"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()

            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@ISID", adVarWChar, adParamInput, 50)
            Cmd.Parameters.Append Parameter
            Parameter.Value = ISID

            Set Parameter = Cmd.CreateParameter("@AccessItemID", adBigInt, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = AccessItemID

            Set Parameter = Cmd.CreateParameter("@AccessRightID", adBigInt, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = AccessRightID

            Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
            Cmd.Parameters.Append Parameter
            Parameter.Value = CreatedBy

            Cmd.Execute

            If Cmd.Parameters("@RETURN_VALUE").Value = -1 Then
                ErrNb = 1
            End If
            Set Cmd = Nothing

        End If

        If ErrNb = 1 Then
            ErrMsg = ToUTF8(GetLabel("msgDataDeleteError",Session("lang")))
            Delete = False
        Else
            Delete = True
            ErrMsg = ToUTF8(GetLabel("msgDataDeleteSuccess",Session("lang")))
        End If

    End Function

End Class


Class ADUser

    Private prvID

    Public Property Get ID
        ID=prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public IsID

    Private prvErrorNb
    Public Property Get ErrNb
        ErrNb = prvErrorNb
    End Property

    Private prvErrMsg
    Public Property Get ErrMsg
        ErrMsg = prvErrMsg
    End Property


    Public Firstname
    Public Lastname
    Public DisplayName
    Public EMail

    Public DepartmentID
    Public Department

    Public ADDepartment
    Public ManagerISID

    Public RoomID
    Public Room

    Public Enabled

    Public AccessItemList
    Public ManualAccessItemList
    Public Delegates


    Public AccessRight
    Public AccessItem
    Public AccessType
    Public Manager


    Private Sub Class_Initialize()

        prvID = ""
        IsID = ""

        Firstname = ""
        Lastname = ""
        DisplayName = ""
        EMail = ""

        DepartmentID = -1
        Department = ""
        ADDepartment = ""
        ManagerISID = ""

        RoomID = -1
        Room = ""



        Enabled = 1

        prvErrorNb = 0
        prvErrMsg = ""

        Set AccessItemList = Server.CreateObject("Scripting.Dictionary")
        Set ManualAccessItemList = Server.CreateObject("Scripting.Dictionary")
        Set Delegates = Server.CreateObject("Scripting.Dictionary")


    End Sub

    Private Sub Init
        Dim SQLStr : SQLStr = "SELECT * FROM vwAdUserlist WHERE isid='" & prvID & "'"
        If prvID <> "" Then
            Dim Rs : Set Rs = DbExecute(SQLStr)
            Fill(Rs)
        End If
    End Sub

    Public Sub Fill(Rs)
        Dim Item
        Dim RsDetail
        Dim i : i=0
        If Not Rs.Eof Then
            prvID = Rs("isid")
            IsID = Rs("isid")

            Firstname = Rs("firstname")
            Lastname = Rs("lastname")
            DisplayName = Rs("displayname")
            EMail = Rs("email")

            DepartmentID = Rs("departmentid")
            Department = Rs("departmentad")

            ADDepartment = Rs("departmentad")
            ManagerISID = Rs("managerisid")

            Room = Rs("room")
            RoomID = IIf(Isnull(Rs("roomid")),CLng(-1), Rs("roomid"))
            Enabled = Rs("enabled")

            SQLStr = "SELECT * FROM vwAdUserAccessItem WHERE isrevoked=0 AND isid='" & prvID & "' ORDER BY created"
            Set RsDetail = DbExecute(SQLStr)
            Do While Not RsDetail.Eof
                Set Item = New ADUserAccessItem
                Item.Fill(RsDetail)
                AccessItemList.Add i, Item
                i=i+1
                RsDetail.MoveNext
            Loop
            RsDetail.Close
            Set RsDetail = Nothing

            SQLStr = "SELECT * FROM vwAdUserAccessItem WHERE manual IN (0,1) AND isrevoked=0 AND isid='" & prvID & "' ORDER BY accesstype, accessitem, accessright"
            Set RsDetail = DbExecute(SQLStr)
            Do While Not RsDetail.Eof
                Set Item = New ADUserAccessItem
                Item.Fill(RsDetail)
                ManualAccessItemList.Add i, Item
                i=i+1
                RsDetail.MoveNext
            Loop
            RsDetail.Close
            Set RsDetail = Nothing

            SQLStr = "SELECT * FROM vwADUserListDelegate WHERE isid='" & prvID & "' ORDER BY lastname, firstname"
            Set RsDetail = DbExecute(SQLStr)
            Do While Not RsDetail.Eof
                Set Item = New Delegate
                Item.Fill(RsDetail)
                Delegates.Add i, Item
                i=i+1
                RsDetail.MoveNext
            Loop
            RsDetail.Close
            Set RsDetail = Nothing

        End If
    End Sub


    Public Function AccessItemManualToJSON(ByVal Draw)

        Dim oJSON : Set oJSON = New aspJSON
        Dim Item
        Dim idx : idx=0

        With oJSON.Data
            .Add "draw", Draw
            .Add "recordsTotal", ManualAccessItemList.Count
            .Add "recordsFiltered", ManualAccessItemList.Count
            .Add "data", oJSON.Collection()
            With .Item("data")
                For Each Item In ManualAccessItemList.Items
                    .Add idx, oJSON.Collection()
                    With .Item(idx)
                        .Add "accessitemtype", ToUTF8(Item.AccessType)
                        .Add "accessitem", ToUTF8(Item.AccessItem)
                        .Add "accessright", ToUTF8(Item.AccessRight)
                        .Add "accessitemtypeid", CLng(Item.AccessTypeID)
                        .Add "accessitemid", CLng(Item.AccessItemID)
                        .Add "accessrightid", CLng(Item.AccessRightID)
                        .Add "manual", Item.Manual
                    End With
                    idx=idx+1
                Next
            End With
        End With
        Set AccessItemManualToJSON = oJSON
    End Function

    Public Sub FillView(Rs)

        If Not Rs.Eof Then
            prvID = Rs("isid")
            IsID = Rs("isid")

            Firstname = Rs("firstname")
            Lastname = Rs("lastname")
            DisplayName = Rs("displayname")
            EMail = Rs("email")

            DepartmentID = Rs("departmentid")
            Department = Rs("department")

            ADDepartment = Rs("departmentad")
            ManagerISID = Rs("managerisid")

            Room = Rs("room")
            RoomID = IIf(Isnull(Rs("roomid")),CLng(-1), Rs("roomid"))
            Enabled = Rs("enabled")

        End If
    End Sub

    Public Sub FillReview(Rs)

        If Not Rs.Eof Then
            prvID = Rs("isid")
            IsID = Rs("isid")
            DisplayName = Rs("name")
            ManagerISID = Rs("isid_manager")
            Manager = Rs("manager")
            AccessRight = Rs("benutzerrecht")
            AccessItem = Rs("item")
            AccessType = Rs("typ")
        End If

    End Sub


    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ADUserUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ISID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@RoomID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = RoomID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute


        prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
        prvErrorNb = 1


        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvErrMsg = GetLabel("msgDataSaveSuccess", Session("lang"))
            prvErrorNb = 0
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        Save = RetVal


    End Function

End Class

Class Delegate

    Public ISID
    Public DelegateISID
    Public LastName
    Public FirstName

    Private prvErrorNb
    Public Property Get ErrNb
        ErrNb = prvErrorNb
    End Property

    Private prvErrMsg
    Public Property Get ErrMsg
        ErrMsg = prvErrMsg
    End Property

    Private prvLang
    Public Property Get Lang
        Lang = prvLang
    End Property

    Public Property Let Lang (Value)
        prvLang = Value
    End Property

    Private Sub Class_Initialize()
        prvLang = IIf(Session("lang")="","de",Session("lang"))
        prvErrorNb = 0
        prvErrMsg = ""
    End Sub

    Public Default Sub Init (ByVal myISID, ByVal myDelegate)

        Dim SQLStr : SQLStr = "SELECT * FROM vwAdUserlist WHERE isid='" & myDelegate & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        If Not Rs.Eof Then
            ISID = myISID
            DelegateISID = myDelegate
            LastName = Rs("lastname")
            FirstName = Rs("firstname")
        End If
        Rs.Close
        Set Rs = Nothing

    End Sub

    Public Sub Fill(Rs)

        ISID = Rs("isid")
        DelegateISID = Rs("delegateisid")
        LastName = Rs("lastname")
        FirstName = Rs("firstname")

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ADUserDelegateAdd"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ISID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ISID

        Set Parameter = Cmd.CreateParameter("@DelegateISID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DelegateISID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        prvErrMsg = GetLabel("msgDataSaveSuccess", Session("lang"))
        prvErrorNb = 0

        On Error Resume Next

        Cmd.Execute

        If Err <> 0 Then
            prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
            prvErrorNb = 1
        End If

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            Init ISID, DelegateISID
            RetVal = True
        Else
            prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
            prvErrorNb = 1
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        Save = RetVal

    End Function

    Public Function Delete

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ADUserDelegateDel"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ISID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ISID

        Set Parameter = Cmd.CreateParameter("@DelegateISID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DelegateISID

        Cmd.Execute

        prvErrMsg = GetLabel("msgDataDeleteSuccess", Session("lang"))
        prvErrorNb = 0

        On Error Resume Next

        Cmd.Execute

        If Err <> 0 Then
            prvErrMsg = GetLabel("msgDataDeleteError", Session("lang"))
            prvErrorNb = 1
        End If

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        Else
            prvErrMsg = GetLabel("msgDataDeleteError", Session("lang"))
            prvErrorNb = 1
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        Delete = RetVal


    End Function

End Class


Const digiDepartmentID = 18

Class ADUserHelper


    Public Lang
    Private Sub Class_Initialize()
        Lang = IIf(Session("lang")="","de",Session("lang"))
    End Sub

    Public Function List()

        Set List = Server.CreateObject("Scripting.Dictionary")
        Dim Item
        Dim SQLStr :

        If IsAdmin Then
            SQLStr = "SELECT * FROM vwAdUserlist ORDER BY displayname"
        Else
            SQLStr = "SELECT * FROM vwAdUserlist WHERE isid=isid Or isid IN (SELECT isid FROM dbo.ExpandPeopleList('" & Session("login") & "')) ORDER BY displayname"
        End If

        Dim Rs : Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ADUser
            Item.FillView(Rs)
            List.Add Item.ISID, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Public Function ReviewList()

        Set ReviewList = Server.CreateObject("Scripting.Dictionary")
        Dim Item
        Dim SQLStr :

        If IsAdmin Then
            SQLStr = "SELECT * FROM vwUserWithAccessRight ORDER BY name, typ, item, benutzerrecht"
        Else
            SQLStr = "SELECT * FROM vwUserWithAccessRight WHERE isid=isid Or isid IN (SELECT isid FROM dbo.ExpandPeopleList('" & Session("login") & "')) ORDER BY name, typ, item, benutzerrecht"
        End If

        Dim Rs : Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ADUser
            Item.FillReview(Rs)
            ReviewList.Add ReviewList.Count, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Public Function ITUserList()

        Set ITUserList = Server.CreateObject("Scripting.Dictionary")
        Dim Item
        Dim SQLStr : SQLStr = "SELECT * FROM vwAdUserlist WHERE  departmentid=" & digiDepartmentID & " ORDER BY displayname"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ADUser
            Item.Fill(Rs)
            ITUserList.Add Item.ISID, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Public Function PeopleManager()

        Set PeopleManager = Server.CreateObject("Scripting.Dictionary")
        Dim Item
        Dim SQLStr : SQLStr = "SELECT * FROM vwAdUserlist WHERE isid IN (SELECT DISTINCT managerisid FROM vwAdUserlist) ORDER BY displayname"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ADUser
            Item.Fill(Rs)
            PeopleManager.Add Item.ISID, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Public Function Delegates(ByVal ISID)

        Set Delegates = Server.CreateObject("Scripting.Dictionary")
        Dim Item
        Dim SQLStr : SQLStr = "SELECT * FROM vwAdUserlist WHERE isid NOT IN (SELECT delegateisid FROM aduserlist_delegate WHERE isid='" & ISID & "') ORDER BY displayname"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("isid")
            Item.Name = Rs("displayname") & "(" & Rs("isid") & ")"
            Delegates.Add Item.Value, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing
    End Function


    Public Function HeaderUserXLS

        Dim HeaderXLS : Set HeaderXLS = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New XLSHeader
        Item.ID = 1
        Item.Description = "ISID"
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "isid"
        Item.Format = ""
        Item.ColumnWidth = 60
        HeaderXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = 2
        Item.Description = GetLabel("lblDisplayName", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "DisplayName"
        Item.Format = ""
        Item.ColumnWidth = 100
        HeaderXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = 3
        Item.Description = GetLabel("lblType", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessType"
        Item.Format = ""
        Item.ColumnWidth = 60
        HeaderXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = 4
        Item.Description = GetLabel("lblAccessItem", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessItem"
        Item.Format = ""
        Item.ColumnWidth = 100
        HeaderXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = 5
        Item.Description = GetLabel("lblAccessRight", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessRight"
        Item.Format = ""
        Item.ColumnWidth = 180
        HeaderXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = 6
        Item.Description = "Manager-ISID"
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "ManagerISID"
        Item.Format = ""
        Item.ColumnWidth = 60
        HeaderXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = 7
        Item.Description = "Manager"
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "Manager"
        Item.Format = ""
        Item.ColumnWidth = 100
        HeaderXLS.Add Item.ID, Item

        Set HeaderUserXLS = HeaderXLS

    End Function

End Class

%>