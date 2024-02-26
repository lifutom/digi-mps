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

        Dim oStream : Set oStream = New StreamType

        Dim SQLStr : SQLStr = "SELECT TOP 100 * FROM vwTierDeliveryBulk ORDER BY dateyear desc, datekw desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   .Add "deliverybulkid", CStr(Rs("deliverybulkid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "dateyear", CStr(Rs("dateyear"))
                   .Add "datekw", CStr(Rs("datekw"))
                   .Add "plantid", CInt(Rs("plantid"))
                   .Add "plant", CStr(Rs("plant"))
                   .Add "plannedcnt", CLng(Rs("plannedcnt"))
                   .Add "producedcnt", CLng(Rs("producedcnt"))
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