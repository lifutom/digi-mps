<%

Class HomeController

    Dim Model
    Dim ViewData
    Dim RoomList
    Dim RegionList
    Dim BuildingList

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
        Dim oRegion : Set oRegion = New Region
        Set RegionList = oRegion.DDList()
        Dim oBuilding : Set oBuilding = New Building
        Set BuildingList = oBuilding.DDList()

    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim Near : Set Near = New NearMiss
        Near.InitByCartID(Session("login"))

        Dim oList : Set oList = New Rooms
        Set RoomList = oList.ListByRegion(Near.BuildingID, Near.RegionID)


        ViewData.Add "nearmiss", Near
        ViewData.Add "regionlist", RegionList
        ViewData.Add "roomlist", RoomList
        ViewData.Add "buildinglist", BuildingList

        %>   <!--#include file="../views/Home/Index.asp" --> <%

    End Sub

    Public Sub Logout

        Session("login") = Login
        Session("IsGuest") = False

        Link = curRootFile & "/login.asp"

        Session.Abandon
        Response.Redirect(Link)

    End Sub

    public Sub IndexPost(args)


        Dim oUpload : Set oUpload = New clsUpload

        Dim Near : Set Near = New NearMiss

        Near.InitByCartID(Session("login"))
        Near.NearDate = oUpload("nmdate").Value
        Near.NearTime = oUpload("nmtime").Value


        Near.RoomID = oUpload("roomid").Value
        Near.UserID = Session("login")
        If oUpload("task").Value = "" Then
            Near.Task = ""
        Else
            Near.Task = oUpload("task").Value
        End If

        Near.AssignedToSPV = IIf(oUpload("assignedtospv").Value="","", oUpload("assignedtospv").Value)
        Near.SetTaskImageName(oUpload("neartaskimage"))

        If Near.Save2Cache Then
           Near.SaveTaskImage oUpload("neartaskimage"),"cache"
        End If

        Response.Redirect(curRootFile & "/home")

    End Sub


    public Sub Tasks


        ''Dim oUpload : Set oUpload = New clsUpload
        Dim Near : Set Near = New NearMiss


        Near.InitByCartID(Session("login"))


        Dim oList : Set oList = New Rooms
        Set RoomList = oList.ListByRegion(Near.BuildingID, Near.RegionID)

        Dim nHelper : Set nHelper = New NearHelper

        ViewData.Add "nearmiss", Near
        ViewData.Add "regionlist", RegionList
        ViewData.Add "roomlist", RoomList
        ViewData.Add "spvlist", nHelper.SPVItemList(Near.RoomID)
        ViewData.Add "buildinglist", BuildingList  

        %>   <!--#include file="../views/Home/tasks.asp" --> <%

    End Sub



    public Sub TasksPost(args)


        Dim oUpload : Set oUpload = New clsUpload

        Dim Near : Set Near = New NearMiss

        Near.InitByCartID(Session("login"))
        Near.NearDate = oUpload("nmdate").Value
        Near.NearTime = oUpload("nmtime").Value

        Near.RoomID = oUpload("roomid").Value

        Near.Description = oUpload("description").Value
        Near.CreatedBy = Session("login")
        Near.Created = Date
        Near.UserID = Session("login")
        Near.SetImageName(oUpload("nearimage"))

        If Near.Save2Cache Then
           Near.SaveImage oUpload("nearimage"),"cache"
        End If

        Response.Redirect(curRootFile & "/home/tasks")


    End Sub


    public Sub RoomPost(args)


        Dim oUpload : Set oUpload = New clsUpload

        Dim Near : Set Near = New NearMiss

        Near.InitByCartID(Session("login"))
        Near.NearDate = oUpload("nmdate").Value
        Near.NearTime = oUpload("nmtime").Value


        Near.RoomID = oUpload("roomid").Value
        Near.UserID = Session("login")
        If oUpload("task").Value = "" Then
            Near.Task = ""
        Else
            Near.Task = oUpload("task").Value
        End If
        Near.AssignedToSPV = ""
        Near.SetTaskImageName(oUpload("neartaskimage"))

        If Near.Save2Cache Then
           Near.SaveTaskImage oUpload("neartaskimage"),"cache"
        End If

        Response.Redirect(curRootFile & "/home/tasks")

    End Sub



    public Sub CreatePost(args)

        Dim oUpload : Set oUpload = New clsUpload

        Dim Near : Set Near = New NearMiss

        Near.InitByCartID(Session("login"))

        Near.NearDate = oUpload("nmdate").Value
        Near.NearTime = oUpload("nmtime").Value


        Near.RoomID = oUpload("roomid").Value
        Near.UserID = Session("login")
        Near.Task = oUpload("task").Value
        Near.AssignedToSPV = oUpload("assignedtospv").Value

        Near.SetTaskImageName(oUpload("neartaskimage"))
        Near.SaveTaskImage oUpload("neartaskimage"),"cache"

        Near.CreateNewMiss

        Response.Redirect(curRootFile & "/home")

    End Sub

End Class
%>