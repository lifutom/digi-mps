<%
Class MacroItem

    Public ID
    Public Value

End Class

Class MailInfo

    Public Subject
    Public Body
    Public From
    Public FromName
    Public Recipient
    Public ToName
    Public CCRecipient
    Public CCToName
    Public HasData
    Public Typ

    Private Sub Class_Initialize()
        HasData = False
    End Sub

End Class



Class Mail

    Private prvMail
    Private prvUserName
    Private prvPassword

    Private prvErrMsg
    Private prvErr

    Private prvAddresses

    Public Property Let From (Value)
        prvMail.From = Value
    End Property

    Public Property Get From
        From = prvMail.From
    End Property

    Public Property Let FromName (Value)
        prvMail.FromName = Value
    End Property

    Public Property Get FromName
        FromName = prvMail.FromName
    End Property


    Public Property Let Subject (Value)
        prvMail.Subject = Value
    End Property

    Public Property Get Subject
        Subject = prvMail.Subject
    End Property

    Public Property Let Body (Value)
        prvMail.Body = Value
    End Property

    Public Property Get Body
        Body = prvMail.Subject
    End Property

    Public Property Let IsHtml (Value)
        prvMail.IsHtml = Value
    End Property

    Public Property Get IsHtml
        IsHtml = prvMail.IsHtml
    End Property

    Public Property Get ErrNb
        ErrNb = prvErr
    End Property

    Public Property Get ErrMsg
        ErrMsg = prvErrMsg
    End Property


    Public Typ
    Public HasData

    Private Sub Class_Initialize()

        HasData = False
        Set prvMail = Server.CreateObject("Persits.MailSender")
        prvMail.IsHtml=True
        prvMail.Timeout = 10000
	prvMail.From = GetAppSettings("from")
        prvMail.FromName = GetAppSettings("fromname")

        prvMail.Host = GetAppSettings("mailhost")
        prvMail.Username = GetAppSettings("mailusername")
        prvMail.Password = GetAppSettings("mailpassword")
        prvMail.TLS = IIf(GetAppSettings("tls")=1, True, False)
        prvMail.Port = GetAppSettings("smtp-port")

        prvErr = 0
        prvErrMsg = ""

        prvAddresses=""

    End Sub

    Public Sub AddAddress(ByVal Recipient, ByVal RecipientName)
        prvMail.AddAddress Recipient, RecipientName

	prvAddresses = prvAddresses & Recipient & " " & RecipientName & ";"

    End Sub

    Public Sub AddCC(ByVal Recipient, ByVal RecipientName)
        prvMail.AddCC Recipient, RecipientName
    End Sub

    Public Sub AddAttachment(ByVal FileName)
        prvMail.AddAttachment FileName
    End Sub

    Public Function Send

        Send = True
        prvErr = 0
        prvErrMsg = ""

        On Error Resume Next
        prvMail.Send
        If Err <> 0 Then
           ''Send = True
           ''prvErr = Err.Description
        End If

	'Dim oFS : Set oFS = Server.CreateObject("Scripting.FileSystemObject")
	'Dim oFile : Set oFile = oFS.OpenTextFile("E:\TEMP\Mail.log", 8, True, -2)
	'oFile.WriteLine "FROM:      " & prvMail.From
	'oFile.WriteLine "FromName:  " & prvMail.FromName
	'oFile.WriteLine "Subject:   " & prvMail.Subject
	'oFile.WriteLine "Body:      " & prvMail.Body
	'oFile.WriteLine "IsHtml:    " & IIf(prvMail.IsHtml,"True","False")
	'oFile.WriteLine "Addresses: " & prvAddresses 
	'oFile.Close

	'Set oFile = Nothing
	'Set oFS = Nothing

    End Function

End Class


Class Message

    Private prvID
    Private prvHasData

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get Message
        Message = prvID
    End Property


    Public Property Let Message (Value)
        prvID = Value
    End Property

    Public MessageType
    Public Subject
    Public Body


    Private QuoteMacro
    Public DefaultMacro

    Private Sub Class_Initialize()

        Dim mItem

        Set QuoteMacro = Server.CreateObject("Scripting.Dictionary")


        Set mItem = New MacroItem
        mItem.ID = "quotenb"
        mItem.Value = "string"
        QuoteMacro.Add mItem.ID,mItem

        Set mItem = New MacroItem
        mItem.ID = "quotedate"
        mItem.Value = "date"
        QuoteMacro.Add mItem.ID,mItem

        prvID = ""
        MessageType = ""
        Subject = ""
        Body = ""
        prvHasData = False

        Set DefaultMacro = Server.CreateObject("Scripting.Dictionary")
        Set mItem = New MacroItem
        mItem.ID = "firstname"
        mItem.Value = ReturnFromRecord("userlist","userid='" & Session("login") & "'", "firstname")
        DefaultMacro.Add mItem.ID,mItem

        Set mItem = New MacroItem
        mItem.ID = "lastname"
        mItem.Value = ReturnFromRecord("userlist","userid='" & Session("login") & "'", "lastname")
        DefaultMacro.Add mItem.ID,mItem

        Set mItem = New MacroItem
        mItem.ID = "email"
        mItem.Value = ReturnFromRecord("userlist","userid='" & Session("login") & "'", "email")

        DefaultMacro.Add mItem.ID,mItem

    End Sub


    Private Sub Init

        Dim SQLStr : SQLStr = "SELECT * FROM message WHERE message='" & prvID & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            prvHasData = True
            MessageType = Rs("messagetype")
            Subject = Rs("subject")
            Body = Rs("body")
        End If
        Rs.Close
        Set Rs = Nothing

    End Sub


    Public Function QuoteMail(ByVal mID)

        prvID = "quote-send"
        Init

        Set QuoteMail = New MailInfo
        QuoteMail.Typ = "quote"

        Dim SQLStr : SQLStr = "SELECT * FROM vwQuote WHERE quoteid=" & mID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
           QuoteMail.HasData = True
           QuoteMail.Subject = ReplaceMacro(Subject, Rs, QuoteMacro)
           QuoteMail.Body = ReplaceMacro(Body, Rs, QuoteMacro)
           QuoteMail.Subject = ReplaceDefaultMacro(QuoteMail.Subject)
           QuoteMail.Body = ReplaceDefaultMacro(QuoteMail.Body)
           QuoteMail.CCRecipient = DefaultMacro("email").Value
           QuoteMail.CCToName = ""
           QuoteMail.Recipient = Rs("email")
           QuoteMail.ToName = Rs("maincontact")
        End If

    End Function


    Private Function ReplaceMacro(ByVal mSubject, ByVal mRec, ByVal mMacroList)

        Dim Item
        Dim Value

        ReplaceMacro = mSubject
        For Each Item In mMacroList.Items
            ReplaceMacro = Replace(ReplaceMacro, "$$" & LCase(Item.ID) & "$$", ValueMacro(Item.Value, mRec(Item.ID)))
        Next

    End Function


    Private Function ValueMacro (ByVal ValueType, ByVal Value)

        Dim RetVal

        Select Case ValueType
        Case "string"
            RetVal = CStr(Value)
        Case "date"
            RetVal = FormatDateTime(Value, vbShortDate)
        Case "integer"
            RetVal = CStr(CInt(Value))
        Case Else
            RetVal = CStr(Value)
        End Select

        ValueMacro = RetVal


    End Function


    Private Function ReplaceDefaultMacro(ByVal Txt)

        Dim Item
        Dim Value

        ReplaceDefaultMacro = Txt

        For Each Item In DefaultMacro.Items
            ReplaceDefaultMacro = Replace(ReplaceDefaultMacro, "$$" & LCase(Item.ID) & "$$", Item.Value)
        Next

    End Function





End Class
%>