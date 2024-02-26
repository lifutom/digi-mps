<%
Class QualityEsca

    Private mEscaID

    Public Property Let EscaID(Value)
        mEscaID = Value
        If mEscaID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get EscaID
        EscaID = mEscaID
    End Property

    Public DateID
    Public NewID
    Public Active
    Public EscaTxt
    Public EscaTask
    Public EscaStart
    Public EscaClosed
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mEscaID = ""
        NewID = ""
        DateID = ""
        Active = 1
        EscaTxt = ""
        EscaTask = ""
        EscaStart = ""
        EscaClosed = ""
        UserID = Session("login")
        LastEdit = ""
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierQualityEsca WHERE escaid='" & mEscaID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            EscaTxt = iRs("escadescription")
            EscaTask = iRs("escatask")
            EscaStart = iRs("escastart")
            EscaClosed = iRs("escaclosed")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "QualityEscaUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mEscaID = "" Then
            Set Parameter = Cmd.CreateParameter("@EscaID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@EscaID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value =mEscaID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID


        Set Parameter = Cmd.CreateParameter("@EscaDescription", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = EscaTxt

        Set Parameter = Cmd.CreateParameter("@EscaTask", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = EscaTask

        If EscaStart <> "" Then
            Set Parameter = Cmd.CreateParameter("@EscaStart", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(EscaStart)
        Else
            Set Parameter = Cmd.CreateParameter("@EscaStart", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        If EscaClosed <> "" Then
            Set Parameter = Cmd.CreateParameter("@EscaClosed", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(EscaClosed)
        Else
            Set Parameter = Cmd.CreateParameter("@EscaClosed", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID


        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            mEscaID = Cmd.Parameters("@EscaID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Delete()

        Dim SQLStr : SQLStr = "DELETE FROM tier_quality_esca WHERE escaid='" & mEscaID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class QualityEscaHelper

    Public Function EscaList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierQualityEsca ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New QualityEsca
            Item.EscaID = Rs("escaid")
            List.Add Item.EscaID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  EscaList =  List

    End Function

    Public Function OpenEscaList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierQualityEsca WHERE escaclosed IS NULL ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New QualityEsca
            Item.EscaID = Rs("escaid")
            List.Add Item.EscaID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  OpenEscaList =  List

    End Function

    Public Function EscaListByDate(DateID)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierQualityEsca WHERE CONVERT(date,escastart) = CONVERT(date,'" & DateID & "')"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New QualityEsca
            Item.EscaID = Rs("escaid")
            List.Add Item.EscaID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  EscaListByDate =  List

    End Function

End Class


%>