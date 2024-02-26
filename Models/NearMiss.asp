<%

Const       dmStateOpened = 0
Const       dmStateInProgress = 2
Const       dmStateClosed = 3
Const       dmStateCanceled = 4




Class NearMissTyp

    Public List

    Private Sub Class_Initialize()
         Set List = Server.CreateObject("Scripting.Dictionary")
         FillList
    End Sub

    Private Sub FillList

        Dim tItem

        Set tItem = New ListItem
        tItem.Value = 1
        tItem.Name = "Good Catch"
        tItem.Active = 1
        tItem.Tag = 30
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 2
        tItem.Name = "Near Miss"
        tItem.Active = 1
        tItem.Tag = 14
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 3
        tItem.Name = "Incident"
        tItem.Active = 1
        tItem.Tag = 7
        List.Add tItem.Value, tItem

    End Sub

End Class

Class NearMissState

    Public List

    Private Sub Class_Initialize()
         Set List = Server.CreateObject("Scripting.Dictionary")
         FillList
    End Sub

    Private Sub FillList

        Dim tItem

        Set tItem = New ListItem
        tItem.Value = 0
        tItem.Name = "Erstellt"
        tItem.Active = 1
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 2
        tItem.Name = "in Bearbeitung"
        tItem.Active = 1
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 3
        tItem.Name = "Geschlossen"
        tItem.Active = 1
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 4
        tItem.Name = "Abgebrochen"
        tItem.Active = 1
        List.Add tItem.Value, tItem

    End Sub

End Class


Class Target0RiskLevel

    Public List

    Private Sub Class_Initialize()
         Set List = Server.CreateObject("Scripting.Dictionary")
         FillList
    End Sub

    Private Sub FillList

        Dim tItem

        Set tItem = New ListItem
        tItem.Value = 1
        tItem.Name = "gering"
        tItem.Active = 1
        tItem.IconClass = "yellow"
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 2
        tItem.Name = "mittel"
        tItem.Active = 1
        tItem.IconClass = "orange"
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 3
        tItem.Name = "hoch"
        tItem.Active = 1
        tItem.IconClass = "red"
        List.Add tItem.Value, tItem

    End Sub

End Class


Class NearMissTaskTyp

    Public List

    Private Sub Class_Initialize()
         Set List = Server.CreateObject("Scripting.Dictionary")
         FillList
    End Sub

    Private Sub FillList

        Dim tItem

        Set tItem = New ListItem
        tItem.Value = 0
        tItem.Name = "Standard"
        tItem.Active = 1
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 1
        tItem.Name = "Dringend"
        tItem.Active = 1
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 2
        tItem.Name = "Kritisch"
        tItem.Active = 1
        List.Add tItem.Value, tItem

    End Sub

End Class


Class NearMissTaskState

    Public List

    Private Sub Class_Initialize()
         Set List = Server.CreateObject("Scripting.Dictionary")
         FillList
    End Sub

    Private Sub FillList

        Dim tItem

        Set tItem = New ListItem
        tItem.Value = 0
        tItem.Name = "Erstellt"
        tItem.Active = 1
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 2
        tItem.Name = "in Bearbeitung"
        tItem.Active = 1
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 3
        tItem.Name = "Geschlossen"
        tItem.Active = 1
        List.Add tItem.Value, tItem

        Set tItem = New ListItem
        tItem.Value = 4
        tItem.Name = "Abgebrochen"
        tItem.Active = 1
        List.Add tItem.Value, tItem

    End Sub

End Class


Class NearMiss

    Public CartID
    Public NearID
    Public TypName
    Public Typ
    Public NearNb
    Public NearDate
    Public NearTime
    Public RoomID
    Public Room
    Public RoomNb
    Public RegionID
    Public RegionNb
    Public Region
    Public Description
    Public ImageName
    Public TaskImageName
    Public Task
    Public CreatedBy
    Public Created

    Public Cont2Work
    Public Falling
    Public RotatingParts
    Public SqueezeDang
    Public CutDang
    Public PushDang
    Public HotDang
    Public FireProtect
    Public DangGoods
    Public Power
    Public Other
    Public OtherText
    Public IsNew
    Public State
    Public StateText

    Public RatingComment

    Public AssignedToSPV
    Public AssignedSPV

    Public AssignedToEHS
    Public AssignedEHS

    Public Queue
    Public QueueDate

    Public EHSRating

    Public IsRated

    Public Tasks
    Public TaskCount
    Public TaskClosed
    Public TaskOpen

    Public CauseComment

    Public SVPClosed

    Public UserID
    Public LastEdit

    Public ErrMsg
    Public ErrStatus
    Public ErrNumber

    Public VirtualPath
    Public PhysicalPath

    Public VirtualTaskPath
    Public PhysicalTaskPath

    Public CanClose

    Public BuildingID
    Public BuildingNb
    Public Building

    Public Categorie
    Public CategorieList

    Public IsTarget0
    Public SolveImm
    Public DueDate
    Public RiskLevel

    Private prvImagePath
    Private prvVirtualImagePath

    Private prvCartImagePath
    Private prvCartVirtualImagePath



    Private Sub Class_Initialize()

        CartID = Session("login")

        NearID = -1
        Typ = 1
        TypName = ""
        NearDate = Date
        NearTime = Time
        RoomID = -1
        RegionID = -1
        Room = ""
        Description = ""
        RatingComment = ""
        ImageName = ""
        TaskImageName = ""
        Task = ""
        CreatedBy = ""
        Created = ""
        UserID = Session("login")
        LastEdit = ""
        StateText = ""

        ErrMsg = ""
        ErrStatus = "OK"
        ErrNumber = 0

        prvImagePath = GetAppSettings("nearimagepath")
        prvVirtualImagePath = "nearimages"

        prvCartImagePath = prvImagePath & "\cart"
        prvCartVirtualImagePath = prvVirtualImagePath & "/cart"

        AssignedToSPV = ""
        AssignedSPV = ""

        AssignedToEHS = ""
        AssignedEHS = ""

        Queue = ""
        QueueDate = ""

        EHSRating = ""

        CauseComment = ""

        SVPClosed = False

        BuildingID = -1
        BuildingNb = ""
        Building = ""


        IsTarget0 = 0
        SolveImm = 0
        DueDate = ""
        RiskLevel = 0

        Categorie = "0000000000"

        Set CategorieList = Server.CreateObject("Scripting.Dictionary")
        FillCategorieList(Categorie)

        Set Tasks = Server.CreateObject("Scripting.Dictionary")
        TaskCount = 0

        CanClose = True

    End Sub


    Public Sub FillCategorieList(ByVal Switches)

        Dim Item

        CategorieList.RemoveAll()

        '1. Elektrisch'
        Set Item = New ListItem
        Item.Value = 1
        Item.Name = "Elektrisch"
        Item.IconClass = "elektro.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item

        '2. Gefährlich Tätigkeiten'
        Set Item = New ListItem
        Item.Value = 2
        Item.Name = "Gefährlich Tätigkeiten"
        Item.IconClass = "dangact.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item

        '3. Ergonomie'
        Set Item = New ListItem
        Item.Value = 3
        Item.Name = "Ergonomie"
        Item.IconClass = "ergonom.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item


        '4. Allgemein'
        Set Item = New ListItem
        Item.Value = 4
        Item.Name = "Allgemein"
        Item.IconClass = "common.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item

        '5. Persönliche Schutzausrüstung'
        Set Item = New ListItem
        Item.Value = 5
        Item.Name = "Persönliche Schutzausrüstung"
        Item.IconClass = "peronalprot.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item

        '6. Umwelt'
        Set Item = New ListItem
        Item.Value = 6
        Item.Name = "Umwelt"
        Item.IconClass = "oekolog.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item


        '7. Gefahrstoffe'
        Set Item = New ListItem
        Item.Value = 7
        Item.Name = "Gefahrstoffe"
        Item.IconClass = "danggoods.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item

        '8. Gefahrstoffe'
        Set Item = New ListItem
        Item.Value = 8
        Item.Name = "Ordnung/Sauberkeit"
        Item.IconClass = "clean.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item


        '9. Maschine/Werkzeug'
        Set Item = New ListItem
        Item.Value = 9
        Item.Name = "Maschine/Werkzeug"
        Item.IconClass = "machine.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item


        '10. Inspektion'
        Set Item = New ListItem
        Item.Value = 10
        Item.Name = "Inspektion"
        Item.IconClass = "inspection.png"
        Item.Active = CInt(Mid(Switches,Item.Value,1))
        CategorieList.Add Item.Value, Item

    End Sub





    Public Sub Init (ByVal iNearID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwNearMiss WHERE nearid=" & iNearID
        Dim SQLStrTask : SQLStrTask = "SELECT * FROM vwNearMissTask WHERE nearid=" & iNearID

        Dim iRs : Set iRs = DbExecute(SQLStr)
        Dim iRsTask : Set iRsTask = DbExecute(SQLStrTask)

        Dim TypList : Set TypList = New NearMissTyp
        Dim StateList : Set StateList = New NearMissState


        Dim TaskTypList : Set TaskTypList = New NearMissTaskTyp
        Dim TaskStateList : Set TaskStateList = New NearMissTaskState

        Dim tItem

        If Not iRs.Eof Then
            NearID = iRs("nearid")
            Typ=iRs("typ")
            TypName = TypList.List.Item(CInt(Typ)).Name
            NearNb = iRs("nearnb")
            NearDate = iRs("neardate")
            NearTime = iRs("neartime")
            RoomID = iRs("roomid")
            RoomNb = iRs("roomnb")
            Room = iRs("room")
            RegionID = iRs("regionid")
            RegionNb = iRs("regionnb")
            Region = iRs("region")
            Description = iRs("description")
            ImageName = iRs("imagename")
            TaskImageName = iRs("taskimagename")
            Task = iRs("task")
            CreatedBy = iRs("createdby")
            Created = iRs("created")
            Cont2Work = iRs("cont2work")
            Falling = iRs("falling")
            RotatingParts = iRs("rotatingparts")
            SqueezeDang = iRs("squeezedang")
            CutDang = iRs("cutdang")
            PushDang = iRs("pushdang")
            HotDang = iRs("hotdang")
            FireProtect = iRs("fireprotect")
            DangGoods = iRs("danggoods")
            Power = iRs("power")
            Other = iRs("other")
            OtherText = iRs("othertext")
            IsNew = iRs("isnew")
            State = iRs("state")
            StateText = StateList.List.Item(CInt(State)).Name
            RatingComment  = iRs("ratingcomment")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")

            AssignedToSPV = iRs("assignedtospv")
            AssignedSPV = iRs("assignedspv")

            AssignedToEHS = iRs("assignedtoehs")
            AssignedEHS = iRs("assignedehs")

            Queue = iRs("queue")
            QueueDate = iRs("queuedate")

            EHSRating = iRs("ehsrating")

            CauseComment = iRs("causecomment")
            SVPClosed = iRs("svpclosed")

            BuildingID =  iRs("buildingid")
            BuildingNb =  iRs("buildingnb")
            Building =  iRs("building")

            IsTarget0 = iRs("istarget0")
            SolveImm = iRs("solveimm")





            DueDate = DateAdd("d", TypList.List.Item(CInt(Typ)).Tag,  iRs("created"))

            RiskLevel = iRs("risklevel")

            Categorie =  iRs("categorie")

            FillCategorieList(Categorie)

            If ImageName <> "" Then
                VirtualPath = prvVirtualImagePath & "/" & GetImageName
                PhysicalPath = prvImagePath & "\" & GetImageName
            End If

            If TaskImageName <> "" Then
                VirtualTaskPath = prvVirtualImagePath & "/" & GetTaskImageName
                PhysicalTaskPath = prvImagePath & "\" & GetTaskImageName
            End If

            TaskClosed = 0

            Do While Not iRsTask.Eof
                Set tItem = New NearMissTask

                tItem.TaskID = iRsTask("taskid")
                tItem.NearID = NearID
                tItem.TaskNb = iRsTask("tasknb")
                tItem.NearNb = NearNb
                tItem.RoomID = RoomID
                tItem.RoomNb = RoomNb
                tItem.Room = Room
                tItem.RegionID = RegionID
                tItem.RegionNb = RegionNb
                tItem.Region = Region
                tItem.Created = iRsTask("created")
                tItem.CreatedBy = iRsTask("createdby")
                tItem.Description = iRsTask("description")
                tItem.DueDate = iRsTask("duedate")
                tItem.Comments = iRsTask("comments")
                tItem.TaskTypeID = iRsTask("tasktypeid")
                tItem.TaskType = TaskTypList.List.Item(CInt(tItem.TaskTypeID)).Name
                tItem.AssignedTo = iRsTask("assignedto")
                tItem.Assigned = iRsTask("assigned")
                tItem.State = iRsTask("state")

                If tItem.State = dmStateClosed Or tItem.State = dmStateCanceled Then
                    TaskClosed=TaskClosed+1
                End If

                tItem.StateText = TaskStateList.List.Item(CInt(tItem.State)).Name
                tItem.UserID = iRsTask("userid")
                tItem.LastEdit = iRsTask("lastedit")

                If tItem.State < 3 Then
                   CanClose = False
                End If

                Tasks.Add tItem.TaskID, tItem
                iRsTask.MoveNext

            Loop

        End If
        iRsTask.Close
        iRs.Close
        Set iRsTask = Nothing
        Set iRs = Nothing
        DbCloseConnection()

        TaskCount = Tasks.Count
        TaskOpen = TaskCount - TaskClosed

        IsRated = False

        If Falling = 1 Then
            IsRated = True
        End If
        If RotatingParts = 1 Then
            IsRated = True
        End If
        If SqueezeDang = 1 Then
            IsRated = True
        End If
        If CutDang = 1 Then
            IsRated = True
        End If
        If PushDang = 1 Then
            IsRated = True
        End If
        If FireProtect = 1 Then
            IsRated = True
        End If
        If HotDang = 1 Then
            IsRated = True
        End If
        If DangGoods = 1 Then
            IsRated = True
        End If
        If Power = 1 Then
            IsRated = True
        End If
        If Other = 1 Then
            IsRated = True
        End If

    End Sub

    Public Sub InitByCartID(ByVal iCartID)

        Dim SQLStr : SQLStr = "SELECT * FROM nearcart WHERE cartid='" & iCartID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        CartID = iCartID
        If Not iRs.Eof Then
            CartID = iRs("cartid")
            NearDate = iRs("neardate")
            NearTime = iRs("neartime")
            RoomID = iRs("roomid")
            RegionID = ReturnFromRecord("room","roomid=" & RoomID, "regionid")
            BuildingID = ReturnFromRecord("room","roomid=" & RoomID, "buildingid")
            ''Room = iRs("nb")
            Description = iRs("description")
            ImageName = iRs("imagename")
            TaskImageName = iRs("taskimagename")
            Task = iRs("task")
            CreatedBy = iRs("createdby")
            Created = iRs("created")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
            AssignedToSPV = iRs("assignedtospv")

            If ImageName <> "" Then
                VirtualPath = prvCartVirtualImagePath & "/" & ImageName
                PhysicalPath = prvCartImagePath & "\" & ImageName
            End If
            If TaskImageName <> "" Then
                VirtualTaskPath = prvCartVirtualImagePath & "/" & TaskImageName
                PhysicalTaskPath = prvCartImagePath & "\" & TaskImageName
            End If
        End If
        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

    End Sub


    Public Sub SaveUpload (ByVal FileObj, ByVal Typ )

        Dim FileName : FileName = FileObj.FilePath

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

        Dim iPath : iPath = prvImagePath & "\" & NearID

        If FileObj.FilePath <> ""  Then

            If Not Fs.FolderExists(iPath) Then
               Fs.CreateFolder iPath
            End If

            Dim FileExt : FileExt =  Fs.GetExtensionName(FileObj.FilePath)

            Select Case Typ
                Case 1:
                    FileName = "5-why." & FileExt
                Case 2:
                    FileName = "Fish-bone." & FileExt
                Case 4:
                    FileName = "PDCA." & FileExt
            End Select

            FileObj.SaveAs iPath & "\" & FileName

        End If

    End Sub


    Public Sub DeleteUpload (ByVal FileName, ByVal Typ )

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

        Dim iPath : iPath = prvImagePath & "\" & NearID

        If FileName <> ""  Then
            If Fs.FileExists(iPath & "\" & FileName) Then
               Fs.DeleteFile iPath & "\" & FileName, True
            End If
        End If

    End Sub


    Public Sub SaveImage (ByVal FileObj, ByVal Typ )


        Dim iPath : iPath = IIf(Typ="cache", prvCartImagePath,prvImagePath )

        If FileObj.FilePath <> ""  Then

            RemoveImage(iPath & "\" & IIf(Typ="cache", CreatedBy, NearID))

            Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
            Dim FileExt : FileExt =  Fs.GetExtensionName(FileObj.FilePath)

            FileObj.SaveAs iPath & "\" & IIf(Typ="cache", CreatedBy, NearID) & "." & FileExt
            If Typ <> "cache" Then
               DBExecute("UPDATE nearmiss SET imagename='" & IIf(Typ="cache", CreatedBy, NearID) & "." & FileExt & "' WHERE nearid=" & NearID)
            End If

        End If


    End Sub

    Public Sub SaveTaskImage (ByVal FileObj, ByVal Typ )


        Dim iPath : iPath = IIf(Typ="cache", prvCartImagePath,prvImagePath )

        If FileObj.FilePath <> ""  Then

            RemoveImage(iPath & "\" & IIf(Typ="cache", CreatedBy, NearID) & "_t")

            Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
            Dim FileExt : FileExt =  Fs.GetExtensionName(FileObj.FilePath)

            FileObj.SaveAs iPath & "\" & IIf(Typ="cache", CreatedBy, NearID) & "_t." & FileExt

            If Typ <> "cache" Then
                    DBExecute("UPDATE nearmiss SET taskimagename='" & IIf(Typ="cache", CreatedBy, NearID) & "." & FileExt & "' WHERE nearid=" & NearID)
            End If

        End If


    End Sub

    Public Sub RemoveCacheImage( ByVal FileTyp)

         Dim iPath : iPath = prvCartImagePath

         If FileTyp = "task" Then
            RemoveImage(iPath & "\" & CreatedBy & "_t")
            TaskImageName = ""
            Save2Cache
         Else
            RemoveImage(iPath & "\" & CreatedBy)
            ImageName = ""
            Save2Cache
         End If

    End Sub


    Public Sub RemoveNearImage( ByVal FileTyp)

         Dim iPath : iPath = prvImagePath

         If FileTyp = "task" Then
            RemoveImage(iPath & "\" & NearID & "_t")
            TaskImageName = ""
            DBExecute("UPDATE nearmiss SET taskimagename='' WHERE nearid=" & NearID)
         Else
            RemoveImage(iPath & "\" & NearID)
            ImageName = ""
            DBExecute("UPDATE nearmiss SET imagename='' WHERE nearid=" & NearID)
         End If

    End Sub


    Private Sub RemoveImage(ByVal Path)

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

        If Fs.FileExists(Path & ".jpg") Then
            Fs.DeleteFile Path & ".jpg", True
        ElseIf Fs.FileExists(Path & ".jpeg") Then
            Fs.DeleteFile Path & ".jpeg", True
        ElseIf Fs.FileExists(Path & ".png") Then
            Fs.DeleteFile Path &".png", True
        End If

    End Sub

    Public Sub SetImageName (ByVal FileObj)
        If FileObj.FilePath <> "" Then
           Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
           Dim FileExt : FileExt =  Fs.GetExtensionName(FileObj.FilePath)
           ImageName = CreatedBy & "." & FileExt
        End If
    End Sub

    Public Sub SetTaskImageName (ByVal FileObj)
        If FileObj.FilePath <> "" Then
           Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
           Dim FileExt : FileExt =  Fs.GetExtensionName(FileObj.FilePath)
           TaskImageName = CreatedBy & "_t." & FileExt
        End If
    End Sub

    Public Function CreateNewMiss
         '1. Save Data'

         If Save2Cache Then

            '' Create NearMiss
            Dim retVal : retVal = False

            Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

            Cmd.CommandText = "CreateNearFromCart"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()


            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@CartID", adVarWChar, adParamInput, 50)
            Cmd.Parameters.Append Parameter
            Parameter.Value = CartID

            Set Parameter = Cmd.CreateParameter("@NearID", adBigInt, adParamInputOutput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = NearID

            Cmd.Execute

            If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
                NearID = Cmd.Parameters("@NearID").Value
                RetVal = True
            End If

            Set Cmd = Nothing
            Set Parameter = Nothing

            DbCloseConnection()

            '' move picture to new location
            If ImageName <> "" Then
               Move2FinalLoc CardID, NearID
            End If

            If TaskImageName <> "" Then
                MoveTask2FinalLoc CardID, NearID
            End If

        End If




        CreateNewMiss = True
    End Function


    Private Sub Move2FinalLoc(ByVal pCardID, ByVal pNearID)

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

        Dim FileExt : FileExt =  Fs.GetExtensionName(ImageName)

        Dim SourcePath : SourcePath = prvCartImagePath & "\" & ImageName
        Dim TargetPath : TargetPath = prvImagePath & "\" & pNearID & "." & FileExt

        If ImageName <> "" Then
            Fs.CopyFile SourcePath, TargetPath
            Fs.DeleteFile SourcePath
        End If

    End Sub

    Private Sub MoveTask2FinalLoc(ByVal pCardID, ByVal pNearID)

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

        Dim FileExt : FileExt =  Fs.GetExtensionName(TaskImageName)

        Dim SourcePath : SourcePath = prvCartImagePath & "\" & TaskImageName
        Dim TargetPath : TargetPath = prvImagePath & "\" & pNearID & "_t." & FileExt

        If TaskImageName <> "" Then
            Fs.CopyFile SourcePath, TargetPath
            Fs.DeleteFile SourcePath
        End If

    End Sub

    Private Function GetImageName

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
        Ext =  Fs.GetExtensionName(ImageName)
        GetImageName = NearID & "." & Ext


    End Function

    Private Function GetTaskImageName

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
        Ext =  Fs.GetExtensionName(TaskImageName)
        GetTaskImageName = NearID & "_t." & Ext


    End Function



    Public Function Delete

        DbExecute("UPDATE nearmiss SET deleted=1, deletedby='" & Session("login") & "', deleteddate=GETDATE() WHERE nearid=" & NearID )
        DbExecute("UPDATE nearmiss_task SET deleted=1, deletedby='" & Session("login") & "', deleteddate=GETDATE() WHERE nearid=" & NearID)
        Delete = True
        DbCloseConnection()

    End Function


    Public Function Save2Cache

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "NearCartUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@CartID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CartID

        Set Parameter = Cmd.CreateParameter("@CreatedBy", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CreatedBy

        Set Parameter = Cmd.CreateParameter("@Created", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IIf(Created="",Date,Created)

        Set Parameter = Cmd.CreateParameter("@NearDate", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = NearDate

        Set Parameter = Cmd.CreateParameter("@NearTime", adVarWChar, adParamInput, 5)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Left(NearTime,5)

        Set Parameter = Cmd.CreateParameter("@RoomID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = RoomID

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description

        Set Parameter = Cmd.CreateParameter("@ImageName", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ImageName

        Set Parameter = Cmd.CreateParameter("@TaskImageName", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TaskImageName

        Set Parameter = Cmd.CreateParameter("@Task", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Task

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Set Parameter = Cmd.CreateParameter("@AssignedToSPV", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AssignedToSPV

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save2Cache = RetVal


    End Function

    Public Function SaveSPV


        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "NearUpdateSPV"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter


        Set Parameter = Cmd.CreateParameter("@NearID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = NearID

        Set Parameter = Cmd.CreateParameter("@Typ", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Typ

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description

        Set Parameter = Cmd.CreateParameter("@Task", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Task

        Set Parameter = Cmd.CreateParameter("@Cont2Work", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Cont2Work

        Set Parameter = Cmd.CreateParameter("@Falling", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Falling

        Set Parameter = Cmd.CreateParameter("@RotatingParts", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = RotatingParts

        Set Parameter = Cmd.CreateParameter("@SqueezeDang", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SqueezeDang

        Set Parameter = Cmd.CreateParameter("@CutDang", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CutDang

        Set Parameter = Cmd.CreateParameter("@PushDang", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = PushDang

        Set Parameter = Cmd.CreateParameter("@HotDang", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = HotDang

        Set Parameter = Cmd.CreateParameter("@FireProtect", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = FireProtect

        Set Parameter = Cmd.CreateParameter("@DangGoods", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DangGoods

        Set Parameter = Cmd.CreateParameter("@Power", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Power

        Set Parameter = Cmd.CreateParameter("@Other", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Other

        Set Parameter = Cmd.CreateParameter("@OtherText", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OtherText

        Set Parameter = Cmd.CreateParameter("@State", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = State


        Set Parameter = Cmd.CreateParameter("@RatingComment", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = RatingComment

        Set Parameter = Cmd.CreateParameter("@EHSRating", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IIf(EHSRating = "", " ", EHSRating)

        Set Parameter = Cmd.CreateParameter("@Queue", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Queue

        Set Parameter = Cmd.CreateParameter("@QueueDate", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = QueueDate

        Set Parameter = Cmd.CreateParameter("@AssignedToSPV", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AssignedToSPV

        Set Parameter = Cmd.CreateParameter("@AssignedSPV", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AssignedSPV

        Set Parameter = Cmd.CreateParameter("@CauseComment", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CauseComment

        Set Parameter = Cmd.CreateParameter("@SVPClosed", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SVPClosed

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Set Parameter = Cmd.CreateParameter("@RoomID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = RoomID

        Set Parameter = Cmd.CreateParameter("@CreatedBy", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CreatedBy

        Set Parameter = Cmd.CreateParameter("@IsTarget0", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IsTarget0

        Set Parameter = Cmd.CreateParameter("@SolveImm", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SolveImm

        Set Parameter = Cmd.CreateParameter("@DueDate", adDate, adParamInput,, NULL)
        Cmd.Parameters.Append Parameter
        If DueDate <> "" Then
            Parameter.Value = DueDate
        End If

        Set Parameter = Cmd.CreateParameter("@RiskLevel", adTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = RiskLevel

        Set Parameter = Cmd.CreateParameter("@Categorie", adVarWChar, adParamInput, 15)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Categorie

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        SaveSPV = RetVal

    End Function

    Public Function SendMail

        Dim Template : Set Template = New MailTemplate
        Dim TemplateName : TemplateName = "NearMiss"
        Dim rItem

        Set ValueList = Server.CreateObject("Scripting.Dictionary")
        Set rItem = New ListItem
        rItem.Value = "picture"
        rItem.Name = "http://atviapp800001/digiadmin/" & VirtualPath
        ValueList.Add rItem.Value, rItem

        Set rItem = New ListItem
        rItem.Value = "number"
        rItem.Name = NearNb
        ValueList.Add rItem.Value, rItem

        Set rItem = New ListItem
        rItem.Value = "portal"
        rItem.Name = "http://atviapp800001/digiadmin"
        ValueList.Add rItem.Value, rItem

        Set rItem = New ListItem
        rItem.Value = "info"
        rItem.Name = InfoHTML
        ValueList.Add rItem.Value, rItem

        Template.Template = TemplateName
        Set Template.ValueList = ValueList

        Dim Mail : Set Mail = New EMail

        If Mail.Send("DigiNM@merck.com","thomas.lauterboeck@merck.com", NearNb & " " & TypName,  HtmlBody) Then
            ErrMsg = "Mail wurde versendet"
            ErrStatus="OK"
            ErrNumber=0
            SendMail = True
        Else
            ErrMsg = "Mail konnte nicht versendet werden"
            ErrStatus="NOTOK"
            ErrNumber=1
            SendMail = False
        End If

    End Function

    Private Function InfoHTML

        InfoHTML = "<table style=""BACKGROUND-COLOR: white"" cellspacing=""0"" cellpadding=""0"" width=""100%"">"
        InfoHTML = InfoHTML & "<tr>"
        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & "Nummer:"
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & NearNb
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "</tr>"

        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & "Typ:"
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & TypName
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "</tr>"

        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & "Melder:"
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & CreatedBy
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "</tr>"

        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & "am:"
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & DBFormatDate(NearDate) & " " & NearTime
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "</tr>"

        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & "Kurzbeschreibung:"
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "<td  class=""contenttd"">"
        InfoHTML = InfoHTML & Description & " " & NearTime
        InfoHTML = InfoHTML & "</td>"
        InfoHTML = InfoHTML & "</tr>"

        InfoHTML = InfoHTML & "</table>"

    End Function


End Class



Class NearSearchParam

    Private prvNb
    Private prvDateFrom
    Private prvDateTo
    Private prvTyp
    Private prvUserID
    Private prvState
    Private prvIsTarget0
    Private prvRegionID
    Private prvRoomID
    Private prvBuildingID


    Public Property Get Nb
        Nb = prvNb
    End Property

    Public Property Let Nb (Value)
        prvNb = Value
        SetSQL
    End Property


    Public Property Get DateFrom
        DateFrom = prvDateFrom
    End Property

    Public Property Let DateFrom (Value)
        prvDateFrom = Value
        SetSQL
    End Property

    Public Property Get DateTo
        DateTo = prvDateTo
    End Property

    Public Property Let DateTo (Value)
        prvDateTo = Value
        SetSQL
    End Property


    Public Property Get Typ
        Typ = prvTyp
    End Property

    Public Property Let Typ (Value)
        prvTyp = Value
        SetSQL
    End Property

    Public Property Get UserID
        UserID = prvUserID
    End Property

    Public Property Let UserID (Value)
        prvUserID = Value
        SetSQL
    End Property

    Public Property Get State
        State = prvState
    End Property

    Public Property Let State (Value)
        prvState = Value
        SetSQL
    End Property

    Public Property Get IsTarget0
        IsTarget0 = prvIsTarget0
    End Property

    Public Property Let IsTarget0 (Value)
        prvIsTarget0 = Value
        SetSQL
    End Property

    Public Property Get RegionID
        RegionID = prvRegionID
    End Property

    Public Property Let RegionID (Value)
        prvRegionID = Value
        SetSQL
    End Property

    Public Property Get RoomID
        RoomID = prvRoomID
    End Property

    Public Property Let RoomID (Value)
        prvRoomID = Value
        SetSQL
    End Property

    Public Property Get BuildingID
        BuildingID = prvBuildingID
    End Property

    Public Property Let BuildingID (Value)
        prvBuildingID = Value
        SetSQL
    End Property

    Public SQLStr
    Public Filter

    Private Sub Class_Initialize()

        prvNb = ""
        prvDateFrom = ""
        prvDateTo = ""
        prvTyp = -1
        prvUserID = ""
        prvState = 3
        prvIsTarget0 = 0
        prvRoomID = -1
        prvRegionID = -1
        prvBuildingID = -1

        SetSQL

    End Sub


    Private Sub SetSQL

        Filter = "1=1"
        If prvNb <> "" Then
           Filter = Filter & " AND nearnb LIKE '%" & prvNb & "%'"
        End If

        If prvDateFrom <> "" Or prvDateTo <> "" Then
            If prvDateFrom <> "" And prvDateTo <> "" Then
               Filter = Filter & " AND CONVERT(date,neardate) BETWEEN '" &  DBFormatDate(prvDateFrom) & "' AND '" &  DBFormatDate(prvDateTo) & "'"
            ElseIf prvDateFrom <> "" Then
               Filter = Filter & " AND CONVERT(date,neardate) >= '" &  DBFormatDate(prvDateFrom) & "'"
            Else
               Filter = Filter & " AND CONVERT(date,neardate) <= '" &  DBFormatDate(prvDateTo) & "'"
            End If
        End If

        If prvTyp > 0 Then
           Filter = Filter & " AND typ = " & prvTyp
        End If

        If prvUserID <> "" Then
           Filter = Filter & " AND assignedtospv = '" & prvUserID & "'"
        End If

        If CInt(prvState) > CInt(-1) Then
            Filter = Filter & " AND state = " & prvState
        End If

        If CInt(prvIsTarget0) = 1 Then
            Filter = Filter & " AND istarget0 = " & prvIsTarget0
        End If

        If CInt(prvRegionID) > CInt(0) Then
            Filter = Filter & " AND regionid = " & prvRegionID
        End If

        If CInt(prvRoomID) > CInt(0) Then
            Filter = Filter & " AND roomid = " & prvRoomID
        End If

        If CInt(prvBuildingID) > CInt(0) Then
            Filter = Filter & " AND buildingid = " & prvBuildingID
        End If


        SQLStr = "SELECT * FROM vwNearMiss WHERE deleted=0 AND " & Filter


    End Sub

End Class


Class TaskSearchParam

    Private prvNb
    Private prvNearNb
    Private prvDateFrom
    Private prvDateTo
    Private prvTyp
    Private prvUserID
    Private prvState


    Public Property Get Nb
        Nb = prvNb
    End Property

    Public Property Let Nb (Value)
        prvNb = Value
        SetSQL
    End Property

    Public Property Get NearNb
        NearNb = prvNearNb
    End Property

    Public Property Let NearNb (Value)
        prvNearNb = Value
        SetSQL
    End Property


    Public Property Get DateFrom
        DateFrom = prvDateFrom
    End Property

    Public Property Let DateFrom (Value)
        prvDateFrom = Value
        SetSQL
    End Property

    Public Property Get DateTo
        DateTo = prvDateTo
    End Property

    Public Property Let DateTo (Value)
        prvDateTo = Value
        SetSQL
    End Property


    Public Property Get Typ
        Typ = prvTyp
    End Property

    Public Property Let Typ (Value)
        prvTyp = Value
        SetSQL
    End Property

    Public Property Get UserID
        UserID = prvUserID
    End Property

    Public Property Let UserID (Value)
        prvUserID = Value
        SetSQL
    End Property

    Public Property Get State
        State = prvState
    End Property

    Public Property Let State (Value)
        prvState = Value
        SetSQL
    End Property

    Public SQLStr
    Public Filter

    Private Sub Class_Initialize()

        prvNb = ""
        prvNearNb = ""
        prvDateFrom = ""
        prvDateTo = ""
        prvTyp = -1
        prvUserID = ""
        prvState = 3

        SetSQL

    End Sub


    Private Sub SetSQL

        Filter = "1=1"
        If prvNb <> "" Then
           Filter = Filter & " AND tasknb LIKE '%" & prvNb & "%'"
        End If

        If prvNearNb <> "" Then
           Filter = Filter & " AND nearnb LIKE '%" & prvNearNb & "%'"
        End If

        If prvDateFrom <> "" Or prvDateTo <> "" Then
            If prvDateFrom <> "" And prvDateTo <> "" Then
               Filter = Filter & " AND CONVERT(date,created) BETWEEN '" &  DBFormatDate(prvDateFrom) & "' AND '" &  DBFormatDate(prvDateTo) & "'"
            ElseIf prvDateFrom <> "" Then
               Filter = Filter & " AND CONVERT(date,created) >= '" &  DBFormatDate(prvDateFrom) & "'"
            Else
               Filter = Filter & " AND CONVERT(date,created) <= '" &  DBFormatDate(prvDateTo) & "'"
            End If
        End If

        If prvTyp > 0 Then
           Filter = Filter & " AND tasktypeid = " & prvTyp
        End If

        If prvUserID <> "" Then
           Filter = Filter & " AND assignedto = '" & prvUserID & "'"
        End If

        If CInt(prvState) > CInt(-1) Then
            Filter = Filter & " AND state = " & prvState
        End If

        SQLStr = "SELECT * FROM vwNearMissTask WHERE deleted=0 AND " & Filter

    End Sub

End Class


Class NearHelper

    Public Function EmptyList

        Set EmptyList = Server.CreateObject("Scripting.Dictionary")

    End Function


    Public Function HistoryList (ByVal hlpParam)

        Set HistoryList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = hlpParam.SQLStr

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item


        Do While Not Rs.Eof
            Set Item = GetNearItem(Rs)
            HistoryList.Add Item.NearID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection

    End Function


    Private Function GetNearItem(ByVal Rs)

        Dim TypList : Set TypList = New NearMissTyp
        Dim StateList : Set StateList = New NearMissState

        Set GetNearItem = New NearMiss

        GetNearItem.NearID = Rs("nearid")
        GetNearItem.Typ = Rs("typ")
        GetNearItem.TypName = TypList.List.Item(GetNearItem.Typ).Name
        GetNearItem.NearNb = Rs("nearnb")
        GetNearItem.NearDate = Rs("neardate")
        GetNearItem.NearTime = Rs("neartime")
        GetNearItem.RoomID = Rs("roomid")
        GetNearItem.Room = Rs("roomnb")
        GetNearItem.Description = Rs("description")
        GetNearItem.ImageName = Rs("imagename")
        GetNearItem.TaskImageName = Rs("taskimagename")
        GetNearItem.Task = Rs("task")
        GetNearItem.CreatedBy = Rs("createdby")
        GetNearItem.Created = Rs("created")
        GetNearItem.Cont2Work = Rs("cont2work")
        GetNearItem.Falling = Rs("falling")
        GetNearItem.RotatingParts = Rs("rotatingparts")
        GetNearItem.SqueezeDang = Rs("squeezedang")
        GetNearItem.CutDang = Rs("cutdang")
        GetNearItem.HotDang = Rs("hotdang")
        GetNearItem.PushDang = Rs("pushdang")
        GetNearItem.FireProtect = Rs("fireprotect")
        GetNearItem.DangGoods = Rs("danggoods")
        GetNearItem.Power = Rs("power")
        GetNearItem.Other = Rs("other")
        GetNearItem.OtherText = Rs("othertext")
        GetNearItem.IsNew = Rs("isnew")
        GetNearItem.State = Rs("state")
        GetNearItem.StateText = StateList.List.Item(CInt(GetNearItem.State)).Name
        GetNearItem.RatingComment  = Rs("ratingcomment")
        GetNearItem.UserID = Rs("userid")
        GetNearItem.LastEdit = Rs("lastedit")
        GetNearItem.AssignedToSPV = Rs("assignedtospv")
        GetNearItem.AssignedSPV = Rs("assignedspv")
        GetNearItem.AssignedToEHS = Rs("assignedtoehs")
        GetNearItem.AssignedEHS = Rs("assignedehs")
        GetNearItem.Queue = Rs("queue")
        GetNearItem.QueueDate = Rs("queuedate")
        GetNearItem.CauseComment = Rs("causecomment")
        GetNearItem.SVPClosed = Rs("svpclosed")


        GetNearItem.BuildingID =  Rs("buildingid")
        GetNearItem.BuildingNb =  Rs("buildingnb")
        GetNearItem.Building =  Rs("building")

        GetNearItem.IsTarget0 = Rs("istarget0")
        GetNearItem.SolveImm = Rs("solveimm")
        GetNearItem.DueDate = Rs("duedate")
        GetNearItem.RiskLevel = Rs("risklevel")
        GetNearItem.Categorie =  Rs("categorie")
        GetNearItem.FillCategorieList(GetNearItem.Categorie)


    End Function



    Public Function List

        Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM vwNearMiss WHERE deleted=0 AND state < 3 AND queue='ehs' ORDER BY created desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Dim TypList : Set TypList = New NearMissTyp
        Dim StateList : Set StateList = New NearMissState

        Do While Not Rs.Eof

            Set Item = GetNearItem(Rs)


            List.Add Item.NearID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection

    End Function


    Public Function SPVList ()

        Set SPVList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM vwNearMiss WHERE deleted=0 AND state < 3 AND queue='svp'  ORDER BY created desc"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
           Set Item = GetNearItem(Rs)
            SPVList.Add Item.NearID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection

    End Function

    Public Function TaskList (ByVal UserID)

        Set TaskList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM vwNearMissTask WHERE deleted=0 AND state < 3 AND assignedto='" & UserID & "'  ORDER BY assigned"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof

            Set Item = GetTaskItem(Rs)
            TaskList.Add Item.TaskID, Item

            Rs.MoveNext
        Loop
        DbCloseConnection

    End Function


    Public Function HistoryTaskList (ByVal hlpParam)

        Set HistoryTaskList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = hlpParam.SQLStr

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item


        Do While Not Rs.Eof
            Set Item = GetTaskItem(Rs)
            HistoryTaskList.Add Item.TaskID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection

    End Function


    Private Function GetTaskItem(ByVal Rs)


        Dim TaskTypList : Set TaskTypList = New NearMissTaskTyp
        Dim TaskStateList : Set TaskStateList = New NearMissTaskState

        Set GetTaskItem = New NearMissTask
        GetTaskItem.TaskID = Rs("taskid")
        GetTaskItem.NearID = Rs("nearid")
        GetTaskItem.TaskNb = Rs("tasknb")
        GetTaskItem.NearNb = Rs("nearnb")
        GetTaskItem.RoomID = Rs("roomid")
        GetTaskItem.RoomNb = Rs("roomnb")
        GetTaskItem.Room = Rs("room")
        GetTaskItem.RegionID = Rs("regionid")
        GetTaskItem.RegionNb = Rs("regionnb")
        GetTaskItem.Region = Rs("region")
        GetTaskItem.CreatedBy = Rs("createdby")
        GetTaskItem.Created = Rs("created")
        GetTaskItem.Description = Rs("description")
        GetTaskItem.DueDate = Rs("duedate")
        GetTaskItem.Comments = Rs("comments")
        GetTaskItem.TaskTypeID = Rs("tasktypeid")
        GetTaskItem.TaskType = TaskTypList.List.Item(CInt(GetTaskItem.TaskTypeID)).Name
        GetTaskItem.AssignedTo = Rs("assignedto")
        GetTaskItem.Assigned = Rs("assigned")
        GetTaskItem.State = Rs("state")
        GetTaskItem.StateText = TaskStateList.List.Item(CInt(GetTaskItem.State)).Name
        GetTaskItem.UserID = Rs("userid")
        GetTaskItem.LastEdit = Rs("lastedit")
        GetTaskItem.BuildingID =  Rs("buildingid")
        GetTaskItem.BuildingNb =  Rs("buildingnb")
        GetTaskItem.Building =  Rs("building")

    End Function

    Public Function SPVItemList (ByVal RoomID)

        Set SPVItemList = Server.CreateObject("Scripting.Dictionary")


        '1. zugeteilte SPV's
        Dim SQLStr : SQLStr = "WITH x " & _
                            "AS " & _
                            "( " & _
                            "SELECT DISTINCT s.userid, u.active " & _
                            "FROM region_svp s " & _
                            "JOIN userlist u ON s.userid=u.userid " & _
                            "WHERE s.regionid IN (SELECT regionid FROM room WHERE roomid=" & RoomID & ") " & _
                            "), y As ( " & _
                            "SELECT userid, active, 1 As sort " & _
                            "FROM x " & _
                            "UNION " & _
                            "SELECT DISTINCT s.userid, u.active, 2 As sort " & _
                            "FROM region_svp s " & _
                            "JOIN userlist u ON s.userid=u.userid " & _
                            "AND s.userid NOT IN (SELECT userid FROM x) " & _
                            ") " & _
                            "SELECT y.*, u.firstname, u.lastname " & _
                            "FROM y " & _
                            "JOIN userlist u ON y.userid=u.userid " & _
                            "ORDER BY y.sort, y.userid"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item
        Dim bSwitch : bSwitch=1


        Set Item = New ListItem
        Item.Value = ""
        Item.Name = "Auswahl SVP/Coach"
        Item.Active = 1
        Item.Disabled="disabled"
        SPVItemList.Add Item.Value, Item

        Do While Not Rs.Eof
            If CInt(Rs("sort")) <> bSwitch Then
               Set Item = New ListItem
               Item.Value = "_sep_"
               Item.Name = "--------"
               Item.Active = 1
               Item.Disabled="disabled"
               SPVItemList.Add Item.Value, Item
               bSwitch = CInt(Rs("sort"))
            End If
            Set Item = New ListItem
            Item.Value = Rs("userid")
            Item.Name = IIf(Rs("lastname") <> "", Rs("lastname") & " " & Rs("firstname"),Rs("userid"))
            Item.Active = Rs("active")
            Item.Disabled=""
            SPVItemList.Add Item.Value, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing
        DbCloseConnection

    End Function

    Public Function SPVAllItemList ()

        Set SPVAllItemList = Server.CreateObject("Scripting.Dictionary")


        '1. zugeteilte SPV's
        Dim SQLStr : SQLStr = "WITH x " & _
                            "AS " & _
                            "( " & _
                            "SELECT DISTINCT s.userid, u.active " & _
                            "FROM region_svp s " & _
                            "JOIN userlist u ON s.userid=u.userid " & _
                            ") " & _
                            "SELECT x.*, u.lastname, u.firstname " & _
                            "FROM x " & _
                            "JOIN userlist u ON x.userid=u.userid " & _
                            "ORDER BY x.userid"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item
        Dim bSwitch : bSwitch=1


        Set Item = New ListItem

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("userid")
            Item.Name = IIf(Rs("lastname") <> "", Rs("lastname") & " " & Rs("firstname"),Rs("userid"))
            Item.Active = Rs("active")
            Item.Disabled=""
            SPVAllItemList.Add Item.Value, Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing
        DbCloseConnection

    End Function


End Class


''-------------------------------------------------
' Tasks
''

Class NearMissTask


    Public TaskID
    Public NearID
    Public TaskNb
    Public NearNb
    Public RoomID
    Public RoomNb
    Public Room
    Public RegionID
    Public RegionNb
    Public Region
    Public Created
    Public CreatedBy
    Public Description
    Public DueDate
    Public Comments
    Public TaskTypeID
    Public TaskType
    Public AssignedTo
    Public Assigned
    Public State
    Public StateText

    Public UserID
    Public LastEdit
    Public ErrMsg
    Public ErrStatus
    Public ErrNumber

    Public BuildingID
    Public BuildingNb
    Public Building

    Private Sub Class_Initialize()

        TaskID = -1
        TaskNb = ""
        NearNb = ""
        NearID = -1

        RoomID = -1
        RoomNb = ""
        Room = ""

        RegionID = -1
        RegionNb = ""
        Region = ""

        CreatedBy = ""
        Created = ""

        Description = ""
        DueDate = ""
        Comments = ""
        TaskTypeID = -1
        TaskType = ""

        AssignedTo = ""
        Assigned = ""

        State = 0
        StateText = ""

        UserID = Session("login")
        LastEdit = ""

        ErrMsg = ""
        ErrStatus = "OK"
        ErrNumber = 0

        BuildingID = -1
        BuildingNb = ""
        Building = ""

    End Sub

    Public Sub Init (ByVal iTaskID)

        Dim TaskTypList : Set TaskTypList = New NearMissTaskTyp
        Dim TaskStateList : Set TaskStateList = New NearMissTaskState


        Dim SQLStr : SQLStr = "SELECT * FROM vwNearMissTask WHERE taskid=" & iTaskID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            TaskID = Rs("taskid")
            NearID = Rs("nearid")
            TaskNb = Rs("tasknb")
            NearNb = Rs("nearnb")
            RoomID = Rs("roomid")
            RoomNb = Rs("roomnb")
            Room = Rs("room")
            RegionID = Rs("regionid")
            RegionNb = Rs("regionnb")
            Region = Rs("region")
            CreatedBy = Rs("createdby")
            Created = Rs("created")
            Description = Rs("description")
            DueDate = Rs("duedate")
            Comments = Rs("comments")
            TaskTypeID = Rs("tasktypeid")
            TaskType = TaskTypList.List.Item(CInt(TaskTypeID)).Name
            AssignedTo = Rs("assignedto")
            Assigned = Rs("assigned")
            State = Rs("state")
            StateText = TaskStateList.List.Item(CInt(State)).Name
            UserID = Rs("userid")
            LastEdit = Rs("lastedit")

            BuildingID = Rs("buildingid")
            BuildingNb = Rs("buildingnb")
            Building = Rs("building")

        End If
        Rs.Close
        Set Rs = Nothing

        DbCloseConnection

    End Sub


    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "NearTaskUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@TaskID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TaskID

        Set Parameter = Cmd.CreateParameter("@NearID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = NearID

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 512)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description

        Set Parameter = Cmd.CreateParameter("@DueDate", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IIf(DueDate="",Date,DueDate)

        Set Parameter = Cmd.CreateParameter("@Comments", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Comments


        Set Parameter = Cmd.CreateParameter("@TaskTypeID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TaskTypeID

        Set Parameter = Cmd.CreateParameter("@AssignedTo", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AssignedTo

        Set Parameter = Cmd.CreateParameter("@Assigned", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IIf(Assigned="",Date,Assigned)

        Set Parameter = Cmd.CreateParameter("@State", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = State

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
            TaskID = Cmd.Parameters("@TaskID").Value
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Delete

        DbExecute("DELETE FROM nearmiss_task WHERE taskid=" & TaskID)
        Delete = True
        DbCloseConnection()

    End Function


End Class


%>