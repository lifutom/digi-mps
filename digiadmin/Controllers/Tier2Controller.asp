<%

Class Tier2Controller

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    Public Sub SafetyIssues

        Dim CCHlp : Set CCHlp = New SafetyIssueHelper

        ViewData.Add "list", CCHlp.List("tier2")

        %>   <!--#include file="../views/Tier2/safetyissues.asp" --> <%

    End Sub

End Class
%>