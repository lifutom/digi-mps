<%
Class EMail

    Public Function Send (Sender, Recipient, Subject, Body)

           'Step 1: create an object of CDO.Message
           dim objMail
           Set objMail = Server.CreateObject("CDO.Message")

           'Step 2: set the smtp server, user name and password for authentication
           dim smtpServer
           smtpServer = "mailhost.merck.com"

           'Step 3: set the configuration properties of objMail object
           objMail.Configuration.Load -1
           objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
           objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtpServer
           objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 0 ' Basis USername/Passwort 0 anonymous/2 NTLM
           objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25       
           ''objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
           ''objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendtls") = True
           ''objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "DigiNM@merck.com"
           ''objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "Thueringer1!"
           objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60

           'Step 4: update the configuration after setting all the required items
           objMail.Configuration.Fields.Update


           'Step 5: prepare your email like set subject, body, from, to etc.

           objMail.AutoGenerateTextBody = False
           objMail.From = Sender
           objMail.To = Recipient

           objMail.Subject=Subject
           objMail.htmlBody = "<html><body>" & Body & "</body></html>"

           On Error Resume Next
           'Step 6: send the email
           objMail.Send

           Dim RetVal  : RetVal = True

           If Err.Number <> 0 Then
              RetVal = False
           End If
           'Step 7: release the object
           Set objMail = Nothing

           Send = RetVal

    End Function


    Public Function SendNearMissMail(ByVal iNearID)


        SendNearMissMail = Send("DigiNM@merck.com","thomas.lauterboeck@merck.com","test", "test" )

    End Function

End Class
%>