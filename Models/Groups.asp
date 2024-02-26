<%

Class Group

    Private mGroupID

    Public Property Get GroupID
        GroupID = mGroupID
    End Property

    Public Property Let GroupID (Value)
        mGroupID = Value
        If mGroupID <> "" Then
            InitObject
        End If
    End Property

    Public Property Let ID (Value)
        mGroupID = Value
    End Property

    Public Group
    Public Active
    Public IsNew

    Private Sub Class_Initialize()
        mGroupID = ""
        Group =""
        Active = 1
        IsNew = True
    End Sub

    Private Sub InitObject
         '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM [group] WHERE groupid='" & mGroupID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            Group = iRs("groupname")
            Active = iRs("active")
            IsNew = False
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

        Cmd.CommandText = "AddGroup"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@GroupID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = mGroupID

        Set Parameter = Cmd.CreateParameter("@Group", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Group

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

        Cmd.CommandText = "UpdateGroup"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

         Set Parameter = Cmd.CreateParameter("@GroupID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = mGroupID

        Set Parameter = Cmd.CreateParameter("@Group", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Group

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

    Public Function Exists(ByVal tstGroupID)

        Dim SQLStr : SQLStr = "SELECT * FROM [group] WHERE groupid='" & tstGroupID & "'"
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

Class GroupHelper

    Public Function GroupList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM [group] ORDER BY groupid"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Group
            Item.ID = Rs("groupid")
            Item.Group = Rs("groupname")
            Item.Active = Rs("active")
            Item.IsNew = False
            List.Add Item.GroupID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  GroupList =  List

    End Function

    Public Function ToggleAccess(ByVal GroupID, ByVal MenuID)

        Dim SQLStr : SQLStr = "SELECT * FROM group_access WHERE groupid='" & GroupID & "' AND menuid='" & MenuID &  "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim SQLStrDel : SQLStrDel = ""
        Dim Arr

        If Rs.Eof Then
           If InStr(MenuID,"_") = 0 Then
              SQLStr = "INSERT INTO group_access (groupid, menuid) SELECT '" & GroupID & "', menuid FROM menu WHERE active=1 AND menuid LIKE '" & MenuID & "%'"
              SQLStrDel = "DELETE FROM group_access WHERE groupid = '" & GroupID & "' AND menuid LIKE '" & MenuID & "%'"
           Else
              Arr = Split(MenuID,"_")

              SQLStrDel = "IF NOT EXISTS(SELECT * FROM group_access WHERE groupid='" & GroupID & "' AND menuid='" & Arr(0) & "') " & _
                          "INSERT INTO group_access (groupid, menuid) VALUES ('" & GroupID & "','" & Arr(0) & "')"

               SQLStr = "INSERT INTO group_access (groupid, menuid) VALUES ('" & GroupID & "','" & MenuID & "')"
           End If
        Else
           If InStr(MenuID,"_") = 0 Then
                SQLStrDel = "DELETE FROM group_access WHERE groupid = '" & GroupID & "' AND menuid LIKE '" & MenuID & "%'"
           Else
                Arr = Split(MenuID,"_")
                SQLStrDel = "DELETE FROM group_access WHERE groupid = '" & GroupID & "' AND menuid = '" & MenuID & "'"
                SQLStr = "IF ((SELECT COUNT(*) FROM group_access WHERE groupid='" & GroupID & "' AND menuid  LIKE '" & Arr(0) & "%') = 1) " & _
                         "DELETE FROM group_access WHERE groupid = '" & GroupID & "' AND menuid LIKE '" & Arr(0) & "%'"
           End If
        End If
        Rs.Close
        Set Rs = Nothing

        If SQLStrDel <> "" Then
            DbExecute(SQLStrDel)
        End If
        If SQLStr <> "" Then
            DbExecute(SQLStr)
        End If

        ToggleAccess = True

    End Function


End Class

%>