<%
Class Events

    Private mEventID

    Public Property Let EventID(Value)
        mEventID = Value
        If mEventID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get EventID
        EventID = mEventID
    End Property

    Public DateID
    Public NewID
    Public Active
    Public DepartmentID
    Public Department
    Public EventNb
    Public EventTxt
    Public EvStart
    Public EvClosed
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mEventID = ""
        NewID = ""
        DateID = ""
        Active = 1
        DepartmentID = 0
        Department = ""
        EventNb = ""
        EventTxt = ""
        EvStart = ""
        EvClosed = ""
        UserID = Session("login")
        LastEdit = ""
        Set oStream = New StreamType
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierEvents WHERE eventid='" & mEventID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            EventNb = iRs("eventnb")
            EventTxt = iRs("eventdescription")
            EvStart = iRs("eventstart")
            EvClosed = iRs("eventclosed")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "EventsUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mEventID = "" Then
            Set Parameter = Cmd.CreateParameter("@EventID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@EventID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value =mEventID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@EventNb", adVarWChar, adParamInput, 15)
        Cmd.Parameters.Append Parameter
        Parameter.Value = EventNb

        Set Parameter = Cmd.CreateParameter("@EventDescription", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = EventTxt


        If EvStart <> "" Then
            Set Parameter = Cmd.CreateParameter("@EventStart", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(EvStart)
        Else
            Set Parameter = Cmd.CreateParameter("@EventStart", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        If EvClosed <> "" Then
            Set Parameter = Cmd.CreateParameter("@EventClosed", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = EvClosed
        Else
            Set Parameter = Cmd.CreateParameter("@EventClosed", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

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

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierEvents WHERE dateid='" & DateID & "' AND departmentid=" & DepartmentID
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

        Dim SQLStr : SQLStr = "DELETE FROM tier_events WHERE eventid='" & mEventID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class EventsRaised

    Private mEventID

    Public Property Let EventID(Value)
        mEventID = Value
        If mEventID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get EventID
        EventID = mEventID
    End Property

    Public DateID
    Public NewID
    Public Active
    Public RaisedCnt
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mEventID = ""
        NewID = ""
        DateID = ""
        Active = 1
        RaisedCnt = 0
        UserID = Session("login")
        LastEdit = ""
        Set oStream = New StreamType
    End Sub


    Private Sub InitObject()
        Dim SQLStr : SQLStr = "SELECT * FROM tier3_events WHERE eventid='" & mEventID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            RaisedCnt = IIf(IsNull(iRs("raisedcnt")), 0, CInt(iRs("raisedcnt")))
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "EventsRaisedUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mEventID = "" Then
            Set Parameter = Cmd.CreateParameter("@EventID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@EventID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mEventID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@RaisedCnt", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = RaisedCnt


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

        Dim SQLStr : SQLStr = "SELECT * FROM tier3_events WHERE dateid='" & DateID & "'"
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

        Dim SQLStr : SQLStr = "DELETE FROM tier3_events WHERE eventid='" & mEventID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class EventsHelper

    Public Function EventsList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierEvents ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Events
            Item.EventID = Rs("eventid")
            List.Add Item.EventID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  EventsList =  List

    End Function

    Public Function Tier3EventsList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM tier3_events ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New EventsRaised
            Item.EventID = Rs("eventid")
            List.Add Item.EventID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  Tier3EventsList =  List

    End Function

End Class


%>