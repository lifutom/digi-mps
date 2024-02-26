<%
Class DashController

    Dim Model
    Dim ViewData
    Dim rHelper

    Private Sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
        Set rHelper = New RequestHelper


    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Sub Index()

        Dim RequestStatisticItem : Set RequestStatisticItem = New RequestStatistic

        ViewData.Add "statelist", rHelper.ApproveStatusList
        ViewData.Add "taskstatelist", rHelper.RequestStatusList
        ViewData.Add "requeststat", RequestStatisticItem
        %>   <!--#include file="../views/Home/Index.asp" --> <%

    End Sub

    Public Sub Logout

        Session("login") = Login
        Session("IsGuest") = False

        Link = curRootFile & "/login.asp"

        Session.Abandon
        Response.Redirect(Link)

    End Sub

    Public Sub IndexPost(args)


        Session("activemoduleid") = args("moduleid")
        Session("catid") = args("catid")
        Session("searchstr") = args("searchstr")

        Response.Redirect(curRootFile & "/home/spareparts")


    End Sub

End Class
%>