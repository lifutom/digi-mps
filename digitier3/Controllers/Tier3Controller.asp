<%

Class Tier3Controller

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
        Dim StreamType : StreamType = "all"

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
           Perc = Round(Kr/MA * 100,2)
        End If



        ViewData.Add "deplist", DepList
        ViewData.Add "dateid", DateID
        ViewData.Add "ma", MA
        ViewData.Add "kr", Kr
        ViewData.Add "perc", Perc
        ViewData.Add "sickfactor", SickFactor

        %>   <!--#include file="../views/tier3/people.asp" --> <%

    End Sub


    Public Sub Safety()

        Dim Helper : Set Helper = New SafetyHelper
        Dim StreamType : StreamType = "all"
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))


        Dim DepList : Set DepList = Helper.DepartmentList("all", DateID)
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
        ViewData.Add "dayssincelastinc", Helper.DaysSinceLastInc

        %>   <!--#include file="../views/tier3/safety.asp" --> <%

    End Sub


    Public Sub SafetyIssue()

        Dim Helper : Set Helper = New SafetyIssueHelper
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))

        ViewData.Add "list", Helper.OpenList("tier3")
        ViewData.Add "dateid", DateID

        %>   <!--#include file="../views/tier3/safetyissue.asp" --> <%

    End Sub

    Public Sub Quality()

        Dim Helper : Set Helper = New QualityHelper
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))

        Dim ComplHelper : Set ComplHelper = New CHelper
        Dim CompList : Set CompList = ComplHelper.CList()
        Dim Escalation : Set Escalation = New QualityEscaHelper

        ViewData.Add "dateid", DateID
        ViewData.Add "eventopenedcnt", EventOpenedCnt
        ViewData.Add "eventclosedcnt", EventClosedCnt
        ViewData.Add "comlaints", CompList
        ViewData.Add "escalationlist", Escalation.OpenEscaList()


        %>   <!--#include file="../views/tier3/quality.asp" --> <%

    End Sub

    Public Sub DeliveryPack()

        Dim Helper : Set Helper = New DeliveryPackHelper
        Dim pHelper : Set pHelper = New DeliveryBulkHelper


        Dim StreamType : StreamType = CurStreamType
        Session("Area") = "pack"
        Dim Area : Area = Session("area")
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))

        Dim LineList : Set LineList = Helper.PlantList(StreamType, Area, DateID)

        Dim ProdList : Set ProdList = pHelper.PlantList("","prod", DateID)

        Dim Escalation : Set Escalation = New DeliveryEscaHelper

        ViewData.Add "curcw", Datepart("ww",DateID)
        ViewData.Add "dateid", DateID
        ViewData.Add "plantlist", LineList
        ViewData.Add "prodlist", ProdList
        ViewData.Add "escalationlist", Escalation.OpenEscaList()
        %>   <!--#include file="../views/tier3/deliverypack.asp" --> <%

    End Sub



    Public Sub QualityHour()

        Dim Helper : Set Helper = New DeliveryPackHelper
        Dim StreamType : StreamType = CurStreamType
        Session("Area") = "pack"
        Dim Area : Area = Session("area")

        Dim QualityHourPath : QualityHourPath = GetPhysicalPath("qh")
        
        ViewData.Add "qualityhour", Helper.OpenExcel (QualityHourPath,"KW " & glKW(Date))

        %>   <!--#include file="../views/tier3/qualityhour.asp" --> <%

    End Sub

    Public Sub DeliveryCritical()

        Dim Helper : Set Helper = New DeliveryPackHelper
        Dim StreamType : StreamType = CurStreamType
        Session("Area") = "pack"
        Dim Area : Area = Session("area")

        Dim CriticalStockPath : CriticalStockPath = GetPhysicalPath("crst")
      
        ViewData.Add "criticalstock", HtmlCriticalStock

        %>   <!--#include file="../views/tier3/deliverycritical.asp" --> <%

    End Sub

    Public Sub Other()

        Dim Helper : Set Helper = New DeliveryBulkHelper
        Dim StreamType : StreamType = CurStreamType

        Session("Area") = "prod"

        Dim Area : Area = Session("area")
        Dim DateID : DateID = IIf(Session("dateid")="",curWorkDay,Session("dateid"))

        Dim LineList : Set LineList = Helper.PlantList(StreamType, Area, DateID)

        ViewData.Add "dateid", DateID
        ViewData.Add "plantlist", LineList

        %>   <!--#include file="../views/tier3/deliveryprod.asp" --> <%

    End Sub

    Public Sub CostWaste()

        Dim Helper : Set Helper = New OHelper
        Dim noteHelper : Set noteHelper = New OnHelper

        Dim StreamType : StreamType = CurStreamType
        Session("Area") = "pack"
        Dim Area : Area = Session("area")
        Dim DateID : DateID = IIf(Session("dateid")="",DBFormatDate(Date) ,Session("dateid"))

        Dim CatList : Set CatList = Helper.CatList
        Dim Cat
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim cList
        Dim cItem
        For Each Cat In CatList.Items
            Set cList = Helper.OListByCatID (DateID,  Cat.Value)
            ''If cList.Count > 0 Then
                Set cItem = New OListItem
                cItem.CatID = Cat.Value
                cItem.Cat = Cat.Name
                Set cItem.ItemList = cList
                List.Add cItem.CatID, cItem
            ''End If
        Next

        Dim coList : Set coList = noteHelper.ONListByDate(DateID)
        Set cItem = New OListItem
        cItem.CatID = 99
        cItem.Cat = "Other"
        Set cItem.ItemList = coList
        List.Add cItem.CatID, cItem

        ViewData.Add "dateid", DateID
        ViewData.Add "list", List

        %>   <!--#include file="../views/tier3/costwaste.asp" --> <%

    End Sub

End Class

%>