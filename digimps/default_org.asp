<%

function AuthenticateUser(Username,Password,Domain)
        dim strUser,strPass,strQuery,oConn,cmd,oRS
        AuthenticateUser = false
        strQuery = "SELECT cn FROM 'LDAP://" & Domain & "' WHERE objectClass='*'"
        set oConn = server.CreateObject("ADODB.Connection")
        oConn.Provider = "ADsDSOOBJECT"
        oConn.properties("User ID") = Username
        oConn.properties("Password")=Password
        oConn.properties("Encrypt Password") = true
        oConn.open "DS Query", Username,Password
        set cmd = server.CreateObject("ADODB.Command")
        set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery
        on error resume next
        set oRS = cmd.Execute
        if oRS.bof or oRS.eof then
            AuthenticateUser = false
        else
            AuthenticateUser = true
        end if
        set oRS = nothing
        set oConn = nothing
end function


If AuthenticateUser("tlauterb","Thueringer1!", "merck.com") Then
   Response.Write "True"
Else
   Response.Write "False"
End If


%>