<%

Class MasterController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    Public Sub index()

        roomlist

    End Sub

    public Sub buildinglist()

        Dim pHelper : Set pHelper = New Building
        Dim List : Set List = pHelper.List

        ViewData.Add "list", List

        %>   <!--#include file="../views/Master/building.asp" --> <%

    End Sub


    public Sub roomlist()

        Dim pHelper : Set pHelper = New Room
        Dim List : Set List = pHelper.List

        Dim rHelper : Set rHelper = New Region
        Dim bHelper : Set bHelper = New Building


        ViewData.Add "list", List
        ViewData.Add "regionlist", rHelper.DDList
        ViewData.Add "buildinglist", bHelper.DDList

        %>   <!--#include file="../views/Master/room.asp" --> <%

    End Sub

    public Sub regionlist()

        Dim pHelper : Set pHelper = New Region
        Dim List : Set List = pHelper.List

        Dim rHelper : Set rHelper = New Region

        ViewData.Add "list", List


        %>   <!--#include file="../views/Master/region.asp" --> <%

    End Sub

End Class
%>