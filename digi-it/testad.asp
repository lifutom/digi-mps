<!--#include file="./controllers/controllers.asp" -->


<!--#include virtual="/Utils/utils.asp" -->


<!--#include virtual="/models/models.asp" -->

<%

Dim curADConn : Set curADConn = server.CreateObject("ADODB.Connection")
curADConn.Provider = "ADsDSOOBJECT"
curADConn.properties("User ID") = "tlauterb"
curADConn.properties("Password")= "Thueringer1!"
curADConn.properties("Encrypt Password") = true
curADConn.open "Active Directory Provider", Username,Password

Dim oAD : Set oAD = New ADAccess

Set UserList = oAD.GetADMemberOfEveryoneGroup()

For Each myItem In UserList.Items

    Set Manager = oAD.GetManager(myItem.Manager)

    Response.Write myItem.ISID  & ": " & myItem.Manager & " -->" & Manager.ISID & "<br>"

Next 

'strQuery = "(&(objectCategory=user)(memberOf=CN=Everyone (AT-Vienna),CN=Exchange Distribution Lists,CN=Groups,DC=merck,DC=com))"

'Set cmd = Server.CreateObject("ADODB.Command")
'Set cmd.ActiveConnection = curADConn

'cmd.CommandText = "<LDAP://54.101.12.9/DC=merck,DC=com>;" & strQuery  & ";sAMAccountname,cn, mail, sn, givenName, manager"
'on error resume next
'Set oRS = cmd.Execute 

'Do While Not oRs.Eof  
'   For i=0 To oRs.Fields.Count - 1
'	If (oRs.Fields(i).Name <> "1manager") Then
'    		Response.Write oRs(oRs.Fields(i).Name) & ";"
'	End If
'   Next
'   Response.Write "<br>---"

'   If oRs("manager") <> "" Then
'   strQuery = "(&(objectCategory=user)(distinguishedName=" & oRs("manager") & "))"

'   Set cmd1 = Server.CreateObject("ADODB.Command")
'   Set cmd1.ActiveConnection = curADConn

'   cmd1.CommandText = "<LDAP://54.101.12.9/DC=merck,DC=com>;" & strQuery  & ";sAMAccountname,cn, mail, sn, givenName"
   
'   Set oRs1 = cmd1.Execute 

'   If Not oRs1.Eof Then
'	For i=0 To oRs1.Fields.Count - 1
'    	    Response.Write oRs1(oRs1.Fields(i).Name) & ";"	
'  	Next
'   End If	

'   Response.Write "<br>"
'   End If
'   oRs.MoveNext
'Loop




%>


