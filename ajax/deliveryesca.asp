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

        Dim SQLStr : SQLStr = "SELECT * FROM vwTierDeliveryEsca ORDER BY dateid desc"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        With oJSON.Data
            idx=0
            Do While Not Rs.Eof
               .Add idx, oJSON.Collection()
               With .Item(idx)
                   .Add "escaid", CStr(Rs("escaid"))
                   .Add "dateid", CStr(Rs("dateid"))
                   .Add "escadescription", CStr(Rs("escadescription"))
                   .Add "escatask", CStr(Rs("escatask"))
                   .Add "escastart", CStr(DBFormatDate(Rs("escastart")))
                   .Add "escaclosed", CStr(IIf(IsNull(Rs("escaclosed")),"", DBFormatDate(Rs("escaclosed"))))
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