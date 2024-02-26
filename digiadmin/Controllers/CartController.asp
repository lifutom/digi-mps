<%

Class CartController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index

        Dim oCart : Set oCart = New ShoppingCartHelper
        Dim cUser : cUser = Session("login")
        Dim List

        If IsAdmin Then
            Set List = oCart.AdminCartList()
        Else
            Set List = oCart.CartList(cUser)
        End If

        ViewData.Add "list", List

        %>   <!--#include file="../views/cart/index.asp" --> <%

    End Sub

    public Sub MyCart

        Dim oCart : Set oCart = New ShoppingCart
        Dim cUser : cUser = Session("login")
        Dim List

        oCart.InitByUserID(cUser)

        ViewData.Add "cart", oCart
        ViewData.Add "mycart", True

        %>   <!--#include file="../views/cart/mycart.asp" --> <%

    End Sub

    Public Sub CartPost (args)

        Dim oCart : Set oCart = New ShoppingCart
        Dim ID : ID = args("id")
        Dim List

        oCart.Init(ID)

        ViewData.Add "cart", oCart
        ViewData.Add "mycart", False

        %>   <!--#include file="../views/cart/mycart.asp" --> <%

    End Sub


End Class

%>