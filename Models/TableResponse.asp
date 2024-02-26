<%
Class TableColumn
    Public ColumnNb
    Public Data
    Public Name
    Public Searchable
    Public Orderable
    Public SearchValue
    Public SearchRegEx
End Class

Class OrderColumn
    Public ColumnNb
    Public Column
    Public Direction
End Class

Class TableResponse

    Private prvResponse

    Public Property Get WebResponse
        WebResponse = prvResponse
    End Property
    Public Property Let WebResonse (ByVal Value)
        Init(Value)
    End Property

    Public DrawNb
    Public StartPage
    Public PageLength
    Public Offset
    Public SearchValue
    Public SearchRegEx
    Public RecordsTotal
    Public RecordsFiltered

    Public ColumnList
    Public OrderList

    Public DataList


    Private prvLang


    Private Sub Class_Initialize()

        prvLang = IIf(Session("lang") = "","de",Session("lang"))
        Set ColumnList = Server.CreateObject( "Scripting.Dictionary")
        Set OrderList = Server.CreateObject( "Scripting.Dictionary")

    End Sub

    Public Default Sub Init (ByVal Value)



        Set prvResponse = Value
        DrawNb = prvResponse.Form("draw")
        StartPage = prvResponse.Form("start")
        Offset = StartPage
        PageLength = prvResponse.Form("length")

        ''Offset = StartPage * PageLength

        SearchValue = prvResponse.Form("search[value]")
        SearchRegEx = IIf(prvResponse.Form("search[regex]") = "false", False, True)

        Dim ColIdx : ColIdx = 0

        Dim testField : testField =  prvResponse.Form("columns[" & ColIdx &  "][searchable]")
        Dim Item
        Do While testField <> ""
            Set Item = New TableColumn
            Item.ColumnNb = ColIdx
            Item.Data = prvResponse.Form("columns[" & Item.ColumnNb & "][data]")
            Item.Name = prvResponse.Form("columns[" & Item.ColumnNb & "][name]")
            Item.Searchable = IIf(prvResponse.Form("columns[" & Item.ColumnNb & "][searchable]") = "false", False,True)
            Item.Orderable = IIf(prvResponse.Form("columns[" & Item.ColumnNb & "][orderable]") = "false", False,True)
            Item.SearchValue = prvResponse.Form("columns[" & Item.ColumnNb & "][search][value]")
            Item.SearchRegEx = IIf(prvResponse.Form("columns[" & Item.ColumnNb & "][search][regex]") = "false",False, True)
            ColumnList.Add Item.ColumnNb, Item
            ColIdx = ColIdx + 1
            testField =  prvResponse.Form("columns[" & ColIdx &  "][searchable]")
        Loop



        ColIdx = 0
        testField =  prvResponse.Form("order[" & ColIdx &  "][column]")
        Do While testField <> ""
            Set Item = New OrderColumn
            Item.ColumnNb = ColIdx
            Item.Column = prvResponse.Form("order[" & Item.ColumnNb & "][column]")
            Item.Direction = prvResponse.Form("order[" & Item.ColumnNb & "][dir]")
            OrderList.Add Item.ColumnNb, Item
            ColIdx = ColIdx + 1
            testField =  prvResponse.Form("order[" & ColIdx &  "][column]")
        Loop

    End Sub

    Public Function FieldListAsText
        Dim StrField : StrField = ""
        Dim Item
        For Each Item In ColumnList.Items
            If Item.Data <> "" Then
                StrField = StrField & Item.Data & ","
            End If
        Next
        FieldListAsText = Left(StrField, Len(StrField) - 1)

    End Function

    Public Function OrderListAsText
        Dim StrField : StrField = ""
        Dim Item
        For Each Item In OrderList.Items

            StrField = StrField & ColumnList(Item.ColumnNb).Data & " " & Item.Direction & ","

        Next
        OrderListAsText = Left(StrField, Len(StrField) - 1)
    End Function

    Public Function SQLFilter

        Dim StrField : StrField = ""
        Dim Item
        If SearchValue <> "" AND Len(SearchValue) > 1 Then
            For Each Item In ColumnList.Items
                If Item.Data <> "" Then
                    If StrField = "" Then
                        StrField = StrField & "CONVERT(nvarchar(255)," & Item.Data & ") LIKE '%" & SearchValue &  "%'"
                    Else
                        StrField = StrField & " OR CONVERT(nvarchar(255)," & Item.Data & ") LIKE '%" & SearchValue &  "%'"
                    End If
                End If
            Next
            StrField = " AND (" & StrField & ")"
        End If
        SQLFilter = strField

    End Function

    Public Function ToJSON(ByVal ListName)

        Dim SQLStr
        Dim SQLStrDefault

        Dim AddFilter


        Select Case ListName
            Case "request-group-header"
                SQLStr = "SELECT " & FieldListAsText & ", maxrows = COUNT(*) OVER()  FROM tblRequestGroup('" & prvLang & "') WHERE isdefault=0 " & SQLFilter & " ORDER BY " & OrderListAsText & " OFFSET " & Offset & " ROWS FETCH NEXT " & PageLength & " ROWS ONLY"
                SQLStrDefault = "SELECT COUNT(*) As maxrows FROM tblRequestGroup('" & prvLang & "') WHERE isdefault=0"

            Case "stand-list"

                AddFilter = ""
                If prvResponse.Form("plantid") <> "" Then
                   AddFilter = " AND plantid=" & prvResponse.Form("plantid")
                End If

                If prvResponse.Form("deviceid") <> "" Then
                   AddFilter = AddFilter & " AND deviceid=" & prvResponse.Form("deviceid")
                End If

                If prvResponse.Form("moduleid") <> "" Then
                   AddFilter = AddFilter & " AND moduleid=" & prvResponse.Form("moduleid")
                End If

                If prvResponse.Form("categoryid") <> "" Then
                   AddFilter = AddFilter & " AND categoryid=" & prvResponse.Form("categoryid")
                End If

                If prvResponse.Form("datefrom") <> "" Or prvResponse.Form("dateto") <> "" Then
                    If prvResponse.Form("datefrom") <> "" AND prvResponse.Form("dateto") <> "" Then
                       AddFilter = AddFilter & " AND CONVERT(date,created) BETWEEN '" & prvResponse.Form("datefrom") & "' AND '" & prvResponse.Form("dateto") & "'"
                    ElseIf prvResponse.Form("datefrom") <> "" Then
                       AddFilter = AddFilter & " AND CONVERT(date,created) = '" & prvResponse.Form("datefrom") & "'"
                    Else
                       AddFilter = AddFilter & " AND CONVERT(date,created) = '" & prvResponse.Form("dateto") & "'"
                    End If
                End If

                SQLStr = "SELECT " & FieldListAsText & ", maxrows = COUNT(*) OVER()  FROM vwStandstill WHERE isdeleted=0 " & SQLFilter & AddFilter & " ORDER BY " & OrderListAsText & " OFFSET " & Offset & " ROWS FETCH NEXT " & PageLength & " ROWS ONLY"
                SQLStrDefault = "SELECT COUNT(*) As maxrows FROM vwStandstill WHERE isdeleted=0"

            Case "stand-list-ipad"
                SQLStr = "SELECT " & FieldListAsText & ", maxrows = COUNT(*) OVER()  FROM vwStandstill WHERE isdeleted=0 AND createdby='" & Session("loginid") & "' ORDER BY created DESC OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY"
                SQLStrDefault = "SELECT COUNT(*) As maxrows FROM vwStandstill WHERE isdeleted=0"

            Case "stand-categories"

                SQLStr = "SELECT " & FieldListAsText & ", maxrows = COUNT(*) OVER()  FROM category WHERE 1=1 " & IIf(SQLFilter <> "", "AND " & SQLFilter,"") & IIf(OrderListAsText <> "", " ORDER BY " & OrderListAsText,"") & " OFFSET " & Offset & " ROWS FETCH NEXT " & PageLength & " ROWS ONLY"
                SQLStrDefault = "SELECT COUNT(*) As maxrows FROM category"



        End Select

        RecordsTotal = 0
        RecordsFiltered = 0

        Dim Rs : Set Rs = DbExecute(SQLStrDefault)
        RecordsTotal = Rs("maxrows")
        Rs.Close

        Set Rs = DbExecute(SQLStr)
        If Not Rs.Eof Then
           RecordsFiltered = Rs("maxrows")
        End If

        Dim oJSON : Set oJSON = New aspJSON
        Dim idx : idx=0
        Dim Item
        Dim ItemVal

        With oJSON.Data
            .Add "draw", DrawNb
            .Add "recordsTotal",RecordsTotal
            .Add "recordsFiltered", RecordsFiltered
            .Add "data", oJSON.Collection()
            With .Item("data")

                Do While Not Rs.Eof
                    .Add idx, oJSON.Collection()
                    With .Item(idx)
                        For Each Item In ColumnList.Items
                            ItemVal = ""
                            If Item.Data <> "" Then
                                If FieldExists(Rs, Item.Data) Then
                                    ''Response.Write Item.Data & " "  &  Rs(Item.Data).Type & " - "
                                    Select Case Rs(Item.Data).Type
                                        Case adInteger
                                            ItemVal = CInt(Rs(Item.Data))
                                        Case adBigInt
                                            ItemVal = CLng(Rs(Item.Data))
                                        Case adVarWChar
                                            ItemVal = ToUTF8(Rs(Item.Data))
                                        Case adLongVarWChar
                                            ItemVal = ToUTF8(Rs(Item.Data))
                                        Case adNumeric
                                            ItemVal = CDbl(Rs(Item.Data))
                                        Case adChar
                                            ItemVal = ToUTF8(Rs(Item.Data))
                                        Case adVarChar
                                            ItemVal = Rs(Item.Data)
                                        Case adDate
                                            ItemVal = Rs(Item.Data)
                                        Case adDBTimeStamp
                                            ItemVal = FormatDateTime(Rs(Item.Data))
                                    End Select
                                End If
                            End If
                            .Add Item.Data, ItemVal
                        Next
                    End With
                    idx=idx+1
                    Rs.MoveNext
                Loop
            End With
        End With
        Rs.Close
        Set Rs = Nothing

        Set ToJSON = oJSON


    End Function

    Private Function FieldExists(ByVal rs, ByVal fieldName)

        On Error Resume Next
        FieldExists = rs.Fields(fieldName).name <> ""
        If Err <> 0 Then FieldExists = False
        Err.Clear
        On Error Goto 0

    End Function

End Class

%>