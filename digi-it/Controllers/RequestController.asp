<%
Class RequestController

    Dim Model
    Dim ViewData
    Dim mHelper
    Dim uHelper
    Dim stHelper

    Private Sub Class_Initialize()

        Set ViewData = Server.CreateObject("Scripting.Dictionary")
        Set mHelper = New RequestHelper
        Set uHelper = New ADUserHelper

    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Sub Index()

        ViewData.Add "list", mHelper.OpenRequests("")
        ViewData.Add "statelist", mHelper.ApproveStatusList
        ViewData.Add "typelist", mHelper.RequestTypeList

        %>   <!--#include file="../views/request/index.asp" --> <%

    End Sub


    Public Sub History()

        ViewData.Add "list", mHelper.ClosedRequests("")
        ViewData.Add "statelist", mHelper.ApproveStatusList
        ViewData.Add "typelist", mHelper.RequestTypeList
        %>   <!--#include file="../views/request/history.asp" --> <%

    End Sub


    Public Sub FormGrant()

        ViewData.Add "userlist", uHelper.List()
        ViewData.Add "peoplemanager", uHelper.PeopleManager()
        ViewData.Add "statelist", mHelper.RequestStatusList

        ViewData.Add "accesstypelist", mHelper.AccessTypeList


        %>   <!--#include file="../views/request/accessform.asp" --> <%
    End Sub

    Public Sub FormRevoke()

        ViewData.Add "userlist", uHelper.List()
        ViewData.Add "peoplemanager", uHelper.PeopleManager()
        ViewData.Add "statelist", mHelper.RequestStatusList
        ViewData.Add "accesstypelist", mHelper.AccessTypeList

        %>   <!--#include file="../views/request/revokeform.asp" --> <%
    End Sub

    Public Sub Form()

        %>   <!--#include file="../views/request/formselect.asp" --> <%
    End Sub

    Public Sub Logout
        Session("IsGuest") = ""
        Session("login") = ""
        Response.Redirect( "/" & Application("root") & "/request/form")
    End Sub

End Class
%>