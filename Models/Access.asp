<%
Const cAccessTypeShare = 1
Const cAccessTypeApp = 2
Const cAccessTypeSAP = 3
Const cAccessTypeDevice = 4

Const cAccessStateEnabled = 1
Const cAccessStateDisabled = 0


Class AccessItem

    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get AccessItemID
        AccessItemID = prvID
    End Property

    Public Property Let AccessItemID (Value)
        prvID = Value
    End Property

    Private prvErrorNb
    Public Property Get ErrNb
        ErrNb = prvErrorNb
    End Property

    Private prvErrMsg
    Public Property Get ErrMsg
        ErrMsg = prvErrMsg
    End Property

    Public Name
    Public Description
    Public AccessTypeID
    Public AccessType
    Public StatusDate
    Public Active

    Public SystemOwner
    Public IsGMP
    Public SODisplayName

    Public ISID
    Public DisplayName
    Public AccessRight

    Public AccessRights
    Public WorkFlows
    Public Groups

    Private Sub Class_Initialize()
        prvID = CLng(-1)
        Name = ""
        Description = ""
        AccessTypeID = ""
        AccessType = ""

        SystemOwner = ""
        IsGMP = 0
        SODisplayName = ""

        prvErrNb = 0
        prvErrMsg = ""
        Set AccessRights = Server.CreateObject( "Scripting.Dictionary")
        Set WorkFlows = Server.CreateObject( "Scripting.Dictionary")
        Set Groups = Server.CreateObject( "Scripting.Dictionary")
    End Sub

    Private Sub Init
        Dim SQLStr : SQLStr = "SELECT * FROM vwAccessItem WHERE id=" & prvID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
           Fill(Rs)
        End If

        Rs.Close
        Set Rs = Nothing
    End Sub

    Public Sub Fill (ByVal Rs)

        prvID = Rs("id")
        Name = Rs("name")
        Description = Rs("description")
        AccessTypeID = Rs("accesstypeid")
        AccessType = Rs("accesstype")
        StatusDate = Rs("statusdate")
        Active = Rs("active")
        SystemOwner = Rs("sys_owner")
        SODisplayName = Rs("displayname")
        IsGMP = Rs("isgxp")

        Dim SQLStr : SQLStr = "SELECT * FROM vwAccessRight WHERE accessitemid=" & prvID & " ORDER BY accessright"
        Dim Rs1 : Set Rs1 = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs1.Eof
            Set Item = New AccessItemRight
            Item.Fill(Rs1)
            AccessRights.Add Item.ID, Item
            Rs1.MoveNext
        Loop
        Rs1.Close
        Set Rs1=Nothing

        SQLStr = "SELECT * FROM workflow ORDER BY workflow"
        Set Rs1 = DbExecute(SQLStr)

        Do While Not Rs1.Eof
            Set Item = New WorkFlowItem
            Item.Fill(Rs1)
            If Item.Active = 1 Then
                WorkFlows.Add Item.ID, Item
            End If
            Rs1.MoveNext
        Loop
        Rs1.Close
        Set Rs1=Nothing

        SQLStr = "SELECT DISTINCT groupid FROM request_group WHERE isdefault=1 AND storno=0 ORDER BY groupid"
        Set Rs1 = DbExecute(SQLStr)
        'Default Groups'
        Set Rs1 = DbExecute(SQLStr)
        Do While Not Rs1.Eof
            Set Item = New ListItem
            Item.Value = Rs1("groupid")
            Item.Name = Rs1("groupid")
            Groups.Add Item.Value, Item
            Rs1.MoveNext
        Loop
        Rs1.Close
        Set Rs1=Nothing

        SQLStr = "SELECT DISTINCT groupid FROM request_group WHERE isdefault=0 AND storno=0 ORDER BY groupid"
        Set Rs1 = DbExecute(SQLStr)
        Do While Not Rs1.Eof
            Set Item = New ListItem
            Item.Value = Rs1("groupid")
            Item.Name = Rs1("groupid")
            Groups.Add Item.Value, Item
            Rs1.MoveNext
        Loop
        Rs1.Close
        Set Rs1=Nothing

    End Sub

    Sub Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "UpdateAccessItem"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 512)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ""

        Set Parameter = Cmd.CreateParameter("@AccessTypeID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccessTypeID

        Set Parameter = Cmd.CreateParameter("@Active", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Set Parameter = Cmd.CreateParameter("@IsGMP", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IsGMP

        Set Parameter = Cmd.CreateParameter("@SysOwner", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SystemOwner

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        prvErrMsg = GetLabel("msgDataSaveSuccess", Session("lang"))
        prvErrorNb = 0

        On Error Resume Next

        Cmd.Execute

        If Err <> 0 Then
            prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
            prvErrorNb = 1
        End If

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
            prvID = Cmd.Parameters("@ID").Value
        Else
            prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
            prvErrorNb = 1
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

    End Sub

    Public Function ToJSONObj(ByVal ParameterList, ByVal ListName)

        Dim iItem
        Dim tItem
        Dim oJSON : Set oJSON = New aspJSON
        Dim idx

        With oJSON.Data

            For Each iItem In ParameterList.Items
                .Add iItem.Name, iItem.Value
            Next
            .Add ListName, oJSON.Collection()
            Select Case ListName

            Case "accessitem"

                With .Item(ListName)
                    .Add "accessitemid", CLng(prvID)
                    .Add "accessitem", ToUTF8(Name)
                    .Add "accesstypeid", AccessTypeID
                    .Add "accesstype", AccessType
                    .Add "description", ToUTF8(Description)
                    .Add "accessright", oJSON.Collection()
                    idx=0
                    With .Item("accessright")
                        ''.Add idx, oJSON.Collection()
                        ''With .Item(idx)
                        ''        .Add "value", ""
                        ''        .Add "name", ToUTF8(GetLabel("lblAccessRights",Lang))
                        ''End With
                        idx=1
                        For Each iItem In AccessRights.Items
                            .Add idx, oJSON.Collection()
                            With .Item(idx)
                                .Add "id", CLng(iItem.ID)
                                .Add "accessright", ToUTF8(iItem.AccessRight)
                                .Add "accessitemid", CLng(iItem.AccessItemID)
                                .Add "accessitem", ToUTF8(iItem.AccessItem)
                                .Add "workflowid", CLng(iItem.WorkFlowID)
                                .Add "workflow", ToUTF8(iItem.WorkFlow)
                            End With
                            idx=idx+1
                        Next
                    End With
                    .Add "workflow", oJSON.Collection()
                    idx=0
                    With .Item("workflow")
                        idx=1
                        For Each iItem In WorkFlows.Items
                            .Add idx, oJSON.Collection()
                            With .Item(idx)
                                .Add "workflowid", CLng(iItem.ID)
                                .Add "workflow", ToUTF8(iItem.WorkFlow)
                                .Add "description", ToUTF8(iItem.Description)
                            End With
                            idx=idx+1
                        Next
                    End With
                End With

            Case "accessright"


                With .Item("accessright")
                    idx=0
                    For Each iItem In AccessRights.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", CLng(iItem.ID)
                            .Add "name", ToUTF8(iItem.AccessRight)
                        End With
                        idx=idx+1
                    Next
                End With


            Case "accessrighttask"

                With .Item(ListName)
                    .Add "accessitemid", CLng(prvID)
                    .Add "accessitem", ToUTF8(Name)
                    .Add "accesstypeid", AccessTypeID
                    .Add "accesstype", AccessType
                    .Add "description", ToUTF8(Description)
                    .Add "accessrighttask", oJSON.Collection()
                    idx=0
                    With .Item("accessrighttask")
                        idx=1
                        For Each iItem In AccessRights.Items
                            For Each tItem In iItem.Tasks.Items
                                .Add idx, oJSON.Collection()
                                With .Item(idx)
                                    .Add "id", CLng(iItem.ID)
                                    .Add "accessright", ToUTF8(iItem.AccessRight)
                                    .Add "accessitemid", CLng(iItem.AccessItemID)
                                    .Add "accessitem", ToUTF8(iItem.AccessItem)
                                    .Add "workflowid", CLng(iItem.WorkFlowID)
                                    .Add "workflow", ToUTF8(iItem.WorkFlow)
                                    .Add "pos", CLng(tItem.Pos)
                                    .Add "tasktypeid", CLng(tItem.TaskTypeID)
                                    .Add "tasktype", ToUTF8(tItem.TaskType)
                                    .Add "sendto", ToUTF8(tItem.SendTo)
                                End With
                                idx=idx+1
                            Next
                        Next
                    End With
                    .Add "group", oJSON.Collection()
                    idx=0
                    With .Item("group")
                        idx=1
                        For Each iItem In Groups.Items
                            .Add idx, oJSON.Collection()
                            With .Item(idx)
                                .Add "groupid", ToUTF8(iItem.Value)
                            End With
                            idx=idx+1
                        Next
                    End With
                End With
            End Select
        End With

        Set ToJSONObj = oJSON

    End Function

    Public Function ToJSON(ByVal ListName, ByVal TypeID, ByVal ItemID, ByVal RightID)

        Dim iItem
        Dim tItem
        Dim oJSON : Set oJSON = New aspJSON
        Dim idx


        Dim SQLAccessItem : SQLAccessItem = "SELECT * FROM vwAccessItem WHERE accesstypeid=" & TypeID & " ORDER BY name"
        If CInt(TypeID) <> 3 Then
           SQLAccessItem = "SELECT * FROM vwAccessItem WHERE id=" & ItemID
        End If

        Dim SQLAccessRight : SQLAccessRight = "SELECT * FROM vwAccessRight WHERE accessitemid=" & ItemID & " ORDER BY accessright"

        Dim RsItem : Set RsItem = DbExecute(SQLAccessItem)
        Dim RsRight : Set RsRight = DbExecute(SQLAccessRight)


        With oJSON.Data
            .Add "listname", ToUTF8(ListName)
            .Add "accesstypeid", CLng(TypeID)
            .Add "accessitemid", CLng(ItemID)
            .Add "accessrightid", CLng(RightID)
            .Add "status", "OK"
            .Add "accessitem", oJSON.Collection()
            Select Case ListName
            Case "task-fill"
                With .Item("accessitem")
                    idx=0
                    Do While Not RsItem.Eof
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", CLng(RsItem("id"))
                            .Add "name", ToUTF8(RsItem("name"))
                        End With
                        idx = idx + 1
                        RsItem.MoveNext
                    Loop
                    RsItem.Close
                    Set RsItem = Nothing
                End With
                .Add "accessright", oJSON.Collection()
                With .Item("accessright")
                    idx=0
                    Do While Not RsRight.Eof
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", CLng(RsRight("id"))
                            .Add "name", ToUTF8(RsRight("accessright"))
                        End With
                        idx = idx + 1
                        RsRight.MoveNext
                    Loop
                    RsRight.Close
                    Set RsRight = Nothing
                End With
            End Select
        End With

        Set ToJSON = oJSON

    End Function

End Class


Class AccessItemRight

    Private prvID
    Private prvLang

    Public Property Get Lang
        Lang = prvLang
    End Property

    Public Property Let Lang (Value)
        prvLang = Value
    End Property


    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get AccessRightID
        AccessRightID = prvID
    End Property

    Public Property Let AccessRightID (Value)
        prvID = Value
    End Property

    Public AccessRight

    Public AccessItemID
    Public AccessItem
    Public WorkFlowID
    Public WorkFlow

    Public Tasks


    Private prvErrorNb
    Public Property Get ErrNb
        ErrNb = prvErrorNb
    End Property

    Private prvErrMsg
    Public Property Get ErrMsg
        ErrMsg = prvErrMsg
    End Property

    Private Sub Class_Initialize()
        prvLang = IIf(Session("lang")="","de",Session("lang"))
        Set Tasks = Server.CreateObject( "Scripting.Dictionary")
        prvID = CLng(0)
    End Sub

    Private Sub Init

        Dim SQLStr : SQLStr = "SELECT * FROM vwAccessRight WHERE id=" & prvID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Fill(Rs)
        End If
        Rs.Close
        Set Rs = Nothing

    End Sub

    Public Sub Fill (ByVal Rs)

        prvID = Rs("id")
        AccessRight = Rs("accessright")
        AccessItemID = Rs("accessitemid")
        AccessItem = Rs("accessitem")
        WorkFlowID = Rs("workflowid")
        WorkFlow = Rs("workflow")

        Dim SQLStr : SQLStr = "SELECT * FROM vwAccessItemRightTask WHERE id=" & prvID
        Dim RsT : Set RsT = DbExecute(SQLStr)
        Dim Item
      
        Do While Not RsT.Eof
            Set Item = New AccessItemRightTask
            Item.Fill(RsT)
            Tasks.Add Item.Pos, Item
            RsT.MoveNext
        Loop
        RsT.Close
        Set RsT = Nothing

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "AccessRightItemUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@AccessItemID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccessItemID

        Set Parameter = Cmd.CreateParameter("@WorkFlowID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = WorkFlowID

        Set Parameter = Cmd.CreateParameter("@AccessRight", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccessRight

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        prvErrMsg = GetLabel("msgDataSaveSuccess", Session("lang"))
        prvErrorNb = 0

        On Error Resume Next

        Cmd.Execute

        If Err <> 0 Then
            prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
            prvErrorNb = 1
        End If

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
            prvID = Cmd.Parameters("@ID").Value
            Init
        Else
            prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
            prvErrorNb = 1
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        Save = RetVal

    End Function

End Class


Class AccessItemRightTask

    Public Pos
    Public AccessRightID
    Public AccessRight
    Public TaskTypeID
    Public TaskType
    Public SendTo
    Public WorkFlowID
    Public WorkFlow
    Public AccessItemID
    Public AccessItem
    Public AccessTypeID
    Public AccessType


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

    Public Default Sub  Init (ByVal myRightID, ByVal myPos)
        Dim SQLStr : SQLStr = "SELECT * FROM vwAccessItemRightTask WHERE id=" & myRightID & " AND pos=" & myPos
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Fill(Rs)
        End If
        Rs.Close
        Set Rs = Nothing

    End Sub

    Public Sub Fill (Rs)

        AccessItemID = Rs("accessitemid")
        AccessItem = Rs("accessitem")
        Pos = Rs("pos")
        AccessRightID = Rs("id")
        AccessRight = Rs("accessright")
        TaskTypeID = Rs("tasktypeid")
        TaskType = GetLabel("lblTaskType" & TaskTypeID, prvLang)
        SendTo = Rs("sendto")

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "AccessItemRightTaskUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccessRightID

        Set Parameter = Cmd.CreateParameter("@Pos", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Pos

        Set Parameter = Cmd.CreateParameter("@SendTo", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SendTo

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        prvErrMsg = GetLabel("msgDataSaveSuccess", Session("lang"))
        prvErrorNb = 0

        On Error Resume Next

        Cmd.Execute

        If Err <> 0 Then
            prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
            prvErrorNb = 1
        End If

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        Else
            prvErrMsg = GetLabel("msgDataSaveError", Session("lang"))
            prvErrorNb = 1
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        Save = RetVal

    End Function


End Class

Class AccessQueueMember
    Public ISID
    Public GroupID
    Public DisplayName
    Public IsDefault
    Public StateID
    Public StateText

    Public Sub Fill(Rs)
        ISID = Rs("isid")
        GroupID = Rs("groupid")
        DisplayName = Rs("displayname")
        StateID = Rs("isid_storno")
        StateText = GetLabel("lblStornoState" & StateID,prvLang)
    End Sub

End Class


Class AccessQueueItem

    Private prvID

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get ID
        ID = prvID
    End Property

    Private prvErrNb
    Private prvErrMsg

    Public Property Get ErrNb
        ErrNb = prvErrNb
    End Property

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

    '---------------------'
    ' Public Variable     '
    '---------------------'
    Public Name
    Public TypID
    Public TypName
    Public StateID
    Public StateText

    Public Created
    Public CreatedBy
    Public LastEdit
    Public LastEditBy

    Public MemberList

    '---------------------'
    ' Private Variable    '
    '---------------------'
    Private WithDetails


    Private Sub Class_Initialize()
        prvErrNb = 0
        prvErrMsg = ""
        prvLang = IIf(Session("lang") = "","de",Session("lang"))
        Set MemberList = Server.CreateObject( "Scripting.Dictionary")
        WithDetails = False
    End Sub

    Public Sub Init
        Dim SQLStr : SQLStr = "SELECT * FROM request_group_head WHERE groupid='" & prvID & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Fill(Rs)
        End If
        Rs.Close
        Set Rs = Nothing
    End Sub

    Public Sub Fill(ByVal Rs)

        WithDetails = True
        FillItem Rs

    End Sub

    Public Sub FillwoDetails(ByVal Rs)

        WithDetails = False
        FillItem Rs

    End Sub

    Private Sub FillItem (ByVal Rs)

        prvID = Rs("groupid")
        Name = Rs("groupid")
        TypID = Rs("isdefault")
        TypName = GetLabel("lblGroupType" & TypID,prvLang)
        StateID = Rs("storno")
        StateText = GetLabel("lblStornoState" & StateID,prvLang)
        Created = Rs("created")
        CreatedBy = Rs("createdby")
        LastEdit = Rs("lastedit")
        LastEditBy = Rs("lasteditby")

        If WithDetails Then
            FillDetail
        End If

    End Sub


    Private Sub FillDetail

        Dim SQLStr : SQLStr = "SELECT * FROM vwRequestGroupMember WHERE groupid='" & prvID & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New AccessQueueMember
            Item.Fill(Rs)
            MemberList.Add Item.ISID, Item
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing

    End Sub

    Public Function Save

    End Function

    Public Function Delete

    End Function

End Class



Class AccessHelper

    Public Lang

    Private rHelper

    Private Sub Class_Initialize()
        Lang = IIf(Session("lang")="","de",Session("lang"))
        Set rHelper = New RequestHelper
    End Sub

    Public Function List(ByVal Typ)

        Set List = Server.CreateObject( "Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwAccessItem WHERE accesstypeid=" & Typ & " ORDER BY name"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
           Set Item = New AccessItem
           Item.Fill(Rs)
           List.Add Item.ID, Item
           Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing

    End Function



    Public Function UserListByItem(ByVal ID)

        Set UserListByItem = Server.CreateObject( "Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwADUserAccessItem WHERE isrevoked=0 AND accessitemid=" & ID & " ORDER BY isid, accessitem, accessright"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
           Set Item = New AccessItem
           Item.Fill(Rs)
           Item.DisplayName = Rs("displayname")
           Item.ISID = Rs("isid")
           Item.AccessRight = Rs("accessright")
           UserListByItem.Add UserListByItem.Count, Item
           Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing

    End Function

    Public Function AccessRightTaskList(ByVal ID)

        Set AccessRightTaskList = Server.CreateObject( "Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwADUserAccessItem WHERE accessitemid=" & ID & " ORDER BY isid, accessitem, accessright"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
           Set Item = New AccessItemRightTask
           Item.Fill(Rs)
           Item.DisplayName = Rs("displayname")
           Item.ISID = Rs("isid")
           Item.AccessRight = Rs("accessright")
           AccessRightTaskList.Add UserListByItem.Count, Item
           Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing

    End Function


    Public Function StatusList()

        Set StatusList = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New ListItem
        Item.Value = cAccessStateEnabled
        Item.Name = GetLabel("lblState" & Item.Value, Lang)
        StatusList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cAccessStateDisabled
        Item.Name = GetLabel("lblState" & Item.Value, Lang)
        StatusList.Add Item.Value, Item

    End Function

    Public Function TypeList()

        Set TypeList = rHelper.AccessTypeList

    End Function


    Public Function HeaderShareItemsXLS

        Dim HeaderXLS : Set HeaderXLS = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New XLSHeader
        Item.ID = 1
        Item.Description = GetLabel("lblName", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "Name"
        Item.Format = ""
        Item.ColumnWidth = 150
        HeaderXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = 2
        Item.Description = GetLabel("lblType", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessType"
        Item.Format = ""
        Item.ColumnWidth = 60
        HeaderXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = 3
        Item.Description = GetLabel("lblState", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "Active"
        Item.Format = ""
        Item.ColumnWidth = 50
        HeaderXLS.Add Item.ID, Item

        Set HeaderShareItemsXLS = HeaderXLS


    End Function

End Class


%>