<%
Class UserController

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

        Dim Helper : Set Helper = New ADAccess
        Dim oList : Set oList = New Rooms
        Dim oDepartment : Set oDepartment = New Department

        ViewData.Add "roomlist", oList.List
        ViewData.Add "deplist", oDepartment.DDList
        ViewData.Add "list", mHelper.List

        %>   <!--#include file="../views/user/index.asp" --> <%

    End Sub

    Public Sub AccessMaint(vars)

        Dim Helper : Set Helper = New RequestHelper

        ViewData.Add "typelist", Helper.AccessTypeList()
        ViewData.Add "itemlist", Nothing ''Helper.AccessTypeList()
        ViewData.Add "rightlist", Nothing ''Helper.AccessTypeList()

        Dim ISID : ISID = vars("id")
        %>   <!--#include file="../views/user/accessmaint.asp" --> <%

    End Sub


    Public Sub AccessMaintPost(args)

        Dim ISID : ISID = args("isid")
        Dim AccessItemTypeID : AccessItemTypeID = args("accessitemtypeid")
        Dim AccessItemID : AccessItemID = args("accessitemid")
        Dim AccessRightID : AccessRightID = args("accessrightid")

        Response.Redirect("user/accessmaint?id=" & ISID)

    End Sub



End Class
%>