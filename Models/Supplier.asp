<%
Class Supplier

    Public SupplierID
    Public Name
    Public Country
    Public Zip
    Public City
    Public Street
    Public Phone
    Public Mobile
    Public MainContact
    Public EMail
    Public Active
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        SupplierID = -1
        Name =""
        Country = ""
        Zip = ""
        City = ""
        Street = ""
        Phone = ""
        Mobile = ""
        MainContact = ""
        Email = ""
        Active = 0
        UserID = Session("login")
        LastEdit = ""
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Default Sub Init(ByVal mID)

        SupplierID = mID
        Dim SQLStr : SQLStr = "SELECT * FROM supplier WHERE supplierid=" & mID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            SupplierID = mID
            Name = iRs("name")
            Country = iRs("country")
            Zip = iRs("zip")
            City = iRs("city")
            Street = iRs("street")
            Phone = iRs("phone")
            Mobile = iRs("mobile")
            MainContact = iRs("maincontact")
            Email = iRs("email")
            Active = iRs("active")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
        End If

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "SupplierUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@SupplierID", adInteger, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SupplierID

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 255)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@Country", adVarWChar, adParamInput, 5)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Country

        Set Parameter = Cmd.CreateParameter("@Zip", adVarWChar, adParamInput, 10)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Zip

        Set Parameter = Cmd.CreateParameter("@City", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = City

        Set Parameter = Cmd.CreateParameter("@Street", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Street

        Set Parameter = Cmd.CreateParameter("@Phone", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Phone

        Set Parameter = Cmd.CreateParameter("@Mobile", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Mobile

        Set Parameter = Cmd.CreateParameter("@MainContact", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = MainContact

        Set Parameter = Cmd.CreateParameter("@EMail", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = EMail


        Set Parameter = Cmd.CreateParameter("@Active", adUnsignedTinyInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Active

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            SupplierID = Cmd.Parameters("@SupplierID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Exists (ByVal mName)

        Dim SQLStr : SQLStr = "SELECT * FROM supplier WHERE name='" & mName & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close

    End Function

End Class

Class SupplierHelper

    Public Function List ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM supplier ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set List = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Supplier
                Item.SupplierID = iRs("supplierid")
                Item.Name = iRs("name")
                Item.Country = iRs("country")
                Item.Zip = iRs("zip")
                Item.City = iRs("city")
                Item.Street = iRs("street")
                Item.Phone = iRs("phone")
                Item.Mobile = iRs("mobile")
                Item.MainContact = iRs("maincontact")
                Item.Email = iRs("email")
                Item.Active = iRs("active")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Results.Add Item.SupplierID, Item
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

        Dim SQLStr : SQLStr = "SELECT * FROM supplier WHERE active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set ActiveList = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Supplier
                Item.SupplierID = iRs("supplierid")
                Item.Name = iRs("name")
                Item.Country = iRs("country")
                Item.Zip = iRs("zip")
                Item.City = iRs("city")
                Item.Street = iRs("street")
                Item.Phone = iRs("phone")
                Item.Mobile = iRs("mobile")
                Item.MainContact = iRs("maincontact")
                Item.Email = iRs("email")
                Item.Active = iRs("active")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Results.Add Item.SupplierID, Item
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

        Dim SQLStr : SQLStr = "SELECT * FROM supplier ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("supplierid")
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

        SiteID = mSiteID
        Dim SQLStr : SQLStr = "SELECT * FROM supplier WHERE active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("supplierid")
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