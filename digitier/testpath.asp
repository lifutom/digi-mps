<%
Dim PhysicalPath : PhysicalPath = Server.MapPath("/qh")


	'PhysicalPath = UCase("\\atviapp800003\common_files\Quality Hour")
	PhysicalPath = UCase("\\atvipsp850000\placeit\Released")

    Response.write PhysicalPath 


   
    Dim FSO : Set FSO = CreateObject("Scripting.FileSystemObject")

    Dim Folder : Set Folder = FSO.GetFolder(PhysicalPath)

    Dim File

    GetPhysicalPath = ""

    If Folder.Files.Count > 0 Then

        For Each File In Folder.Files
            If InStr(LCase(File.Name),".xlsx") Then
                GetPhysicalPath = File.Path
                Exit For
            End If
        Next


    Else
        GetPhysicalPath = ""
    End If
%>