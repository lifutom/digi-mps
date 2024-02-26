<%
Class Categorie

    Public ModuleID
    Public Name
    Public Active
    Public IsCategorie
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        ModuleID = -1
        Name =""
        Active = 0
        IsCategorie = 1
        UserID = Session("login")
        LastEdit = ""
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Default Sub Init(ByVal mID)

        ModuleID = mID
        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=1 AND moduleid=" & mID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            ModuleID = mID
            Name = iRs("name")
            Active = iRs("active")
            IsCategorie = iRs("iscategorie")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
        End If

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ModuleUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ModuleID", adInteger, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ModuleID

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@Active", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Set Parameter = Cmd.CreateParameter("@IsCategorie", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IsCategorie

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            ModuleID = Cmd.Parameters("@ModuleID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Exists (ByVal mName)

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=1 AND LOWER(name)='" & LCase(mName) & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close

    End Function

End Class

Class CategorieHelper

    Public Function List ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set List = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Categorie
                Item.ModuleID = iRs("moduleid")
                Item.Name = iRs("name")
                Item.Active = iRs("active")
                Item.IsCategorie = iRs("iscategorie")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Results.Add Item.ModuleID, Item
                iRs.MoveNext
            Loop
            iRs.Close
            Set iRs = Nothing
            Set List = Results
        End If

    End Function

    Public Function ActiveList ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=1 AND active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set ActiveList = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Categorie
                Item.ModuleID = iRs("moduleid")
                Item.Name = iRs("name")
                Item.Active = iRs("active")
                Item.IsCategorie = iRs("iscategorie")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Results.Add Item.ModuleID, Item
                iRs.MoveNext
            Loop
            iRs.Close
            Set iRs = Nothing
            Set ActiveList = Results
        End If

    End Function

    Public Function ListDD ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ListDD = Results

    End Function



    Public Function ActiveListDD ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=1 AND active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ActiveListDD = Results

    End Function


    Public Function ListByDeviceID(ByVal ID, ByVal WithEmpty)


        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=1 AND active=1 AND moduleid IN (SELECT DISTINCT moduleid FROM sparepart_plant WHERE deviceid=" & ID & ") ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ListByDeviceID = Results

    End Function


    Public Function ListByPlantID(ByVal ID, ByVal WithEmpty)


        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM module WHERE iscategorie=1 AND active=1 AND moduleid IN (SELECT DISTINCT moduleid FROM sparepart_plant WHERE plantid=" & ID & ") ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ListByPlantID = Results

    End Function


End Class

%>