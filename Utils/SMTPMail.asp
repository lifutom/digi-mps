<%
Class SMTPMail

    Private prvSMTPHost
    Private prvSenderAddress
    Private prvSMTPPort
    Private prvSSL
    Private prvUser
    Private prvPassword


    Private Sub Class_Initialize()

        ''Set List = Server.CreateObject("Scripting.Dictionary")
        prvSMTPHost = GetAppSettings("mailhost")
        prvSenderAddress = GetAppSettings("quotesender")
        prvSMTPPort = 25
        prvSSL = False
        prvUser = ""
        prvPassword = ""

    End Sub


    Public Function SendQuote (ByVal QuoteID, ByVal Recipient, ByVal Subject, ByVal Body, ByVal FileName)


    End Function


End Class
%>