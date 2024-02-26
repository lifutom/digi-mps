<%

Public Function DBFormatISODate(ByVal DateStr)


    DBFormatISODate = Year(DateStr) & "-" & Right("00" & Month(DateStr),2) & "-" & Right("00" & Day(DateStr),2) & " " & Right("00" & Hour(DateStr),2) & ":" & Right("00" & Minute(DateStr),2) & ":" & Right("00" & Second(DateStr),2)
    

End Function


Public Function DBFormatDate(actDate)

      DBFormatDate = Year(actDate) & "-" & Month(actDate)  & "-" & Day(actDate)

End Function

Public Function DBFormatNumber(ByVal actVal)

      DBFormatNumber = FormatNumber(actVal,2,False,False,False)

End Function
'-----------------------------------------------------------------
' DBFormate Ende
'-----------------------------------------------------------------

Public Function FormatGUID(ByVal GUID)

    FormatGUID = Replace(CStr(GUID),"{", "")
    FormatGUID = Replace(CStr(GUID),"}", "")

End Function


Function ToUTF8(s)
      if ISNULL(s) <> true then
            sUTF8 = ""
            For slen=1 To Len(s)
                   unicode = AscW(Mid(s, slen, 1))
                   If unicode <= &H007F Then
                         sUTF8 = sUTF8 & Chr(unicode)
                   Else
                         If unicode <= &H07FF Then
                               sUTF8 = sUTF8 & Chr(&HC0 + unicode \ &H40)
                               sUTF8 = sUTF8 & Chr(&H80 + unicode Mod &H40)
                         Else
                               sUTF8 = sUTF8 & Chr(&HE0 + unicode \ &H1000)
                               sUTF8 = sUTF8 & Chr(&H80 + (unicode Mod &H1000) \ &H40)
                               sUTF8 = sUTF8 & Chr(&H80 + (unicode Mod &H1000) Mod &H40)
                         End if
                   End If
            Next
            ToUTF8 = sUTF8
      end if
End Function


Public Sub WriteCookies

    Response.Cookies("Partner")("PartnerID") = Session("PartnerID")
    Response.Cookies("Partner")("Lang") = Session("Lang")
    Response.Cookies("Partner")("PartnerName") =  Session("PartnerName")
    Response.Cookies("Partner")("Status") =  Session("Status")
    Response.Cookies("Partner")("typ") =  Session("typ")
    Response.Cookies("Partner")("MandantID") =  Session("MandantID")
    Response.Cookies("Partner")("SponsorID") =  Session("SponsorID")
    Response.Cookies("Partner")("Title") =  Session("Title")
    Response.Cookies("Partner")("StatusID") =  Session("StatusID")
    Response.Cookies("Partner").Expires = DATE + 365

End Sub

Public Sub SetRememberMe

       If Request.Cookies("RememberMe") <> "" AND Session("PartnerID") = "" Then

          Session("PartnerID") = Request.Cookies("Partner")("PartnerID")
          Session("PartnerName") = Request.Cookies("Partner")("PartnerName")
          Session("Status") = ReturnFromRecord("partnerstatus","partnerstatusid=" & ReturnFromRecord("partner","partnerid=" & Session("PartnerID"),"partnerstatus"), "partnerstatus")
          Session("typ") = Request.Cookies("Partner")("typ")
          Session("Lang") = Request.Cookies("Partner")("Lang")
          Session("MandantID") = ReturnFromRecord("partner","partnerid=" & Session("PartnerID"),"mandantid")
          Session("SponsorID") = ReturnFromRecord("partner","partnerid=" & Session("PartnerID"),"partnerpartnerid")
          Session("Title") = Request.Cookies("Partner")("Title")
          Session("StatusID") = Request.Cookies("Partner")("StatusID")

      End If

End Sub

Public Sub ClearCookies

    For Each cookie in Response.Cookies
        Response.Cookies(cookie).Expires = DateAdd("d",-1,now())
    Next

End Sub



public Function Encode (elValue)
            if elValue <> "" Then
                        Encode = Server.HTMLEncode(elValue)
            End If
end function

public Function eDropDownList (elId, elValue, list , idName, valueName, attribs)

                Dim resStr, listItem
                resStr= "<select data-live-search=""true"" id='" + elID + "' name='" + elID + "' " & attribs & ">"
                For Each listItem in List
                    Dim optValue, optText
                    optValue = Eval("listItem." + idName)
                    optText  = Eval("listItem." + valueName)
                        if elValue = optValue Then
                                resStr = resStr + "<option selected='selected' value='" + Encode(optValue) + "'>" + Encode(optText) + "</option>"
                        else
                                resStr = resStr + "<option value='" + Encode(optValue) + "'>" + Encode(optText) + "</option>"
                        End If
                Next
                resStr = resStr & "</select>"
                eDropDownList = resStr
end function

public Function eTextBox (elId, elValue, attribs)
                eTextBox = "<input id='" + elID + "' name='" + elID + "' type='text' value='" + Encode(elValue) + "' " + attribs + " />"
end function



Public Function iif(psdStr, trueStr, falseStr)
  if psdStr then
    iif = trueStr
  else
    iif = falseStr
  end if
End Function


Public Function GetRoot

   If Application("root") = "" Then
      GetRoot = ""
   Else
      GetRoot = "/" & Application("root")
   End If

End Function

Public Function DBNull

   Dim Conn
   Dim Rs

   Set Conn = Server.CreateObject("ADODB.Connection")
   Conn.Open ( Application( "ConStr") )

   Set Rs = Conn.Execute("SELECT NULL As DbNull")

   DBNull = Rs("DbNull")

   Rs.Close
   Set Rs = Nothing
   Conn.Close
   Set Conn = Nothing


End Function

'-------------------------------------------------------------------
' Replace Umlaute / Scharfes S
' Parameter:  Text
'--------------------------------------------------------------------
Public Function ReplaceSpecialChar( ByVal strText )

     Dim Str

     Str = strText

     '1.) üÜ
     Str = Replace(Str,"ü","ue")
     Str = Replace(Str,"Ü","Ue")

     '2.) äÄ
     Str = Replace(Str,"ä","ae")
     Str = Replace(Str,"Ä","Ae")

     '3.) öÖ
     Str = Replace(Str,"ö","oe")
     Str = Replace(Str,"Ö","Oe")

     '3.) ß
     Str = Replace(Str,"ß","ss")


     Str = Replace(Str,"&","u")

     Str = Replace(Str,"í","i")

     Str = Replace(Str,"ó","o")

     Str = Replace(Str,"á","a")

     Str = Replace(Str,"é","e")

     ReplaceSpecialChar = Str


End Function



Const  lcAustria = 3079
Const  lcGermany = 1031
Const  lcItaly = 1040
Const  lcHungarian = 1038

Const ORDERTYPE_ASC   = 10
Const ORDERTYPE_DESC  = 11
Const SORTBY_KEY      = 20
Const SORTBY_VALUE    = 21


 Public Sub SortDictionary(ByRef dictionaryToSort, ByVal sortBy, ByVal orderType)
        If dictionaryToSort.Count>0 Then
            Dim k : k = dictionaryToSort.Keys
            Dim v : v = dictionaryToSort.Items
            Dim c : c = dictionaryToSort.Count - 1
            Dim e() : ReDim e(c, 1)
            'save dictionary in a multi-dimensional array
            For i = 0 To c
                e(i,0) = k(i) 'key name
                Set e(i,1) = v(i) 'key value
            Next
            'select sort type
            Dim t : t = 0
            Select Case sortBy
            Case SORTBY_KEY
                t = 0
            Case SORTBY_VALUE
                t = 1
            End Select
            'sort array by key or value then by ascending or descending order
            Dim i,j,tmp_k,tmp_v
            For i = 0 To c
                For j = i + 1 To c
                    Select Case orderType
                    Case ORDERTYPE_ASC
                        If e(i,t) > e(j,t) Then
                            tmp_k = e(i,0)
                            tmp_v = e(i,1)
                            e(i,0) = e(j,0)
                            Set e(i,1) = e(j,1)
                            e(j,0) = tmp_k
                            Set e(j,1) = tmp_v
                        End If
                    Case ORDERTYPE_DESC
                        If e(i,t) < e(j,t) Then
                            tmp_k = e(i,0)
                            Set tmp_v = e(i,1)
                            e(i,0) = e(j,0)
                            Set e(i,1) = e(j,1)
                            e(j,0) = tmp_k
                            Set e(j,1) = tmp_v
                        End If
                    End Select
                Next
            Next
            'empty dictionary and save sorted items
            dictionaryToSort.RemoveAll
            For i = 0 To c
                dictionaryToSort.Add e(i,0),e(i,1)
            Next
        End If

End Sub





Public Function usrFormatNumber( ByVal Number, ByVal Decimals )

    usrFormatNumber = Replace(FormatNumber(Number,Decimals),CHR(160),".")

End Function





Public Function IsPostback

     If request.servervariables("REQUEST_METHOD") = "POST" Then
        IsPostback = True
     Else
        IsPostback = False
     End If

End Function




Function DrawCountryFlagg ( ByVal Lang )

     DrawCountryFlagg = "&nbsp;<img src=""Images/" & Lang & ".png"" alt= border=""0"" width=""22"" height=""14"">&nbsp;"

End Function


Function GetAppSettings ( ByVal Name )


     Dim Rs
     Dim Conn
     Dim HtmlString

     Set Conn = Server.CreateObject("ADODB.Connection")
     Conn.Open ( Application( "ConStr"))

     Set Rs = Conn.Execute("SELECT * FROM appsettings WHERE LOWER(name)='" & LCase(Name) & "'")

     '-- 0 String
     '-- 1 Int
     '-- 2 Bigint
     '-- 3 uniqueid

     Select Case Rs("vartyp")
     Case 0  ' String
         GetAppSettings = Rs("value")
     Case 1  ' Int
         GetAppSettings = CInt(Rs("value"))
     Case 2  ' Bigint
         GetAppSettings = CLng(Rs("value"))
     Case 3  ' uniqueid
         GetAppSettings = Rs("value")
     End Select

     Set Rs = Nothing
     Conn.Close
     Set Conn = Nothing

End Function


Function DrawSupportedCountries ( ByVal Lang, ByVal Land, ByVal FieldName, ByVal cssClass )


     Dim Rec
     Dim Conn
     Dim HtmlString

     Set Conn = Server.CreateObject("ADODB.Connection")
     Conn.Open ( Application( "ConStr"))

     Set Rec = Conn.Execute("SELECT * FROM v_laender WHERE lang='" & Lang & "'")

     HtmlString = "<select class=""" & cssClass & """ name=""" & FieldName & """>" & vbCrLf

     Do While Not Rec.Eof
         If Rec("Land") = Land  Then
            HtmlString = HtmlString & "<option value=" & Rec("Land") & " SELECTED>" & Rec("Land") & " " & Rec("bezeichnung") & "</option>" & vbCrLf
         Else
            HtmlString = HtmlString & "<option value=" & Rec("Land") & ">" & Rec("Land") & " " & Rec("bezeichnung") & "</option>" & vbCrLf
         End If
         Rec.MoveNext
     Loop

     HtmlString = HtmlString & "</select>" & vbCrLf

     DrawSupportedCountries=HtmlString

End Function





Function WriteSupportedLanguage(modul)

     Dim HtmlString
     Dim Conn
     Dim Rec
     Set Conn = Server.CreateObject("ADODB.Connection")
     Conn.Open ( Application( "ConStr"))

     Set Rec = Conn.Execute("SELECT * FROM lang WHERE aktiv=1 ORDER BY lang")
     HtmlString = ""
     Do While Not Rec.Eof
        If modul = "partner" Then
           HtmlString = HtmlString & "<a href=""javascript:changeLanguage('" & Rec("lang") & "')""><img src=""Images/" & Rec("lang") & ".png"" alt= border=""0"" width=""22"" height=""14""></a>&nbsp;"
        Else
           HtmlString = HtmlString & "<a href=""javascript:changeLanguage('" & Rec("lang") & "')""><img src=""../Images/" & Rec("lang") & ".png"" alt= border=""0"" width=""22"" height=""14""></a>&nbsp;"
        End If
        Rec.MoveNext
     Loop
     Rec.Close
     Conn.Close
     Set Rec  = Nothing
     Set Conn = Nothing
     WriteSupportedLanguage=HtmlString

End Function







Function IsInArray ( ByVal Val, ByVal ValArr )

    Dim i
    Dim x

    IsInArray = False

    For x = 0 To UBound(ValArr)

        If CInt(Val) = CInt(ValArr(x)) Then
               IsInArray = True
               Exit Function
        End If

    Next
End Function
Function PadRight ( ByVal vValue, ByVal Length, ByVal Char )
      Dim i
      Dim strRepl

      'If Char = "" Then
         Char = "x"
      'End If
      strRepl=""
      For i=0 To Length
          strRepl = strRepl & Char
      Next
      PadRight = Right(strRepl & vValue, Length)
      PadRight = Replace(PadRight,"x","&nbsp;")

End Function


Function CreateGUID()
    Dim Conn
    Dim rs

    Set Conn = Server.CreateObject("ADODB.Connection")
    Conn.Open ( Application( "ConStr") )

    Set rs = Conn.Execute("SELECT NEWID()")
    If Not rs.EOF Then CreateGUID = rs(0)
    ' clean up
    rs.Close
    Conn.Close

End Function

Function GetLable(ByVal LableName, ByVal Lang)

    GetLable = ReturnFromRecord("lables", "LOWER(lablename)='" & LCase(Lablename) & "' AND LOWER(lang)='" & LCase(Lang) & "'", "labletext")

End Function


Function GetNewDBID(ByVal MandantID, ByVal Datum, ByVal TableName)

   Dim Conn
   Dim Cmd
   Dim Parameter
   Dim Number

   Set Conn = Server.CreateObject("ADODB.Connection")
   Conn.Open Application("conStr")

   Set Cmd = Server.CreateObject("ADODB.Command")
   Cmd.CommandText = "GetNewNumber"
   Cmd.CommandType = adCmdStoredProc
   Set Cmd.ActiveConnection = Conn

   Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
   Cmd.Parameters.Append Parameter

   Set Parameter = Cmd.CreateParameter("@MID", adInteger, adParamInput)
   Cmd.Parameters.Append Parameter
   Parameter.Value = MandantID

   Set Parameter = Cmd.CreateParameter("@Datum", adDate, adParamInput)
   Cmd.Parameters.Append Parameter
   Parameter.Value = Datum


   Set Parameter = Cmd.CreateParameter("@TN", adVarWChar, adParamInput, 50)
   Cmd.Parameters.Append Parameter
   Parameter.Value = TableName

   Set Parameter = Cmd.CreateParameter("@LN", adVarWChar, adParamOutput, 50)
   Cmd.Parameters.Append Parameter

   Cmd.Execute


   If Cmd.Parameters("@RETURN_VALUE").Value  <> 0 Then
       GetNewDBID = ""
   Else
       GetNewDBID = Cmd.Parameters("@LN").Value
   End If


   Conn.Close
   Set Conn = Nothing
   Set Cmd = Nothing
   Set Parameter = Nothing

End Function


Function LastDayOfMonth ( ByVal Jahr, ByVal Monat)

      Dim Conn, Record, QueryString

      Set Conn = Server.CreateObject("ADODB.Connection")
      Conn.Open ( Application( "ConStr") )

      QueryString = "SELECT dbo.LastDayOfMonth(" & Jahr & "," & Monat & ") As Datum"

      Record = Conn.Execute(QueryString)

      LastDayOfMonth = Record("Datum")

      Set Record = Nothing
      Conn.Close
      Set Conn = Nothing

End Function



Function GetNewID ()

      Dim Conn, Record, QueryString

      Set Conn = Server.CreateObject("ADODB.Connection")
      Conn.Open ( Application( "ConStr") )

      QueryString = "SELECT NEWID() As ID"

      Record = Conn.Execute(QueryString)

      GetNewID = CStr(Record("ID"))

      Set Record = Nothing
      Conn.Close
      Set Conn = Nothing

End Function


Function RecordExists ( tablename, key)

      Dim Conn, Record, QueryString

      Set Conn = Server.CreateObject("ADODB.Connection")
      Conn.Open ( Application( "ConStr") )
      Set Record = Server.CreateObject("ADODB.RecordSet")
      QueryString = "SELECT * FROM " & tablename & " WHERE " & key

      Record.Open QueryString, Conn

      If Record.Eof Then
         RecordExists = False
      Else
         RecordExists = True
      End If
      Record.Close
      Set Record = Nothing
      Conn.Close
      Set Conn = Nothing

End Function

Function GenerateRandPW ( pLen )

      Dim d
      Dim iType
      Dim hAsc

      GenerateRandPW=""

      For d=1 To pLen
          Randomize
          iType = CInt(Rnd(1) * 3)
          Select Case iType
          Case 0 ' klein
              Randomize
              hAsc = 97 + Cint(Rnd(1) * 25)
          Case 1 ' klein
              Randomize
              hAsc = 97 + Cint(Rnd(1) * 25)
          Case 2 ' gro&szlig;
              Randomize
              hAsc = 65 + Cint(Rnd(1) * 25)
          Case 3
              Randomize
              hAsc = 49 + Cint(Rnd(1) * 8)
          End Select
          GenerateRandPW = GenerateRandPW & Chr(hAsc)
      Next

End Function



Function ReturnFromRecord( tablename, key, fieldname )


      Dim Conn, Record, QueryString

      On Error Resume Next
      Set Conn = Server.CreateObject("ADODB.Connection")
      Conn.Open ( Application( "ConStr") )
      Set Record = Server.CreateObject("ADODB.RecordSet")
      QueryString = "SELECT " & fieldname & " FROM " & tablename & " WHERE " & key
      Record.Open QueryString, Conn

      If Err.Number <> 0 Then
         ReturnFromRecord = ""
      End If
      If Not Record.Eof Then
         ReturnFromRecord = Record(Trim(fieldname))
      Else
          ReturnFromRecord = ""
      End If
      Record.Close
      Set Record = Nothing
      Conn.Close
      Set Conn = Nothing


End Function



Function GetMonatString ( ByVal Monat )

      Dim strMonat
      Select Case Monat
         Case 1
           strMonat = GetLable("lblJan", Session("Lang"))
         Case 2
           strMonat = GetLable("lblFeb", Session("Lang"))
         Case 3
           strMonat = GetLable("lblMar", Session("Lang"))
         Case 4
           strMonat = GetLable("lblApr", Session("Lang"))
         Case 5
           strMonat = GetLable("lblMai", Session("Lang"))
         Case 6
           strMonat = GetLable("lblJun", Session("Lang"))
         Case 7
           strMonat = GetLable("lblJul", Session("Lang"))
         Case 8
           strMonat = GetLable("lblAug", Session("Lang"))
         Case 9
           strMonat = GetLable("lblSep", Session("Lang"))
         Case 10
           strMonat = GetLable("lblOkt", Session("Lang"))
         Case 11
           strMonat = GetLable("lblNov", Session("Lang"))
         Case 12
           strMonat = GetLable("lblDez", Session("Lang"))
      End Select

      GetMonatString = strMonat

End Function




Public Function DBFormatNumber ( ByVal NumberStr )

    Dim StrVal


    If NumberStr = "" Then
       StrVal="0.00"
    Else
       StrVal=Replace(NumberStr,".","")
       StrVal=Replace(StrVal,",",".")
    End If

    DBFormatNumber = StrVal

End Function



Public Function Replicate(Str, Cnt)


     Dim  retStr
     Dim i

     retStr = ""

     For i=1 To Cnt

        retStr = retStr & Str

     Next

     Replicate = retStr


End Function

%>