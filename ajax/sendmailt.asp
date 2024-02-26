<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ItemType : ItemType = Request.Form("item")
    Dim ID : ID = Request.Form("id")
    Dim Status : Status = "NOTOK"
    Dim ErrMsg : ErrMsg = ""
    Dim ErrNumber
    Dim Item
    Dim ItemID

    Dim oJSON : Set oJSON = New aspJSON


    Select Case ItemType

        Case "neartest"

        Set Item = New NearMiss
        Item.Init(ID)
        ItemID = "Item.NearID"

    End Select


    Dim Mail : Set Mail = New Email
    Item.SendMail

    Mail.SendNearMissMail(ID)

    ID = eval(ItemID)
    With oJSON.Data
        .Add "status", Item.ErrStatus
        .Add "errmsg", Item.ErrMsg
        .Add "errnumber", Item.ErrNumber
        .Add "id", CLng(ID)
    End With
    Response.Write oJSON.JSONoutput()
    Response.End

%>