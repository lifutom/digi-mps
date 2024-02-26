<%

Class ADAttribute

    Public ISID
    Public FirstName
    Public LastName
    Public EMail

End Class


Class ADGroup


    Public Name
    Public ID


    Public Sub Update

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "UpdateADAccessItem"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()

        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@CN", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Name

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 512)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ""

        Set Parameter = Cmd.CreateParameter("@Typ", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = 1

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

    End Sub

End Class

Class ADAccess

    Public ISID
    Public FirstName
    Public LastName
    Public EMail

    Function AuthenticateUser(Username,Password)

        Dim strUser,strPass,strQuery,oConn,cmd,oRS
        AuthenticateUser = False
        ''strQuery = "SELECT cn,mail FROM 'LDAP://" & Application("domain") & "' WHERE objectClass='*'"
        strQuery = "SELECT cn, mail, sn, givenName FROM 'LDAP://" & Application("domain") & "' WHERE sAMAccountname='" & UserName & "'"

        Set curADConn = server.CreateObject("ADODB.Connection")


        curADConn.Provider = "ADsDSOOBJECT"
        curADConn.properties("User ID") = Username
        curADConn.properties("Password")= Password
        curADConn.properties("Encrypt Password") = true
        curADConn.open "DS Query", Username,Password

        Set Session("curADConn") = curADConn

        Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = curADConn
        cmd.CommandText = strQuery
        on error resume next
        Set oRS = cmd.Execute
        Set objFs = Server.CreateObject( "Scripting.FileSystemObject" )

        Dim MailName : MailName = ""
        Dim FirstName : FirstName = ""
        Dim LastName : LastName = ""

        Dim oUser : Set oUser = New User

        If Not oRs Is Nothing Then
            If Not oRS.Eof Then
                MailName = oRS("mail")
                FirstName = oRs("givenName")
                LastName = oRs("sn")
            End If
        End If

        Set f=objFs.OpenTextFile(Application("tempdir") & "\digiadmin_login.log", 8 ,true)

        Dim Line

        If Err.Number <>  0 Then
           Line =  Replace(Date & " " & Time & ":" & LEFT(LCase(Username) & Space(15),15) & ":" & Err.Number & "-" & Err.Description,Chr(13),"")
        Else
           Line =  Replace(Date & " " & Time & ":" & LEFT(LCase(Username) & Space(15),15) & ": Logged In " & MailName ,Chr(13),"")
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
               oUser.UserID = Username
               oUser.EMail = MailName
               oUser.FirstName = FirstName
               oUser.LastName = LastName
               oUser.Update
               Session("IsGuest") = False
               Session("IsAdmin") = MPSAccess.IsAdmin
               Session("IsKeyUser") = MPSAccess.IsKeyUser
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


    Public Function GetUserList

        Dim strQuery : strQuery = "SELECT cn, mail FROM 'LDAP://" & Application("domain") & "' WHERE objectClass='user' and objectCategory='person'"
        Dim oConn : Set oConn = curADConn
        Dim cmd : Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery
        ''on error resume next
        Dim oRs : Set oRS = cmd.Execute
        Dim List : Set List = Server.CreateObject( "Scripting.Dictionary")

        If Not oRs.Eof Then
           Do While Not oRs.Eof
              REsponse.WRite oRs("cn") & ":" & oRs("mail") & "<br>"
              oRs.MoveNext
           Loop

        End If

        oRs.Close

        Set GetUserList = List

    End Function


    Public Function GetADGroups(ByVal ISID)


        Dim DomArr : DomArr = Split(Application("domain"),".")
        Dim DomainCtrl : DomainCtrl = GetAppSettings("domainctrl")
        Dim GroupFilter : GroupFilter = GetAppSettings("groupfilter")

        Dim strQuery : strQuery = IIf(ISID="", "<LDAP://" & DomainCtrl & ":389/DC=" & DomArr(0) & ",DC=" & DomArr(1) & ">;" & GroupFilter & ";cn", "SELECT * FROM 'LDAP://" & Application("domain") & "' WHERE objectClass='group'")
        Dim oConn : Set oConn = curADConn
        Dim cmd : Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery

        Dim oRs : Set oRS = cmd.Execute

        Dim List : Set List = Server.CreateObject( "Scripting.Dictionary")

        Dim Item
        Dim i

        Do While Not oRs.Eof
            Set Item = New ADGroup
            Item.Name = oRs(oRs.Fields(0).name)
            Item.Update
            List.Add Item.Name, Item
            oRs.MoveNext
        Loop

        oRs.Close

        Set GetADGroups = List

    End Function

    Public Function GetADMemberOfEveryoneGroup()


        Dim DomArr : DomArr = Split(Application("domain"),".")
        Dim DomainCtrl : DomainCtrl = GetAppSettings("domainctrl")
        Dim GroupFilter : GroupFilter = GetAppSettings("everyonefilter")

        Dim strQuery : strQuery = "<LDAP://" & DomainCtrl & ":389/DC=" & DomArr(0) & ",DC=" & DomArr(1) & ">;" & GroupFilter & ";cn"
        Dim oConn : Set oConn = curADConn
        Dim cmd : Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery

        Dim oRs : Set oRS = cmd.Execute

        Dim List : Set List = Server.CreateObject( "Scripting.Dictionary")

        Dim Item
        Dim i

        Do While Not oRs.Eof

            Set Item = New ADAttribute
            Item.ISID = oRs("cn")
            Item.FirstName = oRs("giveName")
            Item.LastName = oRs("sn")
            Item.EMail = oRs("mail")
            List.Add Item.ISID, Item
            oRs.MoveNext
        Loop

        oRs.Close

        Set GetADMemberOfEveryoneGroup = List

    End Function




    Public Function EMailByISID(ByVal ISID)

        Dim strQuery : strQuery = "SELECT cn, mail, sn, givenName FROM 'LDAP://" & Application("domain") & "' WHERE sAMAccountname='" & ISID & "'"
        Dim oConn : Set oConn = curADConn
        Dim cmd : Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery
        on error resume next
        Dim oRs : Set oRS = cmd.Execute


        If Not oRs.Eof Then
            Set EMailByISID = New ADAttribute
            EMailByISID.ISID = ISID
            EMailByISID.FirstName = oRs("givenName")
            EMailByISID.LastName = oRs("sn")
            EMailByISID.EMail = oRs("mail")
        Else
            Set EMailByISID = Nothing
        End If
        oRs.Close
        Set oRs = Nothing
        Set Cmd = Nothing

    End Function

    Public Function MemberOfByISID(ByVal ISID)

        Dim strQuery : strQuery = "SELECT cn, mail, sn, givenName FROM 'LDAP://" & Application("domain") & "' WHERE sAMAccountname='" & ISID & "'"
        Dim oConn : Set oConn = curADConn
        Dim cmd : Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery
        on error resume next
        Dim oRs : Set oRS = cmd.Execute
        EMailByISID = ""
        If Not oRs.Eof Then
           EMailByISID = oRs("mail")
        End If
        oRs.Close
        Set oRs = Nothing
        Set Cmd = Nothing

    End Function


End Class

Class DigiMPSAccess

    Public IsAdmin
    Public IsKeyUser
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

        Dim oHelper : Set oHelper = New AccessRights

        Dim SQLStr : SQLStr = "SELECT * FROM vwUserlist WHERE LOWER(userid)='" & Session("login") & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            IsUser = True

            IsAdmin = oHelper.IsAdmin(Session("login"))
            IsKeyUser = oHelper.IsKeyUser(Session("login"))
            AccessGroup = Rs("groupid")
            DepartmentID = Rs("departmentid")
            Department = Rs("department")
            StreamTypeID = Rs("streamtype")
            AreaID = Rs("area")
        End If

    End Sub

End Class

Class AccessRights

    Public Function IsAdmin (ByVal UserID)

        IsAdmin = False
        Dim SQLStr : SQLStr = "SELECT * FROM vwUserlistGroup WHERE LOWER(userid)='" & UserID & "' AND groupid='admin'"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        If Not Rs.Eof Then
           IsAdmin = True
        End If
        Rs.Close

    End Function


    Public Function IsKeyUser (ByVal UserID)

        IsKeyUser = False
        Dim SQLStr : SQLStr = "SELECT * FROM vwUserlistGroup WHERE LOWER(userid)='" & UserID & "' AND groupid='key-user'"

        Dim Rs : Set Rs = DbExecute(SQLStr)
        If Not Rs.Eof Then
           IsKeyUser = True
        End If
        Rs.Close

    End Function

    Public Function HasAccessRight(ByVal aRight, ByVal UserID)

        HasAccessRight = False

        Select Case aRight

            Case "delete_downtime"

                If UserID = "luig" Then
                   HasAccessRight = True
                End If

        End Select

    End Function


End Class






%>