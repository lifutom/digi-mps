<%

Class HomeController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New ProductionHelper
        Dim ProdList : Set ProdList = pHelper.TierOverview

        Session("tierboard") = ""

        ViewData.Add "overview", ProdList

        %>   <!--#include file="../views/Home/Index.asp" --> <%

    End Sub

End Class
%>