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
        If oRS.bof or oRS.eof then
            AuthenticateUser = False
        Else
            AuthenticateUser = True
        End If
        Set oRS = Nothing
        Set oConn = Nothing
    End Function

End Class

Class DigiMPSAccess

    Function IsAdmin (ByVal Login)

        Dim SQLStr : SQLStr = "SELECT * FROM userlist WHERE groupid='admin' AND userid='" & Login & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Rs.Eof Then
           IsAdmin = False
        Else
           IsAdmin = True
        End If
        DbCloseConnection()

    End Function


End Class

%>