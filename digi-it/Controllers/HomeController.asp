<%

Class HomeController

    Dim Model
    Dim ViewData
    Dim rHelper

    Private Sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
        Set rHelper = New RequestHelper


    End Sub

    Private Sub Class_Terminate()
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

    Public Sub Index()

        %>   <!--#include file="../views/request/formselect.asp" --> <%
    End Sub

    Public Sub Logout

        Session("login") = Login
        Session("IsGuest") = False

        Link = curRootFile & "/login.asp"

        Session.Abandon
        Response.Redirect(Link)

    End Sub

End Class
%>