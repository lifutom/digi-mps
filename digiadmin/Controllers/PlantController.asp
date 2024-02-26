<%

Class PlantController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New PlantHelper
        Dim PlantList : Set PlantList = pHelper.PlantList

        ViewData.Add "plantlist", PlantList

        %>   <!--#include file="../views/plant/Index.asp" --> <%

    End Sub


End Class
%>