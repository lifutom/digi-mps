<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim PlantID : PlantID = Request.Form("plantid")
    Dim oJSON : Set oJSON = New aspJSON

    'Production'
    Dim SQLString : SQLString = "SELECT TOP 1 * FROM production WHERE end_time IS NULL AND plantid=" & PlantID & " ORDER BY start_time DESC"
    Dim Rs : Set Rs = DbExecute(SQLString)

    Dim ProdCnt : ProdCnt = 0
    Dim ProdIsRunning : ProdIsRunning = 0
    Dim StartTime : StartTime = ""

    If Not Rs.Eof Then
       ProdIsRunning = IIf(IsNull(Rs("end_time")), 1, 0)
       ProdCnt = 1
       StartTime = DBFormatISODate(Rs("start_time"))
    End If
    Rs.Close
   
    'DownTime'
    Dim DownCnt : DownCnt = 0
    Dim DownIsRunning : DownIsRunning=0

    SQLString = "SELECT count(*) As Cnt FROM downtime WHERE end_time IS NULL AND plantid=" & PlantID
    Set Rs = DbExecute(SQLString)
    DownCnt = Rs("Cnt")
    DownIsRunning = IIf(DownCnt > 0, 1, 0)
    Rs.Close

    DbCloseConnection()

    With oJSON.Data
        .Add "status", "OK"
        .Add "errmsg", ""
        .Add "prodcnt", ProdCnt
        .Add "prodisrunning", ProdIsRunning
        .Add "downcnt", DownCnt
        .Add "downisrunning", DownIsRunning
        .Add "start_time",StartTime
    End With

    Response.Write oJSON.JSONoutput()
    Response.End

%>