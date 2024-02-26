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


    Public Sub Index

        Dim pHelper : Set pHelper = New PlantHelper
        Dim cHelper : Set cHelper = New CategoryListDD
        Dim sHelper : Set sHelper = New StandHelper

        Dim List :  Set List = sHelper.GetListLast5(curUser)
        Dim Item :  Set Item = New StandItem

        If Session("standid") = ""  OR  Session("standid") = "-1" Then
        Else
            Item.ID = Session("standid")
            Session("standid") = "-1"
        End If

        ViewData.Add "plant-list", pHelper.PlantListStillDD
        ViewData.Add "cat-list", cHelper.List
        ViewData.Add "stand-list", List
        ViewData.Add "item", Item

        %>   <!--#include file="../views/home/index.asp" --> <%

    End Sub


    Public Sub IndexPost(args)


        Dim Item : Set Item = New StandItem


        Item.StandID = args("id")
        Item.PlantID = args("plantid")
        Item.DeviceID = args("deviceid")
        Item.ModuleID = args("moduleid")
        Item.CategoryID = args("categoryid")

        Item.StartDate = args("startdate")
        Item.DurationHour = args("durationhour")
        Item.DurationMin = args("durationmin")
        Item.Description = args("description")
        Item.LastEditBy = curUser
        Item.IsDeleted = 0
        Item.Save


        Response.Redirect(curRootFile & "/home")

    End Sub

    Public Sub FillPost(args)


        Session("standid") = Request.Form("fillid")

        Response.Redirect(curRootFile & "/home")

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