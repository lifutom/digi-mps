<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim PlantID : PlantID = Request.Form("plantid")
    Dim ControlID : ControlID = Request.Form("controlid")
    Dim ProductionID : ProductionID = Request.Form("productionid")

    Dim SQLString : SQLString = "SELECT count(*) As Cnt FROM downtime WHERE end_time IS NULL AND productionid='" & ProductionID & "'"
   
    Dim Rs : Set Rs = DbExecute(SQLString)

    Dim oJSON : Set oJSON = New aspJSON

    Dim Cnt : Cnt = Rs("Cnt")

    DbCloseConnection()

    With oJSON.Data
        .Add "status", "OK"
        .Add "errmsg", ""
        .Add "cnt", Cnt
    End With

    Response.Write oJSON.JSONoutput()
    Response.End

%>