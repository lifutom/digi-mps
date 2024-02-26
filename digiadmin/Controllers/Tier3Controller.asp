<%

Class Tier3Controller

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim Departments : Set Departments = New Department
        Dim EventsHlp : Set EventsHlp = New EventsHelper

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "list", EventsHlp.Tier3EventsList

        %>   <!--#include file="../views/Tier3/Events.asp" --> <%

    End Sub

    Public Sub Events

        Index

    End Sub

    Public Sub SafetyIssues

        Dim CCHlp : Set CCHlp = New SafetyIssueHelper

        ViewData.Add "list", CCHlp.List("tier3")

        %>   <!--#include file="../views/Tier3/safetyissues.asp" --> <%

    End Sub

End Class
%>