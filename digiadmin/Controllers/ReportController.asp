<%

Class ReportController

    Dim Model
    Dim ViewData

    Private PdfReport


    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
        Set PdfReport = New CreateReportAsPdf
    end sub

    private sub Class_Terminate()
    end sub

    Public Sub TestPrint

        Dim FileName : FileName = PdfReport.TestPrint

        ''Response.Write "FileName:" & FileName

        If FileName <> "" Then
           Response.Redirect("/utils/aspdown.asp?filename=" & Server.UrlEncode(FileName))
        End If

    End Sub

    Public Sub PrintReceipt(vars)

        Dim FileName : FileName = PdfReport.CreateReceipt(vars("id"),vars("typ"))

        If FileName <> "" Then
           Response.Redirect("/utils/aspdown.asp?filename=" & Server.UrlEncode(FileName))
        End If

    End Sub

    Public Sub PrintOnePager(vars)

        Dim FileName : FileName = PdfReport.CreateOnePager(vars("id"))

        If FileName <> "" Then
           Response.Redirect("/utils/aspdown.asp?filename=" & Server.UrlEncode(FileName))
        End If

    End Sub


End Class
%>