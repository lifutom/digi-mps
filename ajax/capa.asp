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

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierCapa ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   .Add "capaid", CStr(Rs("capaid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "departmentid", CInt(Rs("departmentid"))
                   .Add "department", CStr(Rs("department"))
                   .Add "capanb", CStr(Rs("capanb"))
                   .Add "capadescription", CStr(Rs("capadescription"))
                   .Add "capastart", CStr(DBFormatDate(Rs("capastart")))
                   .Add "capaclosed", CStr(IIf(IsNull(Rs("capaclosed")),"", DBFormatDate(Rs("capaclosed"))))
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