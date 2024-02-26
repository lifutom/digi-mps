<%
Class Warehouse

    Public WarehouseID
    Public SiteID
    Public Name
    Public SiteName
    Public Active
    Public UserID
    Public LastEdit

    Private Sub Class_Initialize()
        WarehouseID = -1
        SiteID = -1
        Name =""
        Active = 0
        UserID = Session("login")
        LastEdit = ""
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Default Sub Init(ByVal mWarehouseID)

        WarehouseID = mWarehouseID
        Dim SQLStr : SQLStr = "SELECT * FROM vwWarehouse WHERE warehouseid=" & mWarehouseID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            WarehouseID = mWarehouseID
            SiteID = iRs("siteid")
            Name = iRs("name")
            SiteName = iRs("sitename")
            Active = iRs("active")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
        End If

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "WarehouseUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@WarehouseID", adInteger, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = WarehouseID

        Set Parameter = Cmd.CreateParameter("@SiteID", adInteger, adParamInput)
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
            WarehouseID = Cmd.Parameters("@WarehouseID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Exists (ByVal mName)

        Dim SQLStr : SQLStr = "SELECT * FROM warehouse WHERE name='" & mName & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)
        If iRs.Eof Then
           Exists = False
        Else
           Exists = True
        End If
        iRs.Close

    End Function

End Class

Class WarehouseHelper

    Public Function List ()

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM vwWarehouse ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set List = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Warehouse
                Item.WarehouseID = iRs("warehouseid")
                Item.SiteID = iRs("siteid")
                Item.Name = iRs("name")
                Item.SiteName = iRs("sitename")
                Item.Active = iRs("active")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Results.Add Item.WarehouseID, Item
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

        Dim SQLStr : SQLStr = "SELECT * FROM vwWarehouse WHERE active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If iRs.Eof Then
           Set ActiveList = Nothing
        Else
            Do While Not iRs.Eof
                Set Item = New Warehouse
                Item.WarehouseID = iRs("warehouseid")
                Item.SiteID = iRs("siteid")
                Item.Name = iRs("name")
                Item.SiteName = iRs("sitename")
                Item.Active = iRs("active")
                Item.UserID = iRs("userid")
                Item.LastEdit = iRs("lastedit")
                Results.Add Item.WarehouseID, Item
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

        SiteID = mSiteID
        Dim SQLStr : SQLStr = "SELECT * FROM warehouse ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("warehouseid")
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
        Dim SQLStr : SQLStr = "SELECT * FROM warehouse WHERE active=1 ORDER BY name"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("warehouseid")
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



End Class

%>