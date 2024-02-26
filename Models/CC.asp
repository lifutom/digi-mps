<%
Class CC

    Private mCCID

    Public Property Let CCID(Value)
        mCCID = Value
        If mCCID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get CCID
        CCID = mCCID
    End Property

    Public DateID
    Public NewID
    Public Active
    Public DepartmentID
    Public Department
    Public CCNb
    Public CCTxt
    Public CCStart
    Public CCClosed
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mCCID = ""
        NewID = ""
        DateID = ""
        Active = 1
        DepartmentID = 0
        Department = ""
        CCNb = ""
        CCTxt = ""
        CCStart = ""
        CCClosed = ""
        UserID = Session("login")
        LastEdit = ""
        Set oStream = New StreamType
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierCC WHERE ccid='" & mCCID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            CCNb = iRs("ccnb")
            CCTxt = oStream.Name(iRs("ccdescription"))
            CCStart = iRs("ccstart")
            CCClosed = iRs("ccclosed")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "CCUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mCCID = "" Then
            Set Parameter = Cmd.CreateParameter("@CCID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@CCID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mCCID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@CCNb", adVarWChar, adParamInput, 15)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CCNb

        Set Parameter = Cmd.CreateParameter("@CCDescription", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CCTxt


        If CCStart <> "" Then
            Set Parameter = Cmd.CreateParameter("@CCStart", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(CCStart)
        Else
            Set Parameter = Cmd.CreateParameter("@CCStart", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        If CCClosed <> "" Then
            Set Parameter = Cmd.CreateParameter("@CCClosed", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(CCClosed)
        Else
            Set Parameter = Cmd.CreateParameter("@CCClosed", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

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


    Public Function Exists(ByVal actDateID, ByVal actDepartmentID)

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierCC WHERE dateid='" & DateID & "' AND departmentid=" & DepartmentID
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

        Dim SQLStr : SQLStr = "DELETE FROM tier_cc WHERE ccid='" & mCCID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class CCHelper

    Public Function CCList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierCC ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New CC
            Item.CCID = Rs("ccid")
            List.Add Item.CCID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  CCList =  List

    End Function

End Class


%>