<%

Class SafetyChartItem

    Public Key
    Public YearDate
    Public MonthDate
    Public Lable
    Public KW
    Public DepartmentID
    Public StreamType
    Public AccidentCnt
    Public AccidentCntText
    Public NearAccidentCnt
    Public NearAccidentCntText
    Public IncidentCnt
    Public IncidentCntText
    Public DateID
    Public Department


    Private Sub Class_Initialize()

        Key = ""
        YearDate = ""
        MonthDate = ""
        KW = 0
        DepartmentID = 0
        StreamType = ""
        AccidentCnt = 0
        AccidentCntText = ""
        NearAccidentCnt = 0
        NearAccidentCntText = ""
        IncidentCnt = 0
        IncidentCntText = ""
        DateID=""
        Department=""
        Lable = ""

    End Sub
End Class

Class Safety

    Private mID

    Public Property Let SafetyID(Value)
        mID = Value
        If mID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get SafetyID
        SafetyID = mID
    End Property

    Public DateID
    Public NewID
    Public AccidentCnt
    Public NearAccidentCnt
    Public IncidentCnt
    Public DepartmentID
    Public Department
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        mID = ""
        NewID = ""
        DateID = ""
        AccidentCnt = 0
        NearAccidentCnt = 0
        IncidentCnt = 0
        Active = 1
        DepartmentID = 0
        Department = ""
        UserID = Session("login")
        LastEdit = ""
    End Sub


    Private Sub InitObject()
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierSafety WHERE safetyid='" & mID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            AccidentCnt = iRs("accidentcnt")
            NearAccidentCnt = iRs("nearaccidentcnt")
            IncidentCnt = iRs("incidentcnt")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SafetyUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mID = "" Then
            Set Parameter = Cmd.CreateParameter("@SafetyID", adGUID, adParamOutput)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@SafetyID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@AccidentCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = AccidentCnt

        Set Parameter = Cmd.CreateParameter("@NearAccidentCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = NearAccidentCnt

        Set Parameter = Cmd.CreateParameter("@IncidentCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IncidentCnt

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

        Dim SQLStr : SQLStr = "SELECT * FROM tier_safety WHERE dateid='" & DateID & "' AND departmentid=" & DepartmentID
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

        Dim SQLStr : SQLStr = "DELETE FROM tier_safety WHERE safetyid='" & mID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class SafetyHelper

    Public Function SafetyList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierSafety ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Safety
            Item.SafetyID = Rs("safetyid")
            Item.DateID = Rs("dateid")
            Item.DepartmentID = Rs("departmentid")
            Item.Department = Rs("department")
            Item.AccidentCnt = Rs("accidentcnt")
            Item.NearAccidentCnt = Rs("nearaccidentcnt")
            Item.IncidentCnt = Rs("incidentcnt")
            Item.UserID = Rs("userid")
            Item.LastEdit = Rs("lastedit")
            List.Add Item.SafetyID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  SafetyList =  List

    End Function

    Public Function DaysSinceLastInc()

         Dim SQLStr : SQLStr = "SELECT TOP 1 dateid FROM vwTierSafety WHERE accidentcnt > 0 ORDER BY dateid desc"
         Dim Rs : Set Rs = DbExecute(SQLStr)

         Dim DateID
         Dim actDate : actDate = Date

         If Rs.Eof Then
            DaysSinceLastInc = 0
         Else
            DateID = Rs("dateid")
            DaysSinceLastInc = Abs(DateDiff("d", actDate, DateID))
         End If

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
                Case "near"
                   ChartData = Tier3NearChartData(DateID)
                Case "inc"
                    ChartData = Tier3IncChartData(DateID)
                Case Else
                   ChartData = Tier3HistChartData(DateID)
                End Select
            Case Else
                ChartData = Tier2ChartData(DateID)
        End Select

    End Function

    Private Function Tier2ChartData (ByVal DateID, ByVal StreamType)


        Dim SQLStr : SQLStr = "SELECT dateid, SUM(accidentcnt) As accidentcnt, SUM(nearaccidentcnt) As nearaccidentcnt, SUM(incidentcnt) As incidentcnt FROM vwTierSafety WHERE streamtype='" & StreamType & "' AND CONVERT(date,dateid) BETWEEN DATEADD(month,-1,CONVERT(date,dateid)) AND CONVERT(date,'" & DateID & "') GROUP BY dateid ORDER BY dateid"

        Dim Rs : Set Rs = DbExecute(SQLStr)

        ''Response.Write SQLStr & "<br>"

        Dim Item
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Do While Not Rs.Eof
            Set Item = New SafetyChartItem

            Item.AccidentCnt = DBFormatNumber(Rs("accidentcnt"))
            Item.NearAccidentCnt = DBFormatNumber(Rs("nearaccidentcnt"))
            Item.IncidentCnt = DBFormatNumber(Rs("incidentcnt"))
            Item.DateID = Rs("dateid")
            Item.Key = CStr(Rs("dateid"))

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
                    .Add "label","Unfallmeldungen"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.AccidentCnt
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
                    .Add "label",Html.Encode("Beinaheunfall")
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.NearAccidentCnt
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
                    .Add "label","Vorfallmeldungen"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.IncidentCnt
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
            End With
        End With

        Tier2ChartData = oJSON.JSONoutput()


    End Function

    Private Function Tier2HistChartData (ByVal DateID, ByVal StreamType)


        Dim SQLStr : SQLStr = "SELECT yeardate, kw, SUM(accidentcnt) As accidentcnt, SUM(nearaccidentcnt) As nearaccidentcnt, SUM(incidentcnt) As incidentcnt FROM vwTierSafety WHERE streamtype='" & StreamType & "' AND CONVERT(date,dateid) BETWEEN DATEADD(year,-1,CONVERT(date,dateid)) AND CONVERT(date,'" & DateID & "') GROUP BY yeardate, kw ORDER BY yeardate, kw"

        Dim Rs : Set Rs = DbExecute(SQLStr)

        Dim Item
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Do While Not Rs.Eof
            Set Item = New SafetyChartItem

            Item.AccidentCnt = DBFormatNumber(Rs("accidentcnt"))
            Item.NearAccidentCnt = DBFormatNumber(Rs("nearaccidentcnt"))
            Item.IncidentCnt = DBFormatNumber(Rs("incidentcnt"))
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
                    .Add "label","Unfallmeldungen"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.AccidentCnt
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
                    .Add "label",Html.Encode("Beinaheunfall")
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.NearAccidentCnt
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
                    .Add "label","Vorfallmeldungen"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.IncidentCnt
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
            End With
        End With

        Tier2HistChartData = oJSON.JSONoutput()


    End Function


    Public Function DepartmentList(ByVal StreamType, ByVal DateID)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT dateid , departmentid, department, accidentcnt, nearaccidentcnt, incidentcnt FROM vwTierSafety WHERE dateid='" & DateID & "' AND streamtype='" & StreamType & "' ORDER BY dateid desc, department, departmentid"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item
        Dim pItem

        Dim oDepartment : Set oDepartment = New Department
        Dim DepList : Set DepList = oDepartment.ListByStreamType(StreamType)

        For Each pItem In DepList.Items
            Set Item = New SafetyChartItem
            Item.DepartmentID = pItem.Value
            Item.Department = pItem.Name
            Item.DateID = DateID
            Item.AccidentCntText = "<font color=""red"">N/A</font>"
            Item.NearAccidentCntText = "<font color=""red"">N/A</font>"
            Item.IncidentCntText = "<font color=""red"">N/A</font>"
            List.Add Item.DepartmentID, Item
        Next

        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("departmentid")))
            Item.DateID = Rs("dateid")
            Item.AccidentCnt = Rs("accidentcnt")
            Item.NearAccidentCnt = Rs("nearaccidentcnt")
            Item.IncidentCnt = Rs("incidentcnt")
            Item.AccidentCntText = Rs("accidentcnt")
            Item.NearAccidentCntText = Rs("nearaccidentcnt")
            Item.IncidentCntText = Rs("incidentcnt")
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  DepartmentList =  List

    End Function

    Private Function Tier3ChartData (ByVal DateID)


        Dim SQLStr : SQLStr = "SELECT agid As departmentid, agname As department, SUM(accidentcnt) As accidentcnt, SUM(nearaccidentcnt) As nearaccidentcnt, SUM(incidentcnt) As incidentcnt FROM vwTierSafety WHERE CONVERT(date,dateid) BETWEEN DATEADD(day,-3,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "') GROUP BY agid, agname ORDER BY agname"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        Dim DepListHelper : Set DepListHelper = New Department
        Set DepList = DepListHelper.DDAGList

        Dim Item
        Dim cItem

        For Each cItem In DepList.Items
            Set Item = New SafetyChartItem

            Item.DepartmentID = cItem.Value
            Item.Key = cItem.Value
            Item.Department = cItem.Name

            List.Add Item.DepartmentID, Item

        Next

        ''Response.Write SQLStr & "<br>"

        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("departmentid")))
            Item.AccidentCnt = DBFormatNumber(Rs("accidentcnt"))
            Item.NearAccidentCnt = DBFormatNumber(Rs("nearaccidentcnt"))
            Item.IncidentCnt = DBFormatNumber(Rs("incidentcnt"))
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
                    .Add "label","Safety Observations"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.IncidentCnt
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
            End With
        End With

        Tier3ChartData = oJSON.JSONoutput()


    End Function


    Private Function Tier3IncChartData (ByVal DateID)


        Dim SQLStr : SQLStr = "SELECT agid As departmentid, agname As department, SUM(accidentcnt) As accidentcnt, SUM(nearaccidentcnt) As nearaccidentcnt, SUM(incidentcnt) As incidentcnt FROM vwTierSafety WHERE CONVERT(date,dateid) BETWEEN DATEADD(day,-3,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "') GROUP BY agid, agname ORDER BY agname"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        Dim DepListHelper : Set DepListHelper = New Department
        Set DepList = DepListHelper.DDAGList

        Dim Item
        Dim cItem

        For Each cItem In DepList.Items
            Set Item = New SafetyChartItem

            Item.DepartmentID = cItem.Value
            Item.Key = cItem.Value
            Item.Department = cItem.Name

            List.Add Item.DepartmentID, Item

        Next

        ''Response.Write SQLStr & "<br>"

        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("departmentid")))
            Item.AccidentCnt = DBFormatNumber(Rs("accidentcnt"))
            Item.NearAccidentCnt = DBFormatNumber(Rs("nearaccidentcnt"))
            Item.IncidentCnt = DBFormatNumber(Rs("incidentcnt"))
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
                    .Add "label","Safety Incidents"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.accidentcnt
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
            End With
        End With

        Tier3IncChartData = oJSON.JSONoutput()


    End Function


     Private Function Tier3NearChartData (ByVal DateID)


        Dim SQLStr : SQLStr = "SELECT yeardate, MONTH(dateid) As monthdate, SUM(accidentcnt) As accidentcnt, SUM(nearaccidentcnt) As nearaccidentcnt, SUM(incidentcnt) As incidentcnt FROM vwTierSafety WHERE yeardate = YEAR(CONVERT(date,'" & DateID & "')) GROUP BY yeardate, MONTH(dateid) ORDER BY yeardate, MONTH(dateid)"

        Dim Rs : Set Rs = DbExecute(SQLStr)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        Dim Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 1
        Item.Lable = "Jan"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 2
        Item.Lable = "Feb"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 3
        Item.Lable = "Mar"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 4
        Item.Lable = "Apr"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 5
        Item.Lable = "Mai"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 6
        Item.Lable = "Jun"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 7
        Item.Lable = "Jul"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 8
        Item.Lable = "Aug"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 9
        Item.Lable = "Sep"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 10
        Item.Lable = "Okt"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 11
        Item.Lable = "Nov"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item

        Set Item = New SafetyChartItem
        Item.YearDate = Year(DateID)
        Item.MonthDate = 12
        Item.Lable = "Dez"
        Item.Key = Item.MonthDate
        List.Add Item.Key, Item



        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("monthdate")))
            Item.NearAccidentCnt = DBFormatNumber(Rs("nearaccidentcnt"))
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
                    .Add idx,Item.Lable
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            idx=1
            With .Item("datasets")
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Near Misses pro Monat"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1,Item.NearAccidentCnt
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
                            .Add idx1,"rgba(0, 51, 204,1)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderWidth", 2
                    .Add "lineTension", 0
                    .Add "fill", "false"
                End With
            End With
        End With

        Tier3NearChartData = oJSON.JSONoutput()


    End Function

End Class


%>