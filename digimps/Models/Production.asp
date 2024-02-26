<%

'
' This files defines the Status model
'
Class Production

    Private mProductionID
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


    Public Property Get ProductionID
        ProductionID = mProductionID
    End Property

    Public Property Let ProductionID (Value)
        mProductionID = Value
        If mProductionID <> "" Then
           InitObject
        End If
    End Property

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

    Private Sub InitObject

        '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM production WHERE productionid='" & mProductionID & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            PlantID = Rs("plantid")
            ControlID = Rs("controlid")
            UinNb = Rs("uin_number")
            BatchNb = Rs("batch_number")
            Counter = Rs("counter")
            CounterBad = Rs("counterbad")
            StartTime = Rs("start_time")
            EndTime = Rs("end_time")
            UserID = Rs("userid")
            Description = Rs("description")

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


End Class 'Production

%>
