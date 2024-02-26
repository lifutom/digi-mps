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

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierComplaint ORDER BY cnb"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   .Add "cid", CStr(Rs("cid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "cnb", CStr(Rs("cnb"))
                   .Add "cnumber", CStr(Rs("cnumber"))
                   .Add "cproduct", CStr(Rs("cproduct"))
                   .Add "cdescription", CStr(Rs("cdescription"))
                   .Add "ccountry", CStr(Rs("ccountry"))
                   .Add "creason", CStr(Rs("creason")) 
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