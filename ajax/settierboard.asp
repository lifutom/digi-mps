<!--#include file="../utils/utils.asp" -->
<%

    If InStr(Request.Form("item"),"_") > 0 Then

        Dim Arr : Arr = Split(Request.Form("item"),"_")

        Session("tierboard") = Arr(0)
        Session("tierstream") = Arr(1)

    Else
        Session("tierboard") = Request.Form("item")
        Session("tierstream") = ""
    End If

    Dim oJSON : Set oJSON = New aspJSON

    With oJSON.Data
        .Add "status","OK"
        .Add "errmsg",""
        .Add "tierboard",Session("tierboard")
    End With

    Response.Write oJSON.JSONoutput()
    Response.End

%>