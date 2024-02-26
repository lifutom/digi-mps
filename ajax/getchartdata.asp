<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ListName : ListName = Request.Form("list")
    Dim ID : ID = Request.Form("id")
    Dim Level : Level = Request.Form("level")
    Dim LevelID : LevelID = Request.Form("levelid")
    Dim chtArea : chtArea = Request.Form("area")
    Dim Helper
    Dim JsonList

    Select Case ListName

        Case "devicechartcnt"
            Set Helper = New ProductionHelper
            JsonList = Helper.ChartData(Listname,ID, Level, LevelID)

        Case "devicechartmin"
            Set Helper = New ProductionHelper
            JsonList = Helper.ChartData(Listname,ID, Level, LevelID)

        Case "people"
            Set Helper = New PeopleHelper
            JsonList = Helper.ChartData(Listname,Level,ID, LevelID,"actual")

        Case "people_over"
            Set Helper = New PeopleHelper
            JsonList = Helper.ChartData(Listname,Level,ID, LevelID,"history")

        Case "safety"

            Set Helper = New SafetyHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "actual")

        Case "safety_over"
            Set Helper = New SafetyHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "history")

        Case "safety_near"
            Set Helper = New SafetyHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "near")

        Case "safety_inc"
            Set Helper = New SafetyHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "inc")

        Case "quality"
            Set Helper = New QualityHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "actual")

        Case "deliverypack_oee"
            Set Helper = New DeliveryPackHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "actualoee", chtArea)
        Case "deliverypack_output"
            Set Helper = New DeliveryPackHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "actualoutput", chtArea)

        Case "deliveryprod"
            Set Helper = New DeliveryBulkHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "actual", chtArea)

        Case "quality_over"
            Set Helper = New QualityHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "history")

        Case "quality_work"
            Set Helper = New QualityHelper
            JsonList = Helper.ChartData(Listname,Level,ID,LevelID, "work")

        Case Else
            Set Helper = New ProductionHelper
            JsonList = Helper.ChartData(Listname,ID, Level, LevelID)
            
    End Select

    Response.Write JsonList
    Response.End

%>