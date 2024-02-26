<%

  Dim FileName
  Dim Fso : Set Fso = Server.CreateObject( "Scripting.FileSystemObject" )
 
  If Request("Filename") <> "" Then
     FileName = Request("filename")
     ''SendFileByBlocks FileName , &H10000
     Download_File(FileName)
  End If



  Private Sub Download_File(file)

     strFile = Fso.GetFileName(file)
     response.clear
     DIM objStream
     SET objStream = Server.CreateObject("ADODB.Stream")
     objStream.Type = 1 'ad  type binary
     objStream.Open
     objStream.LoadFromFile(file)
     'This is download
     Dim ext : ext = Fso.GetExtensionName(FileName)

     Select Case LCase(ext)
        Case "pdf"
            Response.ContentType = "application/pdf"
            Response.Addheader "Content-Disposition", "inline; filename= " & strFile
        Case Else
            Response.ContentType = "application/octet-stream"
            Response.Addheader "Content-Disposition", "attachment; filename= " & strFile
     End Select
     Response.BinaryWrite objStream.Read
     Response.end
     objStream.Close
     SET objStream = NOTHING
 End Sub


  Sub SendFileByBlocks(FileName, BlockSize)
      'Set a time required for download to ScriptTimeout
      Server.ScriptTimeout = 10000

      'CreateObject("ScriptUtils.Thread").Priority = -15

      Dim FileSize, ByteCounter
      FileSize = GetFileSize(FileName)



      'Switch off buffer.
      Response.Buffer = False



      'This is download
      Dim ext : ext = Fso.GetExtensionName(FileName)

      Select Case LCase(ext)
        Case "pdf"
            Response.ContentType = "application/pdf"
        Case Else
            ''Response.ContentType = "application/x-msdownload"
            Response.ContentType = "application/pdf"
      End Select
      'response.contenttype="application/octet-stream"

      'Set file name
      Response.AddHeader "Content-Disposition", _
        "attachment; filename=""" &  GetFileName(FileName)  & """"

      'Set Content-Length (ASP doen not set it when Buffer = False)
      'Response.AddHeader "Content-Length", FileSize
      'Response.CacheControl = "no-cache"


      Dim BA
      Set BA = Server.CreateObject("ScriptUtils.ByteArray")


      'Loop through file contents.
      For ByteCounter = 1 To FileSize Step BlockSize
        'Do not write data when client is disconnected
        If Not Response.IsClientConnected() Then Exit For

        'Read block of data from a file
        BA.ReadFrom FileName, ByteCounter, BlockSize

        'Write the block to output.
        Response.BinaryWrite BA.ByteArray
      Next

      'CreateObject("ScriptUtils.Thread").Priority = 0
End Sub


'This function returns a file size as a 64bit number
Function GetFileSize(FileName)
  Dim Kernel
  On Error Resume Next
  Set Kernel = CreateObject("ScriptUtils.Kernel")
  GetFileSize = Kernel.GetFileSize(FileName)
  If IsEmpty(GetFileSize) Then
    GetFileSize = CreateObject("scripting.filesystemobject").GetFile(FileName).Size
  End If
  If IsEmpty(GetFileSize) Then GetFileSize = 0
  On Error Goto 0
End Function

'get a file name from the full file path
Function GetFileName(FullPath)
  Dim Pos, PosF
  PosF = 0
  For Pos = Len(FullPath) To 1 Step -1
    Select Case Mid(FullPath, Pos, 1)
      Case ":", "/", "\": PosF = Pos + 1: Pos = 0
    End Select
  Next
  If PosF = 0 Then PosF = 1
  GetFileName = Mid(FullPath, PosF)
End Function
%>