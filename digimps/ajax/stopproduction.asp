<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ProductionID : ProductionID = Request.Form("productionid")
    Dim Counter : Counter = Request.Form("counter")
    Dim EndTime : EndTime = Request.Form("endtime")
    Dim CounterBad : CounterBad = Request.Form("counterbad")


    Dim oProduction : Set oProduction = New Production

    oProduction.ProductionID = CStr(ProductionID)
    oProduction.Counter = Counter
    oProduction.CounterBad = CounterBad
    oProduction.EndTime = EndTime

    Dim oJSON : Set oJSON = New aspJSON

    If oProduction.PStop Then
        With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ""
            .Add "time", CStr(oProduction.StartTime)
        End With
    Else
        With oJSON.Data
            .Add "status", "ERR"
            .Add "errmsg", "Fehler beim Beenden der Produktion"
            .Add "time", ""
        End With
    End If

    Response.Write oJSON.JSONoutput()
    Response.End

%>