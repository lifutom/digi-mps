<%
Class MailController

    Dim Model
    Dim ViewData

    Private PdfReport


    Private Sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
        Set PdfReport = New CreateReportAsPdf
    End Sub


    Public Sub QuoteMail(vars)

        Dim ID : ID = vars("id")

        Dim mQuote : Set mQuote = New Quote
        Dim mMessage : Set mMessage = New Message


        mQuote.ID = ID

        ViewData.Add "id", ID
        ViewData.Add "mail", mMessage.QuoteMail(ID)
        ViewData.Add "item", mQuote


        %><!--#include file="../views/mail/edit.asp" --> <%


    End Sub

    Public Sub QuoteMailPost(args)

        Dim ID : ID = args("id")

        Dim Recipient : Recipient = args("email")
        Dim ToName : ToName = args("toname")

        Dim CCRecipient : CCRecipient = args("emailcopy")
        Dim SendCopy : SendCopy = args("sendcopy")

        Dim Subject : Subject = args("subject")
        Dim Body : Body = args("body")


    End Sub


End Class
%>