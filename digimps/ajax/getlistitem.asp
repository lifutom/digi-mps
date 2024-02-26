<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim PlantID : PlantID=Request.Form("plantid")


    Dim oJSON : Set oJSON = New aspJSON
    Dim lItem
    Dim x : x = 0
    Dim oHelper
    Dim oList

    Select Case  Request.Form("items")

        Case "control"

            Set oHelper = New PlantHelper
            Set oList = oHelper.ControlList(PlantID)

    End Select

    If oList.Count > 0 Then
        With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ""
            .Add "listitem" , oJSON.Collection()
            With .Item("listitem")
                For Each lItem In oList.Items
                    .Add x, oJSON.Collection()
                    With .Item(x)
                        .Add "id", lItem.id
                        .Add "name", ToUTF8(lItem.name)
                        .Add "enabled", lItem.enabled
                    End With
                    x=x+1
                Next
            End With
        End With
    Else
        With oJSON.Data
            .Add "status", "ERR"
            .Add "errmsg", "Fehler beim Holen der Componenten"
            .Add "listitem", ""
        End With
    End If

    Response.Write oJSON.JSONoutput()
    Response.End
%>