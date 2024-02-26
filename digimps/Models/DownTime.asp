<%

'
' This files defines the Status model
'
Class DownTime

    Private mDownTimeID
    Public PlantID
    Public DeviceID
    Public ComponentID
    Public FailureID
    Public StartTime
    Public EndTime
    Public Description
    Public UserID
    Public ProductionID
    Public ControlID
    Public MinutesDownTime


    Public Property Get DownTimeID
        DownTimeID = mDownTimeID
    End Property

    Public Property Let DownTimeID (Value)
      
        mDownTimeID = Value

        If mDownTimeID <> "" Then
           InitObject
        End If
    End Property

    Private Sub Class_Initialize()
          PlantID = -1
          DeviceID = -1
          ComponentID = -1
          FailureID = -1
          ProductionID = ""
          StartTime = ""
          EndTime  = ""
          Description = ""
          ControlID = ""
          MinutesDownTime = 1
    End Sub

    Private Sub Class_Terminate()
    End Sub


    Private Sub InitObject
          '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM downtime WHERE downtimeid='" & mDownTimeID & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
           PantID = IIf(Not IsNull(Rs("plantid")), Rs("plantid"), PlantID)
           DeviceID = IIf(Not IsNull(Rs("deviceid")), Rs("deviceid"), DeviceID)
           ComponentID = IIf(Not IsNull(Rs("componentid")), Rs("componentid"), ComponentID)
           FailureID = IIf(Not IsNull(Rs("failureid")), Rs("failureid"), FailureID)
           StartTime = IIf(Not IsNull(Rs("start_time")), Rs("start_time"), StartTime)
           EndTime = IIf(Not IsNull(Rs("end_time")), Rs("end_time"), StartTime)
           Description = IIf(Not IsNull(Rs("description")), Rs("description"), Description)
           ProductionID = IIf(Not IsNull(Rs("productionid")), Rs("productionid"), ProductionID)
           ControlID = IIf(Not IsNull(Rs("productionid")), Rs("productionid"), ControlID)
           MinutesDownTime = IIf(Not IsNull(Rs("start_time")) And Not IsNull(Rs("end_time")), DateDiff("n", StartTime, EndTime),MinutesDownTime)
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

            Cmd.CommandText = "DownTimeSave"
            Cmd.CommandType = adCmdStoredProc
            Set Cmd.ActiveConnection = DbOpenConnection()

            Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
            Cmd.Parameters.Append Parameter


            Set Parameter = Cmd.CreateParameter("@DowntimeID", adGUID, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DowntimeID


            Set Parameter = Cmd.CreateParameter("@DeviceID", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DeviceID

            Set Parameter = Cmd.CreateParameter("@ComponentID", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = ComponentID

            Set Parameter = Cmd.CreateParameter("@FailureID", adInteger, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = FailureID

            Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 4096)
            Cmd.Parameters.Append Parameter
            Parameter.Value = Description

            Set Parameter = Cmd.CreateParameter("@StartTime", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = StartTime

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

        Save = RetVal

    End Function

    Public Sub Delete

    End Sub

End Class



%>