<%
Class Site

    Public SiteID
    Public Name
    Public Active
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        SiteID = -1
        Name =""
        Active = 0
        UserID = Session("login")
        LastEdit = ""
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Default Sub Init(ByVal mSiteID)

        SiteID = mSiteID
        Dim SQLStr : SQLStr = "SELECT * FROM site WHERE siteid=" & mSiteID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            SiteID = mSiteID
            Name = iRs("name")
            Active = iRs("active")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
        End If

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SiteUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@SiteID", adInteger, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SiteID

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@Active", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            SiteID = Cmd.Parameters("@SiteID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Exists (ByVal mSiteName)

        Dim SQLStr : SQLStr = "SELECT * FROM site WHERE name='" & mSiteName & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close

    End Function

End Class

Class SiteHelper

    Public Function List ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        SiteID = mSiteID
        Dim SQLStr : SQLStr = "SELECT * FROM site ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set List = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Site
                Item.SiteID = iRs("siteid")
                Item.Name = iRs("name")
                Item.Active = iRs("active")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Results.Add Item.SiteID, Item
                iRs.MoveNext
            Loop
            iRs.Close
            Set iRs = Nothing
            Set List = Results
        End If

    End Function

    Public Function ActiveSiteList ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        SiteID = mSiteID
        Dim SQLStr : SQLStr = "SELECT * FROM site WHERE active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set ActiveSiteList = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Site
                Item.SiteID = iRs("siteid")
                Item.Name = iRs("name")
                Item.Active = iRs("active")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Results.Add Item.SiteID, Item
                iRs.MoveNext
            Loop
            iRs.Close
            Set iRs = Nothing
            Set ActiveSiteList = Results
        End If

    End Function

    Public Function SiteListDD ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        SiteID = mSiteID
        Dim SQLStr : SQLStr = "SELECT * FROM site ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("siteid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set SiteListDD = Results

    End Function



    Public Function ActiveSiteListDD ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        SiteID = mSiteID
        Dim SQLStr : SQLStr = "SELECT * FROM site WHERE active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("siteid")
            Item.Name = iRs("name")
            Item.Active = iRs("active")
            Item.IconClass = ""
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        Set ActiveSiteListDD = Results

    End Function



End Class

%>