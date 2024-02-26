<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim DowntimeID : DowntimeID = Request.Form("downtimeid")
    Dim ProductionID : ProductionID = Request.Form("productionid")
    Dim DeviceID : DeviceID = Request.Form("deviceid")
    Dim ComponentID : ComponentID = Request.Form("componentid")
    Dim FailureID : FailureID = Request.Form("failureid")
    Dim Description : Description = Request.Form("description")
    Dim StartTime : StartTime = Request.Form("start_time")
    Dim EndTime : EndTime = Request.Form("end_time")

    Dim oDownTime : Set oDownTime = New DownTime

    oDownTime.DowntimeID = DowntimeID
    oDownTime.DeviceID = DeviceID
    oDownTime.ComponentID = ComponentID
    oDownTime.FailureID = FailureID
    oDownTime.Description = Description
    oDownTime.StartTime = StartTime
    oDownTime.EndTime = EndTime

    Dim oJSON : Set oJSON = New aspJSON

    If oDownTime.Save Then
        With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ""
        End With
    Else
        With oJSON.Data
            .Add "status", "ERR"
            .Add "errmsg", "Fehler beim Stoppen der Downtime"
        End With
    End If

    Response.Write oJSON.JSONoutput()
    Response.End
%>