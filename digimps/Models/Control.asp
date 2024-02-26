<%
Class Control

    Private mControlID
    Public PlantID
    Public UserID
    Public Plant
    Public ProductionID
    Public UINNb
    Public BatchNb
    Public IsPRunning
    Public PrSeconds
    Public IsDTRunning
    Public DownTimeID
    Public DownTimeStartTime
    Public DTSeconds


    Public Property Get ControlID
        ControlID = mControlID
    End Property

    Public Property Let ControlID (Value)
        mControlID = Value
        If mControlID <> "" Then
           InitObject
        End If
    End Property

    Private Sub Class_Initialize()

        mControlID = ""
        UserID = ""
        PlantID = -1
        Plant = ""
        ProductionID = ""
        UinNb = ""
        BatchNb = ""
        IsPRunning = 0
        PrSeconds = 0
        DownTimeID = ""
        IsDTRunning = 0
        DTSeconds = 0
        DownTimeStartTime = ""

    End Sub

    Private Sub Class_Terminate()
    End Sub

    Private Sub InitObject

        Dim SQLStr : SQLStr = "SELECT * FROM plant_control WHERE controlid='" & mControlID & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
           PlantID = IIf(Not IsNull(Rs("plantid")),Rs("plantid"), PlantID)
           UserID = IIf(Not IsNull(Rs("userid")),Rs("userid"), UserID)
        Else
           PlantID = -1
           UserID = ""
        End If
        Rs.Close

        '(SELECT plantid FROM plant_control WHERE controlid='" & mControlID & "') " & _

        SQLStr = "SELECT TOP 1 p.*, l.plant " & _
             "FROM production p JOIN plant l ON p.plantid=l.plantid " & _
             "WHERE p.plantid IN (" & PlantID & ") " & _
             "ORDER BY p.start_time DESC"
        Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Plant = IIf(Not IsNull(Rs("plant")),Rs("plant"), Plant)
            ProductionID = IIf(Not IsNull(Rs("productionid")),Rs("productionid") , ProductionID)
            UinNb = IIf(Not IsNull(Rs("uin_number")),Rs("uin_number"), UINNb)
            BatchNb = IIf(Not IsNull(Rs("batch_number")),Rs("batch_number"), BatchNb)
            IsPRunning = IIf(Not IsNull(Rs("end_time")), 0, 1)
            PrSeconds = IIf(IsPRunning = 1,DateDiff("s",Rs("start_time"), Now) , 0)
        End If
        Rs.Close
        If IsPRunning = 1 Then
            ' only when production is running downtime possible'
            SQLStr = "SELECT TOP 1 d.* " & _
                    "FROM downtime d " & _
                    "WHERE d.plantid = " & PlantID & _
                    "AND d.controlid='" & mControlID & "'"  & _
                    "ORDER BY start_time DESC"
            Set Rs = DbExecute(SQLStr)
            If Not Rs.Eof Then
                DownTimeID = IIf(Not IsNull(Rs("downtimeid")),Rs("downtimeid"), DownTimeID)
                DownTimeStartTime = IIf(Not IsNull(Rs("start_time")),DBFormatISODate(CStr(Rs("start_time"))), DownTimeStartTime)
                IsDTRunning = IIf(Not IsNull(Rs("end_time")),0,1)
                DTSeconds = IIf(IsDTRunning = 1, DateDiff("s",Rs("start_time"), Now) , 0)
            End If
            Rs.Close

        End If

        Set Rs = Nothing

        DbCloseConnection


    End Sub

    Public Function SetControlID (ByVal PlantID)

        Dim hlpControlID : hlpControlID = ""

        Dim SQLStr : SQLStr = "SELECT TOP 1 * FROM plant_control WHERE linked_date IS NULL AND plantid=" & PlantID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
           hlpControlID = Rs("controlid")
           SQLStr = "UPDATE plant_control SET linked_date=GETDATE() WHERE ControlID='" & hlpControlID & "'"
           DbExecute(SQLStr)
        End If

        SetControlID = hlpControlID

    End Function

    Public Function ClearLink

        Dim SQLStr : SQLStr = "UPDATE plant_control SET linked_date = NULL WHERE controlid='" & mControlID & "'"
        DbExecute(SQLStr)
        ClearLink = True

    End Function

    Public Function SetLink

        Dim SQLStr : SQLStr = "UPDATE plant_control SET linked_date = GETDATE() WHERE controlid='" & mControlID & "'"
        DbExecute(SQLStr)
        SetLink = True

    End Function

End Class

%>
