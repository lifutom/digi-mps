<%
    Dim curRootFile : curRootFile = "/" & Application("root")
    Session("IsGuest") = ""
    Session("login") = ""
    Response.Redirect(curRootFile)
%>