<%
Class DeliveryBulkChartItem

    Public Key
    Public YearDate
    Public KW
    Public DepartmentID
    Public StreamType
    Public ProducedCnt
    Public ProducedCntText
    Public PlannedCnt
    Public PlannedCntText
    Public DateID
    Public Department
    Public PlantID
    Public Plant

    Private Sub Class_Initialize()

        Key = ""
        YearDate = ""
        KW = 0
        DepartmentID = 0
        StreamType = ""
        ProducedCnt = 0
        ProducedCntText = "<font color=""red"">N/A</font>"
        OutputCnt = 0
        OutputCntText = "<font color=""red"">N/A</font>"
        PlannedOutputCnt = 0
        PlannedOutputCntText = "<font color=""red"">N/A</font>"
        DateID=""
        Department=""
        PlantID = 0
        Plant = ""

    End Sub
End Class


Class DeliveryBulk

    Private mID

    Public Property Let DeliveryBulkID(Value)
        mID = Value
        If mID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get DeliveryBulkID
        DeliveryBulkID = mID
    End Property

    Public DateID
    Public DateYear
    Public DateKW
    Public NewID
    Public PlannedCnt
    Public ProducedCnt
    Public PlantID
    Public Plant
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        mID = ""
        NewID = ""
        DateID = ""
        DateYear = ""
        DateKW = ""
        PlannedCnt = 0
        ProducedCnt = 0
        Active = 1
        PlantID = 0
        Plant = ""
        UserID = Session("login")
        LastEdit = ""
    End Sub


    Private Sub InitObject()
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierDeliveryBulk WHERE deliverybulkid='" & mID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            DateYear = iRs("dateyear")
            DateKW = iRs("datekw")
            PlantID = iRs("plantid")
            Plant = iRs("plant")
            PlannedCnt = iRs("plannedcnt")
            ProducedCnt = iRs("producedcnt")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "DeliveryBulkUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mID = "" Then
            Set Parameter = Cmd.CreateParameter("@DeliveryBulkID", adGUID, adParamOutput)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@DeliveryBulkID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DateYear", adVarWChar, adParamInput, 4)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateYear

        Set Parameter = Cmd.CreateParameter("@DateKW", adVarWChar, adParamInput, 2)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateKW

        Set Parameter = Cmd.CreateParameter("@PlantID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = PlantID

        Set Parameter = Cmd.CreateParameter("@PlannedCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = PlannedCnt

        Set Parameter = Cmd.CreateParameter("@ProducedCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ProducedCnt

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID
       
        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function


    Public Function Exists(ByVal actDateYear, ByVal actDateKW, ByVal actPlantID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierDeliveryBulk WHERE dateyear='" & actDateYear & "' AND datekw='" & actDateKW & "' AND plantid=" & actPlantID
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

        Dim SQLStr : SQLStr = "DELETE FROM tier_delivery_bulk WHERE deliverybulkid='" & mID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class DeliveryBulkHelper

    Public Function DeliveryBulkList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierDeliveryBulk ORDER BY dateyear desc, datekw desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Safety
            Item.DeliveryBulkID = Rs("deliverybulkid")
            List.Add Item.DeliveryBulkID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  DeliveryBulkList =  List

    End Function

    Public Function ChartData (ByVal Listname, ByVal Level, ByVal DateID, ByVal StreamType, ByVal Typ, ByVal Area)

        Select Case Level
            Case "tier2":
                Select Case Typ
                Case "actual"
                   ChartData = Tier2ChartData(DateID, StreamType, Area)
                Case Else
                   ChartData = Tier2HistChartData(DateID, StreamType)
                End Select
            Case Else
                ChartData = Tier2ChartData(DateID)
        End Select

    End Function

    Private Function Tier2ChartData (ByVal DateID, ByVal StreamType, ByVal Area)


        Dim KW : KW = glKW(CDate(DateID))

        Dim SQLStr : SQLStr = "SELECT	v.dateyear, v.datekw, SUM(v.plannedcnt) As plannedcnt, SUM(v.producedcnt) As producedcnt " & _
                            "FROM vwTierDeliveryBulk v " & _
                            "WHERE (v.dateyear*53) + v.datekw >= (YEAR(DATEADD(month,-6,CONVERT(date,'" & DateID & "'))) * 53) +  DATEPART(iso_week,DATEADD(month,-6,CONVERT(date,'" & DateID & "'))) " & _
                            "AND (v.dateyear*53) + v.datekw <= (YEAR(CONVERT(date,'" & DateID & "')) * 53) +  DATEPART(iso_week,CONVERT(date,'" & DateID & "')) " & _
                            "AND v.streamtype = '" & StreamType & "' " & _
                            "AND v.area = '" & Area & "' " & _
                            "GROUP BY v.dateyear, v.datekw " & _
                            "ORDER BY CONVERT(int,v.dateyear), CONVERT(int, v.datekw)"

        ''Response.Write SQLStr & "<br>"

        Dim Rs : Set Rs = DbExecute(SQLStr)



        Dim Item
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Do While Not Rs.Eof
            Set Item = New DeliveryBulkChartItem

            Item.YearDate = Rs("dateyear")
            Item.KW =  Rs("datekw")
            Item.PlannedCnt = DBFormatNumber(Rs("plannedcnt"))
            Item.ProducedCnt = DBFormatNumber(Rs("producedcnt"))

            Item.Key = CStr(Rs("dateyear") & "_" & Rs("datekw"))
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
                    .Add "label","Planned"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.PlannedCnt
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
                    .Add "label","Produced"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In List.Items
                            .Add idx1, Item.ProducedCnt
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


    Public Function PlantList(ByVal StreamType, ByVal Area, ByVal DateID)


        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim pItem

        Dim oPlant : Set oPlant = New PlantHelper
        Dim oPlantList : Set oPlantList = oPlant.DDList(StreamType, Area)

        For Each pItem In oPlantList.Items
            Set Item = New DeliveryBulkChartItem
            Item.PlantID = pItem.Value
            Item.Plant = pItem.Name
            Item.DateID = DateID
            List.Add Item.PlantID, Item
        Next

        Dim SQLStr : SQLStr = "SELECT	v.plantid, v.plant, v.dateyear,v.datekw, v.plannedcnt, v.producedcnt " & _
                            "FROM vwTierDeliveryBulk v " & _
                            "WHERE v.dateyear = YEAR(CONVERT(date,'" & DateID & "')) " & _
                            "AND v.datekw = DATEPART(iso_week,CONVERT(date,'" & DateID & "')) "
        If StreamType <> "" Then
            SQLStr = SQLStr & "AND v.streamtype = '" & StreamType & "' "
        End If
        If StreamType <> "" Then
            SQLStr = SQLStr & "AND v.area = '" & Area & "' "
        End If

        SQLStr = SQLStr & "ORDER BY v.dateyear,v.datekw"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item
        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("plantid")))
            Item.PlannedCnt = Rs("plannedcnt")
            Item.PlannedCntText = Rs("plannedcnt")
            Item.ProducedCnt = Rs("producedcnt")
            Item.ProducedCntText = Rs("producedcnt")
            Rs.MoveNext
        Loop

        Rs.Close

        DbCloseConnection
        Set  PlantList =  List

    End Function

End Class


%>