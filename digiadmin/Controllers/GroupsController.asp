<%

Class GroupsController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New GroupHelper
        Dim List : Set List = pHelper.GroupList

        ViewData.Add "list", List

        %>   <!--#include file="../views/groups/index.asp" --> <%

    End Sub

    Public Sub AccessPost(args)

        Dim pHelper : Set pHelper = New GroupHelper
        Dim actGroup : actGroup = args("groupid")
        Dim actGroupName : actGroupName = ReturnFromRecord("[group]","groupid='" & Trim(actGroup) & "'", "groupname")

        Dim accMenu : Set accMenu = New Menu
        Dim GroupAccess : Set GroupAccess = accMenu.GroupAccess(actGroup)

        ViewData.Add "groupaccess", GroupAccess
        ViewData.Add "groupid", actGroup
        ViewData.Add "groupname", actGroupName
       
        %>   <!--#include file="../views/groups/access.asp" --> <%

    End Sub



End Class
%>