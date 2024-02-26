<%

Class UserController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()




        Dim pHelper : Set pHelper = New UserHelper


        Dim List : Set List = pHelper.UserList
        
        Dim Departments : Set Departments = New Department

        Dim gHelper : Set gHelper = New GroupHelper
        Dim gList : Set gList = gHelper.GroupList

        ViewData.Add "list", List
        ViewData.Add "ddgrouplist", gList
        ViewData.Add "dddepartmentlist", Departments.DDList

        %>   <!--#include file="../views/User/index.asp" --> <%

    End Sub


End Class
%>