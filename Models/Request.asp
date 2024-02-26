<%

Const cRequestMailRequestorOpen = 1
Const cRequestMailApproverOpen = 2
Const cRequestMailRequestorApproved = 3
Const cRequestMailRequestorRejected = 4
Const cRequestMailRequestorDone = 5
Const cRequestMailRequestorNotDone = 6
Const cRequestMailTaskOpen = 7

Const cRequestTypeGrant = 10
Const cRequestTypeRevoke = 20

Const cRequestTypeGrantIcon = "fas fa-user-plus"
Const cRequestTypeRevokeIcon = "fas fa-user-minus text-danger"

Const cWorklistMaintIcon = "fas fa-list-alt"
Const cWorklistSearchIcon = "w-fa fas fa-image"

Const cRequestAppoverStateOpened = 10
Const cRequestAppoverStateGranted = 40
Const cRequestAppoverStateRejected = 50

Const cTaskStateOpened = 10
Const cTaskStateProgress = 20
Const cTaskStatePending = 30
Const cTaskStateClosed = 40
Const cTaskStateCanceled = 50

Const cTaskTypeApprove = 10
Const cTaskTypeExecute = 20
Const cTaskTypeUpload = 30

Const cTaskTypeApproveIcon = "fas fa-clipboard-check"
Const cTaskTypeExecuteIcon = "fas fa-cog"
Const cTaskTypeUploadIcon = "fas fa-upload"
Const cTaskTypeDownloadIcon = "fas fa-download"


Const cQueueInbox = "inbox"
Const cQueueToDo = "todo"

Class RequestStatistic

    Public CntSum
    Public CntOpen
    Public CntApproved
    Public CntRejected

    Public CntWorkItem
    Public CntWorkItemOpen
    Public CntWorkItemClosed
    Public CntWorkItemCanceled

    Private Sub Class_Initialize()
        CntSum = 0
        CntOpen = 0
        CntApproved = 0
        CntRejected = 0
        CntWorkItem = 0
        CntWorkItemOpen = 0
        CntWorkItemClosed = 0
        CntWorkItemCanceled = 0

        Dim SQLStr
        ' Inbox '
        If 1=0 Then ''IsAdmin Then
            SQLStr = "SELECT ISNULL(COUNT(*),0) As CntSum" & _
                     ",ISNULL(SUM(CASE WHEN taskstateid=10 THEN 1 ELSE 0 END),0) As CntOpen" & _
                     ",ISNULL(SUM(CASE WHEN taskstateid=40 THEN 1 ELSE 0 END),0) As CntApproved " & _
                     ",ISNULL(SUM(CASE WHEN taskstateid=50 THEN 1 ELSE 0 END),0) As CntRejected " & _
                     "FROM vwRequestDetail WHERE queue='" & cQueueInbox & "'"
        Else
            SQLStr = "SELECT ISNULL(COUNT(*),0) As CntSum" & _
            ",ISNULL(SUM(CASE WHEN taskstateid=10 THEN 1 ELSE 0 END),0) As CntOpen" & _
            ",ISNULL(SUM(CASE WHEN taskstateid>30 THEN 1 ELSE 0 END),0) As CntApproved " & _
            ",ISNULL(SUM(CASE WHEN taskstateid>30 THEN 1 ELSE 0 END),0) As CntRejected " & _
            "FROM vwRequestDetail " & _
            "WHERE queue='" & cQueueInbox & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueInbox & "') AND (sendto_final IN (SELECT groupid FROM request_group WHERE isid='" & Session("login") & "') OR sendto_final='" & Session("login") & "')"
        End If
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            CntSum = Rs("CntSum")
            CntOpen = Rs("CntOpen")
            CntApproved = Rs("CntApproved")
            CntRejected = Rs("CntRejected")
        End If
        Rs.Close
        'Work ITem'
        If 1=0 Then ''IsAdmin Then
            SQLStr = "SELECT " & _
                    "ISNULL(COUNT(*),0) As CntWorkItem" & _
                    ",ISNULL(SUM(CASE WHEN taskstateid=10 THEN 1 ELSE 0 END),0) As CntWorkItemOpen " & _
                    ",ISNULL(SUM(CASE WHEN taskstateid=40 THEN 1 ELSE 0 END),0) As CntWorkItemClosed " & _
                    ",ISNULL(SUM(CASE WHEN taskstateid=50 THEN 1 ELSE 0 END),0) As CntWorkItemCanceled " & _
                    "FROM vwRequestDetail " & _
                    "WHERE queue='" & cQueueToDo & "'"
        Else
            SQLStr = "SELECT " & _
                    "ISNULL(COUNT(*),0) As CntWorkItem" & _
                    ",ISNULL(SUM(CASE WHEN taskstateid=10 THEN 1 ELSE 0 END),0) As CntWorkItemOpen " & _
                    ",ISNULL(SUM(CASE WHEN taskstateid=40 THEN 1 ELSE 0 END),0) As CntWorkItemClosed " & _
                    ",ISNULL(SUM(CASE WHEN taskstateid=50 THEN 1 ELSE 0 END),0) As CntWorkItemCanceled " & _
                    "FROM vwRequestDetail " & _
                    "WHERE queue='" & cQueueToDo & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueToDo & "') AND (sendto_final IN (SELECT groupid FROM request_group WHERE isid='" & Session("login") & "') OR sendto_final='" & Session("login") & "')"
        End If
        Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            CntWorkItem = Rs("CntWorkItem")
            CntWorkItemOpen = Rs("CntWorkItemOpen")
            CntWorkItemClosed = Rs("CntWorkItemClosed")
            CntWorkItemCanceled = Rs("CntWorkItemCanceled")
        End If
        Rs.Close


        Set Rs = Nothing

    End Sub

End Class


Class RequestItem

    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get ReqID
        ReqID = prvID
    End Property

    Public Property Let ReqID (Value)
        prvID = Value
    End Property


    Public ReqNb
    Public ReqDate
    Public CreatedBy
    Public Created
    Public ISID
    Public AssignedTo
    Public Assigned
    Public Displayname
    Public Description
    Public LastEditBy
    Public LastEdit
    Public DepartmentID
    Public Department
    Public StateID
    Public State
    Public ReqTypeID
    Public ReqType

    Public Details
    Public WorkFlowState

    Public Lang

    Private Sub Class_Initialize()
        StateID = 10
        Lang = IIf(Session("lang")="","de",Session("lang"))
        Set Details = Server.CreateObject("Scripting.Dictionary")
        Set WorkFlowState = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Private Sub Init

        Dim SQLStr : SQLStr = "SELECT * FROM vwRequest WHERE id=" & prvID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Fill(Rs)
        End If

        Rs.Close
        Set Rs = Nothing

    End Sub

    Public Sub Fill (Rs)

        If Not Rs.Eof Then
            prvID = CLng(Rs("id"))
            ReqDate = Rs("created")
            ReqNb = Rs("reqnb")
            CreatedBy = Rs("createdby")
            Created = Rs("created")
            ISID = Rs("isid")
            Displayname = Rs("displayname")
            Description = Rs("description")
            DepartmentID = Rs("departmentid")
            Department = Rs("department")
            LastEdit = Rs("lastedit")
            LastEditBy = Rs("lasteditby")
            StateID = Rs("stateid")
            State = GetLabel("lblRequestState" & StateID, Lang)

            ReqTypeID = Rs("typeid")
            ReqType = GetLabel("lblRequestType" & ReqTypeID, Lang)

            Dim SQLStr : SQLStr = "SELECT * FROM vwRequestDetail WHERE reqid=" & prvID
            Dim RsD : Set RsD = DbExecute(SQLStr)
            Dim Item
            Dim SubItem
            Dim idx : idx = 0

            Do While Not RsD.Eof
                Set Item = New RequestDetail
                Item.Fill(RsD)
                Details.Add Item.TaskID, Item
                RsD.MoveNext
            Loop
            RsD.Close
            Set RsD = Nothing

            SQLStr = "SELECT * FROM dbo.tblWorkFlowState(" & prvID   & ") ORDER BY accessitemid, accessrightid, pos, tasktypeid"
            Set RsD = DbExecute(SQLStr)

            Dim tstAcessItemID : tstAcessItemID = CLng(-1)
            Dim tstAccessRightID : tstAccessRightID = CLng(-1)
            Dim hlpAcessItemID
            Dim hlpAccessRightID

            If Not RsD.Eof Then
                hlpAcessItemID = CLng(RsD("accessitemid"))
                hlpAccessRightID = CLng(RsD("accessrightid"))
            End If

            Do While Not RsD.Eof
                Set Item = New WorkFlowStateItem
                Item.Fill(RsD)
                Item.ID = idx
                If CLng(RsD("accessitemid")) <> tstAcessItemID Then
                   tstAcessItemID = CLng(RsD("accessitemid"))
                End If
                If CLng(RsD("accessrightid")) <> tstAccessRightID Then
                   tstAccessRightID = CLng(RsD("accessrightid"))
                End If
                Do While Not RsD.Eof And hlpAcessItemID = tstAcessItemID And hlpAccessRightID = tstAccessRightID
                    Set SubItem = New WorkFlowStateDetailItem
                    SubItem.Fill(RsD)
                    Item.Tasks.Add SubItem.TaskID, SubItem
                    RsD.MoveNext
                    If Not RsD.Eof Then
                        hlpAcessItemID = CLng(RsD("accessitemid"))
                        hlpAccessRightID = CLng(RsD("accessrightid"))
                    End If
                Loop
                WorkFlowState.Add Item.ID, Item
                idx = idx + 1
            Loop
            RsD.Close
            Set RsD = Nothing

        End If

    End Sub

    Public Sub InitByPostData(ByVal ReqPosted)
        ' fill header'
        prvID = CLng(ReqPosted.Form("id"))
        CreatedBy = ReqPosted.Form("createdby")
        ReqNb = ReqPosted.Form("reqnb")
        Created = ReqPosted.Form("created")
        ReqDate = Created
        ISID = ReqPosted.Form("isid")
        StateID = ReqPosted.Form("stateid")
        DepartmentID = ReqPosted.Form("departmentid")
        Description = ReqPosted.Form("description")
        ReqTypeID = ReqPosted.Form("reqtypeid")

        'fill '

        Dim Count : Count = ReqPosted.Form("count")
        Dim i : i=0
        Dim Item

        For i=0 To Count - 1

            Set Item = New RequestDetail

            Item.ReqID = prvID
            Item.DetailID = CLng(-1)
            Item.AccessItemID = ReqPosted.Form("detail[" & i & "][accessitemid]")
            Item.AccessItem = ReturnFromRecord("accessitem","id=" & Item.AccessItemID, "name")
            Item.AccessRightID = ReqPosted.Form("detail[" & i & "][accessrightid]")
            Item.AccessRight = ReturnFromRecord("accessitem_right","id=" & Item.AccessRightID, "accessright")
            Item.StateID = StateID
            Item.CreatedBy = CreatedBy
            If ReqPosted.Form("detail[" & i & "][select]") <> "" Then
                Item.Selected = ReqPosted.Form("detail[" & i & "][select]")
            End If
            Item.Self = ReturnFromRecord("accessitem","id=" & Item.AccessItemID, "self")
            Details.Add i, Item
        Next

    End Sub


    Public Function Save

        Dim retVal : retVal = False

        Dim myConn : Set myConn = DbOpenConnection()

        Dim dItem

        myConn.BeginTrans


        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")
        Dim CmdDet


        Cmd.CommandText = "RequestUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CLng(prvID)

        Set Parameter = Cmd.CreateParameter("@ReqNb", adVarWChar, adParamInputOutput, 12)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ReqNb

        Set Parameter = Cmd.CreateParameter("@ReqDate", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Created

        Set Parameter = Cmd.CreateParameter("@CreatedBy", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CreatedBy

        Set Parameter = Cmd.CreateParameter("@Created", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Created

        Set Parameter = Cmd.CreateParameter("@ISID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ISID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@StateID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = StateID

        If Description = "" Then
            Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 255,null)
            Cmd.Parameters.Append Parameter
        Else
            Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 255,null)
            Cmd.Parameters.Append Parameter
            Parameter.Value = Description
        End If

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Set Parameter = Cmd.CreateParameter("@TypeID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ReqTypeID

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = CLng(Cmd.Parameters("@ID").Value)
            ReqNb = Cmd.Parameters("@ReqNb").Value
            RetVal = True

            For Each dItem In Details.Items

                If dItem.Selected = 1 Then

                    Set CmdDet = Server.CreateObject("ADODB.Command")

                    CmdDet.CommandText = "RequestDetailUpdate"
                    CmdDet.CommandType = adCmdStoredProc
                    Set CmdDet.ActiveConnection = myConn


                    Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
                    CmdDet.Parameters.Append Parameter

                    Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInputOutput)
                    CmdDet.Parameters.Append Parameter
                    Parameter.Value = dItem.ID

                    Set Parameter = Cmd.CreateParameter("@ReqID", adBigInt, adParamInput)
                    CmdDet.Parameters.Append Parameter
                    Parameter.Value = prvID

                    Set Parameter = Cmd.CreateParameter("@AccessItemID", adBigInt, adParamInput)
                    CmdDet.Parameters.Append Parameter
                    Parameter.Value = dItem.AccessItemID

                    Set Parameter = Cmd.CreateParameter("@AccessRightID", adVarWChar, adParamInput, 50)
                    CmdDet.Parameters.Append Parameter
                    Parameter.Value = dItem.AccessRightID

                    Set Parameter = Cmd.CreateParameter("@StateID", adInteger, adParamInput)
                    CmdDet.Parameters.Append Parameter
                    Parameter.Value = StateID

                    Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
                    CmdDet.Parameters.Append Parameter
                    Parameter.Value = dItem.CreatedBy

                    Set Parameter = Cmd.CreateParameter("@Self", adInteger, adParamInput)
                    CmdDet.Parameters.Append Parameter
                    Parameter.Value = dItem.Self

                    CmdDet.Execute

                    If CmdDet.Parameters("@RETURN_VALUE").Value = -1 Then
                       myConn.RollbackTrans
                       Save = False
                       DbCloseConnection()
                       Exit Function
                    End If
                    dItem.ID = CmdDet.Parameters("@ID").Value


                End If
            Next

            myConn.CommitTrans
            SendMail

        Else
            myConn.RollbackTrans
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function SendMail()

        Dim Item
        Dim sItem

        Dim myMail

        For Each Item In Details.Items
            If Item.Selected = 1 Then
                Set sItem = New RequestDetail
                sItem.ID = Item.ID
                sItem.SendMail(cRequestMailRequestorOpen)
                sItem.SendTaskEmail
                ''sItem.SendMail(cRequestMailApproverOpen)
            End If
        Next


    End Function


End Class

Class WorkFlowStateItem


    ' Default Part'
    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
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
    Public ReqID
    Public ReqNb
    Public ReqTypeID
    Public ReqType
    Public ReqCreated
    Public ReqCreatedBy

    Public WorkFlowID
    Public AccessTypeID
    Public AccessType
    Public AccessItemID
    Public AccessItem
    Public AccessRightID
    Public AccessRight
    Public Tasks

    Public Queue

    '---------------------'
    ' Private Variable    '
    '---------------------'
    Private prvRequestTypeList
    Private prvAccessTypeList


    Private Sub Class_Initialize()

        prvErrNb = 0
        prvErrMsg = ""
        prvLang = IIf(Session("lang") = "","de",Session("lang"))

        Set Tasks = Server.CreateObject("Scripting.Dictionary")

        Set Queue = Server.CreateObject("Scripting.Dictionary")

        Dim Helper : Set Helper = New RequestHelper

        Set prvRequestTypeList = Helper.RequestTypeList()
        Set prvAccessTypeList = Helper.AccessTypeList()

    End Sub

    Public Sub Init

    End Sub

    Public Sub Fill(ByVal Rs)

        ReqID = Rs("reqid")
        ReqNb = Rs("reqnb")
        ReqTypeID = Rs("reqtypeid")
        ReqType = prvRequestTypeList(ReqTypeID).Name
        ReqCreated = Rs("req_created")
        ReqCreatedBy = Rs("req_createdby")

        WorkFlowID = Rs("workflowid")

        AccessTypeID = Rs("accesstypeid")
        AccessType = prvAccessTypeList(AccessTypeID).Name
        AccessItemID = Rs("accessitemid")
        AccessItem = Rs("accessitem")
        AccessRightID = Rs("accessrightid")
        AccessRight = Rs("accessright")

    End Sub

    Public Sub FillByAccessRight(ByVal hlpID, ByVal hlpAID, ByVal hlpARID)


        prvID = hlpID
        AccessRightID = hlpARID
        AccessItemID = hlpAID

        Dim SQLStr : SQLStr = "SELECT * FROM dbo.tblWorkFlowState(" & prvID   & ") WHERE accessitemid = " & hlpAID & " AND accessrightid=" & AccessRightID & " ORDER BY accessitemid, accessrightid, pos, tasktypeid"

        Dim RsD : Set RsD = DbExecute(SQLStr)

        Dim tstAcessItemID : tstAcessItemID = CLng(-1)
        Dim tstAccessRightID : tstAccessRightID = CLng(-1)
        Dim hlpAcessItemID
        Dim hlpAccessRightID

        If Not RsD.Eof Then
            hlpAcessItemID = CLng(RsD("accessitemid"))
            hlpAccessRightID = CLng(RsD("accessrightid"))
            Fill(RsD)
        End If

        Do While Not RsD.Eof
            If CLng(RsD("accessitemid")) <> tstAcessItemID Then
               tstAcessItemID = CLng(RsD("accessitemid"))
            End If
            If CLng(RsD("accessrightid")) <> tstAccessRightID Then
               tstAccessRightID = CLng(RsD("accessrightid"))
            End If
            Do While Not RsD.Eof And hlpAcessItemID = tstAcessItemID And hlpAccessRightID = tstAccessRightID
                Set SubItem = New WorkFlowStateDetailItem
                SubItem.Fill(RsD)
                Tasks.Add Tasks.Count + 1, SubItem
                RsD.MoveNext
                If Not RsD.Eof Then
                    hlpAcessItemID = CLng(RsD("accessitemid"))
                    hlpAccessRightID = CLng(RsD("accessrightid"))
                End If
            Loop
        Loop
        RsD.Close
        Set RsD = Nothing

        FillQueue

    End Sub

    Public Sub FillQueue

        Dim SQLStr : SQLStr = "SELECT DISTINCT sendto, sendto_final FROM dbo.tblWorkFlowState(" & prvID   & ") WHERE accessitemid = " & AccessItemID & " AND accessrightid=" & AccessRightID

        Dim RsD : Set RsD = DbExecute(SQLStr)

        Dim RsG
        Dim Item
        Dim SubItem
        Dim hlpUser

        Dim UserList

        Do While Not RsD.Eof
            Set Item = New ListItem
            Item.Value = RsD("sendto")
            Set Item.Tag = Server.CreateObject("Scripting.Dictionary")

            If RsD("sendto_final") = RsD("sendto") Then
               SQLStr = "SELECT * FROM vwRequestGroup WHERE groupid='" & Item.Value & "'"
               Set RsG = DbExecute(SQLStr)
               Do While Not RsG.Eof
                    Set hlpUser = New ADUser
                    hlpUser.ID = RsG("isid")
                    Set SubItem = New ListItem
                    SubItem.Value = hlpUser.ID
                    SubItem.Name = hlpUser.DisplayName
                    If Not Item.Tag.Exists(SubItem.Value ) Then
                        Item.Tag.Add SubItem.Value, SubItem
                    End If
                    RsG.MoveNext
               Loop
               RsG.Close
               Set RsG = Nothing

            Else

                Set hlpUser = New ADUser
                hlpUser.ID = RsD("sendto_final")
                Set SubItem = New ListItem
                SubItem.Value = hlpUser.ID
                SubItem.Name = hlpUser.DisplayName
                Item.Tag.Add SubItem.Value, SubItem

            End If
            Queue.Add Item.Value, Item
            RsD.MoveNext
        Loop

    End Sub

End Class

Class  WorkFlowStateDetailItem

    ' Default Part'
    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
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

    Public Pos
    Public TaskTypeID
    Public TaskType
    Public TaskTypeIcon
    Public TaskStateID
    Public TaskState
    Public TaskID
    Public TaskNb
    Public TaskCreated
    Public TaskCreatedBy
    Public TaskLastEdit
    Public TaskLastEditBy
    Public SendTo
    Public SendToFinal
    Public Queue


     '---------------------'
    ' Private Variable    '
    '---------------------'
    Private prvRequestStatusList
    Private prvApproveStatusList
    Private prvTaskTypeList


    Private Sub Class_Initialize()

        prvErrNb = 0
        prvErrMsg = ""
        prvLang = IIf(Session("lang") = "","de",Session("lang"))

        Dim Helper : Set Helper = New RequestHelper

        Set prvRequestStatusList = Helper.RequestStatusList()
        Set prvApproveStatusList = Helper.ApproveStatusList()
        Set prvTaskTypeList = Helper.TaskTypeList()

    End Sub


    Public Sub Fill (Rs)

        Pos = Rs("pos")
        TaskTypeID = Rs("tasktypeid")
        TaskType = prvTaskTypeList(TaskTypeID).Name
        TaskStateID = Rs("taskstateid")
        TaskTypeIcon = prvTaskTypeList(TaskTypeID).IconClass
        If TaskTypeID = cTaskTypeApprove Then
            TaskState = prvApproveStatusList(TaskStateID).Name
        Else
            TaskState = prvRequestStatusList(IIf(TaskStateID < 10, 10, TaskStateID)).Name
        End If
        TaskID = Rs("taskid")
        TaskNb = Rs("tasknb")
        TaskCreated = Rs("task_created")
        TaskCreatedBy = Rs("task_createdby")
        TaskLastEdit = Rs("task_lastedit")
        TaskLastEditBy = Rs("task_lasteditby")
        SendTo = Rs("sendto")
        SendToFinal = Rs("sendto_final")

    End Sub

End Class




Class RequestDetail

    Private prvID
    Private prvTID
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

    Public Property Get TID
        TID = prvTID
    End Property

    Public Property Let TID (Value)
        prvTID = Value
        TInit
    End Property

    Public Property Get DetailID
        DetailID = prvID
    End Property

    Public Property Let DetailID (Value)
        prvID = Value
    End Property

    Public ReqID
    Public AccessItemID
    Public AccessItem
    Public AccessRightID
    Public AccessRight
    Public StateID
    Public State
    Public AccessType
    Public AccessTypeID
    Public CreatedBy
    Public Created
    Public Description
    Public ISID
    Public DisplayName
    Public Department
    Public DepartmentID
    Public ReqNb
    Public Self
    Public ReqTypeID
    Public ReqType
    Public ReqTypeIcon
    Public Selected
    Public TaskID
    Public TaskTypeID
    Public TaskType
    Public TaskTypeIcon
    Public TaskNb
    Public Pos
    Public Source
    Public Comment
    Public TaskStateID
    Public TaskState
    Public ApprovalRequired
    Public DependOnPos
    Public SendApproverEmail
    Public SendStatusEmail
    Public Queue
    Public SendTo
    Public SendToFinal
    Public IsGxp
    Public ELogNb

    Public TaskTypeList
    Public RequestTypeList
    Public RequestStatusList
    Public ApproveStatusList

    Public ErrMsg
    Public ErrNb

    Private prvUploadPath

    Public DownloadUrl

    Private Sub Class_Initialize()
        prvLang = IIf(Session("lang")="","de",Session("lang"))
        prvID = CLng(-1)
        Selected = 1
        prvUploadPath = GetAppSettings("uploadpath") & "\Task"
        Dim Helper : Set Helper = New RequestHelper
        Set RequestTypeList = Helper.RequestTypeList
        Set RequestStatusList = Helper.RequestStatusList
        Set ApproveStatusList = Helper.ApproveStatusList
        Set TaskTypeList = Helper.TaskTypeList
    End Sub

    Private Sub Init

        Dim SQLStr : SQLStr = "SELECT * FROM vwRequestDetail WHERE id=" & prvID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Fill(Rs)
        End If
        Rs.Close
        Set Rs = Nothing

    End Sub

    Private Sub TInit

        Dim SQLStr : SQLStr = "SELECT * FROM vwRequestDetail WHERE taskid=" & prvTID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Fill(Rs)
        End If
        Rs.Close
        Set Rs = Nothing

    End Sub

    Public Sub Fill (Rs)
        If Not Rs.Eof Then
            prvID = CLng(Rs("id"))
            prvTID = CLng(Rs("taskid"))
            ReqID = Rs("reqid")
            ReqNb = Rs("reqnb")
            AccessItemID = Rs("accessitemid")
            AccessItem = Rs("accessitem")
            AccessRight = Rs("accessright")
            AccessRightID = Rs("accessrightid")
            StateID = Rs("stateid")
            State = RequestStatusList(StateID).Name
            AccessType = Rs("accesstype")
            AccessTypeID = Rs("accesstypeid")
            Created = Rs("created")
            CreatedBy = Rs("createdby")
            Description = Rs("description")
            DisplayName = Rs("displayname")
            ISID = Rs("isid")
            Department = Rs("department")
            DepartmentID = Rs("departmentid")
            Self = Rs("self")

            ReqTypeID = Rs("typeid")
            ReqType = RequestTypeList(ReqTypeID).Name
            ReqTypeIcon = RequestTypeList(ReqTypeID).IconClass

            TaskID = Rs("taskid")
            TaskTypeID = Rs("tasktypeid")

            TaskType = TaskTypeList(TaskTypeID).Name
            TaskTypeIcon = TaskTypeList(TaskTypeID).IconClass
            TaskNb = Rs("tasknb")

            Pos = Rs("pos")
            Source = Rs("source")
            Comment = Rs("taskcomment")
            TaskStateID = Rs("taskstateid")

            Select Case TaskTypeID
                Case cTaskTypeApprove
                    TaskState = ApproveStatusList(CInt(TaskStateID)).Name
                Case cTaskTypeExecute
                    TaskState = RequestStatusList(TaskStateID).Name
                Case cTaskTypeUpload
                    TaskState = RequestStatusList(TaskStateID).Name
            End Select

            ApprovalRequired = Rs("approval_required")
            DependOnPos = Rs("pos_dependon")
            SendApproverEmail = Rs("send_approver_email")
            SendStatusEmail = Rs("send_status_email")
            Queue = Rs("queue")
            SendTo = Rs("sendto")
            SendToFinal = Rs("sendto_final")
            IsGXP = Rs("isgxp")
            ELogNb = Rs("elognb")

            DownloadUrl=curRootFile & "/upload/task/" & TaskNb & ".pdf"

        End If
    End Sub

    Public Function Approve

        Approve = False

        Dim myConn : Set myConn = DbOpenConnection()
        myConn.BeginTrans

        Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "RequestDetailApprove"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = myConn

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@ReqID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ReqID

        Set Parameter = Cmd.CreateParameter("@TaskID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TaskID

        Set Parameter = Cmd.CreateParameter("@ElogNb", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ElogNb

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        If Comment = "" Then
            Set Parameter = Cmd.CreateParameter("@Comment", adVarWChar, adParamInput, 255, Null)
        Else
            Set Parameter = Cmd.CreateParameter("@Comment", adVarWChar, adParamInput, 255)
            Parameter.Value = Comment
        End If
        Cmd.Parameters.Append Parameter

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = -1 Then
            myConn.RollbackTrans
            Exit Function
        End If

        myConn.CommitTrans
        Set myConn = Nothing

        Approve = True

        SendMail(cRequestMailRequestorApproved)
        SendTaskEmail

    End Function

    Public Function Reject

        Reject = False

        Dim myConn : Set myConn = DbOpenConnection()
        myConn.BeginTrans

        Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "RequestDetailReject"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = myConn

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@ReqID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ReqID

        Set Parameter = Cmd.CreateParameter("@TaskID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TaskID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        If Comment = "" Then
            Set Parameter = Cmd.CreateParameter("@Comment", adVarWChar, adParamInput, 255, Null)
        Else
            Set Parameter = Cmd.CreateParameter("@Comment", adVarWChar, adParamInput, 255)
            Parameter.Value = Comment
        End If
        Cmd.Parameters.Append Parameter

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = -1 Then
            myConn.RollbackTrans
            Exit Function
        End If

        myConn.CommitTrans
        Set myConn = Nothing

        Reject = True

        SendMail(cRequestMailRequestorRejected)

    End Function


    Public Function Done

        Done = False

        Dim myConn : Set myConn = DbOpenConnection()
        myConn.BeginTrans

        Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "RequestDetailDone"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = myConn

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@ReqID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ReqID

        Set Parameter = Cmd.CreateParameter("@TaskID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TaskID

        Set Parameter = Cmd.CreateParameter("@AccessItemID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccessItemID

        Set Parameter = Cmd.CreateParameter("@AccessRightID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccessRightID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        If Comment = "" Then
            Set Parameter = Cmd.CreateParameter("@Comment", adVarWChar, adParamInput, 255, Null)
        Else
            Set Parameter = Cmd.CreateParameter("@Comment", adVarWChar, adParamInput, 255)
            Parameter.Value = Comment
        End If
        Cmd.Parameters.Append Parameter

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = -1 Then
            myConn.RollbackTrans
            Exit Function
        End If

        myConn.CommitTrans
        Set myConn = Nothing

        Done = True

        SendMail(cRequestMailRequestorDone)
        SendTaskEmail

    End Function

    Public Function NotDone

        NotDone = False

        ErrMsg = GetLabel("msgWorkItemNotDoneSuccess", prvLang)
        ErrNb = 0

        On Error Resume Next

        Dim myConn : Set myConn = DbOpenConnection()
        myConn.BeginTrans

        Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "RequestDetailNotDone"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = myConn

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@ReqID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ReqID

        Set Parameter = Cmd.CreateParameter("@TaskID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TaskID

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        If Comment = "" Then
            Set Parameter = Cmd.CreateParameter("@Comment", adVarWChar, adParamInput, 255, Null)
        Else
            Set Parameter = Cmd.CreateParameter("@Comment", adVarWChar, adParamInput, 255)
            Parameter.Value = Comment
        End If
        Cmd.Parameters.Append Parameter

        Cmd.Execute

        If Err <> 0 Then
            ErrMsg = GetLabel("msgWorkItemNotDoneError", prvLang)
            ErrNb = 1
        End If

        If Cmd.Parameters("@RETURN_VALUE").Value = -1 Then
            ErrMsg = GetLabel("msgWorkItemNotDoneError", prvLang)
            ErrNb = 1
            myConn.RollbackTrans
            Exit Function
        End If

        myConn.CommitTrans
        Set myConn = Nothing

        NotDone = True

        On Error Goto 0
        SendMail(cRequestMailRequestorNotDone)

    End Function


    Public Sub SendTaskEmail

        Dim SQLStrCr : SQLStrCr = "SELECT taskid FROM task WHERE taskid IN (SELECT taskid FROM request_mailqueue WHERE id=" & prvID & " AND mail_sent=0)"
        Dim RsCr : Set RsCr = DbExecute(SQLStrCr)
        Dim Item

        Do While Not RsCr.Eof
            Set Item = New RequestDetail
            Item.TID = RsCr("taskid")
            Select Case Item.TaskTypeID
                Case cTaskTypeApprove
                    Item.SendMail(cRequestMailApproverOpen)
                Case cTaskTypeExecute
                    Item.SendMail(cRequestMailTaskOpen)
                Case cTaskTypeUpload
                    Item.SendMail(cRequestMailTaskOpen)
            End Select
            RsCr.MoveNext

            DbExecute("UPDATE request_mailqueue SET mail_sent=1, send=GETDATE(), sendby='" & Session("login") & "' WHERE taskid=" & Item.TID & " AND id=" & Item.ID)

        Loop
        RsCr.Close
        Set RsCr = nothing


    End Sub


    Public Function SendMail(ByVal Typ)

        Dim Receipients : Set Receipients = Server.CreateObject("Scripting.Dictionary")
        Dim Recipient
        Dim MailQueue
        Dim MailList

        Select Case Typ

            Case  cRequestMailRequestorOpen

                Set Recipient = New ListItem

                Recipient.Value = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","email")
                Recipient.Name = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","displayname")
                Receipients.Add Recipient.Value, Recipient

            Case  cRequestMailApproverOpen


                MailQueue = ReturnFromRecord("accessitem_right_task", "id=" & AccessRightID & " AND tasktypeid=" & TaskTypeID & " AND pos=" & Pos, "sendto")

                IF MailQueue <> "" Then

                    Set MailList = ExpandMailList(MailQueue,ISID)

                    For Each Recipient In  MailList.Items
                        If Not Receipients.Exists(CStr(Recipient.Value)) And CStr(Recipient.Value) <> "" Then
                            Receipients.Add Recipient.Value, Recipient
                        End If
                    Next
                    Set MailList = Nothing
                End If

            Case  cRequestMailTaskOpen

                MailQueue = SendTo

                IF MailQueue <> "" Then
                    Set MailList = ExpandMailList(MailQueue,ISID)

                    For Each Recipient In  MailList.Items
                        If Not Receipients.Exists(CStr(Recipient.Value)) And CStr(Recipient.Value) <> "" Then
                            Receipients.Add Recipient.Value, Recipient
                        End If
                    Next
                    Set MailList = Nothing
                End If

            Case  cRequestMailRequestorApproved

                Set Recipient = New ListItem
                Recipient.Value = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","email")
                Recipient.Name = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","displayname")
                Receipients.Add Recipient.Value, Recipient

            Case  cRequestMailRequestorRejected

                Set Recipient = New ListItem
                Recipient.Value = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","email")
                Recipient.Name = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","displayname")
                Receipients.Add Recipient.Value, Recipient

            Case cRequestMailRequestorDone

                Set Recipient = New ListItem
                Recipient.Value = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","email")
                Recipient.Name = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","displayname")
                Receipients.Add Recipient.Value, Recipient

            Case cRequestMailRequestorNotDone

                Set Recipient = New ListItem
                Recipient.Value = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","email")
                Recipient.Name = ReturnFromRecord("aduserlist","isid='" & CreatedBy & "'","displayname")
                Receipients.Add Recipient.Value, Recipient


        End Select


        If Receipients.Count > 0 Then

            Dim myMail
            Set myMail = New Mail

            myMail.FromName = "ICAM-DigiMPS"
            myMail.From = "icam-noreply@merck.com"
            If IsDebug = 0 Then
                For Each Recipient In Receipients.Items
                    myMail.AddAddress Recipient.Value, Recipient.Name
                Next
            Else
                myMail.AddAddress "thl@lauterboeck.at","Thomas Lauterboeck"
            End If

            myMail.Subject = HtmlSubject(Typ)
            myMail.Body = HtmlBody(Typ)
            myMail.IsHtml = True
            SendMail = myMail.Send

        End If

    End Function

    Public Function ExpandMailList(ByVal MailGroup, ByVal hlpISID)

        Dim rItem
        Dim HlpText
        Dim Rs

        Set ExpandMailList = Server.CreateObject("Scripting.Dictionary")

        Dim MyadUser : Set MyadUser = New ADUser


        If MailGroup = "people-manager" Then
           Dim MyTstUser : Set MyTstUser = New ADUser
           MyTstUser.ID = hlpISID
           Dim SQLStr : SQLStr = "SELECT * FROM aduserlist WHERE LOWER(isid)='" & LCase(MyTstUser.ManagerISID) & "'"
           Dim Rs1 : Set Rs1 = DbExecute(SQLStr)
           If Rs1.Eof Then
              MailGroup = "mmd-it"
           End If
           Rs1.Close
           Set Rs1=Nothing
        End If


        Select Case MailGroup
        Case "people-manager"


            MyadUser.ID = hlpISID

            Set rItem = New ListItem
            rItem.Value = ReturnFromRecord("aduserlist","isid='" & MyadUser.ManagerISID & "'","email")
            rItem.Name = ReturnFromRecord("aduserlist","isid='" & MyadUser.ManagerISID & "'","displayname")
            ExpandMailList.Add rItem.Value, rItem

	    Case "user"


            MyadUser.ID = hlpISID

            Set rItem = New ListItem
            rItem.Value = ReturnFromRecord("aduserlist","isid='" & MyadUser.ID & "'","email")
            rItem.Name = ReturnFromRecord("aduserlist","isid='" & MyadUser.ID & "'","displayname")
            ExpandMailList.Add rItem.Value, rItem

        Case "system-owner"

            Set rItem = New ListItem
            HlpText = ReturnFromRecord("accessitem","id=" & AccessItemID ,"sys_owner")
            If HlpText = "" Then
               HlpText = "tlauterb"
            End If
            rItem.Value = ReturnFromRecord("aduserlist","isid='" & HlpText & "'","email")
            rItem.Name = ReturnFromRecord("aduserlist","isid='" & HlpText & "'","displayname")
            ExpandMailList.Add rItem.Value, rItem

        Case Else

            Set Rs = DbExecute("SELECT * FROM vwRequestGroup WHERE groupid='" & MailGroup & "' ORDER BY displayname")
            Do While Not Rs.Eof
                Set rItem = New ListItem
                rItem.Value = Rs("email")
                rItem.Name = Rs("displayname")

                If  Not ExpandMailList.Exists (rItem.Value) Then
                    ExpandMailList.Add rItem.Value, rItem
                End If
                Rs.MoveNext
            Loop
            Rs.Close
            Set Rs = Nothing

        End Select

    End Function


    Private Function HtmlBody(ByVal Typ)

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

        Dim url : url = GetAppSettings("report_url")


        Dim TemplateFile  : Set TemplateFile = Fs.OpenTextFile(Server.MapPath("/" & Application("root") & "/MailTemplates/icam.htm"))

         '1.Einlesen Template
        Dim Template : Template = TemplateFile.ReadAll()


        Template = Replace(Template,"$$applink$$",url & "/" & Application("root"))
        Template = Replace(Template,"$$imagepath$$",url & "/" & Application("root"))
        Template = Replace(Template,"$$subject$$",ToUTF8(GetLabel("lblMailTitle" & Typ, prvLang)))

        Dim MailText : MailText = ""
        Dim MailTable : MailTable = ""

        Select Case Typ

            Case  cRequestMailRequestorOpen

                MailText = GetLabel("mailRequestAccessCreated", prvLang)
                MailTable = HtmlRequestBodyAsTable()

            Case  cRequestMailApproverOpen

                MailText = GetLabel("mailRequestTaskOpened", prvLang)
                MailTable = HtmlRequestBodyAsTable()

            Case  cRequestMailRequestorApproved

                MailText = GetLabel("mailRequestAccessApproved", prvLang)
                MailTable = HtmlRequestBodyAsTable()

            Case  cRequestMailRequestorRejected

                MailText = GetLabel("mailRequestAccessRejected", prvLang)
                MailTable = HtmlRequestBodyAsTable()

            Case  cRequestMailRequestorDone

                MailText = GetLabel("mailRequestMailRequestorDone", prvLang)
                MailTable = HtmlRequestBodyAsTable()

            Case  cRequestMailRequestorNotDone

                MailText = GetLabel("mailRequestMailRequestorNotDone", prvLang)
                MailTable = HtmlRequestBodyAsTable()

            Case cRequestMailTaskOpen

                MailText = GetLabel("mailRequestTaskOpened", prvLang)
                MailTable = HtmlRequestBodyAsTable()

        End Select

        MailText = Replace(MailText,"$$reqnb$$",ReqNb & "/" & TaskNb)
        MailText = Replace(MailText,"$$app$$",UCase(Application("root")))
        MailText = Replace(MailText,"$$accessitem$$", MailTable)
        MailText = Replace(MailText,"$$link$$","<a href="""  & url & "/" & Application("root") & """>" & Application("root") & "</a>")

        Template = Replace(Template,"$$mailtext$$",ToUTF8(MailText))

        HtmlBody = Template

    End Function


    Private Function HtmlRequestBodyAsTable()

        Dim HmtlStr : HtmlStr = ""

        HtmlStr = "<table border=""0"">" & _
                "<tr>" & _
                "<td>" & _
                "ISID:" & _
                "</td>" & _
                "<td>" & _
                ISID & _
                "</td>" & _
                "</tr>" & _
                "<tr>" & _
                "<td>" & _
                GetLabel("lblName", prvLang) & ":" & _
                "</td>" & _
                "<td>" & _
                DisplayName & _
                "</td>" & _
                "</tr>" & _
                "<tr>" & _
                "<td>" & _
                GetLabel("lblDate", prvLang) & ":" & _
                "</td>" & _
                "<td>" & _
                Created & _
                "</td>" & _
                "</tr>" & _
                "<tr>" & _
                "<td>" & _
                GetLabel("lblAccessRights", prvLang) & ":" & _
                "</td>" & _
                "<td>" & _
                AccessItem & "/" & AccessRight  & _
                "</td>" & _
                "</tr>"
        If Description <> "" Then
             HtmlStr = HtmlStr & "<tr>" & _
                "<td>" & _
                GetLabel("lblDescription", prvLang) & ":" & _
                "</td>" & _
                "<td>" & _
                Description & _
                "</td>" & _
                "</tr>"
        End If
        If Comment <> "" Then
             HtmlStr = HtmlStr & "<tr>" & _
                "<td>" & _
                GetLabel("lblComment", prvLang) & ":" & _
                "</td>" & _
                "<td>" & _
                Comment & _
                "</td>" & _
                "</tr>"
        End If
        HtmlStr = HtmlStr & "<tr>" & _
                "<td>" & _
                GetLabel("lblRequestor", prvLang) & ":" & _
                "</td>" & _
                "<td>" & _
                CreatedBy & _
                "</td>" & _
                "</tr>" & _
                "</table><br>"
        HtmlRequestBodyAsTable = HtmlStr
    End Function


    Private Function HtmlSubject(ByVal Typ)

        Select Case Typ

            Case  cRequestMailRequestorOpen

                HtmlSubject  = GetLabel("subjectRequestAccessCreated", prvLang)

            Case  cRequestMailApproverOpen

                HtmlSubject  = GetLabel("subjectRequestTaskOpened", prvLang)

            Case  cRequestMailRequestorApproved

                HtmlSubject  = GetLabel("subjectRequestAccessApproved", prvLang)

            Case  cRequestMailRequestorRejected

                HtmlSubject  = GetLabel("subjectRequestAccessRejected", prvLang)

            Case  cRequestMailRequestorDone

                HtmlSubject = GetLabel("subjectRequestMailRequestorDone", prvLang)

            Case  cRequestMailRequestorNotDone

                HtmlSubject = GetLabel("subjectRequestMailRequestorNotDone", prvLang)

            Case cRequestMailTaskOpen

                HtmlSubject = GetLabel("subjectRequestTaskOpened", prvLang)

        End Select

        Select Case Typ
            Case cRequestMailTaskOpen
                HtmlSubject = Replace(HtmlSubject,"$$reqnb$$",TaskNb)
            Case cRequestMailApproverOpen
                HtmlSubject = Replace(HtmlSubject,"$$reqnb$$",TaskNb)
            Case Else
                HtmlSubject = Replace(HtmlSubject,"$$reqnb$$",ReqNb)
        End Select

    End Function

    Private Function HtmlOnlySubject(ByVal Typ)

        Select Case Typ

            Case  cRequestMailRequestorOpen

                HtmlOnlySubject  = GetLabel("subjectRequestAccessOpened", prvLang)

            Case  cRequestMailApproverOpen

                HtmlOnlySubject  = GetLabel("subjectRequestTaskOpened", prvLang)

            Case  cRequestMailRequestorApproved

                HtmlOnlySubject  = GetLabel("subjectRequestAccessApproved", prvLang)

            Case  cRequestMailRequestorRejected

                HtmlOnlySubject  = GetLabel("subjectRequestAccessRejected", prvLang)

            Case  cRequestMailRequestorDone

                HtmlOnlySubject = GetLabel("subjectRequestMailRequestorDone", prvLang)

            Case  cRequestMailRequestorNotDone

                HtmlOnlySubject = GetLabel("subjectRequestMailRequestorNotDone", prvLang)

            Case cRequestMailTaskOpen

                HtmlOnlySubject = GetLabel("subjectRequestTaskOpened", prvLang)

        End Select

        Select Case Typ
            Case cRequestMailTaskOpen
                HtmlOnlySubjectbject = Replace(HtmlOnlySubject,"$$reqnb$$",TaskNb)
            Case cRequestMailApproverOpen
                HtmlOnlySubjectbject = Replace(HtmlOnlySubject,"$$reqnb$$",TaskNb)
            Case Else
                HtmlOnlySubject = Replace(HtmlOnlySubject,"$$reqnb$$",ReqNb)
        End Select

    End Function




    Public Function SaveUAF (ByVal FileObj)

        SaveUAF = False

        ErrMsg = GetLabel("msgDataSaveSuccess", Session("lang"))
        ErrNb = 0

        If FileObj.FilePath <> ""  Then

            Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
            Dim FileExt : FileExt =  Fs.GetExtensionName(FileObj.FilePath)

            Dim FileName : FileName = prvUploadPath & "\" & TaskNb & "." & FileExt

            On Error Resume Next

            If Fs.FileExists(FileName) Then
                Fs.DeleteFile FileName
            End If

            If Err <> 0 Then
                ErrMsg = GetLabel("msgDataSaveError", prvLang)
                ErrNb = 1
            Else

                FileObj.SaveAs prvUploadPath & "\" & TaskNb & "." & FileExt
                If Err <> 0 Then
                    ErrMsg = GetLabel("msgDataSaveError", prvLang)
                    ErrNb = 2
                Else
                    SaveUAF = Done
                End If
            End If

            On Error Goto 0

        End If

    End Function

End Class


Class RequestHelper

    Public Lang
    Private Sub Class_Initialize()
        Lang = IIf(Session("lang")="","de",Session("lang"))
    End Sub

    Public Function RequestStatusList()

        Set RequestStatusList = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New ListItem
        Item.Value = cTaskStateOpened
        Item.Name = GetLabel("lblRequestState" & Item.Value, Lang)
        RequestStatusList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cTaskStateProgress
        Item.Name = GetLabel("lblRequestState" & Item.Value, Lang)
        RequestStatusList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cTaskStatePending
        Item.Name = GetLabel("lblRequestState" & Item.Value, Lang)
        RequestStatusList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cTaskStateClosed
        Item.Name = GetLabel("lblRequestState" & Item.Value, Lang)
        RequestStatusList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cTaskStateCanceled
        Item.Name = GetLabel("lblRequestState" & Item.Value, Lang)
        RequestStatusList.Add Item.Value, Item

    End Function


    Public Function ApproveStatusList()

        Set ApproveStatusList = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New ListItem
        Item.Value = cRequestAppoverStateOpened
        Item.Name = GetLabel("lblApproveState" & Item.Value, Lang)
        ApproveStatusList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cRequestAppoverStateGranted
        Item.Name = GetLabel("lblApproveState" & Item.Value, Lang)
        ApproveStatusList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cRequestAppoverStateRejected
        Item.Name = GetLabel("lblApproveState" & Item.Value, Lang)
        ApproveStatusList.Add Item.Value, Item

    End Function


    Public Function RequestTypeList()

        Set RequestTypeList = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New ListItem
        Item.Value = cRequestTypeGrant
        Item.Name = GetLabel("lblRequestType" & Item.Value, Lang)
        Item.IconClass = cRequestTypeGrantIcon
        RequestTypeList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cRequestTypeRevoke
        Item.Name = GetLabel("lblRequestType" & Item.Value, Lang)
        Item.IconClass = cRequestTypeRevokeIcon
        RequestTypeList.Add Item.Value, Item

    End Function

    Public Function TaskTypeList()

        Set TaskTypeList = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New ListItem
        Item.Value = cTaskTypeApprove
        Item.Name = GetLabel("lblTaskType" & Item.Value, Lang)
        Item.IconClass = cTaskTypeApproveIcon
        TaskTypeList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cTaskTypeExecute
        Item.Name = GetLabel("lblTaskType" & Item.Value, Lang)
        Item.IconClass = cTaskTypeExecuteIcon
        TaskTypeList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = cTaskTypeUpload
        Item.Name = GetLabel("lblTaskType" & Item.Value, Lang)
        Item.IconClass = cTaskTypeUploadIcon
        TaskTypeList.Add Item.Value, Item

    End Function


    Public Function OpenRequests(ByVal AssignedTo)

        Set OpenRequests = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr

        If 1=0 Then ''IsAdmin Then
            SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid=10 AND queue='" & cQueueInbox & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueInbox & "') ORDER BY created DESC"
        Else
            ''SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid=10  AND queue='" & cQueueInbox & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueInbox & "') AND (sendto_final IN (SELECT groupid FROM request_group WHERE isid='" & Session("login") & "') OR sendto_final='" & Session("login") & "' OR isid IN (SELECT isid FROM dbo.ExpandPeopleList('" & Session("login") & "'))) ORDER BY created DESC"
            SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid=10  AND queue='" & cQueueInbox & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueInbox & "') AND (sendto_final IN (SELECT groupid FROM request_group WHERE isid='" & Session("login") & "') OR sendto_final='" & Session("login") & "' OR sendto_final IN (SELECT isid FROM aduserlist_delegate WHERE delegateisid='" & Session("login") & "')) ORDER BY created DESC"
        End If

        Dim RsD : Set RsD = DbExecute(SQLStr)
        Dim Item

        Do While Not RsD.Eof
            Set Item = New RequestDetail
            Item.Fill(RsD)
            OpenRequests.Add Item.TaskID, Item
            RsD.MoveNext
        Loop
        RsD.Close
        Set RsD = Nothing

    End Function

    Public Function ClosedRequests(ByVal AssignedTo)

        Set ClosedRequests = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr

        If IsAdmin Then
            SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid>30  AND queue='" & cQueueInbox & "'  AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueInbox & "') ORDER BY created DESC"
        Else
            SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid>30  AND queue='" & cQueueInbox & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueInbox & "') AND (sendto_final IN (SELECT groupid FROM request_group WHERE isid='" & Session("login") & "') OR sendto_final='" & Session("login") & "' OR isid IN (SELECT isid FROM dbo.ExpandPeopleList('" & Session("login") & "'))) ORDER BY created DESC"
        End If

        Dim RsD : Set RsD = DbExecute(SQLStr)
        Dim Item

        Do While Not RsD.Eof
            Set Item = New RequestDetail
            Item.Fill(RsD)
            ClosedRequests.Add Item.TaskID, Item
            RsD.MoveNext
        Loop
        RsD.Close
        Set RsD = Nothing

    End Function

    Public Function OpenITWorkItems()

        Set OpenITWorkItems = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr

        If 1=0 Then ''IsAdmin Then
            SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid=10  AND queue='" & cQueueToDo & "' ORDER BY created DESC"
        Else
            ''SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid=10  AND queue='" & cQueueToDo & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueToDo & "') AND (sendto_final IN (SELECT groupid FROM request_group WHERE isid='" & Session("login") & "') OR sendto_final='" & Session("login") & "' OR isid IN (SELECT isid FROM dbo.ExpandPeopleList('" & Session("login") & "'))) ORDER BY created DESC"
            SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid=10  AND queue='" & cQueueToDo & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueToDo & "') AND (sendto_final IN (SELECT groupid FROM request_group WHERE isid='" & Session("login") & "') OR sendto_final='" & Session("login") & "') ORDER BY created DESC"
        End If

        Dim RsD : Set RsD = DbExecute(SQLStr)
        Dim Item

        Do While Not RsD.Eof
            Set Item = New RequestDetail
            Item.Fill(RsD)
            OpenITWorkItems.Add Item.TaskID, Item
            RsD.MoveNext
        Loop
        RsD.Close
        Set RsD = Nothing

    End Function

    Public Function OwnRequests()

        Set OwnRequests = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr

        SQLStr = "SELECT * FROM vwRequestDetail WHERE createdby='" & Session("login") & "' ORDER BY created DESC"

        Dim RsD : Set RsD = DbExecute(SQLStr)
        Dim Item

        Do While Not RsD.Eof
            Set Item = New RequestDetail
            Item.Fill(RsD)
            OwnRequests.Add Item.TaskID, Item
            RsD.MoveNext
        Loop
        RsD.Close
        Set RsD = Nothing

    End Function


    Public Function ClosedITWorkItems()

        Set ClosedITWorkItems = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr

        If IsAdmin Then
            SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid>30  AND queue='" & cQueueToDo & "' ORDER BY created DESC"
        Else
            SQLStr = "SELECT * FROM vwRequestDetail WHERE taskstateid>30  AND queue='" & cQueueToDo & "' AND tasktypeid IN (SELECT tasktypeid FROM tasktype WHERE queue='" & cQueueToDo & "') AND (sendto_final IN (SELECT groupid FROM request_group WHERE isid='" & Session("login") & "') OR sendto_final='" & Session("login") & "' OR isid IN (SELECT isid FROM dbo.ExpandPeopleList('" & Session("login") & "'))) ORDER BY created DESC"
        End If

        Dim RsD : Set RsD = DbExecute(SQLStr)
        Dim Item

        Do While Not RsD.Eof
            Set Item = New RequestDetail
            Item.Fill(RsD)
            ClosedITWorkItems.Add Item.TaskID, Item
            RsD.MoveNext
        Loop
        RsD.Close
        Set RsD = Nothing

    End Function

    Public Function HeaderWorkItemsXLS

        Set HeaderWorkItemsXLS = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblRequestNb", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "ReqNb"
        Item.Format = ""
        Item.ColumnWidth = 50
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblRequestType", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "ReqType"
        Item.Format = ""
        Item.ColumnWidth = 60
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblTaskNb", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "TaskNb"
        Item.Format = ""
        Item.ColumnWidth = 50
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblRequestType", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "TaskType"
        Item.Format = ""
        Item.ColumnWidth = 60
        HeaderWorkItemsXLS.Add Item.ID, Item


        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblCreatedBy", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "CreatedBy"
        Item.Format = ""
        Item.ColumnWidth = 50
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblCreated", Lang)
        Item.Typ = cXLSDataTypeDate
        Item.ValueName = "Created"
        Item.Format = "d"
        Item.ColumnWidth = 50
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblRequestedFor", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "DisplayName"
        Item.Format = ""
        Item.ColumnWidth = 100
        HeaderWorkItemsXLS.Add Item.ID, Item

        ''Set Item = New XLSHeader
        'Ä'Item.ID = 8
        ''Item.Description = GetLabel("lblDepartment", Lang)
        ''Item.Typ = cXLSDataTypeText
        ''Item.ValueName = "Department"
        ''Item.Format = ""
        ''Item.ColumnWidth = 50
        ''HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblState", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "TaskState"
        Item.Format = ""
        Item.ColumnWidth = 40
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblAccessItemType", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessType"
        Item.Format = ""
        Item.ColumnWidth = 40
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblAccessItem", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessItem"
        Item.Format = ""
        Item.ColumnWidth = 100
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblAccessRights", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessRight"
        Item.Format = ""
        Item.ColumnWidth = 80
        HeaderWorkItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderWorkItemsXLS.Count + 1
        Item.Description = GetLabel("lblAssignedTo", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "SendToFinal"
        Item.Format = ""
        Item.ColumnWidth = 80
        HeaderWorkItemsXLS.Add Item.ID, Item


    End Function


    Public Function HeaderRequestItemsXLS

        Set HeaderRequestItemsXLS = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblRequestNb", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "ReqNb"
        Item.Format = ""
        Item.ColumnWidth = 50
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblRequestType", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "ReqType"
        Item.Format = ""
        Item.ColumnWidth = 60
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblTaskNb", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "TaskNb"
        Item.Format = ""
        Item.ColumnWidth = 50
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblRequestType", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "TaskType"
        Item.Format = ""
        Item.ColumnWidth = 60
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblCreatedBy", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "CreatedBy"
        Item.Format = ""
        Item.ColumnWidth = 50
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblCreated", Lang)
        Item.Typ = cXLSDataTypeDate
        Item.ValueName = "Created"
        Item.Format = "d"
        Item.ColumnWidth = 50
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblRequestedFor", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "DisplayName"
        Item.Format = ""
        Item.ColumnWidth = 100
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblDepartment", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "Department"
        Item.Format = ""
        Item.ColumnWidth = 80
        ''HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblState", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "TaskState"
        Item.Format = ""
        Item.ColumnWidth = 50
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblAccessItemType", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessType"
        Item.Format = ""
        Item.ColumnWidth = 40
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblAccessItem", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessItem"
        Item.Format = ""
        Item.ColumnWidth = 100
        HeaderRequestItemsXLS.Add Item.ID, Item

        Set Item = New XLSHeader
        Item.ID = HeaderRequestItemsXLS.Count + 1
        Item.Description = GetLabel("lblAccessRights", Lang)
        Item.Typ = cXLSDataTypeText
        Item.ValueName = "AccessRight"
        Item.Format = ""
        Item.ColumnWidth = 80
        HeaderRequestItemsXLS.Add Item.ID, Item


    End Function


    Public Function AccessTypeList()

        Set AccessTypeList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM accesstype ORDER BY name"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof

            Set Item = New ListItem
            Item.Value = Rs("id")
            Item.Name = Rs("name")
            AccessTypeList.Add Item.Value, Item
            Rs.MoveNext

        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Public Function AccessItemList(ByVal Typ)

        Set AccessItemList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM accessitem WHERE accesstypeid=" & Typ & " ORDER BY name"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof

            Set Item = New ListItem
            Item.Value = Rs("id")
            Item.Name = Rs("name")
            AccessItemList.Add Item.Value, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

    End Function

    Public Function AccessRightList(ByVal ID)

        Set AccessRightList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM accessitem_right WHERE accessitemid=" & ID & " ORDER BY accessright"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof

            Set Item = New ListItem
            Item.Value = Rs("id")
            Item.Name = Rs("accessright")
            AccessRightList.Add Item.Value, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing
    End Function

End Class

%>