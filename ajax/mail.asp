<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim Typ : Typ = Request.Form("typ")
    Dim ID : ID = Request.Form("id")

    Dim oJSON : Set oJSON = New aspJSON

    Dim oItem
    Dim FileName

    Dim oMail : Set oMail = New Mail

    oMail.Subject = Decode(Request.Form("subject"))
    oMail.Body = Decode(Replace(Request.Form("body"),CHR(13), "<br>"))

    If Request.Form("ccemail") <> "" Then
        oMail.AddCC Request.Form("ccemail"),Request.Form("cctoname")
    End If

    oMail.AddAddress Request.Form("email"),Request.Form("toname")

    Select Case Typ

        Case "quote"
            Set oItem = New Quote
            oItem.ID = ID
            FileName = oItem.Receipt
            If FileName <> "" Then
                oMail.AddAttachment FileName
            End If
        Case Else
            FileName = ""
    End Select

    oMail.Send

    With oJSON.Data
        .Add "errnb", 0
        .Add "errmsg",oMail.ErrMsg
    End With

    Response.Write oJSON.JSONoutput()
    Response.End

%>