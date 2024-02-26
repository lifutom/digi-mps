<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim PlantID : PlantID = Request.Form("plantid")
    Dim ControlID : ControlID = Request.Form("controlid")
    Dim UinNb : UinNb = Request.Form("uinnb")
    Dim BatchNb : BatchNb = Request.Form("batchnb")


    Dim oProduction : Set oProduction = New Production

    oProduction.PlantID = PlantID
    oProduction.StartTime = CStr(Now)
    oProduction.ControlID = ControlID
    oProduction.UinNb = UinNb
    oProduction.BatchNb = BatchNb


    Dim oJSON : Set oJSON = New aspJSON


    If oProduction.Start Then
        With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ""
            .Add "time", CStr(oProduction.StartTime)
            .Add "productionid", oProduction.ProductionID
        End With
    Else
        With oJSON.Data
            .Add "status", "ERR"
            .Add "errmsg", "Fehler beim Starten der Produktion"
            .Add "time", ""
            .Add "productionid", ""
        End With
    End If

    Response.Write oJSON.JSONoutput()
    Response.End

%>