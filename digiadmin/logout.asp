<%
    Dim curRootFile : curRootFile = "/" & Application("root")
    Session.Abandon()
    Response.Redirect(curRootFile & "/login.asp")
%>