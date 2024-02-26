<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim PlantID : PlantID = Request.Form("plantid")
    Dim ControlID : ControlID = Request.Form("controlid")
    Dim task: Task = Request.Form("task")

    Dim oControl : Set oControl = New Control
    oControl.ControlID=ControlID


    If Task = "set" Then
       oControl.SetLink
    Else
       oControl.ClearLink
    End If

    Response.Cookies("ControlID")=ControlID

    Dim oJSON : Set oJSON = New aspJSON

    With oJSON.Data
        .Add "status", "OK"
        .Add "errmsg", ""
        .Add "controlid", ControlID
    End With



    Response.Write oJSON.JSONoutput()
    Response.End

    If Task <> "set" Then
       Session.Abandon
    End If

%>