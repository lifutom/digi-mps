<%

Class AccessItemController

    Dim Model
    Dim ViewData
    Dim mHelper
    Dim uHelper

    Private Sub Class_Initialize()

        Set ViewData = Server.CreateObject("Scripting.Dictionary")
        Set mHelper = New AccessHelper
        Set uHelper = New ADUserHelper

    End Sub

    Private Sub Class_Terminate()

    End Sub

    Public Sub AdShares()

        ViewData.Add "list", mHelper.List(cAccessTypeShare)
        ViewData.Add "statelist", mHelper.StatusList
        ViewData.Add "accesstypelist", mHelper.TypeList
        ViewData.Add "accesstype", cAccessTypeShare
        ViewData.Add "userlist", uHelper.List()

        %>   <!--#include file="../views/accessitem/adshares.asp" --> <%


    End Sub

    Public Sub Apps()

        ViewData.Add "list", mHelper.List(cAccessTypeApp)
        ViewData.Add "accesstype", cAccessTypeApp
        ViewData.Add "statelist", mHelper.StatusList
        ViewData.Add "accesstypelist", mHelper.TypeList
        ViewData.Add "userlist", uHelper.List()

        %>   <!--#include file="../views/accessitem/adshares.asp" --> <%


    End Sub

    Public Sub Devices()

        ViewData.Add "list", mHelper.List(cAccessTypeDevice)
        ViewData.Add "accesstype", cAccessTypeDevice
        ViewData.Add "statelist", mHelper.StatusList
        ViewData.Add "accesstypelist", mHelper.TypeList
        ViewData.Add "userlist", uHelper.List()

        %>   <!--#include file="../views/accessitem/adshares.asp" --> <%


    End Sub

    

    Public Sub ItemWorkFlow(Vars)


        Dim hItem : Set hItem = New AccessItem
        hItem.ID = Vars("id")
        Set List = hItem.AccessRights

        ViewData.Add "list", List
        ViewData.Add "groups", hItem.Groups
        ViewData.Add "accesstype", Vars("typ")

        %>   <!--#include file="../views/accessitem/itemworkflow.asp" --> <%


    End Sub


End Class
%>