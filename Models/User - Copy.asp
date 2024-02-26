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

    Public GroupID
    Public Group
    Public Active
    Public IsNew
    Public DepartmentID
    Public Department
    Public StreamType
    Public Area

    Private Sub Class_Initialize()
        mUserID = ""
        GroupID =""
        Group = ""
        DepartmentID = 0
        Department = ""
        Active = 1
        IsNew = True
        StreamType = ""
        Area = ""
    End Sub

    Private Sub InitObject
         '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM vwUserlist WHERE userid='" & mUserID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            GroupID = iRs("groupid")
            Group = iRs("groupname")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            Active = iRs("active")
            IsNew = False
            StreamType = iRs("streamtype")
            Area = iRs("area")
        Else
            IsNew = True
        End If
        iRs.Close
    End Sub

    Public Function Save

        If IsNew Then
           Save = Add
        Else
           Save = Update
        End If

    End Function


    Private Function Add()

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

        Add = RetVal

    End Function

    Private Function Update()

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

        Set Parameter = Cmd.CreateParameter("@GroupID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = GroupID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

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
            Item.UserID = Rs("userid")
            List.Add Item.UserID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  UserList =  List

    End Function

End Class

%>