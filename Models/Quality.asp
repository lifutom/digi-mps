<%
Class QualityChartItem

    Public Key
    Public YearDate
    Public KW
    Public DepartmentID
    Public StreamType
    Public ComplaintsCnt
    Public ComplaintsCntText
    Public LROTCnt
    Public LROTCntText
    Public EventOpenedCnt
    Public EventOpenedCntText
    Public EventClosedCnt
    Public EventClosedCntText
    Public CapaOpened
    Public CapaClosed
    Public CCOpened
    Public CCClosed
    Public DateID
    Public Department
    Public Lable
    Public MonthDate

    Private Sub Class_Initialize()

        Key = ""
        YearDate = ""
        KW = 0
        DepartmentID = 0
        StreamType = ""
        ComplaintsCnt = 0
        ComplaintsCntText = ""
        LROTCnt = 0
        LROTCntText = ""
        EventOpenedCnt = 0
        EventOpenedCntText = ""
        EventClosedCnt = 0
        EventClosedCntText = ""
        DateID=""
        Department=""
        Lable=""
        MonthDate = ""
        CapaOpened = 0
        CapaClosed = 0
        CCOpened = 0
        CCClosed = 0

    End Sub
End Class


Class Quality

    Private mQualityID

    Public Property Let QualityID(Value)
        mQualityID = Value
        If mQualityID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get QualityID
        QualityID = mQualityID
    End Property

    Public DateID
    Public YearDate
    Public KW
    Public NewID
    Public ComplaintsCnt
    Public LROTCnt
    Public EventOpenedCnt
    Public EventClosedCnt
    Public Active
    Public DepartmentID
    Public Department
    Public StreamTypeID
    Public StreamTypeTxT
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mQualityID = ""
        NewID = ""
        DateID = ""
        YearDate = ""
        KW = ""
        EventOpenedCnt = 0
        EventClosedCnt = 0
        ComplaintsCnt = 0
        LROTCnt = 0
        Active = 1
        DepartmentID = 0
        Department = ""
        StreamTypeID = ""
        StreamTypeTxT = ""
        UserID = Session("login")
        LastEdit = ""
        Set oStream = New StreamType
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierQuality WHERE qualityid='" & mQualityID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            StreamTypeID = iRs("streamtype")
            StreamTypeTxT = oStream.Name(iRs("streamtype"))
            ComplaintsCnt = iRs("complaintscnt")
            LROTCnt = iRs("lrotcnt")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "QualityUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mQualityID = "" Then
            Set Parameter = Cmd.CreateParameter("@QualityID", adGUID, adParamOutput)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@QualityID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mQualityID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@StreamTypeID", adVarWChar, adParamInput, 15)
        Cmd.Parameters.Append Parameter
        Parameter.Value = StreamTypeID

        Set Parameter = Cmd.CreateParameter("@ComplaintsCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ComplaintsCnt

        Set Parameter = Cmd.CreateParameter("@LrotCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LROTCnt

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID


        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            ''RetVal = Cmd.CreateParameter("@PeopleID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function


    Public Function Exists(ByVal actDateID, ByVal actDepartmentID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierQuality WHERE dateid='" & DateID & "' AND departmentid=" & DepartmentID
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close
        DbCloseConnection()

    End Function

    Public Function Delete()

        Dim SQLStr : SQLStr = "DELETE FROM tier_quality WHERE qualityid='" & mQualityID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class QualityHelper

    Public Function QualityList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierQuality ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Quality
            Item.QualityID = Rs("qualityid")
            List.Add Item.QualityID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  QualityList =  List

    End Function

    Public Function ChartData (ByVal Listname, ByVal Level, ByVal DateID, ByVal StreamType, ByVal Typ)

        Select Case Level
            Case "tier2":
                Select Case Typ
                Case "actual"
                   ChartData = Tier2ChartData(DateID, StreamType)
                Case Else
                   ChartData = Tier2HistChartData(DateID, StreamType)
                End Select
            Case "tier3":
                Select Case Typ
                Case "actual"
                    ChartData = Tier3ChartData(DateID)
                Case "work"
                    ChartData = Tier3WorkChartData(DateID)
                Case "history"
                    ChartData = Tier3HistChartData(DateID)
                End Select
            Case Else
                ChartData = Tier2ChartData(DateID)
        End Select

    End Function

    Private Function Tier2ChartData (ByVal DateID, ByVal StreamType)


        Dim SQLStr : SQLStr = "WITH x As ( " & _
                                "SELECT CONVERT(date,eventstart) As eventstart, SUM(CASE WHEN (CONVERT(date,eventstart) BETWEEN DATEADD(month,-1,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "')) THEN 1 ELSE 0 END) As eventopenedcnt, SUM(CASE WHEN (CONVERT(date,eventclosed) BETWEEN DATEADD(month,-1,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "')) THEN 1 ELSE 0 END) As eventclosedcnt " & _
                                "FROM vwTierEvents " & _
                                "WHERE  ((CONVERT(date,eventstart) BETWEEN DATEADD(month,-1,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "')) OR (CONVERT(date,eventclosed) BETWEEN DATEADD(month,-1,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "'))) " & _
                                "AND streamtype = '" & StreamType & "' " & _
                                "GROUP BY eventstart " & _
                                ") " & _
                                "SELECT *  " & _
                                "FROM x " & _
                                "WHERE CONVERT(date,eventstart) BETWEEN DATEADD(month,-1,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "')"


        Dim Rs : Set Rs = DbExecute(SQLStr)

        ''Response.Write SQLStr & "<br>"

        Dim Item
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Do While Not Rs.Eof
            Set Item = New QualityChartItem

            Item.EventOpenedCnt = DBFormatNumber(Rs("eventopenedcnt"))
            Item.EventClosedCnt = DBFormatNumber(Rs("eventclosedcnt"))
            Item.DateID = Rs("eventstart")
            Item.Key = CStr(Rs("eventstart"))

            List.Add Item.Key, Item
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing


        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        With oJSON.Data
            .Add "labels", oJSON.Collection()
            With .Item("labels")
                For Each Item In List.Items
                    .Add idx,Item.DateID
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            idx=1
            With .Item("datasets")
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Events Open"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.EventOpenedCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 99, 132, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 99, 132,1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Events Closed"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.EventClosedCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 206, 86, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 206, 86, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With

            End With
        End With

        Tier2ChartData = oJSON.JSONoutput()


    End Function

    Private Function Tier2HistChartData (ByVal DateID, ByVal StreamType)

        Dim SQLStr : SQLStr = "SELECT * FROM dbo.tblKWTierQualityByStream('" & DateID & "','" & StreamType & "') ORDER BY yeardate, kw"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        Dim Item
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Do While Not Rs.Eof
            Set Item = New QualityChartItem
            Item.EventOpenedCnt = DBFormatNumber(Rs("eventsopenedcnt"))
            Item.EventClosedCnt = DBFormatNumber(Rs("eventsclosedcnt"))
            Item.ComplaintsCnt = DBFormatNumber(Rs("complaintscnt"))
            Item.LROTCnt = DBFormatNumber(Rs("lrotcnt"))
            Item.YearDate = Rs("yeardate")
            Item.KW = Rs("kw")
            Item.Key = CStr(Rs("yeardate")) & "_" & CStr(Rs("kw"))

            List.Add Item.Key, Item
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing


        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        With oJSON.Data
            .Add "labels", oJSON.Collection()
            With .Item("labels")
                For Each Item In List.Items
                    .Add idx,Item.YearDate & "/KW" & Item.KW
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            idx=1
            With .Item("datasets")
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Events Opened"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.EventOpenedCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 99, 132, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 99, 132,1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label",Html.Encode("Events Closed")
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.EventClosedCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 206, 86, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 206, 86, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Complaints"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.ComplaintsCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(0, 51, 204, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(0, 51, 204, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","LROT"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.LROTCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(120, 9, 255, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(120, 9, 255, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
            End With
        End With

        Tier2HistChartData = oJSON.JSONoutput()


    End Function



    Private Function Tier3HistChartData (ByVal DateID)

        Dim SQLStr : SQLStr = "SELECT * FROM dbo.tblKWTierQualityByStream('" & DateID & "','all') ORDER BY yeardate, kw"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        Dim Item
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Do While Not Rs.Eof
            Set Item = New QualityChartItem
            Item.EventOpenedCnt = DBFormatNumber(Rs("eventsopenedcnt"))
            Item.EventClosedCnt = DBFormatNumber(Rs("eventsclosedcnt"))
            Item.ComplaintsCnt = DBFormatNumber(Rs("complaintscnt"))
            Item.LROTCnt = DBFormatNumber(Rs("lrotcnt"))
            Item.YearDate = Rs("yeardate")
            Item.KW = Rs("kw")
            Item.Key = CStr(Rs("yeardate")) & "_" & CStr(Rs("kw"))

            List.Add Item.Key, Item
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing


        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        With oJSON.Data
            .Add "labels", oJSON.Collection()
            With .Item("labels")
                For Each Item In List.Items
                    .Add idx,Item.YearDate & "/KW" & Item.KW
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            idx=0
            With .Item("datasets")
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","LROT"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.LROTCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(120, 9, 255, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(120, 9, 255, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
            End With
        End With

        Tier3HistChartData = oJSON.JSONoutput()


    End Function


    Public Function DepartmentList(ByVal StreamType, ByVal DateID)


        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim pItem

        Dim oDepartment : Set oDepartment = New Department
        Dim DepList : Set DepList = oDepartment.ListByStreamType(StreamType)

        For Each pItem In DepList.Items
            Set Item = New QualityChartItem
            Item.DepartmentID = pItem.Value
            Item.Department = pItem.Name
            Item.DateID = DateID
            Item.EventOpenedCntText = "0"
            Item.EventClosedCntText = "0"
            List.Add Item.DepartmentID, Item
        Next
        '--------------------------------------------------------------------'
        '1. Events Opened
        '--------------------------------------------------------------------'
        Dim SQLStr : SQLStr = "SELECT departmentid, department, COUNT(*) As opened FROM vwTierEvents WHERE CONVERT(date,eventstart)='" & DateID & "' AND streamtype='" & StreamType & "' GROUP BY departmentid, department ORDER BY department, departmentid"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("departmentid")))
            Item.DateID = DateID
            Item.EventOpenedCnt = Rs("opened")
            Item.EventOpenedCntText = Rs("opened")

            Rs.MoveNext
        Loop

        Rs.Close

        SQLStr = "SELECT departmentid, department, COUNT(*) As closed FROM vwTierEvents WHERE CONVERT(date,eventclosed)='" & DateID & "' AND streamtype='" & StreamType & "' GROUP BY departmentid, department ORDER BY department, departmentid"
        Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("departmentid")))
            Item.DateID = DateID
            Item.EventClosedCnt = Rs("closed")
            Item.EventClosedCntText = Rs("closed")
            Rs.MoveNext
        Loop

        Rs.Close

        DbCloseConnection
        Set  DepartmentList =  List

    End Function

    Private Function Tier3ChartData (ByVal DateID)


        Dim SQLStr : SQLStr = "SELECT MONTH(dateid) As monthdate, SUM(raisedcnt) As opened FROM tier3_events WHERE YEAR(CONVERT(date,dateid)) = YEAR(CONVERT(date,'" & DateID & "')) GROUP BY MONTH(dateid) ORDER BY MONTH(dateid)"

        Dim Rs : Set Rs = DbExecute(SQLStr)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 1
        Item.Lable = "Jan"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 2
        Item.Lable = "Feb"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 3
        Item.Lable = "Mar"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 4
        Item.Lable = "Apr"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 5
        Item.Lable = "Mai"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 6
        Item.Lable = "Jun"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 7
        Item.Lable = "Jul"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 8
        Item.Lable = "Aug"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 9
        Item.Lable = "Sep"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 10
        Item.Lable = "Okt"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 11
        Item.Lable = "Nov"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New QualityChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 12
        Item.Lable = "Dez"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item



        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("monthdate")))
            Item.EventOpenedCnt = DBFormatNumber(Rs("opened"))
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing

        Dim Max : Max = 0


        For Each Item In List.Items
            If Item.EventOpenedCnt > Max Then
               Max =  Item.EventOpenedCnt
            End If
        Next


        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        With oJSON.Data
            .Add "labels", oJSON.Collection()
            With .Item("labels")
                For Each Item In List.Items
                    .Add idx,Item.Lable
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            idx=1
            With .Item("datasets")
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Events Raised"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.EventOpenedCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(0, 51, 204, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(0, 51, 204,1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                Dim QualGood : QualGood = GetAppSettings("qual-good")
                With .Item(idx)
                    .Add "label","Gut(<" & QualGood & ")"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,QualGood
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(0, 204, 0, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(0, 204, 0, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "type", "line"
                    ''.Add "fill", "true"
                    .Add "pointRadius",0
                    .Add "lineTension", 0
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                Dim QualAttention : QualAttention = GetAppSettings("qual-attention")
                With .Item(idx)
                    .Add "label","Achtung(<=" & QualAttention & ")"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,QualAttention
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 204, 0, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 204, 0, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "type", "line"
                    ''.Add "fill", "false"
                    .Add "pointRadius",0
                    .Add "lineTension", 0
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                Dim QualBad : QualBad = GetAppSettings("qual-bad")
                With .Item(idx)
                    .Add "label","Schlecht (>=" & QualBad & ")"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,IIf(Max > 40, Max + 5, 40 + 5)
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(204, 0, 0, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(204, 0, 0, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "type", "line"
                    ''.Add "fill", "false"
                    .Add "pointRadius",0
                    .Add "lineTension", 0
                End With

            End With
        End With

        Tier3ChartData = oJSON.JSONoutput()

    End Function


    Private Function Tier3WorkChartData (ByVal DateID)


        Dim SQLStr : SQLStr = "SELECT agid As departmentid, agname As department, COUNT(*) As workinprogress FROM vwTierEvents WHERE eventclosed IS NULL GROUP BY agid, agname ORDER BY agname"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        Dim DepListHelper : Set DepListHelper = New Department
        Set DepList = DepListHelper.DDAGList

        Dim Item
        Dim cItem

        For Each cItem In DepList.Items
            Set Item = New QualityChartItem

            Item.DepartmentID = cItem.Value
            Item.Key = cItem.Value
            Item.Department = cItem.Name

            List.Add Item.DepartmentID, Item

        Next

        ''Response.Write SQLStr & "<br>"

        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("departmentid")))
            Item.EventOpenedCnt = DBFormatNumber(Rs("workinprogress"))
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing

        SQLStr = "SELECT agid As departmentid, agname As department,  COUNT(*) As workinprogress FROM vwTierCapa WHERE capaclosed IS NULL GROUP BY agid, agname ORDER BY agname"
        Set Rs = DbExecute(SQLStr)
        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("departmentid")))
            Item.CapaOpened = DBFormatNumber(Rs("workinprogress"))
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing

        SQLStr = "SELECT agid As departmentid, agname As department,  COUNT(*) As workinprogress FROM vwTierCC WHERE ccclosed IS NULL GROUP BY agid, agname ORDER BY agname"
        Set Rs = DbExecute(SQLStr)
        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("departmentid")))
            Item.CCOpened = DBFormatNumber(Rs("workinprogress"))
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing



        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        With oJSON.Data
            .Add "labels", oJSON.Collection()
            With .Item("labels")
                For Each Item In List.Items
                    .Add idx,Item.Department
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            idx=1
            With .Item("datasets")
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Events"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.EventOpenedCnt
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(0, 51, 204, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(0, 51, 204, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","CAPA"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, DBFormatNumber(Item.CapaOpened)
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 99, 132, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 99, 132, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","CC"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, DBFormatNumber(Item.CCOpened)
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 206, 86, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,"rgba(255, 206, 86, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
            End With
        End With

        Tier3WorkChartData = oJSON.JSONoutput()


    End Function

End Class

%>