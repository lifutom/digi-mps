<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim DeviceID : DeviceID=Request.Form("deviceid")

    Dim oDevice : Set oDevice = New Device

    Dim oJSON : Set oJSON = New aspJSON

    Dim lItem
    Dim x : x = 0


    oDevice.DeviceID = DeviceID

    If oDevice.ComponentList.Count > 0 Then
        With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ""
            .Add "listitem" , oJSON.Collection()
            With .Item("listitem")
                For Each lItem In oDevice.ComponentList.Items
                    .Add x, oJSON.Collection()
                    With .Item(x)
                        .Add "componentid", lItem.componentid
                        .Add "component", ToUTF8(lItem.component)
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