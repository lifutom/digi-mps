<%

Class ADAccess


    Function AuthenticateUser(Username,Password)

        Dim strUser,strPass,strQuery,oConn,cmd,oRS
        AuthenticateUser = False
        strQuery = "SELECT cn FROM 'LDAP://" & Application("domain") & "' WHERE objectClass='*'"
        Set oConn = server.CreateObject("ADODB.Connection")
        oConn.Provider = "ADsDSOOBJECT"
        oConn.properties("User ID") = Username
        oConn.properties("Password")= Password
        oConn.properties("Encrypt Password") = true
        oConn.open "DS Query", Username,Password
        Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery
        on error resume next
        Set oRS = cmd.Execute
        Set objFs = Server.CreateObject( "Scripting.FileSystemObject" )
        Set f=objFs.OpenTextFile(Application("tempdir") & "\digiadmin_login.log", 8 ,true)
        Dim Line :

        If Err.Number <>  0 Then
           Line =  Replace(Date & " " & Time & ":" & LEFT(LCase(Username) & Space(15),15) & ":" & Err.Number & "-" & Err.Description,Chr(13),"")
        Else
           Line =  Replace(Date & " " & Time & ":" & LEFT(LCase(Username) & Space(15),15) & ": Logged In",Chr(13),"")
        End If

        f.WriteLine(Line)
        f.Close

        Set f = Nothing
        Set objFS = Nothing
        If oRS.bof or oRS.eof then
            AuthenticateUser = False
            Session("login") = ""
            Session("IsGuest") = True
        Else
            AuthenticateUser = True
            Session("login") = LCase(Username)
            Dim MPSAccess : Set MPSAccess= New DigiMPSAccess
            If MPSAccess.IsUser Then
               Session("IsGuest") = False
               Session("IsAdmin") = MPSAccess.IsAdmin
               Session("AccessGroup") = MPSAccess.AccessGroup
               Session("DepartmentID") = MPSAccess.DepartmentID
               Session("Department") = MPSAccess.Department
               Session("StreamTypeID") = MPSAccess.StreamTypeID
               Session("AreaID") = MPSAccess.AreaID
            Else
               Session("IsGuest") = True
            End If
        End If
        Set oRS = Nothing
        Set oConn = Nothing
    End Function

End Class

Class DigiMPSAccess

    Public IsAdmin
    Public IsUser
    Public AccessGroup
    Public DepartmentID
    Public Department
    Public StreamTypeID
    Public AreaID

    Private Sub Class_Initialize()

        IsAdmin = False
        IsUser = False
        AccessGroup = "guest"
        DepartmentID = -1

        Dim SQLStr : SQLStr = "SELECT * FROM vwUserlist WHERE LOWER(userid)='" & Session("login") & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            IsUser = True
            If Rs("groupid") = "admin" Then
                IsAdmin = True
            End If
            AccessGroup = Rs("groupid")
            DepartmentID = Rs("departmentid")
            Department = Rs("department")
            StreamTypeID = Rs("streamtype")
            AreaID = Rs("area")
        End If

    End Sub

End Class

%>