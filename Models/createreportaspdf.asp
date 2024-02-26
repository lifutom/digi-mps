<%
Class CreateReportAsPdf

    Private CmdFile
    Private ExeString
    Private scrShell
    Private UrlRoot
    Private TempRoot
    Private SleepSec
    Private FSO

    Private Sub Class_Initialize()

        CmdFile = GetAppSettings("cmdfile")
        Set scrShell = Server.CreateObject("Wscript.Shell")
        UrlRoot = GetAppSettings("report_url")  & "/" & Application("root")
        TempRoot = GetAppSettings("tempdir")



        Set FSO = Server.CreateObject("Scripting.FileSystemObject")
        If Not FSO.FolderExists(TempRoot) Then
           FSO.CreateFolder(TempRoot)
        End If

    End Sub


    Public Function CreateReceipt (ByVal ID, ByVal Typ)

        Dim Nb

        Select Case Typ
            Case "quote"
               Nb = ReturnFromRecord("quote","quoteid=" & ID, "quotenb")
            Case "order"
               Nb = ReturnFromRecord("order","ordersid=" & ID, "ordernb")
        End Select

        Dim FPath : FPath = TempRoot & "\" & Nb & ".pdf"
        Dim FooterPath : FooterPath = UrlRoot & "/reports/receipt_footer.asp?typ=" & Typ & "&id=" & ID
        Dim Url : Url = UrlRoot & "/reports/receipt.asp?typ=" & Typ & "&id=" & ID

        Dim resultStr : resultStr = 0


        If FSO.FileExists(FPath) Then
            FSO.DeleteFile FPath, True
        End If

        ''Response.Write Url
        ''Response.End

        ExeString = CmdFile & " Portrait 3 """ & Url & """ " &  FPath & " """ & FooterPath & """"

        resultStr = scrShell.Run(ExeString,0,True)

        If resultStr = 0 Then
           CreateReceipt = FPath
        Else
           CreateReceipt = ""
        End If

    End Function


    Public Function CreateOnePager (ByVal ID)

        Dim Nb
        Nb = ReturnFromRecord("vwNearMiss","nearid=" & ID, "nearnb")

        Dim FPath : FPath = TempRoot & "\" & Nb & ".pdf"
        Dim FooterPath : FooterPath = UrlRoot & "/reports/receipt_footer.asp?typ=" & Typ & "&id=" & ID
        Dim Url : Url = UrlRoot & "/reports/onepager.asp?id=" & ID

        Dim resultStr : resultStr = 0


        If FSO.FileExists(FPath) Then
            FSO.DeleteFile FPath, True
        End If

        ExeString = CmdFile & " Landscape 3 """ & Url & """ " &  FPath & " """ & FooterPath & """"

        resultStr = scrShell.Run(ExeString,0,True)

        If resultStr = 0 Then
           CreateOnePager = FPath
        Else
           CreateOnePager = ""
        End If

    End Function



    Public Function TestPrint ()

        Dim FooterPath : FooterPath = UrlRoot & "/reports/list_footer.asp?typ=msd&lang=de"
        Dim Url : Url = UrlRoot & "/reports/testprint.asp"
        Dim FPath : FPath = TempRoot & "\testprint.pdf"

        Dim resultStr : resultStr = 0

        If FSO.FileExists(FPath) Then
            FSO.DeleteFile FPath, True
        End If

        ExeString = CmdFile & " Portrait 3 """ & Url & """ " &  FPath & " """ & FooterPath & """"

        Response.WRite "ExeString: " & ExeString

        resultStr = scrShell.Run(ExeString,0,True)

        ''End If

        If resultStr = 0 Then
           TestPrint = FPath
        Else
           TestPrint = ""
        End If

    End Function




End Class
%>