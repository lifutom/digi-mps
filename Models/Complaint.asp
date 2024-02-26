 <%
Class Complaint

    Private mCID

    Public Property Let CID(Value)
        mCID = Value
        If mCID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get CID
        CID = mCID
    End Property

    Public DateID
    Public NewID
    Public Active
    Public CNb
    Public CNumber
    Public CProduct
    Public CTxt
    Public CCountry
    Public CReason
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mCID = ""
        NewID = ""
        DateID = ""
        Active = 1
        CNb = 0
        CNumber = ""
        CProduct = ""
        CTxt = ""
        CCountry = ""
        CReason = ""
        UserID = Session("login")
        LastEdit = ""
        Set oStream = New StreamType
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierComplaint WHERE cid='" & mCID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            CNb = iRs("cnb")
            CNumber = iRs("cnumber")
            CProduct = iRs("cproduct")
            CTxt = iRs("cdescription")
            CCountry = iRs("ccountry")
            CReason = iRs("creason")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ComplaintUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mCID = "" Then
            Set Parameter = Cmd.CreateParameter("@CID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@CID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mCID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@CNb", adVarWChar, adParamInput, 15)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UCase(CNb)

        Set Parameter = Cmd.CreateParameter("@CNumber", adVarWChar, adParamInput, 20)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UCase(CNumber)

        Set Parameter = Cmd.CreateParameter("@CProduct", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CProduct

        Set Parameter = Cmd.CreateParameter("@CDescription", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CTxt

        Set Parameter = Cmd.CreateParameter("@CCountry", adVarWChar, adParamInput, 5)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UCase(CCountry)

        Set Parameter = Cmd.CreateParameter("@CReason", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CReason

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID


        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            mCID = Cmd.Parameters("@CID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function


    Public Function Delete()

        Dim SQLStr : SQLStr = "DELETE FROM tier_complaint WHERE cid='" & mCID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class CHelper

    Public Function CList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierComplaint ORDER BY cnb"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Complaint
            Item.CID = Rs("cid")
            List.Add Item.CID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  CList =  List

    End Function

End Class


%>