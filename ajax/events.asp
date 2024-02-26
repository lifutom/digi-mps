<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    If Session("login") = "" Then
        Response.End
    End If


    Dim Fu : Fu = Request.Form("fu")

    Select Case Fu
        Case "list"
            RetJSON = List()
        Case "tier3list"
            RetJSON = Tier3List()
    End Select

    Response.Write RetJSON
    Response.End




    Function List

        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 0

        Dim SQLStr : SQLStr = "SELECT TOP 100 * FROM vwTierEvents ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   .Add "eventid", CStr(Rs("eventid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "departmentid", CInt(Rs("departmentid"))
                   .Add "department", CStr(Rs("department"))
                   .Add "eventnb", CStr(Rs("eventnb"))
                   .Add "eventdescription", CStr(Rs("eventdescription"))
                   .Add "eventstart", CStr(DBFormatDate(Rs("eventstart")))
                   .Add "eventclosed", CStr(IIf(IsNull(Rs("eventclosed")),"", DBFormatDate(Rs("eventclosed"))))
                   .Add "userid", CStr(Rs("userid"))
                   .Add "lastedit", DBFormatISODate(Rs("lastedit"))
               End With
               idx=idx+1
               Rs.MoveNext
            Loop
        End With
        List = oJSON.JSONoutput()
        Rs.Close
        Set Rs = Nothing

    End Function

    Function Tier3List

        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 0

        Dim SQLStr : SQLStr = "SELECT * FROM tier3_events ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   .Add "eventid", CStr(Rs("eventid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "raisedcnt", CInt(Rs("raisedcnt"))
                   .Add "userid", CStr(Rs("userid"))
                   .Add "lastedit", DBFormatISODate(Rs("lastedit"))
               End With
               idx=idx+1
               Rs.MoveNext
            Loop
        End With
        Tier3List = oJSON.JSONoutput()
        Rs.Close
        Set Rs = Nothing

    End Function

%>