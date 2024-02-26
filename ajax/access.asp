<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ItemType : ItemType = Request.Form("item")
    Dim GroupID : GroupID = Request.Form("groupid")
    Dim MenuID : MenuID = Request.Form("menuid")
    Dim Status : Status = "NOTOK"
    Dim ErrMsg : ErrMsg = ""
    Dim Item
    Dim ItemID
    Dim oGroup : Set oGroup = New GroupHelper

    Dim oJSON : Set oJSON = New aspJSON

    Select Case ItemType

        Case "toggle"

            Item = oGroup.ToggleAccess(GroupID, MenuID)

            If Item Then
               Status = "OK"
            Else
               ErrMsg = "Zugriff konnte nicht geändert werden"
            End If

    End Select

    With oJSON.Data
            .Add "status", Status
            .Add "errmsg", ErrMsg
            .Add "groupid", GroupID
            .Add "menuid", MenuID
    End With

    Response.Write oJSON.JSONoutput()
    Response.End

%>