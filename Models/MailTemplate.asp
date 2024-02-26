<%
Class MailTemplate


    Public ValueList
    Public Template

    Private prvRawBody
    Private prvTemplatePath

    Private Sub Class_Initialize()

        Set ValueList = Nothing
        prvTemplatePath = Server.MapPath( "/digiadmin/templates")
    End Sub


    Public Function HtmlBody

        Dim Item

        prvRawBody = ReadTemplate

        If Not ValueList Is Nothing Then

            For Each Item In ValueList.Items

                prvRawBody = Replace(prvRawBody,"$$" & Item.value & "$$", Item.Name)

            Next

        End If

        HtmlBody = prvRawBody

    End Function


    Private Function ReadTemplate

        Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")
        Dim SourceFile : Set SourceFile = Fs.OpenTextFile(prvTemplatePath & "\" & Template & ".htm", 1)
        ReadTemplate = SourceFile.ReadAll
        SourceFile.Close

        Set Fs = Nothing

    End Function

End Class
%>