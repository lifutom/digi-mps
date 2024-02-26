<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%
    Dim ItemType : ItemType = Request.Form("item")
    Dim ID : ID = Request.Form("id")
    Dim SQLStr
    Dim Rs
    Dim CloseDate

    Dim oJSON : Set oJSON = New aspJSON

    Select Case ItemType
        Case "tier_other_other"
            SQLStr = "SELECT oclosed FROM tier_other WHERE oid='" & ID & "'"
            Set Rs = DbExecute(SQLStr)
            If Not Rs.Eof Then
                CloseDate = Rs("oclosed")
            End If
            ''Response.Write SQLStr  & "<br>"
            ''Response.Write "Closed: " & CloseDate & "<br>"
            If IsNull(CloseDate) Or CloseDate="" Then
               CloseDate = DBFormatDate(Date)
               ''Response.Write CloseDate
               SQLStr = "UPDATE tier_other SET oClosed=CONVERT(date,'" & CloseDate & "') WHERE oid='" & ID & "'"
            Else
               SQLStr = "UPDATE tier_other SET oClosed=NULL WHERE oid='" & ID & "'"
            End If
            Rs.Close
        Case "tier_other_note"
            SQLStr = "SELECT onclosed FROM tier_othernote WHERE onid='" & ID & "'"
            Set Rs = DbExecute(SQLStr)
            If Not Rs.Eof Then
                CloseDate = Rs("onclosed")
            End If
            If IsNull(CloseDate) Or CloseDate="" Then
               CloseDate = Date
               SQLStr = "UPDATE tier_othernote SET onClosed=CONVERT(date,'" & CloseDate & "') WHERE onid='" & ID & "'"
            Else
               SQLStr = "UPDATE tier_othernote SET onClosed=NULL WHERE onid='" & ID & "'"
            End If
            Rs.Close
        Case "tier_safetyissue"
            SQLStr = "SELECT closed FROM tier_safetyissue WHERE id='" & ID & "'"
            Set Rs = DbExecute(SQLStr)
            If Not Rs.Eof Then
                CloseDate = Rs("closed")
            End If
            If IsNull(CloseDate) Or CloseDate="" Then
               CloseDate = Date
               SQLStr = "UPDATE tier_safetyissue SET Closed=CONVERT(date,'" & CloseDate & "') WHERE id='" & ID & "'"
            Else
               SQLStr = "UPDATE tier_safetyissue SET Closed=NULL WHERE id='" & ID & "'"
            End If
            Rs.Close
         Case "tier3_safetyissue"
            SQLStr = "SELECT closed3 FROM tier_safetyissue WHERE id='" & ID & "'"
            Set Rs = DbExecute(SQLStr)
            If Not Rs.Eof Then
                CloseDate = Rs("closed3")
            End If
            If IsNull(CloseDate) Or CloseDate="" Then
               CloseDate = Date
               SQLStr = "UPDATE tier_safetyissue SET Closed3=CONVERT(date,'" & CloseDate & "') WHERE id='" & ID & "'"
            Else
               SQLStr = "UPDATE tier_safetyissue SET Closed3=NULL WHERE id='" & ID & "'"
            End If
            Rs.Close
    End Select

    DbExecute(SQLStr)

    With oJSON.Data
            .Add "status", "OK"
            .Add "errmsg", ErrMsg
            .Add "id", ID
    End With

    Response.Write oJSON.JSONoutput()
    Response.End
%>