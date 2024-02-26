<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%
    Dim Login : Login = Request.Form("login")
    Dim Password : Password = Request.Form("password")
    Dim Access : Access = Request.Form("access")

    Dim AD : Set AD = New ADAccess
    Dim DigiMPSAD : Set DigiMPSAD = New DigiMPSAccess

    Dim oJSON : Set oJSON = New aspJSON

    Dim LogSuccess : LogSuccess = "NOTOK"
    If AD.AuthenticateUser(Login,Password) Then
       LogSuccess = "OK"
    End If

    Dim ErrMsg : ErrMsg = ""
    Dim IsAccess : IsAccess = "NOTOK"

    Select Case Access
        Case "admin"
            If DigiMPSAD.IsAdmin(Login) Then
               IsAccess = "OK"
            Else
               LogSuccess = "NOTOK"
               ErrMsg = "Sie haben keine Berechtigung für die Zuordnung einer Kontrolleinheit"
            End If
        Case Else
            If DigiMPSAD.IsAdmin(Login) Then
               IsAccess = "OK"
            Else
               LogSuccess = "NOTOK"
               ErrMsg = "Sie haben keine Berechtigung für die Zuordnung einer Kontrolleinheit"
            End If
    End Select

    With oJSON.Data
        .Add "status", "OK"
        .Add "errmsg", ErrMsg
        .Add "login", LogSuccess
        .Add "access",IsAccess
    End With
    Response.Write oJSON.JSONoutput()
    Response.End
%>