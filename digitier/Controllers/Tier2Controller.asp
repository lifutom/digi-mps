<%

Class Tier2Controller

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        People

    End Sub

    Public Sub People()

        Dim Helper : Set Helper = New PeopleHelper
        Dim StreamType : StreamType = CurStreamType

        Dim DateID : DateID = DBFormatDate(Date)
        Dim DepItem

        Dim SickFactor : SickFactor = GetAppSettings("sick_factor")

        Dim DepList : Set DepList = Helper.PeopleDepartmentList(StreamType, DateID, SickFactor)

        Dim MA : MA = 0
        Dim Kr : Kr = 0
        Dim Perc : Perc = 0

        For Each DepItem In DepList.Items
            MA = MA + DepItem.EmployeeCnt
            Kr = Kr + DepItem.SickCnt
        Next

        If MA > 0 Then
           Perc = Round(Kr/MA * 100)
        End If



        ViewData.Add "deplist", DepList
        ViewData.Add "dateid", DateID
        ViewData.Add "ma", MA
        ViewData.Add "kr", Kr
        ViewData.Add "perc", Perc
        ViewData.Add "sickfactor", SickFactor

        %>   <!--#include file="../views/tier2/people.asp" --> <%

    End Sub


    Public Sub Safety()

        Dim Helper : Set Helper = New SafetyHelper
        Dim StreamType : StreamType = CurStreamType
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))

        Dim DepList : Set DepList = Helper.DepartmentList(StreamType, DateID)
        Dim dItem

        Dim AccidentCnt : AccidentCnt = 0
        Dim NearAccidentCnt : NearAccidentCnt = 0
        Dim IncidentCnt : IncidentCnt = 0

        For Each dItem In DepList.Items
            AccidentCnt = AccidentCnt + dItem.AccidentCnt
            NearAccidentCnt = NearAccidentCnt + dItem.NearAccidentCnt
            IncidentCnt = IncidentCnt + dItem.IncidentCnt
        Next

        ViewData.Add "deplist", DepList
        ViewData.Add "dateid", DateID
        ViewData.Add "accidentcnt", AccidentCnt
        ViewData.Add "nearaccidentcnt", NearAccidentCnt
        ViewData.Add "incidentcnt", IncidentCnt



        %>   <!--#include file="../views/tier2/safety.asp" --> <%

    End Sub

    Public Sub SafetyIssue()

        Dim Helper : Set Helper = New SafetyIssueHelper
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))

        ViewData.Add "list", Helper.OpenList("tier3")
        ViewData.Add "dateid", DateID

        %>   <!--#include file="../views/tier2/safetyissue.asp" --> <%

    End Sub

    Public Sub Quality()

        Dim Helper : Set Helper = New QualityHelper
        Dim StreamType : StreamType = CurStreamType
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))

        Dim DepList : Set DepList = Helper.DepartmentList(StreamType, DateID)
        Dim dItem

        Dim EventOpenedCnt : EventOpenedCnt = 0
        Dim EventClosedCnt : EventClosedCnt = 0

        For Each dItem In DepList.Items
            EventOpenedCnt = EventOpenedCnt + dItem.EventOpenedCnt
            EventClosedCnt = EventClosedCnt + dItem.EventClosedCnt
        Next

        ViewData.Add "deplist", DepList
        ViewData.Add "dateid", DateID
        ViewData.Add "eventopenedcnt", EventOpenedCnt
        ViewData.Add "eventclosedcnt", EventClosedCnt


        %>   <!--#include file="../views/tier2/quality.asp" --> <%

    End Sub

    Public Sub QualityHour()

        Dim Helper : Set Helper = New DeliveryPackHelper
        Dim StreamType : StreamType = CurStreamType
        Session("Area") = "pack"
        Dim Area : Area = Session("area")

        Dim QualityHourPath : QualityHourPath = GetPhysicalPath("qh")

        ViewData.Add "qualityhour", Helper.OpenExcel (QualityHourPath,"KW " & glKW(date))

        %>   <!--#include file="../views/tier2/qualityhour.asp" --> <%

    End Sub

    Public Sub DeliveryPack()

        Dim Helper : Set Helper = New DeliveryPackHelper
        Dim StreamType : StreamType = CurStreamType
        Session("Area") = "pack"
        Dim Area : Area = Session("area")
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))

        Dim LineList : Set LineList = Helper.PlantList(StreamType, Area, DateID)
        Dim OverView : Set OverView = Helper.OEEActual(StreamType, Area, DateID)


        ViewData.Add "dateid", DateID
        ViewData.Add "plantlist", LineList
        ViewData.Add "overview", OverView

        %>   <!--#include file="../views/tier2/deliverypack.asp" --> <%

    End Sub

    Public Sub DeliveryProd()

        Dim Helper : Set Helper = New DeliveryBulkHelper
        Dim StreamType : StreamType = CurStreamType

        Session("Area") = "prod"

        Dim Area : Area = Session("area")
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))


        Dim LineList : Set LineList = Helper.PlantList(StreamType, Area, DateID)

        ViewData.Add "dateid", DateID
        ViewData.Add "plantlist", LineList

        %>   <!--#include file="../views/tier2/deliveryprod.asp" --> <%

    End Sub

End Class

%>