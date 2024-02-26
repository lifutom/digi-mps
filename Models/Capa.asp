<%
Class Capa

    Private mCapaID

    Public Property Let CapaID(Value)
        mCapaID = Value
        If mCapaID <> "" Then
           InitObject
        End If
    End Property

    Public Property Get CapaID
        CapaID = mCapaID
    End Property

    Public DateID
    Public NewID
    Public Active
    Public DepartmentID
    Public Department
    Public CapaNb
    Public CapaTxt
    Public CapaStart
    Public CapaClosed
    Public UserID
    Public LastEdit

    Private oStream

    Private Sub Class_Initialize()
        mCapaID = ""
        NewID = ""
        DateID = ""
        Active = 1
        DepartmentID = 0
        Department = ""
        CapaNb = ""
        CapaTxt = ""
        CapaStart = ""
        CapaClosed = ""
        UserID = Session("login")
        LastEdit = ""
        Set oStream = New StreamType
    End Sub


    Private Sub InitObject()

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierCapa WHERE capaid='" & mCapaID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            DateID = iRs("dateid")
            DepartmentID = iRs("departmentid")
            Department = iRs("department")
            CapaNb = iRs("capanb")
            CapaTxt = oStream.Name(iRs("capadescription"))
            CapaStart = iRs("capastart")
            CapaClosed = iRs("capaclosed")
            LastEdit = iRs("lastedit")
            UserID = iRs("userid")
        End If
        iRs.Close
    End Sub


    Public Function Save()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "CapaUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        If mCapaID = "" Then
            Set Parameter = Cmd.CreateParameter("@CapaID", adGUID, adParamOutput,,Null)
            Cmd.Parameters.Append Parameter
        Else
           Set Parameter = Cmd.CreateParameter("@CapaID", adGUID, adParamInput)
           Cmd.Parameters.Append Parameter
           Parameter.Value = mCapaID
        End If

        Set Parameter = Cmd.CreateParameter("@DateID", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DateID

        Set Parameter = Cmd.CreateParameter("@DepartmentID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DepartmentID

        Set Parameter = Cmd.CreateParameter("@CapaNb", adVarWChar, adParamInput, 15)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CapaNb

        Set Parameter = Cmd.CreateParameter("@CapaDescription", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CapaTxt


        If CapaStart <> "" Then
            Set Parameter = Cmd.CreateParameter("@CapaStart", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(CapaStart)
        Else
            Set Parameter = Cmd.CreateParameter("@CapaStart", adDate, adParamInput,,Null)
            Cmd.Parameters.Append Parameter
        End If

        If CapaClosed <> "" Then
            Set Parameter = Cmd.CreateParameter("@CapaClosed", adDate, adParamInput)
            Cmd.Parameters.Append Parameter
            Parameter.Value = DBFormatDate(CapaClosed)
        Else
            Set Parameter = Cmd.CreateParameter("@CapaClosed", adDate, adParamInput,,Null)
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

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierCapa WHERE dateid='" & DateID & "' AND departmentid=" & DepartmentID
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

        Dim SQLStr : SQLStr = "DELETE FROM tier_capa WHERE capaid='" & mCapaID & "'"
        Dim iRs : iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


End Class


Class CapaHelper

    Public Function CapaList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierCapa ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Capa
            Item.CapaID = Rs("capaid")
            List.Add Item.CapaID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  CapaList =  List

    End Function

End Class


%>