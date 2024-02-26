<%

Class OverviewController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Production()

        Dim pHelper : Set pHelper = New ProductionHelper
        Dim ProdList : Set ProdList = pHelper.EmptyOverview


        Dim plHelper : Set plHelper = New PlantHelper
        Dim pSearch : Set pSearch = New DowntimeSearch

        ViewData.Add "search", pSearch
        ViewData.Add "lines",  plHelper.DDList("","")

        ViewData.Add "overview", ProdList

        %>   <!--#include file="../views/Overview/production.asp" --> <%

    End Sub

    Public Sub ProductionPost(args)

        Dim pHelper : Set pHelper = New ProductionHelper
        Dim ProdList : Set ProdList = pHelper.EmptyOverview

        Dim plHelper : Set plHelper = New PlantHelper
        Dim pSearch : Set pSearch = New ProductionSearch

        pSearch.StartDate = Request.Form("start")
        pSearch.EndDate = Request.Form("end")
        pSearch.PlantID = Request.Form("plantid")
        pSearch.UIN = Request.Form("uin")
        pSearch.Batch = Request.Form("batch")

        Dim List : Set List = pHelper.AllOverview(pSearch)

        ViewData.Add "search", pSearch
        ViewData.Add "lines",  plHelper.DDList("","")
        ViewData.Add "overview", List

        %>   <!--#include file="../views/Overview/production.asp" --> <%

    End Sub

    Public Sub ProductionEdit(param)

        Dim ptItem : Set ptItem = New MyProduction

        ptItem(param("id"))

        ViewData.Add "idx", param("idx")
        ViewData.Add "production", ptItem
        %>   <!--#include file="../views/Overview/productionedit.asp" --> <%

    End Sub

    Public Sub ProductionEditPost(args)

        Dim ptItem : Set ptItem = New MyProduction

        ptItem(Request.Form("id"))
        ''Response.Write "ID: " & Request.Form("id") & "<br>"
        ''Response.Write "Start: " & Request.Form("start") & " " & Left(Request.Form("start_time"),5) & "<br>"
        ''Response.Write "End: " & Request.Form("end") & " " & Left(Request.Form("end_time"),5) & "<br>"
        ptItem.StartTime = CDate(DBFormatDate(Request.Form("start")) & " " & Left(Request.Form("start_time"),5))
        ptItem.EndTime = CDate(DBFormatDate(Request.Form("end")) & " " & Left(Request.Form("end_time"),5))
        ptItem.Counter = Request.Form("counter")
        ptItem.CounterBad = Request.Form("counterbad")
        ptItem.Save

        ViewData.Add "idx", args("idx")
        ViewData.Add "production", ptItem
        %>   <!--#include file="../views/Overview/productionedit.asp" --> <%

    End Sub





    Public Sub Downtime()

        Dim pHelper : Set pHelper = New DowntimeHelper
        Dim List : Set List = pHelper.EmptyOverview
        Dim Auto : Auto = ""

        Dim plHelper : Set plHelper = New PlantHelper
        Dim pSearch : Set pSearch = New DowntimeSearch

        ViewData.Add "search", pSearch
        ViewData.Add "lines",  plHelper.DDList("","")
        ViewData.Add "devices", plHelper.DeviceListDD("-1",True)
        ViewData.Add "overview", List

        %>   <!--#include file="../views/Overview/downtime.asp" --> <%

    End Sub




    Public Sub DowntimePost(args)

        Dim pHelper : Set pHelper = New DowntimeHelper

        Dim Auto : Auto = ""

        Dim plHelper : Set plHelper = New PlantHelper
        Dim pSearch : Set pSearch = New DowntimeSearch

        pSearch.StartDate = Request.Form("start")
        pSearch.EndDate = Request.Form("end")
        pSearch.PlantID = Request.Form("plantid")
        pSearch.DeviceID = Request.Form("deviceid")
        pSearch.UIN = Request.Form("uin")
        pSearch.Batch = Request.Form("batch")

        Dim List : Set List = pHelper.AllOverview(pSearch)

        ViewData.Add "search", pSearch
        ViewData.Add "lines",  plHelper.DDList("","")
        ViewData.Add "devices", plHelper.DeviceListDD(pSearch.PlantID,True)
        ViewData.Add "overview", List

        %>   <!--#include file="../views/Overview/downtime.asp" --> <%

    End Sub


    public Sub DowntimeEdit(param)

        Dim ptItem : Set ptItem = New MyDownTime
        Dim pHelper : Set pHelper = New DowntimeHelper
        Dim List : Set List = pHelper.EmptyOverview
        Dim Auto : Auto = ""

        Dim plHelper : Set plHelper = New PlantHelper

        ptItem.DownTimeID = param("id")

        ViewData.Add "idx", param("idx")
        ViewData.Add "downtime", ptItem
        ViewData.Add "failure", plHelper.GetFailureListByID(ptItem.ComponentID)
        %>   <!--#include file="../views/Overview/downtimeedit.asp" --> <%

    End Sub

    Public Sub DowntimeEditPost(args)

        Dim ptItem : Set ptItem = New MyDownTime
        Dim plHelper : Set plHelper = New PlantHelper



        ptItem.DownTimeID = Request.Form("id")
        ptItem.StartTime = CDate(DBFormatDate(Request.Form("start")) & " " & Left(Request.Form("start_time"),5))
        
        If Request.Form("end_time") <> "" Then
            ptItem.EndTime = IIf(Request.Form("end_time") <> "" And Request.Form("end") <> "" ,CDate(DBFormatDate(Request.Form("end")) & " " & Left(Request.Form("end_time"),5)),"")
        Else
            ptItem.EndTime = ""
        End If
        ptItem.FailureID = Request.Form("failureid")
        ptItem.Save

        ViewData.Add "idx", args("idx")
        ViewData.Add "downtime", ptItem
        ViewData.Add "failure", plHelper.GetFailureListByID(ptItem.ComponentID)
        %>   <!--#include file="../views/Overview/downtimeedit.asp" --> <%

    End Sub


    public Sub DowntimeByID(param)



        Dim oProd : Set oProd = New ProductionHelper
        Dim pHelper : Set pHelper = New DowntimeHelper
        Dim List : Set List = pHelper.ListByProductionID(param("id"))


        Dim ProdInfo : Set ProdInfo = oProd.GetByID(param("id"))
        Dim Auto : Auto = param("auto")

        ViewData.Add "overview", List
        ViewData.Add "production", ProdInfo

        %>   <!--#include file="../views/Overview/downtimedetail.asp" --> <%

    End Sub


    public Sub DeviceGraph(param)

        Dim oProd : Set oProd = New ProductionHelper
        Dim ProdInfo : Set ProdInfo = oProd.GetByID(param("id"))

        Dim oPlant : Set oPlant = New Plant
        oPlant.InitObject(ProdInfo.PlantID)

        Dim DeviceList : Set DeviceList = oPlant.DeviceList

        Dim List : List = IIf(param("listname") = "", "devicechartcnt",param("listname"))

        ''Response.Write List
        ''Response.End


        ViewData.Add "datalist", List
        ViewData.Add "devicelist", DeviceList      
        ViewData.Add "production", ProdInfo

        %>   <!--#include file="../views/Overview/prodbarchart.asp" --> <%

    End Sub


End Class
%>