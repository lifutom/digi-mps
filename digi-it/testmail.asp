<!--#include file="./controllers/controllers.asp" -->
<!--#include virtual="/Utils/utils.asp" -->
<!--#include virtual="/models/models.asp" -->

<%

Dim oFS : Set oFS = Server.CreateObject("Scripting.FileSystemObject")
Dim FileBody : Set FileBody = oFS.OpenTextFile("E:\TEMP\mailtext.txt", 1)


Dim oMail : Set oMail = Server.CreateObject("Persits.MailSender")
 oMail.IsHtml=True
        
	oMail.From = GetAppSettings("from")
        oMail.FromName = GetAppSettings("fromname")

        oMail.Host = GetAppSettings("mailhost")
        oMail.Username = GetAppSettings("mailusername")
        oMail.Password = GetAppSettings("mailpassword")
        oMail.TLS = IIf(GetAppSettings("tls")=1, True, False)
        oMail.Port = GetAppSettings("smtp-port")


oMail.From = "icam-noreply@merck.com"
oMail.FromName = "ICAM-DigiMPS" 
oMail.Subject = "Testmail" 
oMail.Body = FileBody.ReadAll 
FileBody.Close
Set FileBody = Nothing 
oMail.IsHtml = True
oMail.AddAddress "thomas.lauterboeck@merck.com", "Thomas Lauterböck"
oMail.Send





Dim oFile : Set oFile = oFS.OpenTextFile("E:\TEMP\Mail.log", 8, True, -2)
oFile.WriteLine "FROM:      " & oMail.From
oFile.WriteLine "FromName:  " & oMail.FromName
oFile.WriteLine "Subject:   " & oMail.Subject
oFile.WriteLine "Body:      " & oMail.Body
oFile.WriteLine "IsHtml:    " & IIf(oMail.IsHtml,"True","False")
oFile.WriteLine "Addresses: " & "thomas.lauterboeck@merck.com Thomas Lauterböck"
oFile.Close





%>


