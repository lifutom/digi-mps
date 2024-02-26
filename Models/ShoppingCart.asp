<%

Class CartBooking

    Public ShoppingID
    Public UserID


    Public ErrMsg
    Public ErrNumber
    Public ErrStatus
    Public HasError

    Private Sub Class_Initialize()

        ShoppingID = CLng(-1)
        UserID = Session("userid")

        HasError = False
        ErrMsg = ""
        ErrNumber = 0
        ErrStatus = "OK"

    End Sub


    Public Function Save


        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ShoppingCartBooking"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ShoppingID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CLng(ShoppingID)

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            ShoppingID = Cmd.Parameters("@ShoppingID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        HasError = RetVal

        If RetVal Then
            ErrStatus="OK"
            HasError = False
        Else
            ErrStatus="NOTOK"
            HasError = True
        End If

        Save = RetVal

    End Function

End Class



Class ShoppingItem

    Public ShoppingID
    Public SparepartID
    Public LocationID
    Public Act
    Public CreatedBy
    Public Created
    Public UserID
    Public LastEdit

    Public ErrMsg
    Public ErrNumber
    Public ErrStatus
    Public HasError

    Public SparepartNb
    Public LocAct
    Public Sparepart
    Public Location
    Public Warehouse


    Private Sub Class_Initialize()
        ShoppingID = CLng(-1)
        SparepartID = CLng(-1)
        Act = 0.00
        CreatedBy = ""
        Created = Date
        UserID = Session("userid")
        LastEdit = ""

        HasError = False
        ErrMsg = ""
        ErrNumber = 0
        ErrStatus = "OK"
    End Sub

    Public Function Save


        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ShoppingCartItemUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ShoppingID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CLng(ShoppingID)

        Set Parameter = Cmd.CreateParameter("@SparepartID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = SparepartID

        Set Parameter = Cmd.CreateParameter("@LocationID", adBigInt, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LocationID

        Set Parameter = Cmd.CreateParameter("@Act", adDouble, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Act

        Set Parameter = Cmd.CreateParameter("@CreatedBy", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CreatedBy

        Set Parameter = Cmd.CreateParameter("@Created", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Created

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = UserID

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            ShoppingID = Cmd.Parameters("@ShoppingID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        HasError = RetVal

        If RetVal Then
            ErrStatus="OK"
            HasError = False
        Else
            ErrStatus="NOTOK"
            HasError = True
        End If

        Save = RetVal

    End Function


    Public Function Delete

        Dim SQLStr : SQLStr = "DELETE FROM shoppingcart_detail WHERE shoppingid=" & ShoppingID & " AND locationid=" & LocationID & " AND sparepartid=" & SparepartID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function

End Class


Class ShoppingCart

    Public ShoppingID
    Public Name
    Public CreatedBy
    Public Created
    Public IsClosed
    Public Closed
    Public UserID
    Public LastEdit
    Public ShoppingItems

    Public Count

    Private Sub Class_Initialize()
        ShoppingID = CLng(-1)
        Name = ""
        CreatedBy = ""
        Created = Date
        IsClosed = 0
        UserID = Session("userid")
        LastEdit = ""
        Set ShoppingItems = Server.CreateObject("Scripting.Dictionary")
        Count = 0
    End Sub


    Public Default Function Init (ByVal ID)

        Dim SQLStr : SQLStr = "SELECT * FROM shoppingcart WHERE shoppingid=" & ID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            ShoppingID = CLng(iRs("shoppingid"))
            Name = iRs("name")
            CreatedBy = iRs("createdby")
            Created = iRs("created")
            IsClosed = iRs("isclosed")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
        End If

        SQLStr = "SELECT * FROM vwShoppingCartDetail WHERE shoppingid=" & ID
        Set iRs = DbExecute(SQLStr)
        Dim Item
        Dim x : x=0
        ActLevel = 0
        Do While Not iRs.Eof
            Set Item = New ShoppingItem
            Item.ShoppingID = CLng(iRs("shoppingid"))
            Item.SparepartID = CLng(iRs("sparepartid"))
            Item.LocationID = iRs("locationid")
            Item.Act = iRs("act")
            Item.CreatedBy = iRs("createdby")
            Item.Created = iRs("created")
            Item.UserID = iRs("userid")
            Item.LastEdit = iRs("lastedit")
            Item.SparepartNb = iRs("sparepartnb")
            Item.Sparepart = iRs("sparepart")
            Item.Location = iRs("location")
            Item.Warehouse = iRs("warehouse")
            Item.LocAct = iRs("locact")
            ShoppingItems.Add x , Item
            x=x+1
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()

        Count = ShoppingItems.Count

    End Function

    Public Function InitByUserID (ByVal ID)

        Dim SQLStr : SQLStr = "SELECT * FROM shoppingcart WHERE isclosed=0 AND createdby='" & ID & "'"
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            ShoppingID = CLng(iRs("shoppingid"))
            Name = iRs("name")
            CreatedBy = iRs("createdby")
            Created = iRs("created")
            IsClosed = iRs("isclosed")
            UserID = iRs("userid")
            LastEdit = iRs("lastedit")
        End If

        SQLStr = "SELECT * FROM vwShoppingCartDetail WHERE shoppingid=" & ShoppingID
        Set iRs = DbExecute(SQLStr)
        Dim Item
        Dim x : x=0
        ActLevel = 0
        Do While Not iRs.Eof
            Set Item = New ShoppingItem
            Item.ShoppingID = CLng(iRs("shoppingid"))
            Item.SparepartID = CLng(iRs("sparepartid"))
            Item.LocationID = iRs("locationid")
            Item.Act = iRs("act")
            Item.CreatedBy = iRs("createdby")
            Item.Created = iRs("created")
            Item.UserID = iRs("userid")
            Item.LastEdit = iRs("lastedit")
            Item.SparepartNb = iRs("sparepartnb")
            Item.Sparepart = iRs("sparepart")
            Item.Location = iRs("location")
            Item.Warehouse = iRs("warehouse")
            Item.LocAct = iRs("locact")   
            ShoppingItems.Add x , Item
            x=x+1
            iRs.MoveNext
        Loop
        iRs.Close
        Set iRs = Nothing
        DbCloseConnection()
        Count = ShoppingItems.Count

    End Function



    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "ShoppingCartUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ShoppingID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ShoppingID

        Set Parameter = Cmd.CreateParameter("@Name", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@CreatedBy", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CreatedBy

        Set Parameter = Cmd.CreateParameter("@Created", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DBFormatDate(Created)

        Set Parameter = Cmd.CreateParameter("@IsClosed", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = IsClosed

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Session("login")

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            ShoppingID = Cmd.Parameters("@ShoppingID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()

        Save = RetVal

    End Function

    Public Function Delete

        Dim SQLStr : SQLStr = "DELETE FROM shoppingcart WHERE shoppingid=" & ShoppingID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        SQLStr = "DELETE FROM shoppingcart_detail WHERE shoppingid=" & ShoppingID
        Set iRs = DbExecute(SQLStr)

        DbCloseConnection()

        Delete = True

    End Function


    Public Function DeleteItem (ByVal SparepartID, ByVal Act)

    End Function


End Class

Class ShoppingCartHelper

    Public Function CartList (ByVal UserID)

        Dim SQLStr : SQLStr = "SELECT *  FROM shoppingcart WHERE isclosed=0 AND createdby='" & UserID & "'"
        Dim iiRs : Set iiRs = DbExecute(SQLStr)

        Dim Arr
        Dim i
        Dim Cart

        Do While Not iiRs.Eof
            If Not IsArray(Arr) Then
                ReDim Arr(0)
            Else
                ReDim Preserve Arr(UBound(Arr)+1)
            End If
            Arr(UBound(Arr)) = iiRs("shoppingid")
            iiRs.MoveNext
        Loop
        iiRs.Close
        DbCloseConnection()

        Set CartList = Server.CreateObject("Scripting.Dictionary")

        If IsArray(Arr) Then
            For i=0 To UBound(Arr)
                Set Cart = New ShoppingCart
                Cart(Arr(i))
                CartList.Add Cart.ShoppingID, Cart
            Next
        End If

    End Function


    Public Function AdminCartList ()

        Dim SQLStr : SQLStr = "SELECT *  FROM shoppingcart WHERE isclosed=0 ORDER BY created DESC"
        Dim iiRs : Set iiRs = DbExecute(SQLStr)

        Dim Arr
        Dim i
        Dim Cart

        Do While Not iiRs.Eof
            If Not IsArray(Arr) Then
                ReDim Arr(0)
            Else
                ReDim Preserve Arr(UBound(Arr)+1)
            End If
            Arr(UBound(Arr)) = iiRs("shoppingid")
            iiRs.MoveNext
        Loop
        iiRs.Close
        DbCloseConnection()

        Set AdminCartList = Server.CreateObject("Scripting.Dictionary")

        If IsArray(Arr) Then
            For i=0 To UBound(Arr)
                Set Cart = New ShoppingCart
                Cart(Arr(i))
                AdminCartList.Add Cart.ShoppingID, Cart
            Next
        End If

    End Function

End Class


%>