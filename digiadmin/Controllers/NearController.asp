<%

    Class NearController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    Public Sub Index()

        Dim pHelper : Set pHelper = New NearHelper
        Dim List : Set List = pHelper.List

        ViewData.Add "list", List

        %>   <!--#include file="../views/near/index.asp" --> <%

    End Sub


    Public Sub NearHistory()

        Dim pHelper : Set pHelper = New NearHelper
        Dim Param : Set Param = New NearSearchParam
        Dim List

        Dim SvpList : Set SvpList = pHelper.SPVAllItemList()

        If Session("nearnb") <> "" Then
            Param.Nb = Session("nearnb")
        Else
            Session("nearnb") = Param.Nb
        End If

        If Session("datefrom") <> "" Then
            Param.DateFrom = Session("datefrom")
        Else
            Session("datefrom") = Param.DateFrom
        End If

        If Session("dateto") <> "" Then
            Param.DateFrom = Session("dateto")
        Else
            Session("dateto") = Param.DateTo
        End If

        If Session("neartyp") <> "" Then
           Param.Typ = Session("neartyp")
        Else
           Session("neartyp") = Param.Typ
        End If

        If Session("assignedtosvp") <> "" Then
            Param.UserID = Session("assignedtosvp")
        Else
            Session("assignedtosvp") = Param.UserID
        End If

        If Session("state") <> "" Then
            Param.State = Session("state")
        Else
            Session("state") = Param.State
        End If

        If Session("istarget0") <> "" Then
            Param.IsTarget0 = CInt(Session("istarget0"))
        Else
            Session("istarget0") = CInt(Param.IsTarget0)
        End If



        If Session("regionid") <> "" Then
            Param.RegionID = CInt(Session("regionid"))
        Else
            Session("regionid") = CInt(Param.RegionID)
        End If

        If Session("roomid") <> "" Then
            Param.RoomID = Session("roomid")
        Else
            Session("roomid") = CInt(Param.RoomID)
        End If

        If Session("buildingid") <> "" Then
            Param.BuildingID = Session("buildingid")
        Else
            Session("buildingid") = CInt(Param.BuildingID)
        End If

        Dim rHelper : Set rHelper = New Region
        Dim rList : Set rList = rHelper.DDList

        Dim bHelper : Set bHelper = New Building
        Dim bList : Set bList = bHelper.DDList

        Set List = pHelper.HistoryList(Param)

        Dim oList : Set oList = New Room
        Set RoomList = oList.DDList

        Dim OpenCases : OpenCases = 0
        Dim ClosedCases : ClosedCases = 0

        For Each Item In List.Items
            If Item.State < 3 Then
               OpenCases = OpenCases + 1
            Else
               ClosedCases = ClosedCases + 1
            End If
        Next


        ViewData.Add "list", List
        ViewData.Add "regionlist", rList
        ViewData.Add "buildinglist", bList
        ViewData.Add "roomlist", RoomList
        ViewData.Add "svplist", SvpList
        ViewData.Add "open", OpenCases
        ViewData.Add "closed", ClosedCases

        %>   <!--#include file="../views/near/nearhistory.asp" --> <%

    End Sub


    Public Sub NearHistoryPost(args)

        Session("neartyp") = args("typ")
        Session("datefrom") = args("datefrom")
        Session("dateto") = args("dateto")
        Session("assignedtosvp") = args("assignedtosvp")
        Session("state") = args("state")
        Session("nearnb") = args("nearnb")
        Session("istarget0") = args("istarget0")
        Session("buildingid") = args("buildingid")
        Session("regionid") = args("regionid")
        Session("roomid") = args("roomid")

        Response.Redirect(curRootFile & "/near/nearhistory")

    End Sub


    Public Sub TaskHistory()

        Dim pHelper : Set pHelper = New NearHelper
        Dim Param : Set Param = New TaskSearchParam

        Dim TaskTypList : Set TaskTypList = New NearMissTaskTyp
        Dim TaskStateList : Set TaskStateList = New NearMissTaskState

        Dim uHelper : Set uHelper = New UserHelper

        Dim Item

        If Session("tasknb") <> "" Then
            Param.Nb = Session("tasknb")
        Else
            Session("tasknb") = Param.Nb
        End If

        If Session("tnearnb") <> "" Then
            Param.NearNb = Session("tnearnb")
        Else
            Session("tnearnb") = Param.NearNb
        End If

        If Session("tdatefrom") <> "" Then
            Param.DateFrom = Session("tdatefrom")
        Else
            Session("tdatefrom") = Param.DateFrom
        End If

        If Session("tdateto") <> "" Then
            Param.DateTo = Session("tdateto")
        Else
            Session("tdateto") = Param.DateTo
        End If

        If Session("tasktyp") <> "" Then
           Param.Typ = Session("tasktyp")
        Else
           Session("tasktyp") = Param.Typ
        End If

        If Session("tassignedto") <> "" Then
            Param.UserID = Session("tassignedto")
        Else
            Session("tassignedto") = Param.UserID
        End If

        If Session("tstate") <> "" Then
            Param.State = Session("tstate")
        Else
            Session("tstate") = Param.State
        End If

        Set List = pHelper.HistoryTaskList(Param)

        Dim OpenTasks : OpenTasks = 0
        Dim ClosedTasks : ClosedTasks = 0

        For Each Item In List.Items
            If Item.State < 3 Then
               OpenTasks = OpenTasks + 1
            Else
               ClosedTasks = ClosedTasks + 1
            End If
        Next
       
        ViewData.Add "list", List
        ViewData.Add "userlist", uHelper.UserListDD
        ViewData.Add "tasktyp",TaskTypList.List
        ViewData.Add "taskstate",TaskStateList.List

        ViewData.Add "opentasks", OpenTasks
        ViewData.Add "closedtasks", ClosedTasks

        %>   <!--#include file="../views/near/taskhistory.asp" --> <%

    End Sub


    Public Sub TaskHistoryPost(args)

        Session("tasktyp") = args("typ")
        Session("tdatefrom") = args("tdatefrom")
        Session("tdateto") = args("tdateto")
        Session("tassignedto") = args("assignedto")
        Session("tstate") = args("tstate")
        Session("tasknb") = args("ttasknb")
        Session("tnearnb") = args("nearnb")

        Response.Redirect(curRootFile & "/near/taskhistory")

    End Sub



    Public Sub MyList()

        Dim pHelper : Set pHelper = New NearHelper
        Dim List : Set List = pHelper.SPVList()
        ViewData.Add "list", List


        %>   <!--#include file="../views/near/mylist.asp" --> <%

    End Sub

    Public Sub MyTasks()

        Dim pHelper : Set pHelper = New NearHelper
        Dim List : Set List = pHelper.TaskList(Session("login"))

        Dim TaskTypList : Set TaskTypList = New NearMissTaskTyp
        Dim TaskStateList : Set TaskStateList = New NearMissTaskState

        ViewData.Add "list", List
        ViewData.Add "tasktyp",TaskTypList.List
        ViewData.Add "taskstate",TaskStateList.List

        %>   <!--#include file="../views/near/mytasks.asp" --> <%

    End Sub

    Public Sub editmytaskspost(args)

        Dim Item : Set Item = New NearMissTask

        Item.Init(args("taskid"))

        Item.NearID = args("nearid")
        Item.Description = args("description")
        Item.DueDate = args("duedate")
        Item.Comments = args("comments")
        Item.TaskTypeID = args("tasktypeid")
        Item.AssignedTo = args("assignedto")
        Item.Assigned = args("assigned")
        Item.State = args("state")
        Item.UserID = Session("userid")
        Item.Save

        Dim Link : Link = CurRootFile & "/near/mytasks"

        Response.Redirect(Link)

    End Sub



    Public Sub Edit(vars)

        Dim Item : Set Item = New NearMiss
        Item.Init(vars("id"))

        Dim TypList : Set TypList = New NearMissTyp
        Dim ActiveTab : ActiveTab = IIf(vars("tab")="", "home", vars("tab"))

        Dim TaskTypList : Set TaskTypList = New NearMissTaskTyp
        Dim TaskStateList : Set TaskStateList = New NearMissTaskState

        Dim nHelper : Set nHelper = New NearHelper

        Dim uHelper : Set uHelper = New UserHelper


        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
        Dim pPath : pPath = GetAppSettings("nearimagepath")
        pPath = pPath & "\" & Item.NearID

        Dim Folder : Set Folder = Nothing
        Dim File

        If Fs.FolderExists(pPath) Then
            Set Folder = Fs.GetFolder(pPath)
        End If

        Dim HasAnalyse : HasAnalyse = False

        If Not Folder Is Nothing Then
            For Each File In Folder.Files
                If Left(LCase(File.Name),5) = "5-why"  Then
                    HasAnalyse = True
                End If
                If Left(LCase(File.Name),9) = "fish-bone" Then
                    HasAnalyse = True
                End If
                If Left(LCase(File.Name),4) = "pdca" Then
                   HasAnalyse = True
                End If
            Next
        End If

        Dim t0Helper : Set t0Helper = New Target0RiskLevel

        Dim HasTarget0 : HasTarget0 = False

        If Item.Categorie <> "0000000000" And Item.RiskLevel > 0 Then
            HasTarget0 = True
        End If





        ViewData.Add "near", Item
        ViewData.Add "typ", TypList.List
        ViewData.Add "tasktyp",TaskTypList.List
        ViewData.Add "taskstate",TaskStateList.List
        ViewData.Add "target0list",t0Helper.List
        ViewData.Add "todo", vars("todo")
        ViewData.Add "svplist", nHelper.SPVItemList(Item.RoomID)
        ViewData.Add "folder", Folder
        ViewData.Add "hasanalyse", HasAnalyse
        ViewData.Add "hastarget0", HasTarget0
        ViewData.Add "userlist", uHelper.UserListDD()

        Dim oList : Set oList = New Rooms
        Dim RoomList : Set RoomList = oList.ListByRegion("", "")

        ViewData.Add "roomlist", RoomList

        %>   <!--#include file="../views/near/editnear.asp" --> <%

    End Sub


    Public Sub EditPost(args)



        Dim oUpload : Set oUpload = New clsUpload

        Dim Item : Set Item = New NearMiss
        Item.Init(oUpload("nearid").Value)
        Item.Description = oUpload("description").Value
        Item.Task = oUpload("task").Value
        Item.Typ = oUpload("typ").Value
        Item.Cont2Work = IIf(oUpload("cont2work").Value  <> "", 1,0)
        Item.Falling = IIf(oUpload("falling").Value <> "", 1,0)
        Item.RotatingParts = IIf(oUpload("rotatingparts").Value <> "", 1,0)
        Item.SqueezeDang = IIf(oUpload("squeezedang").Value <> "", 1,0)
        Item.CutDang = IIf(oUpload("cutdang").Value <> "", 1,0)
        Item.PushDang = IIf(oUpload("pushdang").Value <> "", 1,0)
        Item.HotDang = IIf(oUpload("hotdang").Value <> "", 1,0)
        Item.FireProtect = IIf(oUpload("fireprotect").Value <> "", 1,0)
        Item.DangGoods = IIf(oUpload("danggoods").Value <> "", 1,0)
        Item.Power = IIf(oUpload("power").Value <> "", 1,0)
        Item.Other = IIf(oUpload("other").Value <> "", 1,0)
        Item.OtherText = IIf(oUpload("othertext").Value = ""," ",oUpload("othertext").Value)


        Item.IsTarget0 = IIf(oUpload("istarget0").Value <> "", 1,0)
        Item.SolveImm = IIf(oUpload("solveimm").Value <> "", 1,0)
        Item.DueDate = oUpload("nmduedate").Value
        Item.RiskLevel = IIf(oUpload("target0risk").Value <> "", oUpload("target0risk").Value,0)

        If oUpload("todo").Value = "close" Then
            If Item.State = 3 Then
                Item.State = 0
            Else
                Item.State = 3
            End If
        End If

        If Item.Queue = "ehs" Then
           Item.EHSRating = oUpload("ehsrating").Value
        End If

        If oUpload("todo").Value = "forward" Then
            Item.State = 2
            If Item.Queue = "svp" Then
                Item.Queue = "ehs"
                Item.QueueDate = Now
            Else
                Item.Queue = "svp"
                Item.QueueDate = Now
            End If
        End If
        Item.RatingComment = IIf(oUpload("ratingcomment").Value = ""," ",oUpload("ratingcomment").Value)
        Item.AssignedToSPV = oUpload("assignedtospv").Value

        Item.CauseComment = IIf(oUpload("causecomment").Value = ""," ",oUpload("causecomment").Value)
        Item.SVPClosed = IIf(oUpload("svpclosed").Value <> "", 1,0)

        Item.CreatedBy = oUpload("createdby").Value
        Item.RoomID = oUpload("roomid").Value

        Dim i
        Item.Categorie=""

        For i=1 To 10
            Item.Categorie = Item.Categorie & IIf(oUpload("target0rate_" & i).Value <> "", "1","0")
        Next

        If Item.SaveSPV Then
            Item.SaveImage oUpload("nearimage"), "nearorg"
            Item.SaveTaskImage oUpload("neartaskimage"), "nearorg"
        End If

        Dim Link

        Dim TypList : Set TypList = New NearMissTyp

        Dim ActiveTab : ActiveTab = Right(oUpload("acttab").Value,Len(oUpload("acttab").Value)-InStrRev(oUpload("acttab").Value,"#"))

        Link = CurRootFile & "/near/edit/?partial=yes&id=" & Item.NearID & "&idx=0" & "&tab=" & ActiveTab

        If oUpload("todo").Value <> "" Then
           Link = Link & "&todo=" & oUpload("todo").Value
        End If

        Response.Redirect(Link)


    End Sub

    Public Sub View(vars)

        Dim Item : Set Item = New NearMiss
        Item.Init(vars("id"))

        Dim TypList : Set TypList = New NearMissTyp
        Dim ActiveTab : ActiveTab = IIf(vars("tab")="", "home", vars("tab"))

        Dim TaskTypList : Set TaskTypList = New NearMissTaskTyp
        Dim TaskStateList : Set TaskStateList = New NearMissTaskState

        Dim nHelper : Set nHelper = New NearHelper

        Dim uHelper : Set uHelper = New UserHelper


        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
        Dim pPath : pPath = GetAppSettings("nearimagepath")
        pPath = pPath & "\" & Item.NearID

        Dim Folder : Set Folder = Nothing
        Dim File

        If Fs.FolderExists(pPath) Then
            Set Folder = Fs.GetFolder(pPath)
        End If

        Dim HasAnalyse : HasAnalyse = False

        If Not Folder Is Nothing Then
            For Each File In Folder.Files
                If Left(LCase(File.Name),5) = "5-why"  Then
                    HasAnalyse = True
                End If
                If Left(LCase(File.Name),9) = "fish-bone" Then
                    HasAnalyse = True
                End If
                If Left(LCase(File.Name),4) = "pdca" Then
                   HasAnalyse = True
                End If
            Next
        End If

        Dim t0Helper : Set t0Helper = New Target0RiskLevel

        Dim HasTarget0 : HasTarget0 = False

        If Item.Categorie <> "0000000000" And Item.RiskLevel > 0 Then
            HasTarget0 = True
        End If





        ViewData.Add "near", Item
        ViewData.Add "typ", TypList.List
        ViewData.Add "tasktyp",TaskTypList.List
        ViewData.Add "taskstate",TaskStateList.List
        ViewData.Add "target0list",t0Helper.List
        ViewData.Add "todo", vars("todo")
        ViewData.Add "svplist", nHelper.SPVItemList(Item.RoomID)
        ViewData.Add "folder", Folder
        ViewData.Add "hasanalyse", HasAnalyse
        ViewData.Add "hastarget0", HasTarget0
        ViewData.Add "userlist", uHelper.UserListDD()

        Dim oList : Set oList = New Rooms
        Dim RoomList : Set RoomList = oList.ListByRegion("", "")

        ViewData.Add "roomlist", RoomList

        %>   <!--#include file="../views/near/viewnear.asp" --> <%

    End Sub




    Public Sub EditTaskPost(args)


        Dim Item : Set Item = New NearMissTask

        Item.Init(args("taskid"))

        Item.NearID = args("nearid")
        Item.Description = args("description")
        Item.DueDate = args("duedate")
        Item.Comments = args("comments")
        Item.TaskTypeID = args("tasktypeid")
        Item.AssignedTo = args("assignedto")
        Item.Assigned = args("assigned")
        Item.State = args("state")
        Item.UserID = Session("userid")
        If Item.Save Then



        End If


        Dim TypList : Set TypList = New NearMissTyp

        Dim ActiveTab : ActiveTab = Right(args("tacttab"),Len(args("tacttab"))-InStrRev(args("tacttab"),"#"))

        Dim Link : Link = CurRootFile & "/near/edit/?partial=yes&id=" & Item.NearID & "&idx=0" & "&tab=" & ActiveTab

        Response.Redirect(Link)

    End Sub

    Public Sub UploadPost(args)

        Dim oUpload : Set oUpload = New clsUpload

        Dim ItemType : ItemType = oUpload("uploadtype").Value
        Dim ID : ID = oUpload("unid").Value

        Dim Item : Set Item = New NearMiss
        Item.Init(ID)

        Item.SaveUpload oUpload("fileanalyze"), ItemType

        Dim ActiveTab : ActiveTab = Right(oUpload("facttab").value,Len(oUpload("facttab").value)-InStrRev(oUpload("facttab").value,"#"))
        Dim Link : Link = CurRootFile & "/near/edit/?partial=yes&id=" & Item.NearID & "&idx=0" & "&tab=" & ActiveTab

        Response.Redirect(Link)

    End Sub


End Class


%>