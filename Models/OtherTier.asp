<%
Class OtherTier

    Private mOID

    Public Property Let OID(Value)
        mOID = Value
        If mOID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get OID
        OID = mOID
    End Property

    Public DateID
    Public NewID
    Public Active
    Public DepartmentID
    Public Department
    Public OCatID
    Public OCatName
    Public OTxt
    Public OStart
    Public OClosed
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mOID = ""
        NewID = ""
        DateID = ""
        Active = 1
        DepartmentID = 0
        Department = ""
        OCatID = 0
        OCatName = ""
        OTxt = ""
        OStart = ""
        OClosed = ""
        UserID = Session("login")
        LastEdit = ""
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierOther WHERE oid='" & mOID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            OCatID = iRs("ocatid")
            OCatName = iRs("ocatname")
            OTxt = iRs("odescription")
            OStart = iRs("ostart")
            OClosed = iRs("oclosed")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "TierOtherUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mOID = "" Then
            Set Parameter = Cmd.CreateParameter("@OID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@OID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mOID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@OCatID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OCatID

        Set Parameter = Cmd.CreateParameter("@ODescription", adVarWChar, adParamInput, 512)
        Cmd.Parameters.Append Parameter
        Parameter.Value = OTxt


        If OStart <> "" Then
            Set Parameter = Cmd.CreateParameter("@OStart", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(OStart)
        Else
            Set Parameter = Cmd.CreateParameter("@OStart", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        If OClosed <> "" Then
            Set Parameter = Cmd.CreateParameter("@OClosed", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(OClosed)
        Else
            Set Parameter = Cmd.CreateParameter("@OClosed", adDate, adParamInput,,Null)
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

    Public Function Delete()

        Dim SQLStr : SQLStr = "DELETE FROM tier_other WHERE oid='" & mOID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class OListItem

    Public CatID
    Public Cat
    Public ItemList

    Private Sub Class_Initialize()
        Set ItemList = Server.CreateObject("Scripting.Dictionary")
    End Sub

End Class


Class OHelper

    Public Function OList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierOther ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New OtherTier
            Item.OID = Rs("oid")
            List.Add Item.OID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  OList =  List

    End Function

    Public Function OListByCatID (ByVal DateID, ByVal CatID)

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierOther WHERE (CONVERT(date,dateid)=CONVERT(date,'" & DateID & "') OR CONVERT(date,oclosed)=CONVERT(date,'" & DateID & "') OR oclosed IS NULL) AND ocatid=" & CatID & " ORDER BY dateid desc"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New OtherTier
            Item.OID = Rs("oid")
            List.Add Item.OID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  OListByCatID =  List

    End Function


    Public Function CatList()

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM tier_other_cat ORDER BY ocatname"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("ocatid")
            Item.Name = Rs("ocatname")
            Item.Active = Rs("active")
            List.Add Item.Value, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  CatList =  List

    End Function

End Class


%>