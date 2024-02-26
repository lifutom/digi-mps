<%
Class WorklistController

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

        ViewData.Add "list", mHelper.OpenITWorkItems()
        ViewData.Add "typelist", mHelper.RequestTypeList
        ViewData.Add "progresslist", mHelper.RequestStatusList

        %>   <!--#include file="../views/worklist/index.asp" --> <%

    End Sub


    Public Sub History()

        ViewData.Add "list", mHelper.ClosedITWorkItems
        ViewData.Add "typelist", mHelper.RequestTypeList
        ViewData.Add "progresslist", mHelper.RequestStatusList
        %>   <!--#include file="../views/worklist/history.asp" --> <%

    End Sub


End Class
%>