<%

Class DowntimeSearch

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

        hSQLStr = "SELECT * FROM vwDowntime WHERE 1=1"
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
            hSQLStr = hSQLStr & " AND plantid = " & prvPlantID
        End If
        If prvDeviceID <> -1 Then
            hSQLStr = hSQLStr & " AND deviceid = " & prvDeviceID
        End If

        If prvUIN <> "" Then
            hSQLStr = hSQLStr & " AND UPPER(uin_number) LIKE '%" & UCase(prvUIN) & "%'"
        End If

        If prvBatch <> "" Then
            hSQLStr = hSQLStr & " AND UPPER(batch_number) LIKE '%" & UCase(prvBatch) & "%'"
        End If


        hSQLStr = hSQLStr & " ORDER BY start_time DESC"

        SQLStr = hSQLStr

    End Sub


End Class


'
' This files defines the Status model
'
Class MyDownTime

    Private mDownTimeID

    Public Property Let DownTimeID (Value)
        mDownTimeID = Value
        If mDownTimeID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get DownTimeID
        DownTimeID = mDownTimeID
    End Property

    Public Property Let NoInit_DownTimeID (Value)
        mDownTimeID = Value
    End Property

    Public Property Get NoInit_DownTimeID
        NoInit_DownTimeID = mDownTimeID
    End Property


    Public PlantID
    Public PLant
    Public DeviceID
    Public Device
    Public ComponentID
    Public Component
    Public FailureID
    Public Failure
    Public StartTime
    Public EndTime
    Public Description
    Public UserID
    Public ProductionID
    Public ControlID
    Public MinutesDownTime
    Public Status
    Public BatchNb
    Public UINb

    Private Sub Class_Initialize()
        EmptyValue
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Private Sub EmptyValue

        mDownTimeID = ""
        PlantID = -1
        Plant = ""
        DeviceID = -1
        Device = ""
        ComponentID = -1
        Component = ""
        FailureID = -1
        Failure = ""
        ProductionID = ""
        StartTime = ""
        EndTime  = ""
        Description = ""
        ControlID = ""
        MinutesDownTime = 1
        Status = ""
        BatchNb = ""
        UINb = ""

    End Sub


    Private Sub InitObject
          '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM vwDowntime WHERE downtimeid='" & mDownTimeID & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
           PlantID = IIf(Not IsNull(Rs("plantid")), Rs("plantid"), PlantID)
           Plant = IIf(Not IsNull(Rs("plant")), Rs("plant"), Plant)
           DeviceID = IIf(Not IsNull(Rs("deviceid")), Rs("deviceid"), DeviceID)
           Device = IIf(Not IsNull(Rs("device")), Rs("device"), Device)
           ComponentID = IIf(Not IsNull(Rs("componentid")), Rs("componentid"), ComponentID)
           Component = IIf(Not IsNull(Rs("component")), Rs("component"), Component)
           FailureID = IIf(Not IsNull(Rs("failureid")), Rs("failureid"), FailureID)
           Failure = IIf(Not IsNull(Rs("failure")), Rs("failure"), Failure)
           StartTime = IIf(Not IsNull(Rs("start_time")), Rs("start_time"), StartTime)
           EndTime = IIf(Not IsNull(Rs("end_time")), Rs("end_time"), EndTime)
           Description = IIf(Not IsNull(Rs("dtdescription")), Rs("dtdescription"), Description)
           ProductionID = IIf(Not IsNull(Rs("productionid")), Rs("productionid"), ProductionID)
           ControlID = IIf(Not IsNull(Rs("productionid")), Rs("productionid"), ControlID)
           MinutesDownTime = IIf(Not IsNull(Rs("start_time")) And Not IsNull(Rs("end_time")), DateDiff("n", Rs("start_time"), Rs("end_time")),MinutesDownTime)
           BatchNb = IIf(Not IsNull(Rs("batch_number")), Rs("batch_number"), BatchNb)
           UINb = IIf(Not IsNull(Rs("uin_number")), Rs("uin_number"), UINb)
           Status = IIf(IsNull(Rs("end_time")), "Running", "Beendet")
        End If
        DbCloseConnection

    End Sub


    Public Function StopDownTime ()

        Dim retVal : retVal = False

        If mDownTimeID <> "" Then
            Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

            Cmd.CommandText = "StopDownTime"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()

            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@DowntimeID", adGUID, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = mDownTimeID

            Set Parameter = Cmd.CreateParameter("@EndTime", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = EndTime

            Cmd.Execute

            If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
               RetVal = True
            End If

            Set Cmd = Nothing
            Set Parameter = Nothing

            DbCloseConnection()

        End If

        StopDownTime = retVal

    End Function

    Public Function Add

        Dim RetVal : RetVal = False

        If PlantID > 0 Then

            Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

            Cmd.CommandText = "DowntimeAdd"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()

            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@DowntimeID", adGUID, adParamOutput)
            Cmd.Parameters.Append Parameter

            Set Parameter = Cmd.CreateParameter("@ProductionID", adGUID, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = ProductionID

            Set Parameter = Cmd.CreateParameter("@PlantID", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = PlantID

            Set Parameter = Cmd.CreateParameter("@StartTime", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = StartTime

            Set Parameter = Cmd.CreateParameter("@ControlID", adVarWChar, adParamInput, 50)
            Cmd.Parameters.Append Parameter
            Parameter.Value = ControlID

            Cmd.Execute

            If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
               mDownTimeID = Cmd.Parameters("@DowntimeID").Value
               RetVal = True
            End If

            Set Cmd = Nothing
            Set Parameter = Nothing

            DbCloseConnection()
        End If

        Add = RetVal

    End Function

    Public Function Save

        Dim RetVal : RetVal = False

        If DowntimeID <> "" Then

            Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

            ''Response.Write  "DownTimeEdit '" & DowntimeID & "','" & StartTime & "','" & EndTime & "'," & FailureID & "<br>"

            Cmd.CommandText = "DownTimeEdit"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()

            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter


            Set Parameter = Cmd.CreateParameter("@DowntimeID", adGUID, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DowntimeID

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

            Set Parameter = Cmd.CreateParameter("@FailureID", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = FailureID

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

    Public Sub Delete
        EmptyValue
    End Sub

    Public Function DBDelete
        Dim SQLStr : SQLStr = "DELETE FROM downtime WHERE downtimeid='" & mDownTimeID & "'"
        DbExecute(SQLStr)
        DBDelete = True
    End Function

End Class


Class DowntimeHelper

    Public Function ListByProductionID (ByVal ProductionID)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        If ProductionID = "" Then
           Set ListByProductionID = List
           Exit Function
        End If

        ' get last/active production per plant'
        Dim SQLStr :  SQLStr = "SELECT * " & _
                    "FROM vwDowntime " & _
                    "WHERE productionid='" & ProductionID & "' " & _
                    "ORDER BY start_time DESC"


        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Rec
        Dim Item

        Do While Not Rs.Eof
            Set Item = New MyDownTime
            Item.NoInit_DownTimeID = Rs("downtimeid")
            Item.PlantID = Rs("plantid")
            Item.Plant  = Rs("plant")
            Item.DeviceID = Rs("deviceid")
            Item.Device = Rs("device")
            Item.ComponentID = Rs("componentid")
            Item.Component = Rs("component")
            Item.FailureID = Rs("failureid")
            Item.Failure = Rs("failure")
            Item.StartTime = Rs("start_time")
            Item.EndTime = Rs("end_time")
            ''Item.Description = Rs("description")
            Item.UserID = Rs("userid")
            Item.ProductionID = Rs("productionid")
            Item.ControlID = Rs("controlid")
            Item.MinutesDownTime = IIf(IsNull(Rs("end_time")), DateDiff("n",Rs("start_time"),Now), DateDiff("n",Rs("start_time"),Rs("end_time")))
            Item.Status = IIf(IsNull(Rs("end_time")), "Running", "Beendet")
            Item.BatchNb = IIf(Not IsNull(Rs("batch_number")), Rs("batch_number"), BatchNb)
            Item.UINb = IIf(Not IsNull(Rs("uin_number")), Rs("uin_number"), UINb)
            List.Add CStr(Item.DownTimeID), Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

        Set ListByProductionID = List

    End Function

    Public Function EmptyOverview ()

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        Set EmptyOverview = List

    End Function

    Public Function AllOverview (ByVal pSearch)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")

        ' get last/active production per plant'
        Dim SQLStr :  SQLStr = pSearch.SQLStr

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Rec
        Dim Item

        Do While Not Rs.Eof
            Set Item = New MyDowntime
            Item.NoInit_DownTimeID = Rs("downtimeid")
            Item.PlantID = Rs("plantid")
            Item.Plant  = Rs("plant")     
            Item.DeviceID = Rs("deviceid")
            Item.Device = Rs("device")
            Item.ComponentID = Rs("componentid")
            Item.Component = Rs("component")
            Item.FailureID = Rs("failureid")
            Item.Failure = Rs("failure")
            Item.StartTime = Rs("start_time")
            Item.EndTime = Rs("end_time")
            Item.Description = Rs("dtdescription")
            Item.UserID = Rs("userid")
            Item.ProductionID = Rs("productionid")
            Item.ControlID = Rs("controlid")
            Item.MinutesDownTime = IIf(IsNull(Rs("end_time")), DateDiff("n",Rs("start_time"),Now), DateDiff("n",Rs("start_time"),Rs("end_time")))
            Item.Status = IIf(IsNull(Rs("end_time")), "Running", "Beendet")
            Item.BatchNb = IIf(Not IsNull(Rs("batch_number")), Rs("batch_number"), BatchNb)
            Item.UINb = IIf(Not IsNull(Rs("uin_number")), Rs("uin_number"), UINb)
            List.Add CStr(Item.DownTimeID), Item
            Rs.MoveNext
        Loop

        Rs.Close
        Set Rs = Nothing

        Set AllOverview = List

    End Function



End Class



%>