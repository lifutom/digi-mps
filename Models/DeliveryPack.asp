<%
Class ChartListItem

    Public KeyValue
    Public List
    Public Name
    Public BgColor
    Public BorderColor

    Private Sub Class_Initialize()

        Set List = Server.CreateObject("Scripting.Dictionary")
        KeyValue = ""
        Name = ""
        BgColor = ""
        BorderColor = ""

    End Sub

End Class


Class DeliveryPackChartItem

    Public Key
    Public YearDate
    Public KW
    Public DepartmentID
    Public StreamType
    Public OEEValue
    Public OEEValueText
    Public OEEValueAvg
    Public OEEValueAvgText
    Public OutputCnt
    Public OutputCntText
    Public PlannedOutputCnt
    Public PlannedOutputCntText
    Public DateID
    Public Department
    Public PlantID
    Public Plant
    Public Label
    Public ChartList

    Private Sub Class_Initialize()

        Key = ""
        YearDate = ""
        KW = 0
        DepartmentID = 0
        StreamType = ""
        OEEValue = 0
        OEEValueText = "<font color=""red"">N/A</font>"
        OEEValueAvg = 0
        OEEValueAvgText = "<font color=""red"">N/A</font>"
        OutputCnt = 0
        OutputCntText = "<font color=""red"">N/A</font>"
        PlannedOutputCnt = 0
        PlannedOutputCntText = "<font color=""red"">N/A</font>"
        DateID=""
        Department=""
        PlantID = 0
        Plant = ""
        Label = ""
        Set ChartList = Server.CreateObject("Scripting.Dictionary")

    End Sub
End Class

Class DeliveryPack

    Private mID

    Public Property Let DeliveryPackID(Value)
        mID = Value
        If mID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get DeliveryPackID
        DeliveryPackID = mID
    End Property

    Public DateID
    Public NewID
    Public OEEValue
    Public OutputCnt
    Public PlantID
    Public Plant
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        mID = ""
        NewID = ""
        DateID = ""
        OEEValue = 0
        OutputCnt = 0
        Active = 1
        PlantID = 0
        Plant = ""
        UserID = Session("login")
        LastEdit = ""
    End Sub


    Private Sub InitObject()
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierDeliveryPack WHERE deliverypackid='" & mID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            PlantID = iRs("plantid")
            Plant = iRs("plant")
            OEEValue = iRs("oeevalue")
            OutputCnt = iRs("outputcnt")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "DeliveryPackUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mID = "" Then
            Set Parameter = Cmd.CreateParameter("@DeliveryPackID", adGUID, adParamOutput)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@DeliveryPackID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        ''Response.Write  "PlantID:" & PlantID

        Set Parameter = Cmd.CreateParameter("@PlantID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = PlantID

        Set Parameter = Cmd.CreateParameter("@OEEValue", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OEEValue

        Set Parameter = Cmd.CreateParameter("@OutputCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OutputCnt

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


    Public Function Exists(ByVal actDateID, ByVal actPlantID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierDeliveryPack WHERE dateid='" & actDateID  & "' AND plantid=" & actPlantID
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

        Dim SQLStr : SQLStr = "DELETE FROM tier_delivery_pack WHERE deliverypackid='" & mID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class DeliveryPackHelper

    Public Function ChartData (ByVal Listname, ByVal Level, ByVal DateID, ByVal StreamType, ByVal Typ, ByVal Area)

        Select Case Level
            Case "tier2":
                Select Case Typ
                Case "actualoee"
                   ChartData = Tier2ChartData(DateID, StreamType, Typ, Area)
                 Case "actualoutput"
                   ChartData = Tier2ChartData(DateID, StreamType, Typ, Area)
                Case Else
                   ChartData = Tier2HistChartData(DateID, StreamType)
                End Select
            Case "tier3":
                Select Case Typ
                Case "actualoee"
                   ChartData = Tier3ChartData(DateID)
                End Select
            Case Else
                ChartData = Tier2ChartData(DateID)
        End Select

    End Function

    Private Function Tier2ChartData (ByVal DateID, ByVal StreamType, ByVal Typ, ByVal Area)


        Dim pList : Set pList = Server.CreateObject("Scripting.Dictionary")
        Dim pItem

        Dim oPlant : Set oPlant = New PlantHelper
        Dim oPlantList : Set oPlantList = oPlant.DDList(StreamType, Area)

        For Each pItem In oPlantList.Items
            Set Item = New ChartListItem
            Item.KeyValue = pItem.Value
            Item.Name = pItem.Name
            pList.Add pItem.Value, Item
        Next


        Dim SQLStr : SQLStr = "SELECT	v.plantid, v.plant, v.dateid, v.oeevalue, v.outputcnt " & _
                            "FROM vwTierDeliveryPack v " & _
                            "WHERE CONVERT(date,v.dateid) BETWEEN DATEADD(month,-1,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "') " & _
                            "AND v.streamtype = '" & StreamType & "' " & _
                            "AND v.area = '" & Area & "' " & _
                            "ORDER BY v.plant,v.plantid, v.dateid"

        Dim Rs : Set Rs = DbExecute(SQLStr)

        ''Response.Write SQLStr & "<br>"

        Dim Item
        Dim PlantID
        Dim tstPlantID
        ''Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim DataList

        Do While Not Rs.Eof
            Set DataList = pList(CInt(Rs("plantid"))).List
            PlantID = Rs("plantid")
            tstPlantID = Rs("plantid")
            Do While Not Rs.Eof And PlantID = tstPlantID
                Set Item = New DeliveryPackChartItem
                Item.OEEValue = DBFormatNumber(Rs("oeevalue"))
                Item.OutputCnt = DBFormatNumber(Rs("outputcnt"))
                Item.DateID = Rs("dateid")
                Item.Key = CStr(Rs("dateid"))
                DataList.Add Item.Key, Item
                Rs.MoveNext
                If Not Rs.Eof Then
                   tstPlantID = Rs("plantid")
                End If
            Loop
        Loop
        Rs.Close
        Set Rs = Nothing


        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        Dim Dep
        Dim DepItem

        With oJSON.Data
            For Each Dep In pList.Items
                .Add Dep.KeyValue, oJSON.Collection()
                With.Item(Dep.KeyValue)
                    .Add "plantid", Dep.KeyValue
                    .Add "plant", Dep.Name
                    .Add "oeedata",oJSON.Collection()
                    With .Item("oeedata")
                        Set List = Dep.List
                    ''For Each List In Dep.List.Items
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
                                .Add "label","OEE"
                                .Add "data",oJSON.Collection()
                                With .Item("data")
                                    idx1=1
                                    For Each Item In List.Items
                                        .Add idx1, Item.OEEValue
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
                        End With
                    End With
                    .Add "outputdata",oJSON.Collection()
                    With .Item("outputdata")
                        Set List = Dep.List
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
                                .Add "label", "Output"
                                .Add "data",oJSON.Collection()
                                With .Item("data")
                                    idx1=1
                                    For Each Item In List.Items
                                        .Add idx1,Item.OutputCnt
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
                        End With
                    End With
                End With
            Next

        End With
        Tier2ChartData = oJSON.JSONoutput()
    End Function

    Private Function Tier3ChartData (ByVal DateID)

        ' kwlist '
        Dim kwList : Set kwList = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStart : SQLStart = "SELECT DISTINCT v.yeardate, v.kw "  & _
                                    "FROM vwTierDeliveryPack v " & _
                                    "WHERE CONVERT(date,v.dateid) BETWEEN DATEADD(week,-9,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "') " & _
                                    "GROUP BY v.yeardate,v.kw " & _
                                    "ORDER BY v.yeardate, v.kw"

        Dim RsStart : Set RsStart = DbExecute(SQLStart)
        Dim fItem

        Do While Not RsStart.Eof
           Set fItem = New DeliveryPackChartItem
           fItem.YearDate = RsStart("yeardate")
           fItem.KW = RsStart("kw")
           kwList.Add fItem.YearDate & "_" & fItem.KW, fItem
           RsStart.MoveNext
        Loop
        RsStart.Close
        Set RsStart = Nothing

         '' Plantlist
        Dim pList : Set pList = Server.CreateObject("Scripting.Dictionary")
        Dim pItem
        Dim nItem

        Dim oPlant : Set oPlant = New PlantHelper
        Dim oPlantList : Set oPlantList = oPlant.DDList("", "pack")

        Dim r
        Dim g
        Dim b
        Dim min : min = 0
        Dim max : max = 255

        For Each pItem In oPlantList.Items
            Set Item = New ChartListItem
            Item.KeyValue = pItem.Value
            Item.Name = pItem.Name

            r =int((max-min+1)*rnd+min)
            g =int((max-min+1)*rnd+min)
            b =int((max-min+1)*rnd+min)

            Item.BgColor = "rgba(" & r & "," & g & "," & b & ",0.2)"
            Item.BorderColor = "rgba(" & r & "," & g & "," & b & ", 1)"

            For Each fItem In kwList.Items
                Set nItem = New DeliveryPackChartItem
                nItem.PlantID = Item.KeyValue
                nItem.Plant = Item.Name
                nItem.KW = fItem.KW
                nItem.YearDate = fItem.YearDate
                nItem.Label = nItem.YearDate & "/" & nItem.KW
                nItem.Key = nItem.YearDate & "_" & nItem.KW
                Item.List.Add nItem.Key, nItem
            Next
            pList.Add Item.KeyValue, Item
        Next

        Dim SQLStr : SQLStr = "SELECT yeardate, kw,plantid, plant, ROUND(SUM(ISNULL(oeevalue,0))/COUNT(*),2) As oeevalue " & _
                            "FROM vwTierDeliveryPack v " & _
                            "WHERE CONVERT(date,v.dateid) BETWEEN DATEADD(week,-9,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "') " & _
                            "AND v.area = 'pack' " & _
                            "GROUP BY v.yeardate,v.kw, v.plantid, v.plant " & _
                            "ORDER BY v.plant,v.plantid, v.yeardate, v.kw"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim KeyStr

        Do While Not Rs.Eof
           Set Item = pList(CInt(Rs("plantid")))
           KeyStr = Rs("yeardate") & "_" & Rs("kw")
           If Item.List.Exists(KeyStr) Then
              Set fItem = Item.List(KeyStr)
              fItem.OEEValue = Rs("oeevalue")
           End If
           Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing


        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        Dim Dep
        Dim DepItem

        With oJSON.Data
            .Add "labels", oJSON.Collection()
            With .Item("labels")
                For Each Item In kwList.Items
                    .Add idx,Item.YearDate & "/KW" & Item.KW
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            With .Item("datasets")
                idx=1
                For Each Dep In pList.Items
                    .Add idx, oJSON.Collection()
                    With .Item(idx)
                        .Add "label",Dep.Name
                        .Add "data",oJSON.Collection()
                        With .Item("data")
                            idx1=1
                            For Each Item In Dep.List.Items
                                .Add idx1, DBFormatNumber(Item.OEEValue)
                                idx1=idx1+1
                            Next
                        End With
                        .Add "backgroundColor",oJSON.Collection()
                        With .Item("backgroundColor")
                            idx1=1
                            For Each Item In Dep.List.Items
                                .Add idx1,Dep.BgColor
                                ''.Add idx1,"rgba(0, 51, 204, 0.2)"
                                idx1=idx1+1
                            Next
                        End With
                        .Add "borderColor",oJSON.Collection()
                        With .Item("borderColor")
                            idx1=1
                            For Each Item In Dep.List.Items
                               ''.Add idx1,"rgba(0, 51, 204, 1)"
                                .Add idx1,Dep.BorderColor
                                idx1=idx1+1
                            Next
                        End With
                        .Add "borderWidth", 2
                        .Add "lineTension", 0
                        .Add "fill", "false"
                    End With
                    idx=idx+1
                Next
            End With
        End With
        Tier3ChartData = oJSON.JSONoutput()
    End Function




    Public Function PlantList(ByVal StreamType, ByVal Area, ByVal DateID)


        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim pItem

        Dim oPlant : Set oPlant = New PlantHelper
        Dim oPlantList : Set oPlantList = oPlant.DDList(StreamType, Area)

        For Each pItem In oPlantList.Items
            Set Item = New DeliveryPackChartItem
            Item.PlantID = pItem.Value
            Item.Plant = pItem.Name
            Item.DateID = DateID
            List.Add Item.PlantID, Item
        Next

        Dim SQLStr : SQLStr = "SELECT	v.plantid, v.dateid, v.oeevalue, v.outputcnt " & _
                            "FROM vwTierDeliveryPack v " & _
                            "WHERE CONVERT(date,v.dateid) = '" & DateID & "' "
        If StreamType <> "" Then
            SQLStr = SQLStr & "AND v.streamtype = '" & StreamType & "' "
        End If
        If StreamType <> "" Then
            SQLStr = SQLStr & "AND v.area = '" & Area & "' "
        End If
        SQLStr = SQLStr & "ORDER BY DateID"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = List(CInt(Rs("plantid")))
            Item.DateID = DateID
            Item.OEEValue = Rs("oeevalue")
            Item.OEEValueText = Rs("oeevalue")
            Item.OutputCnt = Rs("outputcnt")
            Item.OutputCntText = Rs("outputcnt")
            Rs.MoveNext
        Loop

        Rs.Close

        DbCloseConnection
        Set  PlantList =  List

    End Function

    Public Function OEEActual(ByVal StreamType, ByVal Area, ByVal DateID)

        Dim SQLStr : SQLStr = "SELECT	AVG(v.oeevalue) As oeevalue, SUM(v.outputcnt) As outputcnt " & _
                            "FROM vwTierDeliveryPack v " & _
                            "WHERE CONVERT(date,v.dateid) = CONVERT(date,'" & DateID & "') " & _
                            "AND v.streamtype = '" & StreamType & "' " & _
                            "AND v.area = '" & Area & "'"

        Dim Rs : Set Rs = DbExecute(SQLStr)

        ''Response.Write SQLStr & "<br>"

        Dim Item : Set Item = New DeliveryPackChartItem

       If Not Rs.Eof Then
            If Not IsNull(Rs("oeevalue")) Then
                Item.OEEValue = Rs("oeevalue")
                Item.OEEValueText = FormatNumber(Round(Rs("oeevalue"),2),2) & " %"
            End If
            If Not IsNull(Rs("outputcnt")) Then
                Item.OutputCnt = Rs("outputcnt")
                Item.OutputCntText = Rs("outputcnt")
            End If

            Item.Key = "oee"

        End If
        Rs.Close

        SQLStr = "SELECT	AVG(v.oeevalue) As oeevalue, SUM(v.outputcnt) As outputcnt " & _
                            "FROM vwTierDeliveryPack v " & _
                            "WHERE CONVERT(date,v.dateid) BETWEEN DATEADD(year,-1,CONVERT(date,'" & DateID & "')) AND CONVERT(date,'" & DateID & "') " & _
                            "AND v.streamtype = '" & StreamType & "' " & _
                            "AND v.area = '" & Area & "'"

        Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            If Not IsNull(Rs("oeevalue")) Then
                Item.OEEValueAvg = Rs("oeevalue")
                Item.OEEValueAvgText = Rs("oeevalue") & " %"  
            End If
        End If
        Rs.Close


        Set Rs = Nothing

        Set OEEActual = Item


    End Function


    Public Function EscaList (ByVal DateID)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

    End Function


    Public Function OpenExcel (ByVal FPath, ByVal Tabelle)

        Dim objConn
        Set objConn = Server.CreateObject("ADODB.Connection")
        objConn.Provider = "Microsoft.ACE.OLEDB.12.0"
        objConn.ConnectionString = "Data Source=" & FPath & ";Extended Properties=""Excel 12.0;HDR=Yes;IMEX=1;"""
        objConn.Open

        Dim oRs : Set oRs = Server.CreateObject("ADODB.Recordset")

        oRs.Open "SELECT * FROM `" & Tabelle & "$`",objConn

        Set OpenExcel = oRs

    End Function


End Class

%>