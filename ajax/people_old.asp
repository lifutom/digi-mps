<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    If Session("login") = "" Then
        Response.End
    End If

    Dim oJSON : Set oJSON = New aspJSON
    Dim JSONString

    JSONString = BytesToStr(Request.BinaryRead(Request.TotalBytes))




    oJSON.loadJSON(JSONString)

    Dim Draw : Draw = oJSON.Data("draw")
    Dim LenghtInt :  LenghtInt = oJSON.Data("length")
    Dim StartInt: StartInt = oJSON.Data("start")

    Dim FieldList : Set FieldList = Server.CreateObject("Scripting.Dictionary")
    Dim Item
    Dim idx : idx = 0
    Dim RecordsTotal
    Dim RecordsFiltered

    For Each Item In oJSON.Data("columns").Items
        FieldList.Add idx, Item
        idx=idx+1
    Next


    Dim PList : PList = PeopleList(StartInt, LenghtInt )

    Response.Write "{""draw"":" & Draw & ", ""recordsTotal"": " & RecordsTotal & ", ""recordsFiltered"": " & RecordsFiltered & ",""data"":" & PList & "}"
    Response.End



    Function BytesToStr(bytes)
        Dim Stream
        Set Stream = Server.CreateObject("Adodb.Stream")
            Stream.Type = 1 'adTypeBinary
            Stream.Open
            Stream.Write bytes
            Stream.Position = 0
            Stream.Type = 2 'adTypeText
            Stream.Charset = "iso-8859-1"
            BytesToStr = Stream.ReadText
            Stream.Close
        Set Stream = Nothing
    End Function

    Function PeopleList (StartPos, PageSize)

        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx = 0

        Dim SQLStrCnt : SQLStrCnt = "SELECT COUNT(*) As Cnt FROM vwTierPeople"
        Dim SQLStr : SQLStr = "SELECT * FROM vwTierPeople ORDER BY dateid desc, department OFFSET " & IIf(StartPos > 0 , StartPos + 1, StartPos) & " ROWS FETCH NEXT " & PageSize & " ROWS ONLY"

        ''Response.Write SQLStr

        Dim RsCnt : Set RsCnt = DbExecute(SQLStrCnt)
        RecordsTotal = RsCnt("Cnt")
        RecordsFiltered = RsCnt("Cnt")


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