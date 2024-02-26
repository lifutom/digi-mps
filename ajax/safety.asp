<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    If Session("login") = "" Then
        Response.End
    End If

    RetJSON = List()

    Response.Write RetJSON
    Response.End

    Function List

        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 0
      
        Dim SQLStr : SQLStr = "SELECT TOP 100 *, CASE WHEN dateid >= '" & DigiSaftyStartDate & "' THEN (SELECT ISNULL(SUM(nearaccidentcnt),0) FROM  vwGoodCatchesDateDep WHERE departmentid=vwTierSafety.departmentid AND dateid=vwTierSafety.dateid) ELSE nearaccidentcnt END As goodcatchcnt FROM vwTierSafety ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   ''.Add "peopleid", Replace(Replace(CStr(Rs("peopleid")),"}",""),"{","")
                   .Add "safetyid", CStr(Rs("safetyid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "departmentid", CInt(Rs("departmentid"))
                   .Add "department", CStr(Rs("department"))
                   .Add "accidentcnt", CInt(Rs("accidentcnt"))
                   .Add "nearaccidentcnt", CInt(Rs("goodcatchcnt"))
                   .Add "incidentcnt", CInt(Rs("incidentcnt"))
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
%>