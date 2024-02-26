<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ID : ID=Request.Form("componentid")
    Dim Typ : Typ=IIf(Request.Form("typ") = "", "linked", Request.Form("typ"))

    Dim oPlantHelper : Set oPlantHelper = New PlantHelper

    Dim oJSON : Set oJSON = New aspJSON

    Dim lItem
    Dim x : x = 0

    Dim FailureList

    If Typ = "linked" Then
       Set FailureList = oPlantHelper.GetFailureListByID(ID)
    Else
       Set FailureList = oPlantHelper.GetFailureListExt()
    End If


    If FailureList.Count > 0 Then
        With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ""
            .Add "listitem" , oJSON.Collection()
            With .Item("listitem")
                For Each lItem In FailureList.Items
                    .Add x, oJSON.Collection()
                    With .Item(x)
                        .Add "failureid", lItem.FailureID
                        .Add "failure", ToUTF8(lItem.Failure)
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