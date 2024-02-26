<%

Class WarehouseController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New WarehouseHelper
        Dim List : Set List = pHelper.List

        Dim sHelper : Set sHelper = New SiteHelper
        Dim sList : Set sList = sHelper.SiteListDD

        ViewData.Add "list", List
        ViewData.Add "ddsitelist", sList

        %>   <!--#include file="../views/Warehouse/index.asp" --> <%

    End Sub


End Class
%>