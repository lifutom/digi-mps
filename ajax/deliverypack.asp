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

        Dim SQLStr : SQLStr = "SELECT TOP 100 * FROM vwTierDeliveryPack ORDER BY dateid desc, Plant"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   .Add "deliverypackid", CStr(Rs("deliverypackid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "plantid", CInt(Rs("plantid"))
                   .Add "plant", CStr(Rs("plant"))
                   .Add "oeevalue", DBFormatNumber((Rs("oeevalue")))
                   .Add "outputcnt", CLng(Rs("outputcnt"))
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