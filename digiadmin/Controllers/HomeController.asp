<%

Class HomeController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New ProductionHelper
        Dim ProdList : Set ProdList = pHelper.Overview

        Dim FirstItem : Set FirstItem = Nothing

        Dim DowntimeList : Set  DowntimeList = New MyDowntime
        Dim DTHelper : Set DTHelper = New DowntimeHelper
        Dim DTList
        If ProdList.Count > 0 Then
            Set FirstItem = ProdList.Items()(0)
            Set DTList = DTHelper.ListByProductionID(FirstItem.ProductionID)
        Else
            Set DTList = DTHelper.ListByProductionID("")
        End If

        ViewData.Add "overview", ProdList
        ViewData.Add "downtimelist", DTList
        ViewData.Add "firstitem", FirstItem

        %>   <!--#include file="../views/Home/Index.asp" --> <%

    End Sub

    public Sub SetDevice(vars)


        Dim pHelper : Set pHelper = New PlantHelper
        Dim oPlant
        Dim ActivePlant
        Dim ActiveDevice

        ActivePlantID =  Request.Cookies("linked_plant")
        ActiveDeviceID = vars("id")
        Response.Cookies("active_device") = ActiveDeviceID

        ''Set Environment for Linked Device'
        If ActivePlantID <> "" Then
           Set oPlant = pHelper.SetEnvForLinkedControl(ActivePlantID)
           If ActiveDeviceID = "" Then
              ActiveDeviceID = 1
           End If
        Else
           ' falls nicht gesetzt'
           ActivePlantID =  1
           ActiveDeviceID = 1
           Response.Cookies("linked_plant") = ActivePlantID
           Response.Cookies("active_device") = ActiveDeviceID
           Set oPlant = pHelper.SetEnvForLinkedControl(1)
        End If

        ''Response.Write  "ActivePlantID: " & ActivePlantID & "<br>"
        ''Response.Write  "ActiveDeviceID: " & ActiveDeviceID & "<br>"

        ViewData.Add "plant", oPlant
        ViewData.Add "active_plant", ActivePlantID
        ViewData.Add "active_device", ActiveDeviceID
        %>   <!--#include file="../views/Home/Index.asp" --> <%
    End Sub


End Class
%>