<%
Class OtherTierNote

    Private mOnID

    Public Property Let OnID(Value)
        mOnID = Value
        If mOnID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get OnID
        OnID = mOnID
    End Property

    Public DateID
    Public NewID
    Public Active
    Public DepartmentID
    Public Department
    Public OnCatID
    Public OnCatName
    Public OnTxt
    Public OnStart
    Public OnClosed
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        mOnID = ""
        NewID = ""
        DateID = ""
        Active = 1
        DepartmentID = 0
        Department = ""
        OnCatID = 0
        OnCatName = ""
        OnTxt = ""
        OnStart = ""
        OnClosed = ""
        UserID = Session("login")
        LastEdit = ""
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierOtherNote WHERE onid='" & mOnID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            OnTxt = iRs("ondescription")
            OnStart = iRs("onstart")
            OnClosed = iRs("onclosed")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "TierOtherNoteUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mOnID = "" Then
            Set Parameter = Cmd.CreateParameter("@OnID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@OnID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mOnID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@OnDescription", adVarWChar, adParamInput, 512)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OnTxt


        If OnStart <> "" Then
            Set Parameter = Cmd.CreateParameter("@OnStart", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(OnStart)
        Else
            Set Parameter = Cmd.CreateParameter("@OnStart", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        If OnClosed <> "" Then
            Set Parameter = Cmd.CreateParameter("@OnClosed", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(OnClosed)
        Else
            Set Parameter = Cmd.CreateParameter("@OnClosed", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID


        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
            mOnID = Cmd.Parameters("@OnID").Value
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Delete()

        Dim SQLStr : SQLStr = "DELETE FROM tier_othernote WHERE onid='" & mOnID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class ONHelper

    Public Function ONList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierOtherNote ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New OtherTierNote
            Item.OnID = Rs("onid")
            List.Add Item.OnID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  ONList =  List

    End Function


    Public Function ONListByDate (ByVal DateID)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierOtherNote WHERE (CONVERT(date,dateid)=CONVERT(date,'" & DateID & "') OR CONVERT(date,onclosed)=CONVERT(date,'" & DateID & "') OR onclosed IS NULL) ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New OtherTierNote
            Item.OnID = Rs("onid")
            List.Add Item.OnID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  ONListByDate =  List

    End Function

End Class


%>