<%

Class BoxController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New BoxHelper
        Dim List : Set List = pHelper.List
        ''Dim DDList : Set DDList = pHelper.DDList

        Dim wHelper : Set wHelper = New WarehouseHelper



        ViewData.Add "list", List
        ''ViewData.Add "ddlist", DDList
        ViewData.Add "warehouse", wHelper.ListDD()

        %>   <!--#include file="../views/box/index.asp" --> <%

    End Sub

End Class
%>