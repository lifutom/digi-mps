<%
Class ProductionSearch

    Private prvStart
    Private prvEnd
    Private prvPlantID
    Private prvDeviceID
    Private prvUIN
    Private prvBatch


    Public Property Get Batch
        Batch  = prvBatch
    End Property

    Public Property Let Batch(Value)
        prvBatch = Value
        BuildSQLStr
    End Property

    Public Property Get UIN
        UIN = prvUIN
    End Property

    Public Property Let UIN(Value)
        prvUIN = Value
        BuildSQLStr
    End Property


    Public Property Get StartDate
        StartDate = prvStart
    End Property

    Public Property Let StartDate(Value)
        prvStart = Value
        BuildSQLStr
    End Property

    Public Property Get EndDate
        EndDate = prvEnd
    End Property

    Public Property Let EndDate(Value)
        prvEnd = Value
        BuildSQLStr
    End Property

    Public Property Get PlantID
        PlantID = prvPlantID
    End Property

    Public Property Let PlantID(Value)
        prvPlantID = CInt(Value)
        BuildSQLStr
    End Property

    Public Property Get DeviceID
        DeviceID = prvDeviceID
    End Property

    Public Property Let DeviceID(Value)
        prvDeviceID = CInt(Value)
        BuildSQLStr
    End Property

    Public SQLStr

    Private Sub Class_Initialize()
        prvStart = ""
        prvEnd = ""
        prvPlantID = -1
        prvDeviceID = -1
        BuildSQLStr
    End Sub


    Private Sub BuildSQLStr

        Dim hSQLStr
        Dim hStart : hStart = DBFormatDate(prvStart)
        Dim hEnd : hEnd = DBFormatDate(prvEnd)

        hSQLStr = "SELECT p.*, (SELECT COUNT(*) FROM downtime WHERE productionid=p.productionid) As downtimes, t.plant " & _
                    "FROM production p " & _
                    "JOIN plant t ON p.plantid=t.plantID " & _
                    "WHERE 1=1"
        If prvStart <> "" Or prvEnd <> "" Then
            If prvStart <> "" And prvEnd <> "" Then
               hSQLStr = hSQLStr & " AND CONVERT(date,start_time) BETWEEN '" & hStart & "' AND '" & hEnd & "'"
            Else
               If  prvStart <> "" Then
                   hSQLStr = hSQLStr & " AND CONVERT(date,start_time) = '" & hStart & "'"
               Else
                   hSQLStr = hSQLStr & " AND CONVERT(date,start_time) = '" & hEnd & "'"
               End If
            End If
        End If
        If prvPlantID <> -1 Then
            hSQLStr = hSQLStr & " AND p.plantid = " & prvPlantID
        End If

        If prvUIN <> "" Then
            hSQLStr = hSQLStr & " AND UPPER(uin_number) LIKE '%" & UCase(prvUIN) & "%'"
        End If

        If prvBatch <> "" Then
            hSQLStr = hSQLStr & " AND UPPER(batch_number) LIKE '%" & UCase(prvBatch) & "%'"
        End If


        hSQLStr = hSQLStr & " ORDER BY p.start_time DESC"

        SQLStr = hSQLStr

    End Sub


End Class


'
' This files defines the Status model
'
Class MyProduction

    Public ProductionID
    Public PlantID
    Public ControlID
    Public UinNb
    Public BatchNb
    Public Counter
    Public CounterBad
    Public StartTime
    Public EndTime
    Public UserID
    Public Description
    Public Plant
    Public Status
    Public DowntimeCounter
    Public MinutesProdTime


    Private Sub Class_Initialize()

        mProductionID = ""
        PlantID = -1
        ControlID = ""
        UinNb = ""
        BatchNb = ""
        Counter = 0
        CounterBad = 0
        StartTime = ""
        EndTime = ""
        UserID = ""
        Description = ""
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Default Sub InitObject(ByVal hProductionID)

        '1.Fill Plant Fields'
        ProductionID = hProductionID
        mProduction = hProductionID
        Dim SQLStr : SQLStr = "SELECT p.*, t.plant FROM production p JOIN plant t ON p.plantid=t.plantid WHERE p.productionid='" & hProductionID & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            PlantID = Rs("plantid")
            ControlID = Rs("controlid")
            UinNb = Rs("uin_number")
            BatchNb = Rs("batch_number")
            Counter = Rs("counter")
            CounterBad =  Rs("counterbad")
            StartTime = IIf(Not IsNull(Rs("start_time")),Rs("start_time"),"")
            EndTime = IIf(Not IsNull(Rs("end_time")),Rs("end_time"),"")
            UserID = Rs("userid")
            Description = Rs("description")
            MinutesProdTime = IIf(IsNull(Rs("end_time")), DateDiff("n",Rs("start_time"),Now), DateDiff("n",Rs("start_time"),Rs("end_time")))
            Status = IIf(IsNull(Rs("end_time")),"Running","Beendet")
            Plant = Rs("plant")
        End If
        DbCloseConnection

    End Sub

    Public Function Start

        Dim RetVal : RetVal = False

        If PlantID > 0 Then

            Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

            Cmd.CommandText = "ProductionStart"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()

            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@ProductionID", adGUID, adParamOutput)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@PlantID", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = PlantID

            Set Parameter = Cmd.CreateParameter("@StartTime", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = StartTime

            Set Parameter = Cmd.CreateParameter("@ControlID", adVarWChar, adParamInput, 50)
            Cmd.Parameters.Append Parameter
            Parameter.Value = ControlID

            Set Parameter = Cmd.CreateParameter("@UinNb", adVarWChar, adParamInput, 50)
            Cmd.Parameters.Append Parameter
            Parameter.Value = UinNb

            Set Parameter = Cmd.CreateParameter("@BatchNb", adVarWChar, adParamInput, 50)
            Cmd.Parameters.Append Parameter
            Parameter.Value =BatchNb

            Cmd.Execute

            If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
               mProductionID = Cmd.Parameters("@ProductionID").Value
               RetVal = True
            End If

            Set Cmd = Nothing
            Set Parameter = Nothing

            DbCloseConnection()
        End If

        Start = RetVal

    End Function


    Public Function PStop

        Dim RetVal : RetVal = False

        If ProductionID <> "" Then

            Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

            Cmd.CommandText = "ProductionStop"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()

            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@ProductionID", adGUID, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = ProductionID

            Set Parameter = Cmd.CreateParameter("@Counter", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = Counter

            Set Parameter = Cmd.CreateParameter("@EndTime", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = EndTime

            Set Parameter = Cmd.CreateParameter("@CounterBad", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = CounterBad

            Cmd.Execute

            If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
               RetVal = True
            End If

            Set Cmd = Nothing
            Set Parameter = Nothing

            DbCloseConnection()
        End If

        PStop = RetVal

    End Function

    Public Function Save

        Dim RetVal : RetVal = False

        If ProductionID <> "" Then

            Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

            Cmd.CommandText = "ProductionEdit"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()

            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@ProductionID", adGUID, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = ProductionID

            If StartTime <> "" Then
                Set Parameter = Cmd.CreateParameter("@StartTime", adDate, adParamInput)
                Parameter.Value = StartTime
            Else
               Set Parameter = Cmd.CreateParameter("@StartTime", adDate, adParamInput,,Null)
            End If
            Cmd.Parameters.Append Parameter


            If EndTime <> "" Then
                Set Parameter = Cmd.CreateParameter("@EndTime", adDate, adParamInput)
                Parameter.Value = EndTime
            Else
                Set Parameter = Cmd.CreateParameter("@EndTime", adDate, adParamInput,,Null)
            End If
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@Counter", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = Counter

            Set Parameter = Cmd.CreateParameter("@CounterBad", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = CounterBad

            Cmd.Execute

            If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
               RetVal = True
            End If

            Set Cmd = Nothing
            Set Parameter = Nothing

            DbCloseConnection()
        End If

        Save = RetVal

    End Function




End Class 'Production

Class ChartItem

    Public ID
    Public Name
    Public Min
    Public AvgMin
    Public Cnt
    Public AvgCnt

    Private Sub Class_Initialize()

        ID = ""
        Name = ""
        Min = 0.00
        AvgMin = 0.00
        Cnt = 0.00
        AvgCnt = 0.00

    End Sub

End Class


Class ProductionHelper


    Public Function Overview

        Dim ProductionList : Set ProductionList = Server.CreateObject("Scripting.Dictionary")

        ' get last/active production per plant'
        Dim SQLStr : SQLStr = "SELECT plantid FROM plant ORDER BY plant"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Rec
        Dim Item

        Do While Not Rs.Eof
	   SQLStr = "SELECT TOP 1 p.*, (SELECT COUNT(*) FROM downtime WHERE productionid=p.productionid) As downtimes, t.plant " & _
                    "FROM production p " & _
                    "JOIN plant t ON p.plantid=t.plantID " & _
                    "WHERE p.plantid=" & Rs("plantid") & " " & _
                    "ORDER BY p.start_time DESC"
           Set Rec = DbExecute(SQLStr)
           If Not Rec.Eof Then
                Set Item = New MyProduction
                Item.ProductionID = Rec("productionid")
                Item.ControlID = Rec("controlid")
                Item.PlantID = Rec("plantid")
                Item.UinNb = Rec("uin_number")
                Item.BatchNb = Rec("batch_number")
                Item.Counter = Rec("counter")
                Item.CounterBad = Rec("counterbad")
                Item.StartTime = Rec("start_time")
                Item.EndTime = Rec("end_time")
                Item.UserID = Rec("userid")
                Item.Description = Rec("description")
                Item.Plant = Rec("plant")
                Item.Status = IIf(IsNull(Item.EndTime),"Running","Beendet")
                Item.DowntimeCounter = Rec("downtimes")
                Item.MinutesProdTime = IIf(IsNull(Rec("end_time")), DateDiff("n",Rec("start_time"),Now), DateDiff("n",Rec("start_time"),Rec("end_time")))
                ProductionList.Add Item.PlantID, Item
           End If
           Rec.Close
           Rs.MoveNext
        Loop

        Set Rec = Nothing
        Set Overview = ProductionList

    End Function

    Public Function AllOverview (pSearch)

        Dim ProductionList : Set ProductionList = Server.CreateObject("Scripting.Dictionary")

        ' get last/active production per plant'
        Dim SQLStr : SQLStr = pSearch.SQLStr

        ''Response.Write SQLStr

        Dim Rec : Set Rec = DbExecute(SQLStr)
        Dim Item

        Do While Not Rec.Eof
            Set Item = New MyProduction
            Item.ProductionID = Rec("productionid")
            Item.ControlID = Rec("controlid")
            Item.PlantID = Rec("plantid")
            Item.UinNb = Rec("uin_number")
            Item.BatchNb = Rec("batch_number")
            Item.Counter = Rec("counter")
            Item.CounterBad = Rec("counterbad")
            Item.StartTime = Rec("start_time")
            Item.EndTime = Rec("end_time")
            Item.UserID = Rec("userid")
            Item.Description = Rec("description")
            Item.Plant = Rec("plant")
            Item.Status = IIf(IsNull(Item.EndTime),"Running","Beendet")
            Item.DowntimeCounter = Rec("downtimes")
            Item.MinutesProdTime = IIf(IsNull(Rec("end_time")), DateDiff("n",Rec("start_time"),Now), DateDiff("n",Rec("start_time"),Rec("end_time")))
            ProductionList.Add Item.ProductionID, Item
            Rec.MoveNext
        Loop
        Rec.Close
        Set Rec = Nothing
        Set AllOverview = ProductionList

    End Function


    Public Function EmptyOverview()

        Set EmptyOverview = Server.CreateObject("Scripting.Dictionary")

    End Function

    Public Function GetByID(ByVal ID)

        Set GetByID = New MyProduction
        GetByID.InitObject(ID)

    End Function


    Public Function ChartData (ByVal Listname, ByVal ID, ByVal Level, ByVal LevelID)

        Select Case Level
            Case 0:
               ChartData = DeviceChartData(ID, ListName)
            Case 1:
               ChartData = ComponentChartData(ID, ListName, LevelID)
            Case 2:

            Case Else

                ChartData = DeviceChartData(ID, ListName)

        End Select

    End Function

    Private Function DeviceChartData (ByVal ProductionID, ByVal ListName)

        Dim oProd : Set oProd = GetByID(ProductionID)

        Dim SQLDevice : SQLDevice = "SELECT * FROM plant_device WHERE plantid=" & oProd.PlantID & " ORDER BY device"

        Dim SQLAvg : SQLAvg = "SELECT c.*,ROUND(CONVERT(float,c.dtcnt)/c.ProdCnt,2) As avgcnt,ROUND(CONVERT(float,c.dtmin)/c.ProdCnt,2) As avgmin,pd.device,p.plant " & _
                                "FROM vwDeviceData c " & _
                                "JOIN plant_device pd ON c.deviceid=pd.deviceid " & _
                                "JOIN plant p ON c.plantid=p.plantID " & _
                                "WHERE c.plantid=" & oProd.PlantID

        Dim SQLProd : SQLProd = "SELECT c.*,pd.device,p.plant " & _
                                "FROM vwProdDeviceData c " & _
                                "JOIN plant_device pd ON c.deviceid=pd.deviceid " & _
                                "JOIN plant p ON pd.plantid=p.plantID " & _
                                "WHERE productionid='" & ProductionID & "'"

        Dim RsAvg : Set RsAvg = DbExecute(SQLAvg)
        Dim RsProd : Set RsProd = DbExecute(SQLProd)
        Dim RsDev : Set RsDev = DbExecute(SQLDevice)

        Dim Item
        Dim DeviceList : Set DeviceList = Server.CreateObject("Scripting.Dictionary")
        Do While Not RsDev.Eof
           Set Item = New ChartItem
           Item.ID = RsDev("deviceid")
           Item.Name = RsDev("device")

           DeviceList.Add Item.ID, Item
           RsDev.MoveNext
        Loop

        Dim hVal

        Do While Not RsAvg.Eof
            hVal = RsAvg("deviceid")
            If DeviceList.Exists(hVal) Then
                Set Item = DeviceList.Item(hVal)
                Item.AvgMin = RsAvg("avgmin")
                Item.AvgCnt = RsAvg("avgcnt")
            End If

            RsAvg.MoveNext
        Loop

        Do While Not RsProd.Eof
            hVal = RsProd("deviceid")
            If DeviceList.Exists(hVal) Then
                Set Item = DeviceList.Item(hVal)
                Item.Min = RsProd("dtmin")
                Item.Cnt = RsProd("dtcnt")
            End If
            RsProd.MoveNext
        Loop

        RsDev.Close
        RsAvg.Close
        RsProd.Close
        Set RsDev = Nothing
        Set RsAvg = Nothing
        Set RsProd = Nothing

        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        With oJSON.Data
            .Add "labels", oJSON.Collection()
            With .Item("labels")
                For Each Item In DeviceList.Items
                    .Add idx,Item.Name
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            idx=1
            With .Item("datasets")
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Jahresdurchschnitt"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,IIf(ListName="devicechartcnt",DBFormatNumber(Item.AvgCnt),DBFormatNumber(Item.AvgMin))
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 99, 132, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 99, 132,1)"
                            idx1=idx1+1
                        Next
                    End With
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Produktion"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,IIf(ListName="devicechartcnt",Item.Cnt,Item.Min)
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 206, 86, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 206, 86, 1)"
                            idx1=idx1+1
                        Next
                    End With
                End With
            End With
        End With

        DeviceChartData = oJSON.JSONoutput()


    End Function


    Public Function ComponentChartData (ByVal ProductionID, ByVal ListName, ByVal DeviceID)

        Dim oProd : Set oProd = GetByID(ProductionID)

        Dim SQLDevice : SQLDevice = "SELECT * FROM device_component WHERE deviceid=" & DeviceID & " ORDER BY component"

        Dim SQLAvg : SQLAvg = "SELECT c.*,ROUND(CONVERT(float,c.dtcnt)/c.ProdCnt,2) As avgcnt,ROUND(CONVERT(float,c.dtmin)/c.ProdCnt,2) As avgmin,pd.device,p.plant,dc.component " & _
                                "FROM vwComponentData c " & _
                                "JOIN device_component dc ON c.componentid=dc.componentid " & _
                                "JOIN plant_device pd ON c.deviceid=pd.deviceid " & _
                                "JOIN plant p ON c.plantid=p.plantID " & _
                                "WHERE c.deviceid=" & DeviceID

        Dim SQLProd : SQLProd = "SELECT c.*,pd.device,p.plant, dc.component " & _
                                "FROM vwProdComponentData c " & _
                                "JOIN device_component dc ON c.componentid=dc.componentid " & _
                                "JOIN plant_device pd ON c.deviceid=pd.deviceid " & _
                                "JOIN plant p ON pd.plantid=p.plantID " & _
                                "WHERE productionid='" & ProductionID & "'"

        Dim RsAvg : Set RsAvg = DbExecute(SQLAvg)
        Dim RsProd : Set RsProd = DbExecute(SQLProd)
        Dim RsDev : Set RsDev = DbExecute(SQLDevice)

        Dim Item
        Dim DeviceList : Set DeviceList = Server.CreateObject("Scripting.Dictionary")
        Do While Not RsDev.Eof
           Set Item = New ChartItem
           Item.ID = RsDev("componentid")
           Item.Name = RsDev("component")

           DeviceList.Add Item.ID, Item
           RsDev.MoveNext
        Loop

        Dim hVal

        Do While Not RsAvg.Eof
            hVal = RsAvg("componentid")
            If DeviceList.Exists(hVal) Then
                Set Item = DeviceList.Item(hVal)
                Item.AvgMin = RsAvg("avgmin")
                Item.AvgCnt = RsAvg("avgcnt")
            End If

            RsAvg.MoveNext
        Loop

        Do While Not RsProd.Eof
            hVal = RsProd("componentid")
            If DeviceList.Exists(hVal) Then
                Set Item = DeviceList.Item(hVal)
                Item.Min = RsProd("dtmin")
                Item.Cnt = RsProd("dtcnt")
            End If
            RsProd.MoveNext
        Loop

        RsDev.Close
        RsAvg.Close
        RsProd.Close
        Set RsDev = Nothing
        Set RsAvg = Nothing
        Set RsProd = Nothing

        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 1
        Dim idx1 : idx1 = 1

        With oJSON.Data
            .Add "labels", oJSON.Collection()
            With .Item("labels")
                For Each Item In DeviceList.Items
                    .Add idx,Item.Name
                    idx=idx+1
                Next
            End With
            .Add "datasets", oJSON.Collection()
            idx=1
            With .Item("datasets")
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Jahresdurchschnitt"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,IIf(ListName="devicechartcnt",DBFormatNumber(Item.AvgCnt),DBFormatNumber(Item.AvgMin))
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 99, 132, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 99, 132,1)"
                            idx1=idx1+1
                        Next
                    End With
                End With
                idx=idx+1
                .Add idx,oJSON.Collection()
                With .Item(idx)
                    .Add "label","Produktion"
                    .Add "data",oJSON.Collection()
                    With .Item("data")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,IIf(ListName="devicechartcnt",Item.Cnt,Item.Min)
                            idx1=idx1+1
                        Next
                    End With
                    .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 206, 86, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 206, 86, 1)"
                            idx1=idx1+1
                        Next
                    End With
                End With
            End With
        End With

        ComponentChartData = oJSON.JSONoutput()


    End Function

    '--------------------------------------------------------'
    'Tierboard'
    '--------------------------------------------------------'

    Public Function TierOverview

        Dim ProductionList : Set ProductionList = Server.CreateObject("Scripting.Dictionary")

        ' get last/active production per plant'
        ''Dim SQLStr : SQLStr = "SELECT p.*, (SELECT COUNT(*) FROM downtime WHERE productionid=p.productionid) As downtimes, t.plant " & _
        ''            "FROM p p " & _
        ''            "JOIN plant t ON p.plantid=t.plantID " & _
        ''            "ORDER BY t.plant, p.start_time DESC"
        Dim SQLStr : SQLStr = "SELECT * FROM plant WHERE active=1 AND area='pack' ORDER by plant"

        Dim Rec : Set Rec = DbExecute(SQLStr)
        Dim Item

        Do While Not Rec.Eof
            Set Item = New MyProduction
            Item.PlantID = Rec("plantid")
            Item.Plant = Rec("plant")
            ProductionList.Add Item.PlantID, Item
            Rec.MoveNext
        Loop
        Rec.Close

        For Each Item In ProductionList.Items
            SQLStr = "SELECT TOP 1 *, (SELECT COUNT(*) FROM downtime WHERE productionid=production.productionid) As downtimes FROM production WHERE plantid=" & Item.PlantID & " ORDER BY start_time DESC"
            Set Rec = DbExecute(SQLStr)
            If Not Rec.Eof Then
                Item.ProductionID = Rec("productionid")
                Item.ControlID = Rec("controlid")
                Item.PlantID = Rec("plantid")
                Item.UinNb = Rec("uin_number")
                Item.BatchNb = Rec("batch_number")
                Item.Counter = Rec("counter")
                Item.CounterBad = Rec("counterbad")
                Item.StartTime = Rec("start_time")
                Item.EndTime = Rec("end_time")
                Item.UserID = Rec("userid")
                Item.Description = Rec("description")
                Item.Status = IIf(IsNull(Item.EndTime),"Running","Beendet")
                Item.DowntimeCounter = Rec("downtimes")
                Item.MinutesProdTime = IIf(IsNull(Rec("end_time")), DateDiff("n",Rec("start_time"),Now), DateDiff("n",Rec("start_time"),Rec("end_time")))
            End If
            Rec.Close
        Next

        Set Rec = Nothing
        Set TierOverview = ProductionList

    End Function

End Class

%>
