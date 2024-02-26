<%

Class FailureItem

    Private mFailureID

    Public Property Get FailureID
        FailureID = mFailureID
    End Property

    Public Property Let FailureID (Value)
        mFailureID = Value
        If mFailureID <> "" Then
            InitObject
        End If
    End Property

    Public Failure
    Public Description
    Public Active

    Private Sub Class_Initialize()
        mFailureID = -1
        Failure =""
        Description = ""
        Active = 1
    End Sub

    Private Sub InitObject

         '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM failurelist WHERE failureid=" & mFailureID
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If Not iRs.Eof Then
            Failure = iRs("failure")
            Description = iRs("description")
            Active = iRs("active")
        End If
        iRs.Close
    End Sub

    Public Function Save

        If mFailureID = 0 Or mFailureID = "" Then
           Save = Add
        Else
           Save = Update
        End If

    End Function


    Private Function Add()

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "AddFailureItem"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@FailureID", adInteger, adParamOutput)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@Failure", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Failure

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 4096)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description

        Set Parameter = Cmd.CreateParameter("@Active", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Add = RetVal

    End Function

    Private Function Update()

         Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "UpdateFailureItem"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@FailureID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = mFailureID

        Set Parameter = Cmd.CreateParameter("@Failure", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Failure

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 4096)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description

        Set Parameter = Cmd.CreateParameter("@Active", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Update = RetVal

    End Function

    Public Function Exists(ByVal Failure)

        Dim SQLStr : SQLStr = "SELECT * FROM failurelist WHERE failure='" & Failure & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close
        DbCloseConnection()

    End Function

End Class

Class FailureHelper

    Public Function FailureList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM failurelist ORDER BY failure"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New FailureItem
            Item.FailureID = Rs("failureid")
            List.Add Item.FailureID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  FailureList =  List

    End Function

End Class

%>