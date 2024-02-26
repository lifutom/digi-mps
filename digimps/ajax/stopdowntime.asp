<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim DowntimeID : DowntimeID = Request.Form("downtimeid")
    Dim EndTime : EndTime = Request.Form("start_time")

    Dim oDownTime : Set oDownTime = New DownTime



    oDownTime.DowntimeID = DowntimeID

    oDownTime.EndTime = EndTime

    Dim oJSON : Set oJSON = New aspJSON

    If oDownTime.StopDownTime Then
        With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ""
            .Add "time", CStr(oDownTime.EndTime)
        End With
    Else
        With oJSON.Data
            .Add "status", "ERR"
            .Add "errmsg", "Fehler beim Stoppen der Downtime"
            .Add "time", ""
        End With
    End If

    Response.Write oJSON.JSONoutput()
    Response.End
%>