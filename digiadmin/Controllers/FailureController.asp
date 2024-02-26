<%

Class FailureController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New FailureHelper
        Dim FailureList : Set FailureList = pHelper.FailureList

        ViewData.Add "failurelist", FailureList

        %>   <!--#include file="../views/failure/Index.asp" --> <%

    End Sub


End Class
%>