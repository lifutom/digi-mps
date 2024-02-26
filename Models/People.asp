<%
Class PeopleChartItem

    Public Key
    Public YearDate
    Public KW
    Public DepartmentID
    Public StreamType
    Public EmployeeCnt
    Public Percentage
    Public SickCnt
    Public DateID

    Private Sub Class_Initialize()

        Key = ""
        YearDate = ""
        KW = 0
        DepartmentID = 0
        StreamType = ""
        EmployeeCnt = 0
        SickCnt = 0
        Percentage = 0

    End Sub
End Class


Class PeopleDepartmentItem

    Public Key
    Public DepartmentID
    Public Department
    Public StreamType
    Public Area
    Public DateID
    Public YearDate
    Public KW
    Public EmployeeCnt
    Public SickCnt
    Public Percentage
    Public BgColor
    Public ItemText
    Public PercentageText

    Private Sub Class_Initialize()

        Key = ""
        YearDate = ""
        KW = 0
        DepartmentID = 0
        Department = 0
        StreamType = ""
        Area = ""
        DateID = ""
        EmployeeCnt = 0
        SickCnt = 0
        Percentage = 0
        BgColor = ""
        ItemText = ""
        PercentageText = ""

    End Sub

End Class


Class People

    Private mPeopleID
    Private mID

    Public Property Let PeopleID(Value)
        mPeopleID = Value
        If mPeople <> "" Then
           InitObject
        End If
    End Property

    Public Property Get PeopleID
        PeopleID = mPeopleID
    End Property

    Public Property Let ID(Value)
        mPeopleID = Value
    End Property

    Public Property Get ID
        ID = mPeopleID 
    End Property
     
    Public DateID
    Public NewID
    Public EmployeeCnt
    Public SickCnt
    Public Active
    Public DepartmentID
    Public Department
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        mPeopleID = ""
        NewID = ""
        DateID = ""
        EmployeeCnt = 0
        SickCnt = 0
        Active = 1
        DepartmentID = 0
        Department = ""
        UserID = Session("login")
        LastEdit = ""
    End Sub


    Private Sub InitObject()
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierPeople WHERE peopleid='" & mPeopleID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then        
	    DateID = iRs("dateid")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            EmployeeCnt = iRs("employeecnt")
            SickCnt = iRs("sickcnt")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "PeopleUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mPeopleID = "" Then
            Set Parameter = Cmd.CreateParameter("@PeopleID", adGUID, adParamOutput)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@PeopleID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mPeopleID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@EmployeeCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = EmployeeCnt

        Set Parameter = Cmd.CreateParameter("@SickCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SickCnt

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

        Dim SQLStr : SQLStr = "SELECT * FROM tier_people WHERE dateid='" & DateID & "' AND departmentid=" & DepartmentID
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

        Dim SQLStr : SQLStr = "DELETE FROM tier_people WHERE peopleid='" & mPeopleID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class PeopleHelper

    Public Function PeopleList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierPeople ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)
	 
        Dim Item

        Do While Not Rs.Eof
            Set Item = New People
            Item.ID = Rs("peopleid")
            Item.DateID = Rs("dateid")
            Item.DepartmentID = Rs("departmentid")
            Item.Department = Rs("department")
            Item.EmployeeCnt = Rs("employeecnt")
            Item.SickCnt = Rs("sickcnt")
            Item.UserID = Rs("userid")
            Item.LastEdit = Rs("lastedit")
            List.Add Item.PeopleID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  PeopleList =  List

    End Function

    Public Function ChartData (ByVal Listname, ByVal Level, ByVal DateID, ByVal StreamType, ByVal Typ)

        Select Case Level
            Case "tier2":
                Select Case Typ
                    Case "actual"
                        ChartData = Tier2ChartData(StreamType, DateID)
                    Case Else
                        ChartData = Tier2HistChartData(StreamType, DateID)
                End Select
            Case "tier3":
                Select Case Typ
                    Case "actual"
                        ChartData = Tier2ChartData(StreamType, DateID)
                    Case Else
                        ChartData = Tier2HistChartData(StreamType, DateID)
                End Select
            Case Else
                ChartData = Tier2ChartData(StreamType, DateID)
        End Select

    End Function

    Private Function Tier2ChartData (ByVal Stream, ByVal DateID)


        Dim SQLStr : SQLStr = "SELECT dateid, yeardate, kw, SUM(employeecnt) As employeecnt, SUM(sickcnt) As sickcnt FROM vwTierPeople WHERE " & IIf(Stream="all","", "streamtype='" & Stream & "' AND ") & " CONVERT(date,dateid) BETWEEN DATEADD(dd,-45,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "') GROUP BY dateid, yeardate, kw ORDER BY dateid"


        Dim Rs : Set Rs = DbExecute(SQLStr)

        Dim Item
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SickFactor : SickFactor = GetAppSettings("sick_factor")


        Do While Not Rs.Eof
            Set Item = New PeopleChartItem

            Item.YearDate = Rs("yeardate")
            Item.KW = Rs("kw")
            Item.EmployeeCnt = DBFormatNumber(Rs("employeecnt"))
            Item.SickCnt = DBFormatNumber(Rs("sickcnt"))
            Item.DateID = Rs("dateid")
            Item.Key = Rs("dateid")
            Item.Percentage = Round((Rs("sickcnt") / Rs("employeecnt")) * 100,2)
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
                    .Add "label","Krankenstand in %"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, DBFormatNumber(Item.Percentage)
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
                    .Add "label","Max in %"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, DBFormatNumber(SickFactor)
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
            End With
        End With

        Tier2ChartData = oJSON.JSONoutput()


    End Function


    Private Function Tier2HistChartData (ByVal Stream, ByVal DateID)


        Dim SQLStr : SQLStr = "SELECT yeardate, kw, SUM(employeecnt) As employeecnt, SUM(sickcnt) As sickcnt FROM vwTierPeople WHERE " & IIf(Stream="all","", "streamtype='" & Stream & "' AND ") & " CONVERT(date,dateid) BETWEEN  DATEADD(year,-1,CONVERT(date,'" & DateID & "'))  AND CONVERT(date,'" & DateID & "') GROUP BY yeardate, kw ORDER BY yeardate, kw"

        Dim Rs : Set Rs = DbExecute(SQLStr)

        Dim Item
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        Dim SickFactor : SickFactor = GetAppSettings("sick_factor")
        Do While Not Rs.Eof
            Set Item = New PeopleChartItem

            Item.YearDate = Rs("yeardate")
            Item.KW = Rs("kw")
            Item.EmployeeCnt = DBFormatNumber(Rs("employeecnt"))
            Item.SickCnt = DBFormatNumber(Rs("sickcnt"))
            Item.Percentage = DBFormatNumber(Round((Rs("sickcnt") / Rs("employeecnt")) * 100,2))
            Item.Key = Rs("yeardate") & "_" & Rs("kw")

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
                    .Add "label","Krankenstand pro KW in %"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.Percentage
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
                    .Add "label","Max in %"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, DBFormatNumber(SickFactor)
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
            End With
        End With

        Tier2HistChartData = oJSON.JSONoutput()


    End Function


    Public Function PeopleDepartmentList(ByVal StreamType, ByVal DateID, ByVal SickFactor)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr

        If StreamType <> "all" Then
            SQLStr = "SELECT peopleid, dateid , departmentid, department, employeecnt, sickcnt FROM vwTier2PeopleDepartmentList WHERE active=1 AND dateid='" & DateID & "' AND streamtype='" & StreamType & "' ORDER BY dateid desc, department, departmentid"
        Else
            SQLStr = "SELECT agid As departmentid, agname As department, SUM(employeecnt) As employeecnt, SUM(sickcnt) As sickcnt FROM vwTier2PeopleDepartmentList WHERE active=1 AND dateid='" & DateID & "' GROUP BY agid, agname ORDER BY agname, agid"
        End If
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item
        Dim pItem

        Dim oDepartment : Set oDepartment = New Department
        Dim DepList : Set DepList = oDepartment.ListByStreamType(StreamType)

        For Each pItem In DepList.Items
            Set Item = New PeopleDepartmentItem
            Item.DepartmentID = pItem.Value
            Item.Department = pItem.Name
            Item.DateID = DateID
            Item.Percentage = -1
            Item.ItemText = "<font color=""red"">N/A</font>"
            Item.PercentageText = "<font color=""red"">N/A</font>"
            List.Add Item.DepartmentID, Item
        Next

        Do While Not Rs.Eof

            Set Item = List(CInt(Rs("departmentid")))
            If StreamType <> "all" Then
               Item.Key = Rs("peopleid")
            End If   
            If Rs("employeecnt") > 0 Then
                Item.EmployeeCnt = Rs("employeecnt")
                Item.SickCnt = Rs("sickcnt")
                Item.Percentage = Item.SickCnt/Item.EmployeeCnt * 100
                Item.ItemText = "<strong>" & Item.EmployeeCnt & "/" & Item.SickCnt & "</strong>"
                Item.PercentageText = FormatNumber(Item.Percentage,2)
                If Item.Percentage < SickFactor Then
                   Item.BgColor = "success-color text-white font-weight-bold"
                Else
                   Item.BgColor = "danger-color text-white font-weight-bold"
                End If
            Else
                Item.EmployeeCnt = Rs("employeecnt")
                Item.SickCnt = Rs("sickcnt")
                Item.Percentage = -1
                Item.ItemText = "<font color=""red"">N/A</font>"
                Item.PercentageText = "<font color=""red"">N/A</font>"
            End If
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  PeopleDepartmentList =  List

    End Function


End Class


%>