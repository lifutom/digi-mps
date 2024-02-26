<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    If Session("login") = "" Then
        Response.End
    End If



    RetJSON = PeopleList()


    Response.Write RetJSON
    Response.End

    Function PeopleList

        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 0

        Dim SQLStr : SQLStr = "SELECT TOP 100 * FROM vwTierPeople ORDER BY dateid desc, department"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   ''.Add "peopleid", Replace(Replace(CStr(Rs("peopleid")),"}",""),"{","")
                   .Add "peopleid", CStr(Rs("peopleid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "departmentid", CInt(Rs("departmentid"))
                   .Add "department", CStr(Rs("department"))
                   .Add "employeecnt", CInt(Rs("employeecnt"))
                   .Add "sickcnt", CInt(Rs("sickcnt"))
                   .Add "userid", CStr(Rs("userid"))
                   .Add "lastedit", DBFormatISODate(Rs("lastedit"))
               End With
               idx=idx+1
               Rs.MoveNext
            Loop
        End With
        PeopleList = oJSON.JSONoutput()
        Rs.Close
        Set Rs = Nothing

    End Function
%>