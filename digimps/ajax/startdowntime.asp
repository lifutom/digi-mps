<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim PlantID : PlantID = Request.Form("plantid")
    Dim ControlID : ControlID = Request.Form("controlid")
    Dim StartTime : StartTime = Request.Form("start_time")
    Dim ProductionID : ProductionID = Request.Form("productionid")


    Dim oDownTime : Set oDownTime = New DownTime

    oDownTime.PlantID = PlantID
    oDownTime.StartTime = StartTime
    oDownTime.ControlID = ControlID
    oDownTime.ProductionID = ProductionID

    Dim oJSON : Set oJSON = New aspJSON


    If oDownTime.Add Then
        With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ""
            .Add "time", CStr(oDownTime.StartTime)
            .Add "downtimeid", oDownTime.DowntimeID
        End With
    Else
        With oJSON.Data
            .Add "status", "ERR"
            .Add "errmsg", "Fehler beim Starten der Downtime"
            .Add "time", ""
            .Add "downtimeid", -1
        End With
    End If

    Response.Write oJSON.JSONoutput()
    Response.End

%>