<%
Class ProfileController

    Dim Model
    Dim ViewData
    Dim mHelper

    Private Sub Class_Initialize()

        Set ViewData = Server.CreateObject("Scripting.Dictionary")
        Set mHelper = New ADUserHelper

    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Sub Index()

        Dim Helper : Set Helper = New ADUser
        Helper.ID = Session("login")
        Dim oList : Set oList = New Rooms
        Dim oDepartment : Set oDepartment = New Department

        ViewData.Add "roomlist", oList.List
        ViewData.Add "deplist", oDepartment.DDList
        ViewData.Add "delegate", mHelper.Delegates(Session("login"))
        ViewData.Add "user", Helper

        %>   <!--#include file="../views/profile/index.asp" --> <%

    End Sub

    Public Sub OwnRequest()

        Dim Helper : Set Helper = New RequestHelper
        ViewData.Add "list", Helper.OwnRequests
        ViewData.Add "statelist", Helper.ApproveStatusList
        ViewData.Add "typelist", Helper.RequestTypeList

        %>   <!--#include file="../views/profile/myrequest.asp" --> <%

    End Sub


    Public Sub WorkFlowState(vars)

        ''Dim Helper : Set Helper = New RequestItem
        ''Helper.ID = vars("id")

        Dim wHelper : Set wHelper = New WorkFlowStateItem
        wHelper.FillByAccessRight vars("id"), vars("aid"), vars("arid")
        ViewData.Add "item", wHelper
        ViewData.Add "taskid", vars("taskid")
        %>   <!--#include file="../views/shared/workflowstate.asp" --> <%

    End Sub



End Class
%>