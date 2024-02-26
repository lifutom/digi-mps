<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.CodePage = 65001
    Response.CharSet = "UTF-8"
%>
<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ItemName : ItemName = Request.Form("item")
    Dim ID : ID = Request.Form("id")
    Dim Lang : Lang = Request.Form("lang")
    Dim UserID : UserID = Request.Form("userid")

    Dim Item
    Dim oOutPut : Set oOutPut = Nothing

    Select Case ItemName
        Case "stillstand-item"
            Set Item = New StandItem
            Item.ID = ID
            Set oOutPut = Item.Serialize
            oOutPut.JSONoutput()
        Case Else
    End Select

    oOutPut.JSONoutput()

    If Not oOutPut Is Nothing Then

        Response.Write oOutPut.JSONoutput()
        Response.End

    Else

    End If

%>