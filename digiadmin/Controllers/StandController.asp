<%

Class StandController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()
        Dim pHelper : Set pHelper = New PlantHelper
        Dim cHelper : Set cHelper = New CategoryListDD

        ViewData.Add "plant-list", pHelper.PlantListStillDD
        ViewData.Add "cat-list", cHelper.List

        %>   <!--#include file="../views/stand/Index.asp" --> <%

    End Sub

    Public Sub category()

        %>   <!--#include file="../views/stand/category.asp" --> <%

    End Sub

End Class
%>