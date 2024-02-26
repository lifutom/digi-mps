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

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierOther ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   .Add "oid", CStr(Rs("oid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "departmentid", CInt(Rs("departmentid"))
                   .Add "department", CStr(Rs("department"))
                   .Add "ocatid", CStr(Rs("ocatid"))
                   .Add "ocatname", CStr(Rs("ocatname"))
                   .Add "odescription", CStr(Rs("odescription"))
                   .Add "ostart", CStr(DBFormatDate(Rs("ostart")))
                   .Add "oclosed", CStr(IIf(IsNull(Rs("oclosed")),"", DBFormatDate(Rs("oclosed"))))
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