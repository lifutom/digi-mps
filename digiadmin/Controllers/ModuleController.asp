<%

Class ModuleController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New ModuleHelper
        Dim List : Set List = pHelper.List

        Dim plHelper : Set plHelper = New PlantHelper

        ViewData.Add "lines",  plHelper.DDSpareList()
        ViewData.Add "list", List

        %>   <!--#include file="../views/module/index.asp" --> <%

    End Sub

End Class
%>