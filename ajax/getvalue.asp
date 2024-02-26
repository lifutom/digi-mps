<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

Dim ValueName : ValueName = Request.Form("item")
Dim UserID : UserID = Request.Form("userid")
Dim ID : ID = Request.Form("id")

Dim SQLStr

Dim Ok : Ok = "NOTOK"
Dim Value1
Dim Value2

Select Case ValueName
    Case "user_department"
        SQLStr = "SELECT departmentid, departmentad as department FROM vwAdUserList WHERE isid='" & ID & "'"
End Select

Dim Rs : Set Rs = DbExecute(SQLStr)

If Not Rs.Eof Then
   Ok = "OK"
   Value1 = ToUTF8(Rs("departmentid"))
   Value2 = ToUTF8(Rs("department"))
Else
   Value = "N/A"
End If
Rs.Close
Set Rs = Nothing

Dim oJSON : Set oJSON = New aspJSON

With oJSON.Data
    .Add "status", OK
    .Add "departmentid", Value1
    .Add "department", Value2
    .Add "valuename", ValueName
End With

Response.Write oJSON.JSONoutput()
Response.End

%>