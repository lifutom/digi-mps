<%

Public Function glKW (ByVal curDate )
    glKW = datepart("ww",curDate,2,3)
End Function

Public Function GetWarenKorb ()

     If Session("Source") = "shop" Then
       GetWarenKorb = "Anmeldung"
     ElseIf Session("Source") = "reg" Then
        GetWarenKorb = "RegAnmeldung"
     Else
        GetWarenKorb = "Anmeldung"
     End If

End Function

Public Function iif(psdStr, trueStr, falseStr)
  if psdStr then
    iif = trueStr
  else
    iif = falseStr
  end if
End Function

Public Function if_then_else(psdStr, trueStr, falseStr)
        if_then_else = iif(psdStr, trueStr, falseStr)
End Function

Public Function IsNothing(var)
   if(IsObject(var)) then
      IsNothing = (var is nothing) or IsEmpty(var) or IsNull(var)
   else
      IsNothing = IsEmpty(var) or IsNull(var)
   end if
End Function

Public Function StringFormat(ByVal SourceString , Arguments() )
   Dim objRegEx 'As RegExp  ' regular expression object
   Dim objMatch 'As Match   ' regular expression match object
   Dim strReturn 'As String ' the string that will be returned

   Set objRegEx = New RegExp
   objRegEx.Global = True
   objRegEx.Pattern = "(\{)(\d)(\})"

   strReturn = SourceString
   For Each objMatch In objRegEx.Execute(SourceString)
      strReturn = Replace(strReturn, objMatch.Value, Arguments(CInt(objMatch.SubMatches(1))))
   Next

   StringFormat = strReturn

End Function


 Function PrepareVariables(args())

        dim keyPairs, keyPair, key, keyValue
        Set results = Server.CreateObject("Scripting.Dictionary")

   if not IsArray(args) then
          args = Split(args, ",")
   end if

        for each keyPair in args
                keyPairs = Split(keyPair,"=")
                if UBound(keyPairs) = 1 then
                        key = Trim(keyPairs(0))
                        keyValue = Trim(keyPairs(1))
                        if InStr(1,"controller, action, partial",key,1)=0 Then
                                results.Add key,keyValue
                        End If
                End If
        next
        if results.Count=0 Then
                Set PrepareVariables = Nothing
        else
                Set PrepareVariables = results
        End If
End Function

Function CreateGUID
  Dim TypeLib
  Set TypeLib = CreateObject("Scriptlet.TypeLib")
  CreateGUID = Mid(TypeLib.Guid, 2, 36)
  Set TypeLib = Nothing
End Function

Const blackPattern = "(?:\'|is\s+null|--|=|%|values|where|count|\sand\s|\sor\s|;|\slike\s|,|\/\*|\*\/|@@|\s@|\schar|nchar|varchar|nvarchar|alter|begin|cast|create\s|cursor|declare|database|delete|drop|end|exec|execute|fetch|from|insert|kill|open|select|sys|sysobjects|syscolumns|table|update|values|xp_cmdshell)"

Function detectInjection(strtoclean)
  Set absoluteNoValidator = New RegExp
  absoluteNoValidator.Pattern = blackPattern
  absoluteNoValidator.IgnoreCase = True
  If absoluteNoValidator.Test(strtoclean) Then
      detectInjection = True
      Exit Function
  End If
  detectInjection = False
End Function


''Const adTypeBinary = 1
'Const adTypeText = 2

' accept a string and convert it to Bytes array in the selected Charset
Function StringToBytes(Str,Charset)
  Dim Stream : Set Stream = Server.CreateObject("ADODB.Stream")
  Stream.Type = adTypeText
  Stream.Charset = Charset
  Stream.Open
  Stream.WriteText Str
  Stream.Flush
  Stream.Position = 0
  ' rewind stream and read Bytes
  Stream.Type = adTypeBinary
  StringToBytes= Stream.Read
  Stream.Close
  Set Stream = Nothing
End Function

' accept Bytes array and convert it to a string using the selected charset
Function BytesToString(Bytes, Charset)
  Dim Stream : Set Stream = Server.CreateObject("ADODB.Stream")
  Stream.Charset = Charset
  Stream.Type = adTypeBinary
  Stream.Open
  Stream.Write Bytes
  Stream.Flush
  Stream.Position = 0
  ' rewind stream and read text
  Stream.Type = adTypeText
  BytesToString= Stream.ReadText
  Stream.Close
  Set Stream = Nothing
End Function

' This will alter charset of a string from 1-byte charset(as windows-1252)
' to another 1-byte charset(as windows-1251)
Function AlterCharset(Str, FromCharset, ToCharset)
  Dim Bytes
  Bytes = StringToBytes(Str, FromCharset)
  AlterCharset = BytesToString(Bytes, ToCharset)
End Function

%>