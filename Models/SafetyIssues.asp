<%
Class SafetyIssue

    Private mID

    Public Property Let ID(Value)
        mID = Value
        If mID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get ID
        ID = mID
    End Property

    Public DateID
    Public NewID
    Public TierLevel
    Public Active
    Public Description
    Public LongDescription
    Public Start
    Public Closed
    Public Closed3
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mID = ""
        NewID = ""
        DateID = ""
        TierLevel = ""
        Active = 1
        Description = ""
        LongDescription = ""
        Start = ""
        Closed = ""
        Closed3 = ""
        UserID = Session("login")
        LastEdit = ""
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierSafetyIssue WHERE id='" & mID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            Description = iRs("description")
            LongDescription = iRs("longdescription")
            TierLevel = iRs("tierlevel")
            Start = iRs("start")
            Closed = iRs("closed")
            Closed3 = iRs("closed3")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SafetyIssueUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mID = "" Then
            Set Parameter = Cmd.CreateParameter("@ID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@ID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value =mID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@TierLevel", adVarWChar, adParamInput, 15)
        Cmd.Parameters.Append Parameter
        Parameter.Value = TierLevel

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description


        If Start <> "" Then
            Set Parameter = Cmd.CreateParameter("@Start", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(Start)
        Else
            Set Parameter = Cmd.CreateParameter("@Start", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        If Closed <> "" Then
            Set Parameter = Cmd.CreateParameter("@Closed", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(Closed)
        Else
            Set Parameter = Cmd.CreateParameter("@Closed", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        If Closed3 <> "" Then
            Set Parameter = Cmd.CreateParameter("@Closed3", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(Closed3)
        Else
            Set Parameter = Cmd.CreateParameter("@Closed3", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        Set Parameter = Cmd.CreateParameter("@LongDescription", adVarWChar, adParamInput, 4000)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LongDescription

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID


        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            mID = Cmd.Parameters("@ID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Delete()

        Dim SQLStr : SQLStr = "DELETE FROM tier_safetyissue WHERE id='" & mID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class SafetyIssueHelper

    Public Function List (ByVal TierLevel)

        Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierSafetyIssue WHERE tierlevel='" & TierLevel & "' ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New SafetyIssue
            Item.ID = Rs("id")
            List.Add Item.ID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection

    End Function

    Public Function OpenList (ByVal TierLevel)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr

        If TierLevel = "tier2" Then
            SQLStr = "SELECT * FROM vwTierSafetyIssue WHERE (closed IS NULL OR CONVERT(date, closed) = CONVERT(date,GETDATE())) AND tierlevel='" & TierLevel & "' ORDER BY dateid desc"
        Else
            SQLStr = "WITH x " & _
                    "As ( " & _
                    "SELECT * " & _
                    "FROM vwTierSafetyIssue WHERE CONVERT(date, closed) = CONVERT(date,GETDATE()) AND tierlevel='tier2' " & _
                    "UNION " & _
                    "SELECT * FROM vwTierSafetyIssue WHERE (closed3 IS NULL OR CONVERT(date, closed3) = CONVERT(date,GETDATE())) AND tierlevel='tier3' " & _
                    ") " & _
                    "SELECT * FROM x " & _
                    "ORDER BY dateid desc"
        End If
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New SafetyIssue
            Item.ID = Rs("id")
            List.Add Item.ID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  OpenList =  List

    End Function

    Public Function ListByDate(ByVal DateID, ByVal TierLevel)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierSafetyIssue WHERE tierlevel='" & TierLevel & "' AND CONVERT(date,start) = CONVERT(date,'" & DateID & "')"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New SafetyIssue
            Item.ID = Rs("id")
            List.Add Item.ID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  ListByDate =  List

    End Function

End Class


%>